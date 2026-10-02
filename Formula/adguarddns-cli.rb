class AdguarddnsCli < Formula
  desc "AdGuard DNS command-line interface"
  homepage "https://github.com/AdguardTeam/AdGuardDNSCLI"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.2.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardDNSCLI/releases/download/v0.2.1/AdGuardDNSCLI_darwin_arm64.zip"
      sha256 "630d18d3ad344317086ac2d6f40489c105ae33dcc5ef58795bee9163a61d2de0"
    else
      url "https://github.com/AdguardTeam/AdGuardDNSCLI/releases/download/v0.2.1/AdGuardDNSCLI_darwin_amd64.zip"
      sha256 "f88f912bbae147f7f0f59cbf2add1b4edf9b779d2f463f5db54ebcc1058f5e0e"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/AdGuardDNSCLI/releases/download/v0.2.1/AdGuardDNSCLI_linux_arm64.tar.gz"
    sha256 "ba589b425148e342728e70ddfa8721b0433fd0e423649b8c3f12394fda2a9b8b"
  else
    url "https://github.com/AdguardTeam/AdGuardDNSCLI/releases/download/v0.2.1/AdGuardDNSCLI_linux_amd64.tar.gz"
    sha256 "92d9406e961957b383cc056c821f4c04ae2967715b385b1eb9f71a531e698255"
  end
  # --- END MANAGED ---

  def install
    # Homebrew cds into the single top-level directory of the archive.
    bin.install "adguarddns-cli"
  end

  test do
    assert_match(/v\d+\.\d+\.\d+/, shell_output("#{bin}/adguarddns-cli --version"))
  end
end
