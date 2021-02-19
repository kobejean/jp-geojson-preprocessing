import featureCollection from './index.geojson'
import kawasaki from './kawasaki'
import sagamihara from './sagamihara'
import yokohama from './yokohama'

export default {
  features: featureCollection.features,
  items: { kawasaki, sagamihara, yokohama }
}
