const fs = require("fs");
const path = require("path");
const Kuroshiro = require("kuroshiro");
const KuromojiAnalyzer = require("kuroshiro-analyzer-kuromoji");

const kuroshiro = new Kuroshiro();
const analyzer = new KuromojiAnalyzer();

const DATA_DIR = path.resolve(__dirname, "output/geo-json/");

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

const trimRegEx = /^(.*)(都|府|県|振興局|支庁|政令|都|市|郡|区)$/;
async function idFromName(name) {
  const options = { to: "romaji", romajiSystem: "passport" };
  const matches = name && name.match(trimRegEx);
  const trimmed = (matches && matches[1]) || name;
  const converted = await kuroshiro.convert(trimmed, options);
  if (Kuroshiro.Util.hasJapanese(converted)) {
    console.warn("could not romanize", name);
    return name;
  }
  return converted;
}

async function enFromName(name) {
  const options = { to: "romaji", romajiSystem: "hepburn" };
  const matches = name && name.match(trimRegEx);
  const trimmed = (matches && matches[1]) || name;
  const converted = await kuroshiro.convert(trimmed, options);
  if (Kuroshiro.Util.hasJapanese(converted)) {
    console.warn("could not romanize", name);
    return name;
  }
  return converted.charAt(0).toUpperCase() + converted.slice(1);
}

async function processGeoJSON(file, dir) {
  const geoJSON = JSON.parse(fs.readFileSync(file));
  const promises = geoJSON.features.map(async (feature) => {
    const { id, type } = feature.properties;
    feature.properties.name = {
      ja: id,
      en: await enFromName(id),
    };
    feature.id = await idFromName(id);
    feature.properties.path = `${path.relative(DATA_DIR, dir)}/${feature.id}`;
    if (type === "region") console.log(feature.id, feature.properties.name);
  });
  await Promise.all(promises).catch((error) => console.error(error));

  fs.writeFileSync(file, JSON.stringify(geoJSON, null));
}

async function processJS(dir, dirs = []) {
  const file = path.join(dir, "index.js");

  const js = `import featureCollection from './index.geojson'
${dirs.map((dir) => `import ${dir} from './${dir}'\n`).join("")}
export default {
  features: featureCollection.features,
  items: { ${dirs.join(", ")} }
}
`;

  fs.writeFileSync(file, js);
}

// Then, use it with a simple async for loop
async function main() {
  await kuroshiro.init(analyzer);

  for await (const { file, dir } of walk(DATA_DIR)) {
    if (path.extname(file) === ".geojson") {
      processGeoJSON(file, dir);
    }
  }
  for await (const { dir, dirs } of walkDir(DATA_DIR)) {
    processJS(dir, dirs);
  }
}

main().catch((error) => console.error(error));
