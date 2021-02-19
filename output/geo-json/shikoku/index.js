import featureCollection from './index.geojson'
import tokushima from './tokushima'
import kagawa from './kagawa'
import ehime from './ehime'
import kochi from './kochi'

export default {
  features: featureCollection.features,
  items: { tokushima, kagawa, ehime, kochi }
}
