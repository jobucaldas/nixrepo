{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  writeShellScript,
  makeWrapper,
  ffmpeg,
  pipewire,
  procps,
  bc,
  bash,
  wl-clipboard,
  xclip,
  python3,
  whisper-cpp-vulkan,
  jq,
  engine ? "whisper-cpp",
}:
let
  useWhisperCpp = engine == "whisper-cpp";
  useFasterWhisper = engine == "faster-whisper";

  src = fetchFromGitHub {
    owner = "wpbryant";
    repo = "xhisper-local";
    rev = "e4ff18dc4c5ac5f1c0c9212f3ff1d15aaeb0b3ec";
    hash = "sha256-HsBCKHZNN57zqQBjmpsrbpcbAQso+qEutwDu3fsuKt8=";
  };

  modelTiny = fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin";
    hash = "sha256-vgfgSOHlma1GNByNKhNWRQl6U4IhZ4t6zdGxkZxuGyE=";
  };

  modelBase = fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin";
    hash = "sha256-YO1bw90U7qhWST0zQ0m0BXgt3K8AKNS130CINF+6Lv4=";
  };

  pythonEnv = python3.withPackages (ps: [ ps.faster-whisper ]);

  transcribeWhisperCpp = writeShellScript "xhisper-transcribe-whisper-cpp" ''
    set -uo pipefail

    MODEL="base"
    LANGUAGE=""
    PROMPT=""
    DEBUG=0
    AUDIO=""

    usage() {
      echo "Usage: $(basename "$0") AUDIO_FILE [--model tiny|base] [--device auto|cpu|cuda] [--language LANG] [--prompt TEXT] [--debug]" >&2
    }

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --model)
          MODEL="''${2:?--model needs a value}"
          shift 2
          ;;
        --device)
          shift 2 ;; # ignored: whisper-cli picks Vulkan, else CPU
        --language)
          LANGUAGE="''${2:-}"
          shift 2
          ;;
        --prompt)
          PROMPT="''${2:-}"
          shift 2
          ;;
        --debug)
          DEBUG=1
          shift
          ;;
        -h | --help)
          usage
          exit 0
          ;;
        -*)
          echo "Error: unknown option '$1'" >&2
          usage
          exit 1
          ;;
        *)
          AUDIO="$1"
          shift
          ;;
      esac
    done

    if [[ -z "$AUDIO" || ! -f "$AUDIO" ]]; then
      echo "Error: audio file not found: ''${AUDIO:-<none>}" >&2
      exit 1
    fi

    case "$MODEL" in
      tiny) MODEL_FILE="${modelTiny}" ;;
      base) MODEL_FILE="${modelBase}" ;;
      *)
        echo "Error: unsupported model '$MODEL' (this build ships tiny|base)" >&2
        exit 1
        ;;
    esac

    [[ "$DEBUG" == 1 ]] && set -x

    WORKDIR=$(mktemp -d)
    trap 'rm -rf "$WORKDIR"' EXIT

    args=(
      -m "$MODEL_FILE"
      -f "$AUDIO"
      -np
      -oj
      -of "$WORKDIR/out"
    )
    if [[ -n "$LANGUAGE" ]]; then
      args+=(-l "$LANGUAGE")
    else
      args+=(-l auto)
    fi
    [[ -n "$PROMPT" ]] && args+=(--prompt "$PROMPT")

    whisper-cli "''${args[@]}" >/dev/null 2>&1

    jq -rj '[.transcription // [] | .[].text] | join(" ")' "$WORKDIR/out.json" |
      sed 's/^ *//;s/ *$//;s/  */ /g'
  '';
in
assert lib.assertMsg (
  useWhisperCpp || useFasterWhisper
) "xhisper: engine must be \"whisper-cpp\" or \"faster-whisper\", got \"${engine}\"";
stdenv.mkDerivation rec {
  pname = "xhisper-${engine}";
  version = "unstable-2026-09-17";

  inherit src;

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    cc -O2 -Wall -Wextra xhispertool.c -o xhispertool
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 xhispertool $out/bin/xhispertool
    ln -sf $out/bin/xhispertool $out/bin/xhispertoold
    install -Dm755 xhisper.sh $out/bin/xhisper
    install -Dm644 default_xhisperrc $out/share/xhisper/default_xhisperrc

    ${lib.optionalString useWhisperCpp ''
      install -Dm755 ${transcribeWhisperCpp} $out/bin/xhisper_transcribe

      grep -q '^NV_LIBS=' $out/bin/xhisper || (echo "xhisper.sh: NV_LIBS line gone, update the CUDA cleanup" >&2; exit 1)
      grep -q '^export LD_LIBRARY_PATH=' $out/bin/xhisper || (echo "xhisper.sh: LD_LIBRARY_PATH line gone, update the CUDA cleanup" >&2; exit 1)
      sed -i '/^NV_LIBS=/d; /^export LD_LIBRARY_PATH=/d' $out/bin/xhisper

      substituteInPlace $out/bin/xhisper \
        --replace-fail 'python3 "$TRANSCRIPT_SCRIPT"' \
                        '"$TRANSCRIPT_SCRIPT"'
    ''}

    ${lib.optionalString useFasterWhisper ''
      install -Dm755 xhisper_transcribe.py $out/bin/xhisper_transcribe
    ''}

    substituteInPlace $out/bin/xhisper \
      --replace-fail 'TRANSCRIPT_SCRIPT="$(command -v xhisper_transcribe)"' \
                      'TRANSCRIPT_SCRIPT="${placeholder "out"}/bin/xhisper_transcribe"'

    wrapProgram $out/bin/xhisper \
      --prefix PATH : "${
        lib.makeBinPath (
          [
            ffmpeg
            pipewire
            procps
            bc
            bash
            wl-clipboard
            xclip
          ]
          ++ lib.optional useFasterWhisper pythonEnv
        )
      }" \
      ${lib.optionalString useFasterWhisper ''--set XHISPER_PYTHON "${pythonEnv}/bin/python3"''}

    ${lib.optionalString useWhisperCpp ''
      wrapProgram $out/bin/xhisper_transcribe \
        --prefix PATH : "${
          lib.makeBinPath [
            whisper-cpp-vulkan
            jq
          ]
        }"
    ''}
    ${lib.optionalString useFasterWhisper ''
      wrapProgram $out/bin/xhisper_transcribe \
        --prefix PATH : "${lib.makeBinPath [ pythonEnv ]}"
    ''}
    runHook postInstall
  '';

  meta = with lib; {
    description =
      if useWhisperCpp then
        "Offline dictation at cursor for Linux (xhisper UX, whisper-cpp Vulkan engine)"
      else
        "Offline dictation at cursor for Linux (local faster-whisper fork of xhisper)";
    homepage = "https://github.com/wpbryant/xhisper-local";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "xhisper";
  };
}
