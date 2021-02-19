import featureCollection from './index.geojson'
import fukuoka from './fukuoka'
import kitakyushu from './kitakyushu'

export default {
  features: featureCollection.features,
  items: { fukuoka, kitakyushu }
}
