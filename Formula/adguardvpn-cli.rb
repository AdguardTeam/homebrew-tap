class AdguardvpnCli < Formula
  desc "Command-line interface for AdGuard VPN on Linux and macOS"
  homepage "https://github.com/AdguardTeam/AdGuardVPNCLI"
  license "proprietary"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  #
  # NOTE: AdGuard VPN CLI is not an open-source project; binaries are
  # distributed through GitHub releases and the GitHub repo is used as an issue
  # tracker.
  # --- BEGIN MANAGED ---
  version "1.7.12"

  url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.7.12-release/adguardvpn-cli-1.7.12-macos.tar.gz"
  sha256 "32e89e923cf1888e3e17c4ec040d45376201ce1006945a3163384c6d73ada37b"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.7.12-release/adguardvpn-cli-1.7.12-linux-aarch64.tar.gz"
      sha256 "872fcd81ec41f952001c567abd2e61564773ccdcf5be246afd047f3d3eb4ee0b"
    else
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.7.12-release/adguardvpn-cli-1.7.12-linux-x86_64.tar.gz"
      sha256 "a706933c87ec88eec8578cce96d2b91c385e083cf738a806e69b3bcd877fb88c"
    end
  end
  # --- END MANAGED ---

  def install
    bin.install "adguardvpn-cli"
    bash_completion.install "bash-completion.sh" => "adguardvpn-cli"
  end

  def caveats
    <<~EOS
      AdGuard VPN CLI is not an open-source project; the prebuilt binary is
      distributed through GitHub releases.
    EOS
  end

  test do
    assert_match(/AdGuard VPN CLI v\d+\.\d+\.\d+/, shell_output("#{bin}/adguardvpn-cli --version"))
  end
end
