{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "google-chrome.desktop";
    "text/xml" = "google-chrome.desktop";
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "x-scheme-handler/chrome" = "google-chrome.desktop";
    "application/xhtml+xml" = "google-chrome.desktop";
    "application/x-extension-htm" = "google-chrome.desktop";
    "application/x-extension-html" = "google-chrome.desktop";
    "application/x-extension-shtml" = "google-chrome.desktop";
    "application/x-extension-xhtml" = "google-chrome.desktop";
    "application/x-extension-xht" = "google-chrome.desktop";
  };
}
