class AdguarddnsCli < Formula
  desc "AdGuard DNS command-line interface"
  homepage "https://github.com/AdguardTeam/AdGuardDNSCLI"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.2.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardDNSCLI/releases/download/v0.2.0/AdGuardDNSCLI_darwin_arm64.zip"
      sha256 "ac2708cf7f07243bd61d59717a126718e653a2398e8f86310fb652dea7626bfa"
    else
      url "https://github.com/AdguardTeam/AdGuardDNSCLI/releases/download/v0.2.0/AdGuardDNSCLI_darwin_amd64.zip"
      sha256 "bd94bc8fedc50359ff693ecf9f022c242a9fedc464064c49393986dad2f62773"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/AdGuardDNSCLI/releases/download/v0.2.0/AdGuardDNSCLI_linux_arm64.tar.gz"
    sha256 "458413f930685224af2b98bb6edae4ce2741735688ec74a5027c7370292f91d9"
  else
    url "https://github.com/AdguardTeam/AdGuardDNSCLI/releases/download/v0.2.0/AdGuardDNSCLI_linux_amd64.tar.gz"
    sha256 "be6f73b2fcc989514bf70d06809ef478ddb891428854165da91152925cfca06d"
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
