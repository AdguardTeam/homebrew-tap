class AdguardCli < Formula
  require "json"
  require "net/http"
  require "uri"

  desc "Command-line interface for AdGuard (ad-blocking) on Linux and macOS"
  homepage "https://github.com/AdguardTeam/AdGuardCLI"
  license "proprietary"

  # The GitHub repository whose `/releases/latest` endpoint is used to pick the
  # newest release, its asset URL, and its sha256 at install time, so the
  # formula always installs the latest release.
  #
  # NOTE: AdGuard CLI is not an open-source project; binaries are distributed
  # through GitHub releases and the GitHub repo is used as an issue tracker.
  REPO = "AdguardTeam/AdGuardCLI".freeze

  # Queries the GitHub releases API for the latest (non-prerelease) release.
  def self.latest_release
    uri = URI("https://api.github.com/repos/#{REPO}/releases/latest")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10
    http.read_timeout = 10
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/vnd.github+json"
    request["User-Agent"] = "homebrew-tap"
    response = http.request(request)
    JSON.parse(response.body)
  rescue => e
    odie "Unable to fetch the latest release of #{REPO}: #{e}"
  end

  release = latest_release
  TAG_NAME = release.fetch("tag_name").freeze
  VERSION = TAG_NAME.delete_prefix("v").delete_suffix("-release").freeze
  ASSETS = release.fetch("assets").freeze

  # Returns the release asset whose filename matches the given pattern.
  def self.asset(matching)
    ASSETS.find { |a| a["name"].to_s.match?(matching) }
  end

  macos_asset = asset(/-macos\.tar\.gz\z/)
  odie "No macOS release asset found for #{TAG_NAME}" if macos_asset.nil?
  odie "No sha256 digest for the macOS asset of #{TAG_NAME}" if macos_asset["digest"].to_s.empty?

  url macos_asset.fetch("browser_download_url")
  sha256 macos_asset.fetch("digest").delete_prefix("sha256:")
  version VERSION

  on_linux do
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    linux_asset = ASSETS.find { |a| a["name"].to_s.match?(/-linux-#{arch}\.tar\.gz\z/) }
    odie "No #{arch} Linux release asset found for #{TAG_NAME}" if linux_asset.nil?
    odie "No sha256 digest for the #{arch} Linux asset of #{TAG_NAME}" if linux_asset["digest"].to_s.empty?

    url linux_asset.fetch("browser_download_url")
    sha256 linux_asset.fetch("digest").delete_prefix("sha256:")
  end

  def install
    bin.install "adguard-cli"
    bash_completion.install "bash-completion.sh" => "adguard-cli"
  end

  def caveats
    <<~EOS
      For system-wide DNS filtering on macOS you may need to run
        sudo adguard-cli configure
      AdGuard CLI is not an open-source project; the prebuilt binary is
      distributed through GitHub releases.
    EOS
  end

  test do
    assert_match(/AdGuard CLI v\d+\.\d+\.\d+/, shell_output("#{bin}/adguard-cli --version"))
  end
end
