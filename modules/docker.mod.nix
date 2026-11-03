{ globals, ... }:
let
  colimaConfig = {
    cpu = 4;
    memory = 8;
    disk = 60;
    runtime = "docker";
    kubernetes.enabled = false;
    vmType = "vz";
    mountType = "virtiofs";
    sshConfig = false;
  };
in
{
  flake.modules.nixos.docker =
    { pkgs, ... }:
    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
        daemon.settings = {
          log-driver = "journald";
          storage-driver = "overlay2";
        };
      };

      users.users.${globals.username}.extraGroups = [ "docker" ];
      environment.systemPackages = [ pkgs.docker-compose ];

      # Rootless alternative (once the unstable regression is fixed):
      # virtualisation.docker.rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
    };

  flake.modules.darwin.docker =
    { pkgs, config, ... }:
    let
      inherit (builtins) toJSON;
      inherit (pkgs) writeText writeShellScriptBin;

      homeDir = config.users.users.${globals.username}.home;
      colimaYaml = writeText "colima.yaml" (toJSON colimaConfig);

      docker-up = writeShellScriptBin "docker-up" ''
        if [ ! -f "$COLIMA_HOME/default/colima.yaml" ]; then
          exec colima start --cpu 4 --memory 8 --disk 60 --ssh-config=false
        fi
        colima status >/dev/null 2>&1 || exec colima start
      '';
      docker-down = writeShellScriptBin "docker-down" ''
        exec colima stop "$@"
      '';
      docker-nuke = writeShellScriptBin "docker-nuke" ''
        colima stop --force 2>/dev/null || true
        exec colima delete --data
      '';
    in
    {
      environment.systemPackages = with pkgs; [
        colima
        docker-client
        docker-buildx
        docker-compose
        docker-up
        docker-down
        docker-nuke
      ];

      system.activationScripts.postActivation.text = ''
        colimaHome="${homeDir}/.local/share/colima"
        install -d -m 0755 -o ${globals.username} -g staff "$colimaHome/default"
        if [ ! -f "$colimaHome/default/colima.yaml" ]; then
          install -m 0644 -o ${globals.username} -g staff ${colimaYaml} "$colimaHome/default/colima.yaml"
        fi
      '';
    };

  flake.modules.home.docker =
    { pkgs, lib, ... }:
    let
      inherit (lib) mkMerge mkIf;
      inherit (pkgs.stdenv.hostPlatform) isDarwin;
    in
    {
      my.env = {
        fixed = mkMerge [
          {
            DOCKER_CONFIG = "$HOME/.config/docker";
          }
          (mkIf isDarwin {
            COLIMA_HOME = "$HOME/.local/share/colima";
            DOCKER_HOST = "unix://$HOME/.local/share/colima/default/docker.sock";
          })
        ];

        session = {
          MINIKUBE_HOME = "$HOME/.local/share/minikube";
          KUBECONFIG = "$HOME/.config/kube/config";
          KUBECACHEDIR = "$HOME/.cache/kube";
        };
      };
    };
}
