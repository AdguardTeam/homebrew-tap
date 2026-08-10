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
  version "1.6.24"

  url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.6.24-release/adguardvpn-cli-1.6.24-macos.tar.gz"
  sha256 "a9d3b852cd3c38662caaaa556325e2b316925834ce33add82537e5e97aa743fb"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.6.24-release/adguardvpn-cli-1.6.24-linux-aarch64.tar.gz"
      sha256 "71ea36ed43c105ce2f7773083bd290d6b46f99b96181177084f086687c7c36df"
    else
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.6.24-release/adguardvpn-cli-1.6.24-linux-x86_64.tar.gz"
      sha256 "7fa79c65e200f9494fd9315d2262c690003ca810b2d4d2fc9e211fb787e09b7f"
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
