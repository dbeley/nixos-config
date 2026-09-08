let
  # Hand-picked upstream NTP servers (NOT pool.ntp.org)
  # See: https://support.ntp.org/bin/view/Servers/NtpPoolServers
  upstreamServers = [
    # France
    "ntp.online.net" # Scaleway/Online.net
    "time.franceme.net" # French NTP
    "ntp.fflep.org" # French IPv6
    # Europe/Global (anycast)
    "time.cloudflare.com" # Cloudflare
    "time.google.com" # Google
  ];
in
{
  # Disable systemd-timesyncd (we're serving, not just syncing)
  services.timesyncd.enable = false;

  # Use chrony for NTP pool participation
  services.chrony = {
    enable = true;

    # Hand-picked upstream servers
    servers = upstreamServers;

    # Configure as pool server
    extraConfig = ''
      # Allow pool clients (any source)
      allow

      # Enable rate limiting to protect against abuse
      maxsources 4

      # Disable management queries from external (security)
      # Localhost can still use ntpq
      noserve
    '';
  };

  # Open UDP 123 for NTP pool traffic
  networking.firewall.allowedUDPPorts = [
    123 # NTP
  ];

  networking.firewall.logRefusedConnections = false;
}
