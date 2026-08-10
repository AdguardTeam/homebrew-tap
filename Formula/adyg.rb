class Adyg < Formula
  desc "Small dig-like DNS query CLI tool built on the upstream library"
  homepage "https://github.com/AdguardTeam/DnsLibs"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "2.10.0"

  url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.0/adyg-v2.10.0-macos-universal.tar.gz"
  sha256 "257d03e8083b564b38fc383931d09f9956da309873811f6f3a2e811968bee13b"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.0/adyg-v2.10.0-linux-aarch64.tar.gz"
      sha256 "69efd31ec44d9d5ea4ce755f69adb2329213a344ad933a6a222f9b7df5af7d4e"
    else
      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.0/adyg-v2.10.0-linux-x86_64.tar.gz"
      sha256 "0866c87ba166eaa6aba43da241ca6808febbade641ef9900646d42804f47b3e3"
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
