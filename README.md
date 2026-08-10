# AdGuard Homebrew Tap

A [Homebrew tap](https://docs.brew.sh/Taps) that installs AdGuard command-line
tools as prebuilt binaries. Every formula pins an **exact** release, and a
scheduled workflow automatically bumps the pins when the upstream projects
publish newer versions.

## What's in this tap

| Formula | Tool | License | Pinned version |
| --- | --- | --- | --- |
| `adyg` | dig-like DNS query CLI built on the [`upstream` library] (part of `DnsLibs`) | Apache-2.0 | 2.10.1 |
| `adguard-cli` | AdGuard command-line interface (ad-blocking) | proprietary | 1.4.13 |
| `adguardvpn-cli` | AdGuard VPN command-line interface | proprietary | 1.7.12 |

The pinned versions are updated automatically — see
[How versions are kept up to date](#how-versions-are-kept-up-to-date).

[`upstream` library]: https://github.com/AdguardTeam/DnsLibs

## Usage

Install the tap and formulas:

```sh
brew tap AdguardTeam/tap
brew install adyg adguard-cli adguardvpn-cli
```

Or install a single formula:

```sh
brew install AdguardTeam/tap/adyg
```

## How the formulas work

Every formula in this tap is **pinned**: it declares an exact `version`, plus
a `url` and `sha256` for macOS and for each supported Linux architecture, all
inside a marked metadata block:

```ruby
# --- BEGIN MANAGED ---
version "2.10.1"

url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/..."
sha256 "18ea085d..."

on_linux do
  if Hardware::CPU.arm?
    url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/..."
    sha256 "d2f3b0e9..."
  else
    url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/..."
    sha256 "82e9f3ec..."
  end
end
# --- END MANAGED ---
```

Pinning an exact version means `brew install` and `brew upgrade` fetch a
specific release: builds are reproducible, `brew audit` / `brew test` work
without touching the network, and each version is cached separately by
Homebrew. The managed block is generated and kept up to date automatically —
do not edit it by hand, only the content between the markers ever changes.

## How versions are kept up to date

The [`update-versions`](.github/workflows/update-versions.yml) workflow runs
daily at 06:00 UTC (and on demand via **workflow_dispatch**) and checks whether
the upstream repositories have published newer releases:

1. The multi-stage [`Dockerfile`](Dockerfile) is built and its result written
   back to the checkout with Docker's local output:

   ```sh
   docker build --target export \
     --build-arg CACHEBUST="$(date -u +%s)" \
     --output type=local,dest=/tmp/tap-out .
   cp -R /tmp/tap-out/Formula/. Formula/
   ```

   The `test` stage runs the unit tests, the `update` stage runs
   [`scripts/update-versions.js`](scripts/update-versions.js), which queries
   `GET /repos/<repo>/releases/latest` for every formula and rewrites only the
   managed block above when a newer version is available (nothing else in the
   formula file is touched), and the `export` stage returns just the updated
   `Formula/`. `CACHEBUST` forces the upstream check to re-run on every build
   instead of being served from the Docker layer cache. Running it this way
   means the runner needs no Node.js at all.
2. If anything changed, the updated formulas are committed and pushed straight
   to `master` with the org's `protected-push` action (a short-lived Octopass
   token, the same approach as `AdGuardSoftwareLimited/github-knowledge-base`).
   The push in turn triggers the usual `test.yml` (brew install + test) and
   `mirror.yml` (publish to the public tap) flows.

## Supported platforms

- macOS (universal binary: both Apple Silicon and Intel are supported)
- Linux `x86_64` and `aarch64`

## Development

The version-bump logic is plain Node.js with **no dependencies** and is
unit-tested with Node's built-in test runner (hermetic — no network access):

```sh
npm test                              # run the unit tests
npm run update-versions               # check for new releases and bump the pins
npm run update-versions -- --dry-run  # print what would change, write nothing
```

The scheduled workflow does not install Node on the runner — instead it builds
the multi-stage [`Dockerfile`](Dockerfile) (which runs `npm test` in the `test`
stage and the bump script in the `update` stage inside a `node:24` image) and
copies `Formula/` back from Docker's local output (see
"How versions are kept up to date").

Formulas are validated locally with Homebrew by registering this checkout as a
tap (a Homebrew formula must live in a tap, path installs are not allowed):

```sh
brew tap <owner>/tap "$PWD"
brew install <owner>/tap/adyg
brew test <owner>/tap/adyg
brew untap <owner>/tap
```

The CI workflow (`.github/workflows/test.yml`) does the same thing on the
self-hosted macOS runners and installs + tests all three formulas.

## Disclaimer

`adguard-cli` and `adguardvpn-cli` are **not** open-source projects — their
repos are used as public issue trackers and to distribute prebuilt binaries.
`adyg` is licensed under the Apache License 2.0.
