{ self }:
let
  inherit (self.attrsets) mapAttrs filterAttrs attrNames;
  inherit (self.strings) concatStringsSep concatMapStringsSep;
  inherit (builtins) elem head;
in
{
  tailnet = rec {
    domain = "albacore-vector.ts.net";

    peers = {
      # my devices
      miyoshi = { };
      chasen = { };
      kizaemon = { };

      # shared exit-node
      jamess-mac-mini = {
        domain = "tail8e6a8d.ts.net";
        roles = [ "exit-node" "subnet-router" ];
        external = true;
      };
    };

    exitNodes = {
      us = "jamess-mac-mini";
    };

    peerDomain = name: peers.${name}.domain or domain;
    fqdn = name: "${name}.${peerDomain name}";

    mine = filterAttrs (_: v: !(v.external or false)) peers;

    hosts = mapAttrs (name: _: fqdn name) peers;
    byRole = role: filterAttrs (_: v:
      elem role (v.roles or [ ])) peers;
    hasRole = role: name: elem role (peers.${name}.roles or [ ]);

    commands = {
      exit = pkgs:
        let
          aliases = attrNames exitNodes;
          defaultAlias = head aliases;
          exitCases = concatMapStringsSep "\n" (short: ''
              ${short}) set_exit "${fqdn exitNodes.${short}}" ;;
          '') (attrNames exitNodes);
        in
        pkgs.writeShellApplication {
          name = "ts-exit";
          runtimeInputs = [ pkgs.tailscale ];
          text = ''
            set -euo pipefail

            node_id() {
              tailscale debug prefs | grep -m1 -oE '"ExitNodeID": *"[^"]*"' | cut -d'"' -f4
            }

            current() {
              if [[ -n "$(node_id)" ]]; then
                tailscale status | grep -E '[;-] exit node[;,]|running' | head -1 || true
              else
                echo "(no exit node active)"
              fi
            }

            set_exit() {
              if [[ -z "''${1:-}" ]]; then
                tailscale set --exit-node=
                echo "exit node cleared"
              else
                tailscale set --exit-node="$1" --exit-node-allow-lan-access
                echo "exit node set to $1"
              fi
              current
            }

            case "''${1:-}" in
              "" )
                if [[ -n "$(node_id)" ]]; then
                  set_exit ""
                else
                  set_exit "${fqdn exitNodes.${defaultAlias}}"
                fi
                ;;
            ${exitCases}
              off|none) set_exit "" ;;
              status)   current ;;
              *)
                echo "usage: ts-exit [${concatStringsSep "|" aliases}|off|status]" >&2
                exit 2
                ;;
            esac
          '';
        };
    };
  };
}
