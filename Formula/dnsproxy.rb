class Dnsproxy < Formula
  desc "Simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support"
  homepage "https://github.com/AdguardTeam/dnsproxy"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.84.2"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.2/dnsproxy-darwin-arm64-v0.84.2.tar.gz"
      sha256 "f72490d1d76566a9101e719fce4174e5fe794695c9c0ad9334bd5ecf7664b3da"
    else
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.2/dnsproxy-darwin-amd64-v0.84.2.tar.gz"
      sha256 "72824e9a402f70bb5ca9daa615e3c9c0669b1c9fe5b5d46637b4f5c64924f5aa"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.2/dnsproxy-linux-arm64-v0.84.2.tar.gz"
    sha256 "e9bcdb4fcc35c2ac85e837745416a599af6024a07637cc042c92a5a368277d5e"
  else
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.2/dnsproxy-linux-amd64-v0.84.2.tar.gz"
    sha256 "0b4ae9f09f9e4e701208291b79df26d08532bdbfdc8a928f22b9454ba5c4057a"
  end
  # --- END MANAGED ---

  def install
    # Each archive contains a single top-level directory (the platform name);
    # Homebrew cds into it, so the binary is at the top level here.
    bin.install "dnsproxy"
  end

  test do
    assert_match(/dnsproxy version v\d+\.\d+\.\d+/, shell_output("#{bin}/dnsproxy --version"))
  end
end
