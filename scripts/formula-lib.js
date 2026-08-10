/**
 * Formula metadata and pure helpers behind the automatic version bump.
 *
 * Every formula in Formula/ pins ONE exact release. The pinned metadata
 * (version, URLs and sha256 for macOS + Linux) lives in a managed block
 * delimited by MANAGED_BEGIN / MANAGED_END markers. This module knows how to
 * render that block from a GitHub release payload and transplant it into a
 * formula file, so the rest of the formula (desc, install, test, caveats) is
 * never touched.
 *
 * The module is intentionally dependency-free and side-effect-free (no I/O) —
 * the whole bump logic is unit-testable with `node --test`.
 */

export const MANAGED_BEGIN = "# --- BEGIN MANAGED ---";
export const MANAGED_END = "# --- END MANAGED ---";

/**
 * One entry per formula. `tagSuffix` is the part appended to the semver in the
 * release tag ("" for adyg, "-release" for the *-cli tools). `platforms` maps
 * a platform key to the release-asset filename patterns used to find that
 * platform's binary (in priority order).
 */
export const formulas = [
  {
    file: "Formula/adyg.rb",
    repo: "AdguardTeam/DnsLibs",
    tagSuffix: "",
    platforms: [
      { key: "macos", patterns: [/-macos-universal\.tar\.gz$/, /-macos\.tar\.gz$/] },
      { key: "linuxAarch64", patterns: [/-linux-aarch64\.tar\.gz$/] },
      { key: "linuxX86_64", patterns: [/-linux-x86_64\.tar\.gz$/] },
    ],
  },
  {
    file: "Formula/adguard-cli.rb",
    repo: "AdguardTeam/AdGuardCLI",
    tagSuffix: "-release",
    platforms: [
      { key: "macos", patterns: [/-macos\.tar\.gz$/] },
      { key: "linuxAarch64", patterns: [/-linux-aarch64\.tar\.gz$/] },
      { key: "linuxX86_64", patterns: [/-linux-x86_64\.tar\.gz$/] },
    ],
  },
  {
    file: "Formula/adguardvpn-cli.rb",
    repo: "AdguardTeam/AdGuardVPNCLI",
    tagSuffix: "-release",
    platforms: [
      { key: "macos", patterns: [/-macos\.tar\.gz$/] },
      { key: "linuxAarch64", patterns: [/-linux-aarch64\.tar\.gz$/] },
      { key: "linuxX86_64", patterns: [/-linux-x86_64\.tar\.gz$/] },
    ],
  },
];

/** "v1.2.3" -> "1.2.3"; "v1.4.13-release" + "-release" -> "1.4.13". */
export function versionFromTag(tag, tagSuffix = "") {
  let version = tag.replace(/^v/, "");
  if (tagSuffix && version.endsWith(tagSuffix)) {
    version = version.slice(0, -tagSuffix.length);
  }
  return version;
}

/** "1.4.13" + "-release" -> "v1.4.13-release". */
export function tagFromVersion(version, tagSuffix = "") {
  return `v${version}${tagSuffix}`;
}

/** The first release asset whose name matches any of the patterns. */
export function findAsset(release, patterns) {
  const assets = release.assets ?? [];
  for (const pattern of patterns) {
    const hit = assets.find((asset) => pattern.test(asset.name));
    if (hit) return hit;
  }
  return undefined;
}

/** Find one platform's asset and its sha256 digest; throw if unavailable. */
function requireAsset(def, release, key, patterns) {
  const asset = findAsset(release, patterns);
  const digest = asset?.digest;
  if (!asset || typeof digest !== "string" || !digest) {
    throw new Error(
      `No "${key}" asset matching ${patterns.map((p) => String(p)).join(", ")} ` +
        `with a sha256 digest in ${def.repo}@${release.tag_name}`,
    );
  }
  return { url: asset.browser_download_url, sha256: digest.replace(/^sha256:/, "") };
}

/**
 * Rendering helper: `line` is indented by two spaces unless it is blank, so
 * the block sits neatly inside the formula class body.
 */
const indent = (line) => (line === "" ? "" : `  ${line}`);

/**
 * The full Ruby snippet reserved for the managed markers, indented to sit
 * inside the formula class body. Has no trailing newline.
 */
export function renderManaged(def, release) {
  const version = versionFromTag(release.tag_name, def.tagSuffix);
  const assets = Object.fromEntries(
    def.platforms.map(({ key, patterns }) => [key, requireAsset(def, release, key, patterns)]),
  );
  const { macos: m, linuxAarch64: a, linuxX86_64: x } = assets;
  const body = [
    `version "${version}"`,
    "",
    `url "${m.url}"`,
    `sha256 "${m.sha256}"`,
    "",
    "on_linux do",
    "  if Hardware::CPU.arm?",
    `    url "${a.url}"`,
    `    sha256 "${a.sha256}"`,
    "  else",
    `    url "${x.url}"`,
    `    sha256 "${x.sha256}"`,
    "  end",
    "end",
  ];
  return [`  ${MANAGED_BEGIN}`, ...body.map(indent), `  ${MANAGED_END}`].join("\n");
}

/** The version currently pinned inside an existing formula's managed block. */
export function readPinnedVersion(text) {
  const match = text.match(/version "([^"]+)"/);
  return match ? match[1] : null;
}

/**
 * Replace the managed block in `text` with one rendered from `release`,
 * preserving everything outside the markers. Throws if the markers are absent.
 */
export function updateFormula(text, def, release) {
  const markerStart = text.indexOf(MANAGED_BEGIN);
  const markerEnd = text.indexOf(MANAGED_END);
  if (markerStart === -1 || markerEnd === -1 || markerStart > markerEnd) {
    throw new Error(
      `${def.file} has no managed metadata block; expected ` +
        `"${MANAGED_BEGIN}" / "${MANAGED_END}" markers`,
    );
  }
  const lineStart = text.lastIndexOf("\n", markerStart) + 1;
  return (
    text.slice(0, lineStart) +
    renderManaged(def, release) +
    text.slice(markerEnd + MANAGED_END.length)
  );
}
