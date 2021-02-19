import featureCollection from './index.geojson'
import nara from './nara'
import wakayama from './wakayama'
import hyogo from './hyogo'
import mie from './mie'
import osaka from './osaka'
import shiga from './shiga'
import kyoto from './kyoto'

export default {
  features: featureCollection.features,
  items: { nara, wakayama, hyogo, mie, osaka, shiga, kyoto }
}
