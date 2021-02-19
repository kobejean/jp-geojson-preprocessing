import featureCollection from './index.geojson'
import shimane from './shimane'
import tottori from './tottori'
import yamaguchi from './yamaguchi'
import okayama from './okayama'
import hiroshima from './hiroshima'

export default {
  features: featureCollection.features,
  items: { shimane, tottori, yamaguchi, okayama, hiroshima }
}
