const fs = require("fs");
const path = require("path");
const { walk, walkDir } = require("./utils/walk");
const { init, idFromName, enFromName } = require("./utils/convert");

const DATA_DIR = path.resolve(__dirname, "output/geo-json/");

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
  await init();
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
