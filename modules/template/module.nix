  { lib, config }:

  with lib;

  {

    options = {
      file = mkOption {
        type = types.path;
      };
      fileContents = mkOption {
        type = types.lines;
      };
      params = mkOption {
        type = types.attrsOf (types.submodule {
          # ...
        });
      };
    };

    config = {
      file = builtins.toFile config.fileContents;
      fileContents = throw "Some function to convert config.params to a string, possibly with some assertions";
    };
  }
