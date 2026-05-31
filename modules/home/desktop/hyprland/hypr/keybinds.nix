{ pkgs, lib, ... }:
let
  lua = lib.generators.mkLuaInline;

  terminal = "kitty";
  explorer = "thunar";
  browser = "zen-beta";
  editor = "code";

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
  wayland.windowManager.hyprland.settings = {
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
}
