  { stdenv, lib }:

  stdenv.mkDerivation {
    # ...

    passthru = rec {
      module = import ./module.nix;
      configFile = cfg: (lib.evalModules {
        modules = [
          module
          cfg
        ];
      }).config.file;
    };
  }
