class AdguardCli < Formula
  desc "Command-line interface for AdGuard (ad-blocking) on Linux and macOS"
  homepage "https://github.com/AdguardTeam/AdGuardCLI"
  license "proprietary"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  #
  # NOTE: AdGuard CLI is not an open-source project; binaries are distributed
  # through GitHub releases and the GitHub repo is used as an issue tracker.
  # --- BEGIN MANAGED ---
  version "1.5.1"

  url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.5.1/adguard-cli-1.5.1-macos.tar.gz"
  sha256 "09821ea8367711888f26d1589ff31df0bc74c0a33d1d1009d6be0d04d9e33aa8"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.5.1/adguard-cli-1.5.1-linux-aarch64.tar.gz"
      sha256 "9bb3ad73cabc7837ed2867dd5ba89cec728d575f72b8a52a321bade5e7d59451"
    else
      url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.5.1/adguard-cli-1.5.1-linux-x86_64.tar.gz"
      sha256 "f37556565664cef0e4ad385f8496824aae79f43ac97f0117f23f79d434e83d00"
    end
  end
  # --- END MANAGED ---

  def install
    bin.install "adguard-cli"
    bash_completion.install "bash-completion.sh" => "adguard-cli"
  end

  def caveats
    <<~EOS
      For system-wide DNS filtering on macOS you may need to run
        sudo adguard-cli configure
      AdGuard CLI is not an open-source project; the prebuilt binary is
      distributed through GitHub releases.
    EOS
  end

  test do
    assert_match(/AdGuard CLI v\d+\.\d+\.\d+/, shell_output("#{bin}/adguard-cli --version"))
  end
end
