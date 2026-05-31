{
  lib,
  pkgs,
  vars,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      vscode
      qbittorrent
      obsidian
      postman
      imv
    ]
    ++ lib.optionals vars.enableGaming [
      mangohud
      lutris
    ];
}
