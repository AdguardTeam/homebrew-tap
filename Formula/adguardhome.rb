class Adguardhome < Formula
  desc "Network-wide ads and trackers blocking DNS server"
  homepage "https://github.com/AdguardTeam/AdGuardHome"
  license "GPL-3.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.107.80"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.80/AdGuardHome_darwin_arm64.zip"
      sha256 "fd5e09eebdf9758b455c9998c0afd32a7f6b9ca63104a9b290ac12b7d26963ad"
    else
      url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.80/AdGuardHome_darwin_amd64.zip"
      sha256 "f0bb399bb3f5e6d9f7879b7176f269796f1c62ac1ced2603815971a4ee620d57"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.80/AdGuardHome_linux_arm64.tar.gz"
    sha256 "d5e17d0d724418ddef8b7723ed8ade7eef4e621ec5b0e43a341859cca71a3d8f"
  else
    url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.80/AdGuardHome_linux_amd64.tar.gz"
    sha256 "28593bc761d71469abdbc6f39ca42cbed763ec92b63082c729177b037ed51d18"
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
