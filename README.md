# AdGuard Homebrew Tap

A [Homebrew tap](https://docs.brew.sh/Taps) that installs AdGuard command-line
tools as prebuilt binaries straight from the **latest** GitHub release of each
project.

## What's in this tap

| Formula | Tool | License |
| --- | --- | --- |
| `adyg` | dig-like DNS query CLI built on the [`upstream` library] (part of `DnsLibs`) | Apache-2.0 |
| `adguard-cli` | AdGuard command-line interface (ad-blocking) | proprietary |
| `adguardvpn-cli` | AdGuard VPN command-line interface | proprietary |

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

Unlike a classic homebrew formula (which pins a specific version, URL, and
sha256), every formula in this tap resolves its metadata **at install time** by
querying the GitHub [releases API](https://docs.github.com/rest/releases/releases)
(`GET /repos/<owner>/<repo>/releases/latest`):

1. The latest non-prerelease release tag is used as the formula version.
2. The matching platform asset (macOS universal, or Linux `x86_64` / `aarch64`)
   is selected from the release.
3. The asset URL is used as the download URL, and the `sha256` digest published
   by GitHub for that asset is used for checksum verification.

The result is that `brew install` (and `brew upgrade`) always fetches the
current latest release — no manual formula bumps are needed. Because the version
is part of the download URL, Homebrew caches each version separately and
upgrades work normally.

## Supported platforms

- macOS (universal binary: both Apple Silicon and Intel are supported)
- Linux `x86_64` and `aarch64`

## Development

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
