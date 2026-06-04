{
  inputs,
  ...
}:

let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  extensions = [
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
    (extension "darkreader" "addon@darkreader.org")
    (extension "steam-database" "firefox-extension@steamdb.info")
    (extension "web-developer" "{c45c406e-ab73-11d8-be73-000a95be3b12}")
    (extension "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}")
    (extension "absolute-enable-right-click" "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}")
    (extension "enhancer-for-youtube" "enhancerforyoutube@maximerf.addons.mozilla.org")
    (extension "return-youtube-dislikes" "{762f9885-5a13-4abd-9c77-433dcd38b8fd}")
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
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      ExtensionSettings = builtins.listToAttrs extensions;
      SearchEngines = {
        Default = "DuckDuckGo";
        Add = [
          {
            Name = "YouTube";
            URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
            Method = "GET";
            IconURL = "https://www.youtube.com/favicon.ico";
            Alias = "yt";
          }
          {
            Name = "Wikipedia";
            URLTemplate = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}";
            Method = "GET";
            IconURL = "https://en.wikipedia.org/static/favicon/wikipedia.ico";
            Alias = "wk";
          }
          {
            Name = "GitHub";
            URLTemplate = "https://github.com/search?q={searchTerms}&type=repositories";
            Method = "GET";
            IconURL = "https://github.com/favicon.ico";
            Alias = "gh";
          }
          {
            Name = "Nixpkgs Packages";
            URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
            Method = "GET";
            IconURL = "https://wiki.nixos.org/favicon.ico";
            Alias = "np";
          }
          {
            Name = "NixOS Options";
            URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
            Method = "GET";
            IconURL = "https://wiki.nixos.org/favicon.ico";
            Alias = "no";
          }
          {
            Name = "Home Manager Options";
            URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
            Method = "GET";
            IconURL = "https://wiki.nixos.org/favicon.ico";
            Alias = "ho";
          }
        ];
      };
    };
  };
}
