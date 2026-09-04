{ inputs, ... }:
{
  den.aspects.zen-browser.homeManager =
    { pkgs, ... }:
    let
      mkExtension = slug: guid: {
        name = guid;
        value = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${slug}/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
      };
      extensions = [
        (mkExtension "ublock-origin" "uBlock0@raymondhill.net")
        (mkExtension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
        (mkExtension "darkreader" "addon@darkreader.org")
        (mkExtension "absolute-enable-right-click" "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}")
        (mkExtension "youtube-no-translation" "{9a3104a2-02c2-464c-b069-82344e5ed4ec}")
        (mkExtension "return-youtube-dislikes" "{762f9885-5a13-4abd-9c77-433dcd38b8fd}")
      ];
    in
    {
      imports = [ inputs.zen-browser.homeModules.default ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
        policies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          DisablePocket = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
          HardwareAcceleration = true;
          SearchSuggestEnabled = false;
          HttpsOnlyMode = "enabled";
          EnableTrackingProtection = {
            Value = true;
            Locked = false;
            Category = "strict";
            Cryptomining = true;
            Fingerprinting = true;
            EmailTracking = true;
            SuspectedFingerprinting = true;
          };
          DNSOverHTTPS = {
            Enabled = true;
            ProviderURL = "https://dns.quad9.net/dns-query";
            Locked = false;
          };

          ExtensionSettings = builtins.listToAttrs extensions;
          "3rdparty".Extensions = {
            "uBlock0@raymondhill.net" = {
              toOverwrite = {
                filterLists = [
                  "user-filters"
                  "ublock-filters"
                  "ublock-badware"
                  "ublock-privacy"
                  "ublock-unbreak"
                  "ublock-quick-fixes"
                  "easylist"
                  "easyprivacy"
                  "urlhaus-1"
                  "plowe-0"

                  "fanboy-cookiemonster"
                  "easylist-annoyances"
                  "ublock-annoyances"
                  "adguard-cookies"

                  "adguard-spyware-url"
                ];
              };
            };
          };

          SearchEngines = {
            Default = "DuckDuckGo";
            PreventInstalls = true;
            Remove = [
              "Bing"
              "Google"
              "Perplexity"
              "Wikipedia (en)"
            ];
            Add = [
              {
                Name = "YouTube";
                URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
                Method = "GET";
                IconURL = "https://www.google.com/s2/favicons?domain=youtube.com&sz=128";
                Alias = "yt";
              }
              {
                Name = "Wikipedia";
                URLTemplate = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}";
                Method = "GET";
                IconURL = "https://www.google.com/s2/favicons?domain=wikipedia.org&sz=128";
                Alias = "wk";
              }
              {
                Name = "Nixpkgs Packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                Method = "GET";
                IconURL = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
                Alias = "np";
              }
            ];
          };
        };

        profiles.default = {
          isDefault = true;
          spacesForce = true;
          containersForce = true;
          pinsForce = true;
          pinsForceAction = "remove";

          settings = {
            "zen.workspaces.continue-where-left-off" = true;
            "zen.view.compact.hide-tabbar" = true;
            "zen.urlbar.behavior" = "float";
          };
          mods = [
            "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
            "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
            "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
            "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
            "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
            "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
          ];
          containers = {
            Dev = {
              color = "red";
              icon = "chill";
              id = 2;
            };
            Personal = {
              color = "purple";
              icon = "fingerprint";
              id = 1;
            };
            Shopping = {
              color = "yellow";
              icon = "cart";
              id = 5;
            };
            Study = {
              color = "green";
              icon = "tree";
              id = 3;
            };
            Work = {
              color = "blue";
              icon = "briefcase";
              id = 4;
            };
          };

          pins = {
            "YouTube" = {
              id = "3c2d1a0b-1111-2222-3333-444455556666";
              url = "https://youtube.com";
              position = 100;
              isEssential = true;
            };
            "Proton Mail" = {
              id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
              url = "https://mail.proton.me";
              position = 101;
              isEssential = true;
            };
          };

          spaces = {
            "Personal" = {
              id = "c6de089c-410d-4206-961d-ab11f988d40a";
              position = 1000;
              icon = "🏠";
              container = 1;
            };
            "Dev" = {
              id = "f9db866c-da35-43a8-8863-d2ddb419b5ae";
              position = 2000;
              icon = "💻";
              container = 2;
            };
            "Study" = {
              id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
              position = 3000;
              icon = "📚";
              container = 3;
              pins = {
                "NixOS" = {
                  id = "d85a9026-1458-4db6-b115-346746bcc692";
                  isGroup = true;
                  isFolderCollapsed = false;
                  position = 301;
                  pins = {
                    "NixOS Search" = {
                      id = "f8dd784e-11d7-430a-8f57-7b05ecdb4c77";
                      url = "https://search.nixos.org/packages";
                      position = 302;
                    };
                  };
                };
              };
            };
            "Work" = {
              id = "cdd10fab-4fc5-494b-9041-325e5759195b";
              position = 4000;
              icon = "💼";
              container = 4;
            };
            "Shopping" = {
              id = "01a3de97-93e1-44be-84b3-74c51e5b11e9";
              position = 5000;
              icon = "🛒";
              container = 5;
            };
          };
        };
      };

      home.sessionVariables.BROWSER = "zen-beta";

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "application/pdf" = "zen-beta.desktop";
      };
    };
}
