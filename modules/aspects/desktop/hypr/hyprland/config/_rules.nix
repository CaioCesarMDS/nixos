{ }:
{
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
    
    {
      match = {
        class = "^(xdg-desktop-portal-gtk)$";
      };
      float = true;
    }
    {
      match = {
        class = "(?i)^(thunar)$";
        title = "^(Rename.*)$";
      };
      float = true;
    }
    {
      match = {
        class = "^(xarchiver)$";
      };
      float = true;
    }
    {
      match = {
        class = "^(org.pulseaudio.pavucontrol)$";
      };
      float = true;
    }
    {
      match = {
        class = "^(blueman-manager)$";
      };
      float = true;
    }
    {
      match = {
        class = "^(nm-connection-editor)$";
      };
      float = true;
    }

    {
      match = {
        title = "^(Open File)(.*)$";
      };
      float = true;
    }
    {
      match = {
        title = "^(Select a File)(.*)$";
      };
      float = true;
    }
    {
      match = {
        title = "^(Open Folder)(.*)$";
      };
      float = true;
    }
    {
      match = {
        title = "^(Save As)(.*)$";
      };
      float = true;
    }
    {
      match = {
        title = "^(Library)(.*)$";
      };
      float = true;
    }
    {
      match = {
        title = "^(File Upload)(.*)$";
      };
      float = true;
    }
    {
      match = {
        title = "^(File Operation Progress)$";
      };
      float = true;
    }
    {
      match = {
        title = "^(Confirm to replace files)$";
      };
      float = true;
    }

    {
      match = {
        class = "^(Steam)$";
        title = ".*Steam library folder.*";
      };
      float = true;
      center = true;
    }
    {
      match = {
        class = "^(Steam)$";
        title = "^(Friends List)$";
      };
      float = true;
      center = true;
    }

    {
      match = {
        class = "^(firefox|google-chrome|zen|zen-beta)$";
        title = "^(Save As)$";
      };
      size = "800 600";
    }
    {
      match = {
        class = "^(firefox|google-chrome|zen|zen-beta)$";
        title = "^(Choose Files)$";
      };
      size = "800 600";
    }
    {
      match = {
        class = "^(firefox|google-chrome|zen|zen-beta)$";
        title = "^(Open File)$";
      };
      size = "800 600";
    }
    {
      match = {
        class = "^(firefox|google-chrome|zen|zen-beta)$";
        title = "^(Open Folder)$";
      };
      size = "800 600";
    }

    {
      match = {
        class = "(firefox|google-chrome|zen|zen-beta)";
        title = ".*(Picture-in-Picture|Picture in Picture).*";
      };
      float = true;
      pin = true;
      size = "480 270";
      no_blur = true;
      move = "74.5% 4.25%";
      animation = "slide";
      opacity = "1.0 1.0 override";
    }
  ];

  layer_rule = [
    {
      match = {
        namespace = "waybar";
      };
      blur = true;
      ignore_alpha = 0.1;
      blur_popups = true;
    }
    {
      match = {
        namespace = "swaync-control-center|swaync-notification-window";
      };
      blur = true;
      ignore_alpha = 0.1;
    }
    {
      match = {
        namespace = "rofi";
      };
      blur = true;
      ignore_alpha = 0.1;
    }
  ];
}
