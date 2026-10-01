{ inputs, lib, ... }:
let
  inherit (lib.attrsets) attrNames filterAttrs hasAttr removeAttrs mapAttrs' mapAttrsToList nameValuePair;
  inherit (lib.generators) toPlist;
  inherit (lib.lists) filter foldr;
  inherit (lib.strings) hasInfix concatMapStringsSep toJSON;
  inherit (lib.trivial) flip warn importJSON;

  ublockAssets = importJSON "${inputs.ublock}/assets/assets.json";

  ublockFilterLists =
    (
      ublockAssets
      |> filterAttrs (_: spec: (spec.content or null) == "filters" && (spec.group or null) != "regions")
      |> flip removeAttrs [ "ublock-experimental" ]
      |> attrNames
    )
    ++ [
      # opt-in regional lists
      "FRA-0"

      # custom filters
      "user-filters"

      # external lists
      "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/BrowseWebsitesWithoutLoggingIn.txt"
      "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt"
      "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/LegitimateURLShortener.txt"
      "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/annoyance_list.txt"
      "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/click2load.txt"
      "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/privacy_essentials.txt"
    ];

  extensions = {

    # UNSLOP
    consent-o-matic.id = "mdjildafknihdffpkfmmpnpoiajfjnjd";
    indie-wiki-buddy.id = "fkagelmloambgokoeokbpihmgpkbgbfm";
    ublock-origin = {
      id = "blockjmkbacgjkknlgpkjjiijinjdanf";
      preinstalled = true;
      settings.toolbar_pin = "force_pinned";

      policy.userSettings = [
        [ "suspendUntilListsAreLoaded" "true" ]
        [ "userFiltersTrusted" "true" ]
      ];

      policy.toOverwrite.filterLists =
        filter (name: !(hasInfix "://" name || name == "user-filters" || hasAttr name ublockAssets)) ublockFilterLists
        |> foldr (name: warn "helium: unknown ublock filter list: ${name}") ublockFilterLists;

      policy.toOverwrite.filters =
        [
          # shorts -> normal player
          ''||youtube.com/shorts/$document,uritransform=/^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([^\/?#]+)/https:\/\/www.youtube.com\/watch?v=\$1/''

          # keep embeds working despite the click2load list
          "@@||youtube.com/embed/$frame"
          "@@||youtube-nocookie.com/embed/$frame"
        ]
        ++ [
          # old reddit
          "@@||reddit.com/media$document"
          "@@||reddit.com/mod$document"
          "@@||reddit.com/poll$document"
          "@@||reddit.com/settings$document"
          "@@||reddit.com/topics$document"
          "@@||reddit.com/community-points$document"
          "@@||reddit.com/appeal$document"
          "@@||reddit.com/appeals$document"
          "@@||reddit.com/notifications$document"
          "@@||reddit.com/message/compose/$document"
          "@@||reddit.com/mail^$document"
          "@@||reddit.com/answers^$document"
          "@@||reddit.com/r/subreddit^$document"
          ''@@/^https:\/\/\w*\.?reddit\.com\/r\/[A-Za-z0-9_]+\/s\//$document''
          ''@@/^https:\/\/\w*\.?reddit\.com\/.*[?&]new_reddit=true(?:$|[&#])/$document''

          ''||reddit.com/gallery/$document,uritransform=/^https:\/\/(?:www\.|np\.|amp\.|i\.)?reddit\.com\/gallery\/(.*)/https:\/\/old.reddit.com\/comments\/\$1/''
          ''||reddit.com^$document,uritransform=/^https:\/\/(?:www\.|np\.|amp\.|i\.)?reddit\.com\/(?!gallery\/)/https:\/\/old.reddit.com\//''

          "old.reddit.com##:is(#eu-cookie-policy, #redesign-beta-optin-btn)"
        ];
    };

    # REFERENCE
    steamdb.id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon";

    # SERVICES
    onepassword = {
      id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
      settings.toolbar_pin = "force_pinned";
    };

    # VISUAL
    unhook.id = "khncfooichmfjbepaaaebmommgaepoid";
    refined-github.id = "hlepfoohegkhhmjieoechaddaejaokhf";
    dark-reader.id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";

    # THEME
    gruvbox-slate = {
      id = "giokfhncgfjkoamdbhfhfhgpikaioccc";
      force = false;
    };
  };

  allowed =
    extensions
    |> filterAttrs (_: e: !(e.preinstalled or false))
    |> mapAttrsToList (_: e: e.id);

  forced =
    extensions
    |> filterAttrs (_: e: !(e.preinstalled or false) && (e.force or true))
    |> mapAttrsToList (_: e: e.id);

  extensionSettings =
    extensions
    |> filterAttrs (_: e: e ? settings)
    |> mapAttrs' (_: e: nameValuePair e.id e.settings);

  extensionPolicies =
    extensions
    |> filterAttrs (_: e: e ? policy)
    |> mapAttrs' (_: e: nameValuePair e.id e.policy);

  policy = {
    ExtensionInstallBlocklist = [ "*" ];

    ExtensionInstallAllowlist = allowed;
    ExtensionInstallForcelist = forced;
    ExtensionInstallSources = [ "https://services.helium.imput.net/*" ];

    ExtensionSettings = extensionSettings;
  };

  linuxPolicy = policy // {
    "3rdparty".extensions = extensionPolicies;
  };
in
{
  flake.modules.nixos.helium =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      environment.etc."chromium/policies/managed/policies.json".text = toJSON linuxPolicy;
    };

  flake.modules.darwin.helium =
    { pkgs, ... }:
    let
      writePlist = name: value: pkgs.writeText name (toPlist { escape = true; } value);

      extPlists = mapAttrsToList (id: value: {
        inherit id;
        path = writePlist "helium-extension-${id}.plist" value;
      }) extensionPolicies;
    in
    {
      environment.systemPackages = [
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      system.defaults.CustomUserPreferences."net.imput.helium" = {
        SUEnableAutomaticChecks = false;
        SUAutomaticallyUpdate = false;
        SUSendProfileInfo = false;
      };

      system.activationScripts.postActivation.text = ''
        target="/Library/Managed Preferences"
        mkdir -p "$target"
        cp ${writePlist "net.imput.helium.plist" policy} "$target/net.imput.helium.plist"
        ${concatMapStringsSep "\n" (
          e: ''cp ${e.path} "$target/net.imput.helium.extensions.${e.id}.plist"''
        ) extPlists}
        /usr/bin/killall cfprefsd 2>/dev/null || true
      '';
    };
}
