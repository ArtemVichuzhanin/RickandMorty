import Foundation

protocol ClientServiceAPIDelegate: AnyObject {
  func characters() -> CharactersModelDelegate
  func locations() -> LocationsModelDelegate
  func episodes() -> EpisodesModelDelegate
}
