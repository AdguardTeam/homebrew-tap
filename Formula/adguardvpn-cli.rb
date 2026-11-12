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
  version "1.8.3"

  url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.3/adguardvpn-cli-1.8.3-macos.tar.gz"
  sha256 "340501f5bac9b66042c9c4bbda3b66f6a9caba525b53bcb1a2feb423b7b63fde"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.3/adguardvpn-cli-1.8.3-linux-aarch64.tar.gz"
      sha256 "f39d7eec102ac1bfada80a2cb6453a507d7a7a381af09ef0fb62ea6fa88374aa"
    else
      url "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/download/v1.8.3/adguardvpn-cli-1.8.3-linux-x86_64.tar.gz"
      sha256 "00722863c705ba6e0dff0533bcab693561423987f3db6dcd78d16b76fff70a3c"
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
