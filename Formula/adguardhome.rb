class Adguardhome < Formula
  desc "Network-wide ads and trackers blocking DNS server"
  homepage "https://github.com/AdguardTeam/AdGuardHome"
  license "GPL-3.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.107.79"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.79/AdGuardHome_darwin_arm64.zip"
      sha256 "916f50bcc16b452c63ab8289f523a3c637e84933460a0ae7525fec03e31de867"
    else
      url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.79/AdGuardHome_darwin_amd64.zip"
      sha256 "a28e30605c306c9002a496e705cffbe8828ef300ba5e85121e9308e623335ffa"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.79/AdGuardHome_linux_arm64.tar.gz"
    sha256 "3f7893c18e8aaadc456d0452839190561c306ca95175a2254958be80a769c1ae"
  else
    url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.79/AdGuardHome_linux_amd64.tar.gz"
    sha256 "c48f4a43000665484c5ec28177de11a004759b620dae8f77b2aabefc9ef3687f"
  end
  # --- END MANAGED ---

  def install
    # Homebrew cds into the single top-level directory of the archive.
    bin.install "AdGuardHome"
  end

  test do
    assert_match(/AdGuard Home, version v\d+\.\d+\.\d+/, shell_output("#{bin}/AdGuardHome --version"))
  end
end
