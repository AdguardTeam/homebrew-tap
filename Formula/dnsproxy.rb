class Dnsproxy < Formula
  desc "Simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support"
  homepage "https://github.com/AdguardTeam/dnsproxy"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.85.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.85.0/dnsproxy-darwin-arm64-v0.85.0.tar.gz"
      sha256 "64c2a6c2645745e24369f21c9e22661a18bfcfdcbdd8ff54af0d37328b3ea9e6"
    else
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.85.0/dnsproxy-darwin-amd64-v0.85.0.tar.gz"
      sha256 "48ea71b4f3d3f78d39f3e5bce43379bef41889e32fc45b8391598df9dd3b55c1"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.85.0/dnsproxy-linux-arm64-v0.85.0.tar.gz"
    sha256 "6243b9e6c48d2fce9eee0c1170566b8474768ec87602baccbc6dc44514a83568"
  else
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.85.0/dnsproxy-linux-amd64-v0.85.0.tar.gz"
    sha256 "740af768b17fe8ecc2dbc8c82c7b5224e43278a181b4fe31b0cce5d8da656332"
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
