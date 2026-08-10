#!/usr/bin/env bash
#
# Sets up Homebrew on a self-hosted runner.
#
# Mirrors the approach used in AdGuardSoftwareLimited/dns-libs: instead of a
# third-party setup action (e.g. Homebrew/actions/setup-homebrew) we manage
# Homebrew ourselves. The script is idempotent: if Homebrew is already
# installed it simply makes sure it is on the PATH and up to date.
#
# Exit codes:
#   0 - Homebrew is installed and ready.
#   1 - Homebrew could not be installed or located.
#
set -euo pipefail

# Common Homebrew installation prefixes, in order of preference.
prefix=""
for candidate in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
  if [[ -x "${candidate}/bin/brew" ]]; then
    prefix="${candidate}"
    break
  fi
done

# Install Homebrew if it is not present yet. The official installer picks the
# right prefix (/opt/homebrew on Apple Silicon, /usr/local on Intel).
if [[ -z "${prefix}" ]]; then
  echo "::group::Installing Homebrew"
  NONINTERACTIVE=1 CI=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "::endgroup::"

  for candidate in /opt/homebrew /usr/local; do
    if [[ -x "${candidate}/bin/brew" ]]; then
      prefix="${candidate}"
      break
    fi
  done
fi

if [[ -z "${prefix}" || ! -x "${prefix}/bin/brew" ]]; then
  echo "::error::Homebrew is not installed and could not be installed." >&2
  exit 1
fi

# Make `brew` available to the current shell and to every later job step.
eval "$("${prefix}/bin/brew" shellenv)"
if [[ -n "${GITHUB_PATH:-}" ]]; then
  echo "${prefix}/bin" >> "${GITHUB_PATH}"
fi

# Catch-up: refresh the local Homebrew installation and recipe index.
echo "::group::Homebrew update"
HOMEBREW_NO_ENV_HINTS=1 "${prefix}/bin/brew" update
echo "::endgroup::"

"${prefix}/bin/brew" --version

# Subsequent `brew` invocations in this job should not trigger an implicit
# auto-update of its own (we already did that above).
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "HOMEBREW_NO_AUTO_UPDATE=1" >> "${GITHUB_ENV}"
fi
