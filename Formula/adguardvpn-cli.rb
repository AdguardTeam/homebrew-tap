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
  version "1.8.1"

  url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.1-release/adguardvpn-cli-1.8.1-macos.tar.gz"
  sha256 "fd87fdd3b875068593249ac62d2cac87d3f7188efbe0dea598c55620e4e70c10"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.1-release/adguardvpn-cli-1.8.1-linux-aarch64.tar.gz"
      sha256 "43c8850fef41efa8fd1389e4b875c9e85d59ff8e1cc17cb2a586084825c4bfbe"
    else
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.1-release/adguardvpn-cli-1.8.1-linux-x86_64.tar.gz"
      sha256 "e48b67f0ff4c5a5b1099890d7ea4ef0d26e9119d379f019c751a45b3715bc62d"
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
