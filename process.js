const fs = require("fs");
const path = require("path");
const Kuroshiro = require("kuroshiro");
const KuromojiAnalyzer = require("kuroshiro-analyzer-kuromoji");

const kuroshiro = new Kuroshiro();
const analyzer = new KuromojiAnalyzer();

async function* walkFiles(dir) {
  for await (const d of await fs.promises.opendir(dir)) {
    const entry = path.join(dir, d.name);
    if (d.isDirectory()) yield* walkFiles(entry);
    else if (d.isFile()) yield entry;
  }
}

const idRegEx = /^(.*)(都|府|県|振興局|支庁|政令|都|市|郡|区)$/g;
async function idFromName(name) {
  const options = { to: "romaji", romajiSystem: "passport" };
  const matches = (name && name.match(idRegEx)) || [name];
  console.log(matches[0]);
  return await kuroshiro.convert(matches[0], options);
}

async function processGeoJSON(file) {
  console.log("processing:", file);
  const geoJSON = JSON.parse(fs.readFileSync(file));
  const promises = geoJSON.features.map(async (feature) => {
    const { name, type } = feature.properties;
    feature.properties = {
      ja: name,
    };
    feature.id = `${type}:${await idFromName(name)}`;
    console.log(feature.id);
  });
  await Promise.all(promises).catch((error) => console.error(error));

  fs.writeFileSync(file, JSON.stringify(geoJSON, null));
}

// Then, use it with a simple async for loop
async function main() {
  await kuroshiro.init(analyzer);

  const dir = path.resolve(__dirname, "output/geo-json/");
  for await (const file of walkFiles(dir)) {
    if (path.extname(file) === ".geojson") {
      processGeoJSON(file);
    }
  }
}

main().catch((error) => console.error(error));
