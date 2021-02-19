import featureCollection from './index.geojson'
import sakai from './sakai'
import osaka from './osaka'

export default {
  features: featureCollection.features,
  items: { sakai, osaka }
}
