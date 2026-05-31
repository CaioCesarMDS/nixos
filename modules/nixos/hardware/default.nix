{ vars, ... }:

{
  imports = [
    ./common.nix
    ./${vars.gpu}.nix
    ./bluetooth.nix
  ];
}
