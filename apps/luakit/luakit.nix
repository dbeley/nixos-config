{
  config,
  lib,
  pkgs,
  ...
}:
let
  easylistRev = "0357f4cc67d91633d41edec81ec75d546bd1ec9f";
  filterLists = {
    "easylist-general.txt" = {
      path = "easylist/easylist_general_block.txt";
      hash = "sha256-2lLvMwR1S7qA/TYKm+ZpU81YVfHtbxQsbM4fH8IW7a4=";
    };
    "easylist-specific.txt" = {
      path = "easylist/easylist_specific_block.txt";
      hash = "sha256-dlrL522NM8MI/BN07TKq5ZuYjrOFaggGO1KLgC6pFjU=";
    };
    "easyprivacy-general.txt" = {
      path = "easyprivacy/easyprivacy_general.txt";
      hash = "sha256-KuUzA0ZtkVdvBFaKB43isWTRTxY2xG4HnU+LTB3+5eQ=";
    };
    "easyprivacy-specific.txt" = {
      path = "easyprivacy/easyprivacy_specific.txt";
      hash = "sha256-CiNmQXelk7a+ZxEFbhUiAuZ2I6ZNdQbUC2l3TvztN4c=";
    };
  };
in
{
  home.packages = [ pkgs.luakit ];

  xdg.dataFile = lib.concatMapAttrs (name: list: {
    "luakit/adblock/${name}".source = pkgs.fetchurl {
      inherit (list) hash;
      url = "https://raw.githubusercontent.com/easylist/easylist/${easylistRev}/${list.path}";
    };
  }) filterLists;

  xdg.configFile."luakit/userconf.lua".text = ''
    -- Loaded by luakit's stock rc.lua (`require "userconf"`).
    local settings = require "settings"

    settings.window.home_page = "https://start.duckduckgo.com"
    settings.window.default_search_engine = "duckduckgo"

    settings.webview.media_playback_requires_gesture = true
  '';

  wayland.windowManager.niri.settings = lib.mkIf (config.wayland.windowManager.niri.enable or false) {
    binds."Mod+Z".spawn = lib.mkForce [ "luakit" ];
  };
}
