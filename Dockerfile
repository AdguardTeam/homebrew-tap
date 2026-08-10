# syntax=docker/dockerfile:1

# Multi-stage image that performs the automatic Homebrew formula version bump
# (see scripts/ and .github/workflows/update-versions.yml).
#
# The scheduled workflow builds the 'export' stage and writes its content back
# to the checkout with Docker's local output, so the runner needs no Node.js:
#
#   docker build --target export \
#     --build-arg CACHEBUST="$(date -u +%s)" \
#     --output type=local,dest=/tmp/tap-out .
#
#   test   stage — runs the hermetic unit tests for the bump logic in the
#          image (no network access needed).
#   update stage — fetches the latest upstream releases and rewrites the pinned
#          metadata block of each formula in Formula/ in place.
#   export stage — a `scratch` stage carrying only the files the workflow
#          needs. `--output type=local` writes exactly these back to the
#          checkout, which is why the runner needs no runtime/toolchain.

# Base: the Node.js runtime. The bump scripts have no dependencies, so no
# package install step is needed.
FROM node:24-bookworm-slim AS base
WORKDIR /app

# Test: unit tests for the version-bump logic (node:test, hermetic). The
# formula files are copied here too — the tests also assert that every
# checked-in formula still carries a valid managed block. Failing tests fail
# the build, so the workflow never reaches the update/push steps.
FROM base AS test
COPY package.json ./
COPY scripts/ ./scripts/
COPY Formula/ ./Formula/
RUN npm test

# Update: run the bump script against the live GitHub releases API. Inherits
# package.json, scripts/ and Formula/ from the test stage.
FROM test AS update
# CACHEBUST is set to a fresh timestamp by the workflow on every run. Because
# it is used by the RUN below, the upstream check always re-executes — the
# layer cache would otherwise skip it when the build context is unchanged.
ARG CACHEBUST=0
RUN echo "cache-bust: ${CACHEBUST}" && node scripts/update-versions.js

# Export: only the updated Formula/ (and the scripts for reference) end up on
# the runner — not the base image rootfs.
FROM scratch AS export
COPY --from=update /app/Formula/ /Formula/
COPY --from=update /app/scripts/ /scripts/
COPY --from=update /app/package.json /package.json
