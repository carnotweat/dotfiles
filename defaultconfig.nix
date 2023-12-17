{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.configuration;
in {
  options.modules.configuration = {
    machine = mkOption {
      type = types.attrs;
      default = { };
    };

    user = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = mkMerge [ (cfg.machine) (cfg.user) ];
}
