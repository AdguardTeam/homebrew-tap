class Dnsproxy < Formula
  desc "Simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support"
  homepage "https://github.com/AdguardTeam/dnsproxy"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.86.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.86.0/dnsproxy-darwin-arm64-v0.86.0.tar.gz"
      sha256 "5964db3a45d39df4e41f74907f50657a80907c514355f9ad75b9666e3431d277"
    else
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.86.0/dnsproxy-darwin-amd64-v0.86.0.tar.gz"
      sha256 "14bbc3f9f561d0a2483ce402bc4510767086f0d60bf32d0a4213d53d1538457d"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.86.0/dnsproxy-linux-arm64-v0.86.0.tar.gz"
    sha256 "eda840d39da0c2777ea2431d3d73407e813e3fc0e411bfe256a9fb4b97d08247"
  else
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.86.0/dnsproxy-linux-amd64-v0.86.0.tar.gz"
    sha256 "17ac43f76ebfcedf547c663f6f31aa70e68b8eb6fc41d2fc37d3bfe21a2ced66"
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
