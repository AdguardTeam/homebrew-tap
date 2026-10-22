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
  version "1.5.0"

  url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.5.0/adguard-cli-1.5.0-macos.tar.gz"
  sha256 "9b248a40978b78c0e442feb4034cff357337394a86d5cfb8802468fcb37b6c48"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.5.0/adguard-cli-1.5.0-linux-aarch64.tar.gz"
      sha256 "bb92958a8b17a037058d2f9c4b5018a8a23c9f1ab18c89efb6557a5e729701d9"
    else
      url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.5.0/adguard-cli-1.5.0-linux-x86_64.tar.gz"
      sha256 "e515de4a4b36d31067416731abe1450e494edd3743df766d9e4673b9ed9f3e28"
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
