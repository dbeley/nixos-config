{
  pkgs,
  user,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    gh
    nautilus
    supersonic
    google-chrome

    slack
    awscli2
    zoom-us
    teleport
    kubectl
    cloudflared
    google-cloud-sdk
    vault
    gnumake
    gcc
    file
    pango
    mecab
    libffi
    insomnia
    nodejs
    postgresql
  ];

  programs.firefox.profiles.${user}.extensions.packages = lib.mkMerge [
    (with pkgs.nur.repos.rycee.firefox-addons; [
      okta-browser-plugin
      onepassword-password-manager
    ])
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "application/xhtml+xml" = lib.mkForce [ "google-chrome.desktop" ];
      "application/xhtml_xml" = lib.mkForce [ "google-chrome.desktop" ];
      "text/html" = lib.mkForce [ "google-chrome.desktop" ];
      "x-scheme-handler/http" = lib.mkForce [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = lib.mkForce [ "google-chrome.desktop" ];
    };
  };
}
