const fs = require("fs");
const path = require("path");

async function* walk(dir) {
  for await (const d of await fs.promises.opendir(dir)) {
    const entry = path.join(dir, d.name);
    if (d.isDirectory()) yield* walk(entry);
    else if (d.isFile()) yield { file: entry, dir };
  }
}

async function* walkDir(dir) {
  const dirs = [];
  for await (const d of await fs.promises.opendir(dir)) {
    const entry = path.join(dir, d.name);
    if (d.isDirectory()) {
      dirs.push(d.name);
      yield* walkDir(entry);
    }
  }
  yield { dir, dirs };
}

exports.walk = walk;
exports.walkDir = walkDir;
