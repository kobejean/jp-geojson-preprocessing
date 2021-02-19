import featureCollection from './index.geojson'
import sendai from './sendai'

export default {
  features: featureCollection.features,
  items: { sendai }
}
