# Hermes agent config. hermes merges this over its built-in defaults and
# never rewrites the user file, so this is the supported config surface.
# Web backends are set to exa (EXA_API_KEY comes from the systemd service's
# environmentFiles). Updated via `scp` from the running host then committed.
{
  home.file.".hermes/config.yaml".source = ./config.yaml;
}
