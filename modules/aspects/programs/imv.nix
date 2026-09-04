{ ... }:
{
  den.aspects.imv.homeManager =
    { pkgs, ... }:
    let
      imv-dir = pkgs.writeShellScriptBin "imv-dir" ''
        file=$(realpath "$1")
        dir=$(dirname "$file")

        shopt -s nullglob nocaseglob

        files=()
        for f in "$dir"/*; do
          if [ -f "$f" ]; then
            files+=("$f")
          fi
        done

        if [ ''${#files[@]} -eq 0 ]; then
          exec ${pkgs.imv}/bin/imv "$file"
        fi

        index=1
        for i in "''${!files[@]}"; do
          if [ "$(realpath "''${files[$i]}")" = "$file" ]; then
            index=$((i + 1))
            break
          fi
        done

        exec ${pkgs.imv}/bin/imv -n "$index" "''${files[@]}"
      '';
    in
    {
      programs.imv = {
        enable = true;
      };

      xdg = {
        desktopEntries.imv-folder = {
          name = "imv (Folder Viewer)";
          exec = "${imv-dir}/bin/imv-dir %f";
          mimeType = [
            "image/jpeg"
            "image/png"
            "image/gif"
            "image/webp"
            "image/bmp"
            "image/tiff"
            "image/svg+xml"
            "image/heif"
          ];
          noDisplay = true;
        };

        mimeApps.defaultApplications = {
          "image/jpeg" = "imv-folder.desktop";
          "image/png" = "imv-folder.desktop";
          "image/gif" = "imv-folder.desktop";
          "image/webp" = "imv-folder.desktop";
          "image/bmp" = "imv-folder.desktop";
          "image/tiff" = "imv-folder.desktop";
          "image/svg+xml" = "imv-folder.desktop";
          "image/heif" = "imv-folder.desktop";
        };
      };
    };
}
