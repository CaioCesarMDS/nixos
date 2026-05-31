{ pkgs, vars, ... }:

let
  package =
    if vars.gpu == "nvidia" then
      pkgs.ollama-cuda
    else if vars.gpu == "amd" then
      pkgs.ollama-rocm
    else
      pkgs.ollama;
in
{
  services.ollama = {
    enable = true;
    inherit package;
  };
}
