import featureCollection from './index.geojson'
import nagasaki from './nagasaki'
import oita from './oita'
import okinawa from './okinawa'
import fukuoka from './fukuoka'
import saga from './saga'
import kagoshima from './kagoshima'
import kumamoto from './kumamoto'
import miyazaki from './miyazaki'

export default {
  features: featureCollection.features,
  items: { nagasaki, oita, okinawa, fukuoka, saga, kagoshima, kumamoto, miyazaki }
}
