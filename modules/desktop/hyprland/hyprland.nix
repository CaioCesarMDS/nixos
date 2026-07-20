{ ... }:
{
  den.aspects.hyprland = {
    nixos =
      { pkgs, ... }:
      {
        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
          ];
        };
        programs.hyprland = {
          enable = true;
          xwayland.enable = true;
        };
      };

    homeManager =
      { lib, pkgs, ... }:
      let
        lua = lib.generators.mkLuaInline;

        mkEnv = key: val: ''hl.env("${key}", "${val}")'';

        baseEnv = [
          # --- Wayland & Ozone ---
          (mkEnv "NIXOS_OZONE_WL" "1")
          (mkEnv "ELECTRON_OZONE_PLATFORM_HINT" "wayland")
          (mkEnv "OZONE_PLATFORM" "wayland")
          (mkEnv "MOZ_ENABLE_WAYLAND" "1")

          # --- Toolkits ---
          (mkEnv "SDL_VIDEODRIVER" "wayland,x11")
          (mkEnv "CLUTTER_BACKEND" "wayland")
          (mkEnv "GDK_BACKEND" "wayland,x11,*")

          # --- Qt ---
          (mkEnv "QT_QPA_PLATFORM" "wayland;xcb")
          (mkEnv "QT_QPA_PLATFORMTHEME" "qt5ct")
          (mkEnv "QT_AUTO_SCREEN_SCALE_FACTOR" "1")
          (mkEnv "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")

          # --- XDG ---
          (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
          (mkEnv "XDG_SESSION_TYPE" "wayland")
          (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")

          # --- Cursor ---
          (mkEnv "HYPRCURSOR_THEME" "Bibata-Modern-Ice")
          (mkEnv "HYPRCURSOR_SIZE" "20")
          (mkEnv "XCURSOR_THEME" "Bibata-Modern-Ice")
          (mkEnv "XCURSOR_SIZE" "20")
        ];

        terminal = "kitty";
        explorer = "thunar";
        browser = "zen-beta";
        editor = "codium";

        dsp = {
          exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
          close = lua "hl.dsp.window.close()";
          exit = lua "hl.dsp.exit()";
          float = lua ''hl.dsp.window.float({ action = "toggle" })'';
          fullscreen = lua "hl.dsp.window.fullscreen()";
          maximize = lua "hl.dsp.window.fullscreen({ maximize = true })";
          pseudo = lua "hl.dsp.window.pseudo()";
          layout = msg: lua ''hl.dsp.layout("${msg}")'';
          focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
          swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
          toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
          moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
          moveToSpecialSilent =
            name: lua ''hl.dsp.window.move({ workspace = "special:${name}", silent = true })'';
          focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
          moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
          moveToWorkspaceSilent =
            ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}", silent = true })'';
          drag = lua "hl.dsp.window.drag()";
          resize = lua "hl.dsp.window.resize()";

          resizeActive =
            x: y: lua "hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })";
          sendshortcut = mod: key: lua ''hl.dsp.send_shortcut({ mods = "${mod}", key = "${key}" })'';
        };

        bind = keys: dispatcher: {
          _args = [
            keys
            dispatcher
          ];
        };

        bindOpts = keys: dispatcher: opts: {
          _args = [
            keys
            dispatcher
            opts
          ];
        };

        workspaceBinds = lib.concatMap (i: [
          (bind "SUPER + ${toString i}" (dsp.focusWorkspace i))
          (bind "SUPER + SHIFT + ${toString i}" (dsp.moveToWorkspace i))
          (bind "SUPER + ALT + ${toString i}" (dsp.moveToWorkspaceSilent i))
        ]) (lib.range 1 9);
      in
      {
        home.packages = with pkgs; [
          hyprshot
          hyprpicker
          hyprsunset
          hyprcursor
          cliphist
          wl-clipboard
          awww
          playerctl
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          systemd = {
            enable = true;
            variables = [ "--all" ];
          };
          configType = "lua";
          extraConfig = lib.concatStringsSep "\n" baseEnv;
        };

        services = {
          hyprpolkitagent = {
            enable = true;
          };
        };

        systemd.user.services = {
          awww-daemon = {
            Unit = {
              Description = "awww daemon";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session-pre.target" ];
            };
            Service = {
              Type = "simple";
              ExecStart = "${pkgs.awww}/bin/awww-daemon";
              Restart = "on-failure";
              RestartSec = 1;
            };
            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          };

          cliphist = {
            Unit = {
              Description = "Clipboard manager (cliphist)";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
            };

            Service = {
              ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
              Restart = "on-failure";
            };

            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          };

          hyprsunset = {
            Unit = {
              Description = "Hyprsunset";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
            };

            Service = {
              ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 4800";
              Restart = "on-failure";
            };

            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          };

          waybar = {
            Unit = {
              Description = "Waybar";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
            };

            Service = {
              ExecStart = "${pkgs.waybar}/bin/waybar";
              Restart = "on-failure";
            };

            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          };
        };

        wayland.windowManager.hyprland.settings = {
          on = {
            _args = [
              "hyprland.start"
              (lua ''
                function()
                  hl.exec_cmd("systemctl --user start graphical-session.target")
                  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 20")
                end'')
            ];
          };

          config = {
            general = {
              border_size = 2;
              col = {
                active_border = "#8A8A8A";
                inactive_border = "#383838";
              };
              gaps_in = 3;
              gaps_out = 10;
              allow_tearing = true;
              layout = "dwindle";
            };

            dwindle = {
              preserve_split = true;
              force_split = 2;
            };

            decoration = {
              rounding = 10;
              active_opacity = 1.0;
              inactive_opacity = 0.8;
              shadow = {
                enabled = true;
                range = 5;
                render_power = 2;
                color = "rgba(34, 34, 2, 0.07)";
              };
              blur = {
                enabled = true;
                size = 6;
                passes = 2;
                xray = true;
                noise = 0.05;
                popups = true;
              };
            };

            ecosystem = {
              no_donation_nag = true;
              no_update_news = true;
            };

            xwayland = {
              force_zero_scaling = true;
            };

            misc = {
              force_default_wallpaper = 0;
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              font_family = "JetBrainsMono Nerd Font";
              focus_on_activate = true;
              close_special_on_empty = true;
              enable_swallow = true;
              swallow_regex = ".*(kitty|alacritty|foot|wezterm).*";
              mouse_move_enables_dpms = true;
              key_press_enables_dpms = true;
            };

            cursor = {
              hide_on_key_press = true;
              inactive_timeout = 10;
              no_warps = true;
              enable_hyprcursor = true;
            };

            input = {
              follow_mouse = true;
              sensitivity = 0;
              force_no_accel = true;
            };
          };

          curve = [
            {
              _args = [
                "smooth"
                {
                  type = "bezier";
                  points = lua "{ {0.25, 0.1}, {0.25, 1.0} }";
                }
              ];
            }
            {
              _args = [
                "balanced"
                {
                  type = "bezier";
                  points = lua "{ {0.2, 0.0}, {0.3, 1.0} }";
                }
              ];
            }
            {
              _args = [
                "crisp"
                {
                  type = "bezier";
                  points = lua "{ {0.3, 0.0}, {0.4, 1.0} }";
                }
              ];
            }
            {
              _args = [
                "flow"
                {
                  type = "bezier";
                  points = lua "{ {0.15, 0.0}, {0.35, 1.0} }";
                }
              ];
            }
          ];

          animation = [
            {
              leaf = "windows";
              enabled = true;
              speed = 4;
              bezier = "smooth";
            }
            {
              leaf = "windowsIn";
              enabled = true;
              speed = 3;
              bezier = "balanced";
              style = "slide";
            }
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 2;
              bezier = "crisp";
              style = "slide";
            }
            {
              leaf = "workspaces";
              enabled = true;
              speed = 4;
              bezier = "flow";
              style = "slide";
            }
          ];

          window_rule = [
            {
              match = {
                class = ".*";
              };
              suppress_event = "maximize";
            }
            {
              match = {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              };
              no_focus = true;
            }
          ];

          bind = [
            # --- Applications ---
            (bind "SUPER + Q" (dsp.exec terminal))
            (bind "SUPER + F" (dsp.exec browser))
            (bind "SUPER + D" (dsp.exec editor))
            (bind "SUPER + E" (dsp.exec explorer))
            (bind "SUPER + R" (dsp.exec "rofi-launcher"))

            # --- System & Utilities ---
            (bind "SUPER + Delete" dsp.exit)
            (bind "SUPER + L" (dsp.exec "hyprlock"))
            (bind "SUPER + ESCAPE" (dsp.exec "rofi-powermenu"))
            (bind "SUPER + A" (dsp.exec "swaync-client -t -sw"))

            # --- Wallpaper Management ---
            (bind "SUPER + SHIFT + W" (dsp.exec "rofi-wallpaper-manager --select"))
            (bind "SUPER + SHIFT + A" (dsp.exec "rofi-wallpaper-manager --prev"))
            (bind "SUPER + SHIFT + D" (dsp.exec "rofi-wallpaper-manager --next"))

            # --- Clipboard Management ---
            (bind "SUPER + V" (dsp.exec "rofi-clipboard-manager -c"))
            (bind "SUPER + SHIFT + V" (dsp.exec "rofi-clipboard-manager"))

            # --- Screenshots (Hyprshot) ---
            (bind "SUPER + PRINT" (
              dsp.exec "hyprshot -m window -f $(date +%Y-%m-%d_%H-%M-%S).png -o ~/Pictures/screenshots"
            ))
            (bind "SUPER + SHIFT + PRINT" (
              dsp.exec "hyprshot -m region -f $(date +%Y-%m-%d_%H-%M-%S).png -o ~/Pictures/screenshots"
            ))
            (bind "SUPER + CTRL + PRINT" (
              dsp.exec "hyprshot -m output -f $(date +%Y-%m-%d_%H-%M-%S).png -o ~/Pictures/screenshots"
            ))

            # --- Zoom ---
            (bind "SUPER + ALT + mouse_down" (
              lua "function() hl.config({ cursor = { zoom_factor = 1.5 } }) end"
            ))
            (bind "SUPER + ALT + mouse_up" (lua "function() hl.config({ cursor = { zoom_factor = 1.0 } }) end"))

            # --- Window Management ---
            (bind "SUPER + C" dsp.close)
            (bind "SUPER + SHIFT + C" (dsp.exec "hyprctl killwindow"))
            (bind "SUPER + W" dsp.float)
            (bind "SUPER + J" (dsp.layout "togglesplit"))
            (bind "SUPER + P" dsp.pseudo)
            (bind "SUPER + SPACE" dsp.maximize)
            (bind "SUPER + SHIFT + SPACE" dsp.fullscreen)
            (bind "SUPER + bracketleft" (dsp.layout "splitratio -0.05"))
            (bind "SUPER + bracketright" (dsp.layout "splitratio +0.05"))

            # --- Focus & Window Movement ---
            (bind "SUPER + Left" (dsp.focus "left"))
            (bind "SUPER + Right" (dsp.focus "right"))
            (bind "SUPER + Up" (dsp.focus "up"))
            (bind "SUPER + Down" (dsp.focus "down"))
            (bind "SUPER + SHIFT + H" (dsp.swap "left"))
            (bind "SUPER + SHIFT + L" (dsp.swap "right"))
            (bind "SUPER + SHIFT + K" (dsp.swap "up"))
            (bind "SUPER + SHIFT + J" (dsp.swap "down"))

            # --- Workspace Navigation ---
            (bind "SUPER + CTRL + Right" (dsp.focusWorkspace "r+1"))
            (bind "SUPER + CTRL + Left" (dsp.focusWorkspace "r-1"))
            (bind "SUPER + mouse_down" (dsp.focusWorkspace "e+1"))
            (bind "SUPER + mouse_up" (dsp.focusWorkspace "e-1"))
            (bind "SUPER + S" (dsp.toggleSpecial "special"))
            (bind "SUPER + SHIFT + S" (dsp.moveToSpecial "special"))
            (bind "SUPER + ALT + S" (dsp.moveToSpecialSilent "special"))

            # --- Window Resizing ---
            (bindOpts "SUPER + SHIFT + Right" (dsp.resizeActive 30 0) { repeating = true; })
            (bindOpts "SUPER + SHIFT + Left" (dsp.resizeActive (-30) 0) { repeating = true; })
            (bindOpts "SUPER + SHIFT + Up" (dsp.resizeActive 0 (-30)) { repeating = true; })
            (bindOpts "SUPER + SHIFT + Down" (dsp.resizeActive 0 30) { repeating = true; })

            # --- Media & Hardware Keys ---
            (bindOpts "XF86AudioRaiseVolume" (dsp.exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") {
              locked = true;
              repeating = true;
            })
            (bindOpts "XF86AudioLowerVolume" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
              locked = true;
              repeating = true;
            })
            (bindOpts "XF86AudioMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
              locked = true;
            })

            # --- Media Player ---
            (bindOpts "XF86AudioPlay" (dsp.exec "playerctl play-pause") { locked = true; })
            (bindOpts "XF86AudioNext" (dsp.exec "playerctl next") { locked = true; })
            (bindOpts "XF86AudioPrev" (dsp.exec "playerctl previous") { locked = true; })
            (bindOpts "XF86AudioStop" (dsp.exec "playerctl stop") { locked = true; })

            # --- Brightness ---
            (bindOpts "XF86MonBrightnessUp" (dsp.exec "brightnessctl set +10%") {
              locked = true;
              repeating = true;
            })
            (bindOpts "XF86MonBrightnessDown" (dsp.exec "brightnessctl set 10%-") {
              locked = true;
              repeating = true;
            })

            # --- Mouse Bindings ---
            (bindOpts "SUPER + mouse:272" dsp.drag { mouse = true; })
            (bindOpts "SUPER + mouse:273" dsp.resize { mouse = true; })
          ]
          ++ workspaceBinds;
        };
      };
  };
}
