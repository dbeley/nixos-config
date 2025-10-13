{ pkgs, ... }:
let
  managedPolicy = {
    BrowserSignin = 0;
    SigninAllowed = false;
    SyncDisabled = true;
    DefaultBrowserSettingEnabled = false;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderKeyword = "ddg";
    DefaultSearchProviderName = "DuckDuckGo";
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}";
    DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";
    HomepageIsNewTabPage = false;
    HomepageLocation = "about:blank";
    NewTabPageLocation = "about:blank";
    BackgroundModeEnabled = false;
    PasswordManagerEnabled = false;
    PasswordManagerAllowShowPasswords = false;
    PasswordLeakDetectionEnabled = false;
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    AutofillProfileEnabled = false;
    PaymentMethodQueryEnabled = false;
    SpellcheckServiceEnabled = false;
    TranslateEnabled = false;
    URLKeyedAnonymizedDataCollectionEnabled = false;
    MetricsReportingEnabled = false;
    DeviceMetricsReportingEnabled = false;
    SafeBrowsingEnabled = false;
    SafeBrowsingProtectionLevel = 0;
    AlternateErrorPagesEnabled = false;
    SearchSuggestEnabled = false;
    NetworkPredictionOptions = 2;
    CloudPrintProxyEnabled = false;
    ContextualSearchEnabled = false;
    EnableMediaRouter = false;
    QuicAllowed = false;
    PromptForDownloadLocation = true;
    ImportAutofillFormData = false;
    ImportBookmarks = false;
    ImportHistory = false;
    ImportHomepage = false;
    ImportSavedPasswords = false;
    ImportSearchEngine = false;
    DefaultCookiesSetting = 1;
    DefaultGeolocationSetting = 2;
    DefaultNotificationsSetting = 2;
    DefaultWebBluetoothGuardSetting = 2;
    DefaultFileSystemReadGuardSetting = 2;
    DefaultFileSystemWriteGuardSetting = 2;
    DefaultSerialGuardSetting = 2;
    DefaultUsbGuardSetting = 2;
    BrowserGuestModeEnabled = false;
    BrowserAddPersonEnabled = false;
  };
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--disable-background-networking"
      "--disable-client-side-phishing-detection"
      "--disable-component-update"
      "--disable-domain-reliability"
      "--disable-features=AutofillServerCommunication,DriveFs,InProductHelpSnooze,SignInProfileCreation,SharingHubLinkToggle"
      "--disable-print-preview"
      "--disable-renderer-backgrounding"
      "--disable-speech-api"
      "--disable-sync"
      "--metrics-recording-only"
      "--no-default-browser-check"
      "--no-first-run"
      "--password-store=basic"
      "--safebrowsing-disable-auto-update"
      "--silent-debugger-extension-api"
    ];
    extensions = [
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC Browser
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
    ];
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };

  xdg.configFile."chromium/Policies/Managed/privacy-and-hardening.json".text =
    builtins.toJSON managedPolicy;
}
