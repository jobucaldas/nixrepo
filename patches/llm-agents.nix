{ formatelf }:
final: prev: {
  llm-agents = prev.llm-agents // {
    chatgpt =
      let
        package = prev.llm-agents.chatgpt;
      in
      if final.stdenv.hostPlatform.isLinux then
        package.override {
          chatgpt-unwrapped = package.unwrapped.overrideAttrs (old: {
            # The native device-key module links against the TPM2 TSS libraries.
            buildInputs = (old.buildInputs or [ ]) ++ [ final.tpm2-tss ];
          });
        }
      else
        package;

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
