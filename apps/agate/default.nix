{
  user,
  ...
}:
let
  # The capsule mirrors the web site: the French tree at /, English under /en/.
  #
  # It cannot live on the apex: dbeley.ovh resolves to Netlify (where the HTML
  # is hosted), and gemini needs port 1965 on the same hostname to reach this
  # VM. Change this to "dbeley.ovh" only if the web site itself moves here.
  capsule = "gemini.dbeley.ovh";
  contentDir = "/srv/gemini";
in
{
  services.agate = {
    enable = true;
    hostnames = [ capsule ];
    inherit contentDir;
    # the module's default is [ "" ], which would put an empty argv entry on
    # the agate command line
    extraArgs = [ ];
  };

  networking.firewall.allowedTCPPorts = [ 1965 ];

  # Content is rsynced from the blog repository (`just deploy-gemini`), so the
  # login user owns the directory; agate runs as a DynamicUser and only reads
  # it.
  systemd.tmpfiles.rules = [
    "d ${contentDir} 0755 ${user} ${user} -"
  ];

  # No certificate to manage: gemini has no certificate authority and clients
  # pin whatever the capsule presented on first contact (TOFU). agate
  # generates a self-signed pair in /var/lib/agate/certificates/dbeley.ovh on
  # first start and reuses it afterwards — deleting it there invalidates every
  # client's pin.
}
