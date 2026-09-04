{ ... }:
{
  den.aspects.ollama.nixos =
    { config, lib, ... }:
    let
      cfg = config.services.ollama;
    in
    {
      options.services.ollama.contextLength = lib.mkOption {
        type = lib.types.enum [
          2048
          4096
          8192
          16384
          32768
          65536
          131072
        ];
        default = 32768;
        description = "Ollama context length in tokens (must be a valid context window size).";
      };

      config = {
        services.ollama = {
          enable = true;
          environmentVariables = {
            OLLAMA_CONTEXT_LENGTH = toString cfg.contextLength;
          };
        };
      };
    };
}
