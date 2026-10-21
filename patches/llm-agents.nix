{ formatelf }:
final: prev: {
  llm-agents = prev.llm-agents // {
    copilot-cli =
      let
        package = prev.llm-agents.copilot-cli;
      in
      if final.stdenv.hostPlatform.isLinux && package.version == "1.0.101" then
        # formatelf preserves the embedded Node SEA payload that patchelf corrupts.
        package.override {
          patchelf = formatelf.packages.${final.stdenv.buildPlatform.system}.default;
        }
      else
        package;
  };
}
