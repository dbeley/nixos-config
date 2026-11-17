{ inputs, ... }:
{
  imports = [ inputs.kite-browser.nixosModules.default ];

  programs.kite = {
    enable = true;
    defaultBrowser = false;
  };
}
