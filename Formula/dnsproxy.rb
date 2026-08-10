class Dnsproxy < Formula
  desc "Simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support"
  homepage "https://github.com/AdguardTeam/dnsproxy"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "0.83.2"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.83.2/dnsproxy-darwin-arm64-v0.83.2.tar.gz"
      sha256 "509f56266af3c06104d57e75cff2f741de80ba3dd916a75c3c07c5d8b124f030"
    else
      url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.83.2/dnsproxy-darwin-amd64-v0.83.2.tar.gz"
      sha256 "e8f7ad5261690e89fc665cb24881da13f72183a97d34a9cd5e22e8d3357fd5bc"
    end
  elsif Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.83.2/dnsproxy-linux-arm64-v0.83.2.tar.gz"
    sha256 "83fd900d80be1309a64d1bbbd98a034594501870faa8bd2f60266e0ad7296f22"
  else
    url "https://github.com/AdguardTeam/dnsproxy/releases/download/v0.83.2/dnsproxy-linux-amd64-v0.83.2.tar.gz"
    sha256 "9b02ed517a792f2fd492601c00c96454c4ee1b17c4c8792de58770aade327ddf"
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
