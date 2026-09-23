# Wabi-Sabi

## Project Conventions

1. Suffix = mechanism: *.mod.nix is a flake-parts module (auto-imported from
   anywhere in the repo);*.lib.nix is a library fragment (auto-gathered into
   mylib); any other .nix is inert data, referenced by path.
2. Directory = role: lib/ is the library + its injection; modules/ is aspects;
   options/ is cross-aspect option declarations; hosts/ is the fleet —
   manifest.nix (data), builder.mod.nix (mechanism), <host>/ (host data).
3. Aspects register facets as flake.modules.<class>.<name> (classes: nixos,
   darwin, home) and are inert until named in the manifest. Aspects never emit
   flake outputs or configurations; configurations are born in builder.mod.nix.
4. Naming a module activates its host-class facet and its home facet; a missing
   facet is skipped; a name with neither facet is an eval error.
5. manifest.nix is pure data — no arguments, no logic. common + hosts
   (+ roles when a second use case exists, not before).
6. mylib/globals reach modules via _module.args (flake, perSystem),
   specialArgs (system), and closure capture (home).
7. Options consumed by more than one aspect are declared in options/; values
   used by one aspect stay in that aspect's let.
   - shared targets are options; owners emit once, contributors append, guards use options ? name.
8. A new directory is created by its first file, never in advance.
9. New flake inputs need a reason in a comment, follows hygiene
   (nixpkgs/nix-darwin), and pruning (follows = "") for unused transitive inputs.
10. Hostnames, paths, and stateVersions live in hosts/<name>/, never in aspects.
