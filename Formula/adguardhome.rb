class Adguardhome < Formula
  desc "Network-wide ads and trackers blocking DNS server"
  homepage "https://github.com/AdguardTeam/AdGuardHome"
  license "GPL-3.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "1.0.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v1.0.0/AdGuardHome_darwin_arm64.zip"
      sha256 "0a180a9a0a8e7a57b2a73e252ffcb4fda4a7c668576d0228aae96114689129ed"
    else
      url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v1.0.0/AdGuardHome_darwin_amd64.zip"
      sha256 "da7ce3790c268eb4f932a951d09c297dcbfcc8f256eccb86eaff8267a816b6c8"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v1.0.0/AdGuardHome_linux_arm64.tar.gz"
    sha256 "f5c331d29580726179d3119c0464ddacd6fdcd487a0a9e108532f58fdf772604"
  else
    url "https://github.com/AdguardTeam/AdGuardHome/releases/download/v1.0.0/AdGuardHome_linux_amd64.tar.gz"
    sha256 "19e023d98eb42eb1cdbfd6e4b6ebc937dade59e969506c62eafb3a3d6d2c1e4f"
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
