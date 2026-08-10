class Adyg < Formula
  desc "Small dig-like DNS query CLI tool built on the upstream library"
  homepage "https://github.com/AdguardTeam/DnsLibs"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "2.10.1"

  url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-macos-universal.tar.gz"
  sha256 "18ea085d00c4366ea1c7ee4dd5a6b872bf49a392507d3d7b0cd14bf4b039c4f9"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-linux-aarch64.tar.gz"
      sha256 "d2f3b0e9e14fbb675b51bc663e1bf0c98f4dd367f4d86e6278b5c4d2bea5800b"
    else
      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-linux-x86_64.tar.gz"
      sha256 "82e9f3ec16cd17c30807530fd49d792c3c15c77f904075e073aea67aa9481337"
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
