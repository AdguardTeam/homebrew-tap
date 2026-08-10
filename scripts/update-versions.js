#!/usr/bin/env node
/**
 * Bump the pinned formula versions to the latest upstream GitHub releases.
 *
 *   node scripts/update-versions.js [--root <dir>] [--dry-run]
 *
 * For every formula in Formula/ it queries `GET /repos/<repo>/releases/latest`
 * and rewrites the managed metadata block in the formula file (version, URLs
 * and sha256 for macOS and Linux). Nothing else in the file is touched. The
 * scheduled workflow (.github/workflows/update-versions.yml) runs this script
 * and commits the result; `--dry-run` prints what would change without
 * writing anything.
 *
 *   --root <dir>   repository root to operate on (default: current directory)
 */
import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { pathToFileURL } from "node:url";
import { formulas, readPinnedVersion, updateFormula, versionFromTag } from "./formula-lib.js";

const USER_AGENT = "homebrew-tap-update";

/** GET the latest (non-prerelease) release of a GitHub repo. */
export async function fetchLatestRelease(repo) {
  const url = `https://api.github.com/repos/${repo}/releases/latest`;
  const response = await fetch(url, {
    headers: { Accept: "application/vnd.github+json", "User-Agent": USER_AGENT },
  });
  if (!response.ok) {
    throw new Error(
      `GitHub API for ${repo} returned HTTP ${response.status}: ` +
        `${(await response.text()).slice(0, 300)}`,
    );
  }
  return response.json();
}

/** Absolute repository root from `--root <dir>`, defaulting to the CWD. */
function resolveRoot(args) {
  const index = args.indexOf("--root");
  const value = index !== -1 ? args[index + 1] : undefined;
  return value ? path.resolve(value) : process.cwd();
}

export async function main() {
  const dryRun = process.argv.includes("--dry-run");
  const root = resolveRoot(process.argv);
  const updated = [];

  for (const def of formulas) {
    const release = await fetchLatestRelease(def.repo);
    const file = path.join(root, def.file);
    const current = await readFile(file, "utf8");
    const next = updateFormula(current, def, release);
    const to = versionFromTag(release.tag_name, def.tagSuffix);
    if (next === current) {
      console.log(`${def.file}: already at ${to}, nothing to do`);
      continue;
    }
    const from = readPinnedVersion(current) ?? "?";
    if (!dryRun) {
      await writeFile(file, next);
    }
    updated.push({ file: def.file, from, to });
  }

  if (updated.length === 0) {
    console.log("All formulas are up to date.");
    return;
  }
  console.log(`${dryRun ? "Would update" : "Updated"} ${updated.length} formula(s):`);
  for (const { file, from, to } of updated) {
    console.log(`  ${file}: ${from} -> ${to}${dryRun ? " (dry run)" : ""}`);
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main().catch((error) => {
    console.error(`update-versions: ${error.message}`);
    process.exit(1);
  });
}
