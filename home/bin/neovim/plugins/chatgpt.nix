{config, ...}: {
  programs.nixvim.plugins.chatgpt = {
    enable = true;
    settings = {
      api_key_cmd = "cat ${config.sops.secrets.openai_api_key.path}";
    };
  };
}
