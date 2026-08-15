class Dnsproxy < Formula
  desc "Simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support"
  homepage "https://github.com/AdguardTeam/dnsproxy"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.84.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.0/dnsproxy-darwin-arm64-v0.84.0.tar.gz"
      sha256 "8b1f5d8ec7f4f9daad9be95b0bc6c21a82cf7ab6607f7294a430505f1a021eed"
    else
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.0/dnsproxy-darwin-amd64-v0.84.0.tar.gz"
      sha256 "263188359b248ecb07ec93241791e83961af9f18c447b55086578962876eabbc"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.0/dnsproxy-linux-arm64-v0.84.0.tar.gz"
    sha256 "5180311ad9f16cfe16f354fdc66db6a67fe45193b35bf7f70df5ac275f48d098"
  else
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.84.0/dnsproxy-linux-amd64-v0.84.0.tar.gz"
    sha256 "5137f6fd0e965692889e8e94cc7ff8be512a6bbee07d988a4935f9d8f24a2102"
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
