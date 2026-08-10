import { test } from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import path from "node:path";

import {
  MANAGED_BEGIN,
  MANAGED_END,
  formulas,
  findAsset,
  readPinnedVersion,
  renderManaged,
  tagFromVersion,
  updateFormula,
  versionFromTag,
} from "./formula-lib.js";

const repoRoot = fileURLToPath(new URL("../", import.meta.url));
const adyg = formulas.find((f) => f.file === "Formula/adyg.rb");
const cli = formulas.find((f) => f.file === "Formula/adguard-cli.rb");

/** Realistic release payload for AdguardTeam/DnsLibs (tag has no suffix). */
const dnsLibsRelease = {
  tag_name: "v2.10.1",
  assets: [
    { name: "adyg-v2.10.1-linux-aarch64.tar.gz", browser_download_url: "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-linux-aarch64.tar.gz", digest: "sha256:d2f3b0e9e14fbb675b51bc663e1bf0c98f4dd367f4d86e6278b5c4d2bea5800b" },
    { name: "adyg-v2.10.1-linux-x86_64.tar.gz", browser_download_url: "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-linux-x86_64.tar.gz", digest: "sha256:82e9f3ec16cd17c30807530fd49d792c3c15c77f904075e073aea67aa9481337" },
    { name: "adyg-v2.10.1-macos-universal.tar.gz", browser_download_url: "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-macos-universal.tar.gz", digest: "sha256:18ea085d00c4366ea1c7ee4dd5a6b872bf49a392507d3d7b0cd14bf4b039c4f9" },
  ],
};

/** Realistic release payload for AdguardTeam/AdGuardCLI (tag has -release). */
const cliRelease = {
  tag_name: "v1.4.13-release",
  assets: [
    { name: "adguard-cli-1.4.13-linux-aarch64.tar.gz", browser_download_url: "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.4.13-release/adguard-cli-1.4.13-linux-aarch64.tar.gz", digest: "sha256:607af03ed83563d8d4162a2a3e5c9ed0d05d6d5b73840ec41fb5c5c573d09a45" },
    { name: "adguard-cli-1.4.13-linux-x86_64.tar.gz", browser_download_url: "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.4.13-release/adguard-cli-1.4.13-linux-x86_64.tar.gz", digest: "sha256:0575c9a2397fc1537d9c8213811f0d79867a7953f2481f3e9677bd3f0a2cf88c" },
    { name: "adguard-cli-1.4.13-macos.tar.gz", browser_download_url: "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.4.13-release/adguard-cli-1.4.13-macos.tar.gz", digest: "sha256:7f917aa5744695ce7c9af870df72061b33b17e07c233f1fa6a381c9fc1675065" },
    { name: "install.sh", browser_download_url: "https://github.com/AdguardTeam/AdGuardCLI/releases/download/v1.4.13-release/install.sh", digest: "sha256:da3040b0fd18c1e3ff1030e28a437c2c3b143c5380c211d8e591b960fa064763" },
  ],
};

test("versionFromTag strips the v prefix", () => {
  assert.equal(versionFromTag("v2.10.1"), "2.10.1");
  assert.equal(versionFromTag("v2.10.1", ""), "2.10.1");
});

test("versionFromTag strips the -release tag suffix", () => {
  assert.equal(versionFromTag("v1.4.13-release", "-release"), "1.4.13");
  assert.equal(versionFromTag("v1.7.12-release", "-release"), "1.7.12");
});

test("tagFromVersion round-trips with versionFromTag", () => {
  assert.equal(tagFromVersion("1.4.13", "-release"), "v1.4.13-release");
  assert.equal(versionFromTag(tagFromVersion("1.4.13", "-release"), "-release"), "1.4.13");
  assert.equal(versionFromTag(tagFromVersion("2.10.1", ""), ""), "2.10.1");
});

test("findAsset matches patterns in priority order", () => {
  const release = {
    assets: [
      { name: "adyg-v2.10.1-macos.tar.gz" },
      { name: "adyg-v2.10.1-macos-universal.tar.gz" },
    ],
  };
  // The universal build is preferred when both exist.
  const hit = findAsset(release, [/-macos-universal\.tar\.gz$/, /-macos\.tar\.gz$/]);
  assert.equal(hit.name, "adyg-v2.10.1-macos-universal.tar.gz");
  assert.equal(findAsset(release, [/-linux-aarch64\.tar\.gz$/]), undefined);
});

test("renderManaged renders an exact pinned block for adyg", () => {
  assert.equal(
    renderManaged(adyg, dnsLibsRelease),
    [
      "  # --- BEGIN MANAGED ---",
      '  version "2.10.1"',
      "",
      '  url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-macos-universal.tar.gz"',
      '  sha256 "18ea085d00c4366ea1c7ee4dd5a6b872bf49a392507d3d7b0cd14bf4b039c4f9"',
      "",
      "  on_linux do",
      "    if Hardware::CPU.arm?",
      '      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-linux-aarch64.tar.gz"',
      '      sha256 "d2f3b0e9e14fbb675b51bc663e1bf0c98f4dd367f4d86e6278b5c4d2bea5800b"',
      "    else",
      '      url "https://github.com/AdguardTeam/DnsLibs/releases/download/v2.10.1/adyg-v2.10.1-linux-x86_64.tar.gz"',
      '      sha256 "82e9f3ec16cd17c30807530fd49d792c3c15c77f904075e073aea67aa9481337"',
      "    end",
      "  end",
      "  # --- END MANAGED ---",
    ].join("\n"),
  );
});

test("renderManaged uses the -release tag in adguard-cli URLs", () => {
  const block = renderManaged(cli, cliRelease);
  assert.ok(block.includes('version "1.4.13"'));
  assert.ok(block.includes("/download/v1.4.13-release/adguard-cli-1.4.13-macos.tar.gz"));
  assert.ok(block.includes("7f917aa5744695ce7c9af870df72061b33b17e07c233f1fa6a381c9fc1675065"));
  // install.sh must never be picked for a platform asset.
  assert.ok(!block.includes("install.sh"));
});

test("renderManaged throws when a platform asset is missing", () => {
  const release = { tag_name: "v2.10.1", assets: [] };
  assert.throws(() => renderManaged(adyg, release), /No "macos" asset/);
});

test("updateFormula rewrites only the managed block", () => {
  const before = [
    'class Adyg < Formula',
    '  desc "dig-like DNS query CLI"',
    '  license "Apache-2.0"',
    "",
    "  # human-authored note that must survive",
    "  # --- BEGIN MANAGED ---",
    '  version "1.0.0"',
    "",
    "  url \"https://old.example/adyg.tar.gz\"",
    '  sha256 "1111111111111111111111111111111111111111111111111111111111111111"',
    "",
    "  on_linux do",
    "    if Hardware::CPU.arm?",
    "      url \"https://old.example/arm.tar.gz\"",
    '      sha256 "2222222222222222222222222222222222222222222222222222222222222222"',
    "    else",
    "      url \"https://old.example/x86.tar.gz\"",
    '      sha256 "3333333333333333333333333333333333333333333333333333333333333333"',
    "    end",
    "  end",
    "  # --- END MANAGED ---",
    "",
    "  def install",
    '    bin.install "adyg"',
    "  end",
    "end",
    "",
  ].join("\n");

  const after = updateFormula(before, adyg, dnsLibsRelease);

  // Outside content is preserved verbatim.
  assert.ok(after.includes('class Adyg < Formula'));
  assert.ok(after.includes('desc "dig-like DNS query CLI"'));
  assert.ok(after.includes("# human-authored note that must survive"));
  assert.ok(after.includes('bin.install "adyg"'));
  assert.ok(after.endsWith("end\n"));

  // Old pinned values are gone, new ones are in.
  assert.ok(!after.includes('version "1.0.0"'));
  assert.ok(!after.includes("old.example"));
  assert.ok(after.includes('version "2.10.1"'));
  assert.ok(after.includes("18ea085d00c4366ea1c7ee4dd5a6b872bf49a392507d3d7b0cd14bf4b039c4f9"));

  // The markers are still present, so a later run is possible.
  assert.ok(after.includes(MANAGED_BEGIN));
  assert.ok(after.includes(MANAGED_END));
});

test("updateFormula is idempotent", () => {
  const seed = [
    "  # --- BEGIN MANAGED ---",
    '  version "1.0.0"',
    "  # --- END MANAGED ---",
    "",
  ].join("\n");
  const once = updateFormula(seed, adyg, dnsLibsRelease);
  const twice = updateFormula(once, adyg, dnsLibsRelease);
  assert.equal(twice, once);
});

test("updateFormula throws when the managed markers are absent", () => {
  assert.throws(
    () => updateFormula("class Adyg < Formula\nend\n", adyg, dnsLibsRelease),
    /no managed metadata block/,
  );
});

test("readPinnedVersion extracts the pinned version", () => {
  assert.equal(readPinnedVersion('version "1.4.13"\n'), "1.4.13");
  assert.equal(readPinnedVersion("no version here\n"), null);
});

// Regression guard: every definition lists all expected platforms, and the
// checked-in formulas still carry a valid managed block with a pinned version
// (keeps the script and the tap in sync without needing the network).
test("every formula definition lists the expected platforms", () => {
  for (const def of formulas) {
    const keys = def.platforms.map((p) => p.key);
    assert.deepEqual(keys, ["macos", "linuxAarch64", "linuxX86_64"], def.file);
    for (const { patterns } of def.platforms) {
      assert.ok(patterns.length > 0, `${def.file}: empty patterns for a platform`);
    }
  }
});

for (const def of formulas) {
  test(`${def.file}: has a managed block with a pinned version`, async () => {
    const text = await readFile(path.join(repoRoot, def.file), "utf8");
    assert.ok(text.includes(MANAGED_BEGIN), `${def.file} is missing ${MANAGED_BEGIN}`);
    assert.ok(text.includes(MANAGED_END), `${def.file} is missing ${MANAGED_END}`);
    assert.ok(readPinnedVersion(text) !== null, `${def.file} has no pinned version`);
  });
}
