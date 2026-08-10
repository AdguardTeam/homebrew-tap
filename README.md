# AdGuard Homebrew Tap

A [Homebrew tap](https://docs.brew.sh/Taps) that installs AdGuard command-line
tools as prebuilt binaries. Every formula pins an **exact** release, and a
scheduled workflow automatically bumps the pins when the upstream projects
publish newer versions.

## What's in this tap

This tap provides prebuilt binaries of the following AdGuard command-line tools.
Each tool links to its upstream repository:

| Formula | Tool | License | Pinned version |
| --- | --- | --- | --- |
| `adyg` | [dig-like DNS query CLI][adyg-readme], built on the `upstream` library (part of `DnsLibs`) | Apache-2.0 | 2.10.1 |
| `adguard-cli` | [AdGuard command-line interface][adguard-cli] (ad-blocking) | proprietary | 1.4.13 |
| `adguardvpn-cli` | [AdGuard VPN command-line interface][adguardvpn-cli] | proprietary | 1.7.12 |
| `adguarddns-cli` | [AdGuard DNS command-line interface][adguarddns-cli] | Apache-2.0 | 0.2.0 |
| `adguardhome` | [Network-wide ads and trackers blocking DNS server][adguardhome] | GPL-3.0 | 0.107.78 |
| `dnsproxy` | [Simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support][dnsproxy] | Apache-2.0 | 0.83.2 |

[adyg-readme]: https://github.com/AdguardTeam/DnsLibs/blob/master/docs/adyg.md
[adguard-cli]: https://github.com/AdguardTeam/AdGuardCLI
[adguardvpn-cli]: https://github.com/AdguardTeam/AdGuardVPNCLI
[adguarddns-cli]: https://github.com/AdguardTeam/AdGuardDNSCLI
[adguardhome]: https://github.com/AdguardTeam/AdGuardHome
[dnsproxy]: https://github.com/AdguardTeam/dnsproxy

The pinned versions are updated automatically — see
[How versions are kept up to date](#how-versions-are-kept-up-to-date).

## Usage

Install the tap:

```sh
brew tap AdguardTeam/tap
```

Then install the tools you need, one command per tool:

```sh
brew install adyg
brew install adguard-cli
brew install adguardvpn-cli
brew install adguarddns-cli
brew install adguardhome
brew install dnsproxy
```

Or install a single formula directly by its fully-qualified name (this also
adds the tap for you):

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

- macOS — both Apple Silicon and Intel are supported. `adyg`, `adguard-cli` and
  `adguardvpn-cli` ship a single universal binary; `adguarddns-cli`,
  `adguardhome` and `dnsproxy` ship per-architecture binaries, which the
  formulas select with `Hardware::CPU.arm?`.
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
