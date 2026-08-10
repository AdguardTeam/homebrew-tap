class Adyg < Formula
  require "json"
  require "net/http"
  require "uri"

  desc "Small dig-like DNS query CLI tool built on the upstream library"
  homepage "https://github.com/AdguardTeam/DnsLibs"
  license "Apache-2.0"

  # The GitHub repository whose `/releases/latest` endpoint is used to pick the
  # newest release, its asset URL, and its sha256 at install time, so the
  # formula always installs the latest release.
  REPO = "AdguardTeam/DnsLibs".freeze

  # Queries the GitHub releases API for the latest (non-prerelease) release.
  #
  # Validates the HTTP status and the payload shape so that failures (e.g. the
  # unauthenticated API rate limit being exceeded on CI runners, which returns
  # an error JSON without "tag_name") produce a useful error instead of a bare
  # KeyError.
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
    unless response.is_a?(Net::HTTPSuccess)
      odie "GitHub API for #{REPO} returned HTTP #{response.code}: #{response.body.to_s[0, 300]}"
    end

    release = JSON.parse(response.body)
    %w[tag_name assets].each do |key|
      odie "GitHub release payload for #{REPO} is missing '#{key}'" if release[key].nil?
    end
    release
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

  macos_asset = asset(/-macos-universal\.tar\.gz\z/) || asset(/-macos\.tar\.gz\z/)
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
    bin.install "adyg"
  end

  test do
    assert_match(/adyg \d+(\.\d+)+/, shell_output("#{bin}/adyg -v"))
  end
end
