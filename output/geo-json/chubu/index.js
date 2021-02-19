import featureCollection from './index.geojson'
import niigata from './niigata'
import ishikawa from './ishikawa'
import fukui from './fukui'
import aichi from './aichi'
import nagano from './nagano'
import shizuoka from './shizuoka'
import gifu from './gifu'
import toyama from './toyama'
import yamanashi from './yamanashi'

export default {
  features: featureCollection.features,
  items: { niigata, ishikawa, fukui, aichi, nagano, shizuoka, gifu, toyama, yamanashi }
}
