class Adguardhome < Formula
  desc "Network-wide ads and trackers blocking DNS server"
  homepage "https://github.com/AdguardTeam/AdGuardHome"
  license "GPL-3.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.107.78"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.78/AdGuardHome_darwin_arm64.zip"
      sha256 "9ccbf51e55d7a1ea13ee49ec8e58bb1ab88aa2ca9361eed11660c565e8d8a202"
    else
      url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.78/AdGuardHome_darwin_amd64.zip"
      sha256 "7730683fd1870767d51b0938052899f53b1bf6a80c22619e156d2bd9779635b2"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.78/AdGuardHome_linux_arm64.tar.gz"
    sha256 "71ef6d495d6d3fae45e6a80a172d44ae7f5aa528794cf927bb52fd5bff034eae"
  else
    url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.78/AdGuardHome_linux_amd64.tar.gz"
    sha256 "2070f644644be8299232f4a7bff857036fb1423563c1bf8c787e07aaf4f88278"
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
