import featureCollection from './index.geojson'
import chiba from './chiba'
import saitama from './saitama'
import ibaraki from './ibaraki'
import tokyo from './tokyo'
import kanagawa from './kanagawa'
import gunma from './gunma'
import tochigi from './tochigi'

export default {
  features: featureCollection.features,
  items: { chiba, saitama, ibaraki, tokyo, kanagawa, gunma, tochigi }
}
