{ config, pkgs, ... }:
let
  extensionIds = [
    "oboonakemofpalcgghocfoadofidjkkk" # KeePassXC-Browser
    "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
    "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
  ];
  extensionUpdateUrl = "https://clients2.google.com/service/update2/crx";
  chromiumConfigDir = "${config.xdg.configHome}/chromium";
  managedPolicies = {
    ExtensionInstallAllowlist = extensionIds;
    ExtensionInstallForcelist =
      builtins.map (id: "${id};${extensionUpdateUrl}") extensionIds;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "DuckDuckGo";
    DefaultSearchProviderKeyword = "DuckDuckGo";
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    DefaultSearchProviderSuggestURL =
      "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
    DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";
  };
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [ "--enable-extensions" ];
    extensions = builtins.map (id: { inherit id; }) extensionIds;
  };

  home.file."${chromiumConfigDir}/policies/managed/extensions.json".text =
    builtins.toJSON managedPolicies;
}
