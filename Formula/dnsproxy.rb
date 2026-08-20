class Dnsproxy < Formula
  desc "Simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support"
  homepage "https://github.com/AdguardTeam/dnsproxy"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.84.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.1/dnsproxy-darwin-arm64-v0.84.1.tar.gz"
      sha256 "9a02d08a0345e89d0e24d336cdb114c7dc144006997542d570019a7764f0746e"
    else
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.1/dnsproxy-darwin-amd64-v0.84.1.tar.gz"
      sha256 "7a662e156114f429114560545e01ae1735a80710a0129f6ae794efc3156b7939"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.1/dnsproxy-linux-arm64-v0.84.1.tar.gz"
    sha256 "a3e1a602d0d190d6949b1ddf44362ba3e09a45c1da2a9a2bf39f606eb3b1c27f"
  else
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.1/dnsproxy-linux-amd64-v0.84.1.tar.gz"
    sha256 "977364197eddb5fa13c012f6f3fd61b2ce689419be8cbc2d828631da9da3e865"
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
