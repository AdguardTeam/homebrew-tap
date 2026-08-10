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
  version "1.4.13"

  url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.4.13-release/adguard-cli-1.4.13-macos.tar.gz"
  sha256 "7f917aa5744695ce7c9af870df72061b33b17e07c233f1fa6a381c9fc1675065"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.4.13-release/adguard-cli-1.4.13-linux-aarch64.tar.gz"
      sha256 "607af03ed83563d8d4162a2a3e5c9ed0d05d6d5b73840ec41fb5c5c573d09a45"
    else
      url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.4.13-release/adguard-cli-1.4.13-linux-x86_64.tar.gz"
      sha256 "0575c9a2397fc1537d9c8213811f0d79867a7953f2481f3e9677bd3f0a2cf88c"
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
