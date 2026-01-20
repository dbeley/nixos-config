{
  # List of skill repositories to fetch
  # Each skill will be symlinked to ~/.config/opencode/skills/<skillName>/
  skills = [
    # Single-skill repositories (entire repo is the skill)
    {
      owner = "blader";
      repo = "humanizer";
      rev = "3b117912054aab527533523a173999df0bce862f";
      sha256 = "sha256-4gh92+5AQ6AH7BUduKXLM3vLA3FQNvX5sGn4tJ2Pxh8=";
      skillName = "humanizer";
    }
    {
      owner = "blader";
      repo = "Claudeception";
      rev = "c0daa23c5dd999deda95831996a0b2ac5da292c2";
      sha256 = "sha256-9cpbEu87JwHVD9nBeju0ciysx00E+PMlhpqIFiBHcXU=";
      skillName = "claudeception";
    }
    # Multi-skill repository (Nymbo/Skills contains multiple skills in subdirectories)
    # We'll create separate entries for each skill we want from this repo
    {
      owner = "Nymbo";
      repo = "Skills";
      rev = "218da9fe55d37fc3e738c4fcb5ac733117081d9b";
      sha256 = "sha256-qf7JJJBZd54UKOY/35i0MoEECk1D7LA5HEiHHDtXg9E=";
      subPath = "plan-work";
      skillName = "plan-work";
    }
    {
      owner = "Nymbo";
      repo = "Skills";
      rev = "218da9fe55d37fc3e738c4fcb5ac733117081d9b";
      sha256 = "sha256-qf7JJJBZd54UKOY/35i0MoEECk1D7LA5HEiHHDtXg9E=";
      subPath = "commit-work";
      skillName = "commit-work";
    }
    {
      owner = "Nymbo";
      repo = "Skills";
      rev = "218da9fe55d37fc3e738c4fcb5ac733117081d9b";
      sha256 = "sha256-qf7JJJBZd54UKOY/35i0MoEECk1D7LA5HEiHHDtXg9E=";
      subPath = "deep-research";
      skillName = "deep-research";
    }
  ];
}
