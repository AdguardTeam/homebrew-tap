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
  version "1.8.2"

  url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.2/adguardvpn-cli-1.8.2-macos.tar.gz"
  sha256 "53d16c1b0b372391709f17ed6a86c929381ae2e0b4b696084070ccc3782fed32"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.2/adguardvpn-cli-1.8.2-linux-aarch64.tar.gz"
      sha256 "3de54a9f31352d4d9a1262efc17c979dc5fdeca6c5ae8d06242b3438b38a5575"
    else
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.2/adguardvpn-cli-1.8.2-linux-x86_64.tar.gz"
      sha256 "7e78aff6e890435ec8f67390a228282cabfa16d39a8fefbf908a5a0176bc61cb"
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
