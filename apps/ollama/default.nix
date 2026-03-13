{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      "llama3.2:3b"
      "deepseek-r1:1.5b"
      "deepseek-r1:8b"
      "qwen3.5:9b"
      "glm-4.7-flash"
      "qwen3-coder-next"
    ];
    rocmOverrideGfx = "11.5.0";
  };
  services.open-webui = {
    enable = true;
  };
}
