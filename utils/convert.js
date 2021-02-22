const Kuroshiro = require("kuroshiro");
const KuromojiAnalyzer = require("kuroshiro-analyzer-kuromoji");
// const translate = require("translate");

const kuroshiro = new Kuroshiro();
const analyzer = new KuromojiAnalyzer();

const trimRegEx = /^(.*)(都|府|県|振興局|支庁|政令|都|市|郡|町|村|区)$/;
async function toSimpleRomaji(name) {
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

async function toDisplayRomaji(name) {
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

async function init() {
  await kuroshiro.init(analyzer);
}

exports.init = init;
exports.toSimpleRomaji = toSimpleRomaji;
exports.toDisplayRomaji = toDisplayRomaji;
