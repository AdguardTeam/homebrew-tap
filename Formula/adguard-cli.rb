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
  version "1.3.35"

  url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.3.35-release/adguard-cli-1.3.35-macos.tar.gz"
  sha256 "b332665fe29702b995479ce7879bb1eee76e323d5090a850169373ab88e61ea3"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.3.35-release/adguard-cli-1.3.35-linux-aarch64.tar.gz"
      sha256 "92c744cc159a3e73e2d3d3615aefcf5c64cf3ea013ae3425c690ec2abbb69793"
    else
      url "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.3.35-release/adguard-cli-1.3.35-linux-x86_64.tar.gz"
      sha256 "ac35f24c7c3ffb190c3729f9b19c7868e5bfc8a31522fc7d2d954dfaea963111"
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
