{
  services.ollama = {
    enable = true;
    loadModels = [
      # "llama3.2:3b"
    ];
  };
  services.open-webui = {
    enable = true;
  };
}
