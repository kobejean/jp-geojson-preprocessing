import featureCollection from './index.geojson'
import yamagata from './yamagata'
import iwate from './iwate'
import aomori from './aomori'
import miyagi from './miyagi'
import fukushima from './fukushima'
import akita from './akita'

export default {
  features: featureCollection.features,
  items: { yamagata, iwate, aomori, miyagi, fukushima, akita }
}
