{ ... }:
{
  den.aspects.btop.homeManager =
    { pkgs, ... }:
    {
      programs.btop = {
        enable = true;
        package = pkgs.btop.override {
          rocmSupport = true;
          cudaSupport = true;
        };
        settings = {
          color_theme = "adwaita-dark";
          show_gpu_info = "on";
          cpu_sensor = "auto";
          vim_keys = true;
          rounded_corners = true;
          proc_tree = false;
          show_uptime = true;
          show_coretemp = true;
          show_disks = true;
          only_physical = true;
          io_mode = true;
          io_graph_combined = false;
        };
        themes.adwaita-dark = ''
          theme[main_bg]="#1d1d1d"
          theme[main_fg]="#deddda"
          theme[title]="#deddda"
          theme[hi_fg]="#62a0ea"
          theme[selected_bg]="#1c71d8"
          theme[selected_fg]="#ffffff"
          theme[inactive_fg]="#77767b"
          theme[proc_misc]="#1a5fb4"
          theme[cpu_box]="#77767b"
          theme[mem_box]="#77767b"
          theme[net_box]="#77767b"
          theme[proc_box]="#77767b"
          theme[div_line]="#77767b"
          theme[temp_start]="#62a0ea"
          theme[temp_mid]="#1c71d8"
          theme[temp_end]="#e01b24"
          theme[cpu_start]="#62a0ea"
          theme[cpu_mid]="#1c71d8"
          theme[cpu_end]="#e01b24"
          theme[free_start]="#62a0ea"
          theme[free_mid]="#1c71d8"
          theme[free_end]="#c01b24"
          theme[cached_start]="#62a0ea"
          theme[cached_mid]="#1c71d8"
          theme[cached_end]="#c01b24"
          theme[available_start]="#62a0ea"
          theme[available_mid]="#1c71d8"
          theme[available_end]="#c01b24"
          theme[used_start]="#62a0ea"
          theme[used_mid]="#1c71d8"
          theme[used_end]="#c01b24"
          theme[download_start]="#62a0ea"
          theme[download_mid]="#1c71d8"
          theme[download_end]="#c01b24"
          theme[upload_start]="#62a0ea"
          theme[upload_mid]="#1c71d8"
          theme[upload_end]="#c01b24"
        '';
      };
    };
}
