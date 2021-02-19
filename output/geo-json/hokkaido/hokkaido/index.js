import featureCollection from './index.geojson'
import tokachi from './tokachi'
import kamikawa from './kamikawa'
import hiyama from './hiyama'
import kushiro from './kushiro'
import rumoi from './rumoi'
import iburi from './iburi'
import hidaka from './hidaka'
import oshima from './oshima'
import shiribeshi from './shiribeshi'
import okhotsk from './okhotsk'
import sorachi from './sorachi'
import ishikari from './ishikari'
import soya from './soya'
import nemuro from './nemuro'

export default {
  features: featureCollection.features,
  items: { tokachi, kamikawa, hiyama, kushiro, rumoi, iburi, hidaka, oshima, shiribeshi, okhotsk, sorachi, ishikari, soya, nemuro }
}
