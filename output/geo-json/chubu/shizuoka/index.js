import featureCollection from './index.geojson'
import hamamatsu from './hamamatsu'
import shizuoka from './shizuoka'

export default {
  features: featureCollection.features,
  items: { hamamatsu, shizuoka }
}
