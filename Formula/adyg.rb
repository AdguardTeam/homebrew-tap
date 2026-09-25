class Adyg < Formula
  desc "Small dig-like DNS query CLI tool built on the upstream library"
  homepage "https://github.com/AdguardTeam/DnsLibs"
  license "Apache-2.0"

  # Pinned to the latest release by scripts/update-versions.js, which runs on a
  # schedule (see .github/workflows/update-versions.yml). Do not edit the
  # managed block by hand — run `npm run update-versions` instead.
  # --- BEGIN MANAGED ---
  version "2.10.2"

  url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.2/adyg-v2.10.2-macos-universal.tar.gz"
  sha256 "5cbfb64af3342ad76d4d2e1504792be11e7033a57a5aa4ea686fcd61e3f65013"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.2/adyg-v2.10.2-linux-aarch64.tar.gz"
      sha256 "b25820972e9840bf6d30a9d7b48c70de048e590b498ceb81c916a4b0dfb5afb6"
    else
      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.2/adyg-v2.10.2-linux-x86_64.tar.gz"
      sha256 "e2c36ac1b453b9d754e6823cfe92fbcc247a76d003af95f56374fe3387b752c2"
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
