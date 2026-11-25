class Adyg < Formula
  desc "Small dig-like DNS query CLI tool built on the upstream library"
  homepage "https://github.com/AdguardTeam/DnsLibs"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "2.11.0"

  url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.11.0/adyg-v2.11.0-macos-universal.tar.gz"
  sha256 "dafee97e8dbd6f3ad3e93f66c286dbb009c3865e5acebddf593ed65227f730a3"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.11.0/adyg-v2.11.0-linux-aarch64.tar.gz"
      sha256 "5ee3b6fe5dc88a5b09f76613e94312b4bdfdb84c1e0da0a05c225bd135f9816d"
    else
      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.11.0/adyg-v2.11.0-linux-x86_64.tar.gz"
      sha256 "e97e99ee9106178f7c61b8f5e274951770773c364024af958b75dfe50f49af3f"
    end
  end
  # --- END MANAGED ---

  def install
    bin.install "adyg"
  end

  test do
    assert_match(/adyg \d+(\.\d+)+/, shell_output("#{bin}/adyg -v"))
  end
end
