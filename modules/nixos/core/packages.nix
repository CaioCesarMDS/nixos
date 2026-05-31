{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # --- Core ---
    git
    curl
    wget
    nano
    psmisc
    xdg-utils
    util-linux
    procps
    # --- Hardware & Debug ---
    pciutils
    usbutils
    hwinfo
    lm_sensors
    # --- Utilities ---
    jq
    tree
    nixfmt
    # --- Archive ---
    p7zip
    unzip
    zip
    gnutar
    # --- Media ---
    imagemagick
    ffmpeg
  ];
}
