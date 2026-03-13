{ pkgs, ... }:
{
  # home.packages = [ pkgs.ollama-rocm ];
  # boot.initrd.kernelModules = [ "amdgpu" ];
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    # Optional: preload models, see https://ollama.com/library
    # loadModels = [
    #   "llama3.2:3b"
    #   "deepseek-r1:1.5b"
    #   # "deepseek-r1:8b"
    #   "qwen3.5:9b"
    # ];
    rocmOverrideGfx = "11.5.0";
    acceleration = "rocm";
  };
  services.open-webui.enable = true;
}
