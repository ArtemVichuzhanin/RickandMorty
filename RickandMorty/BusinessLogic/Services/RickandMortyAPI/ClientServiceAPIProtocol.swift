import Foundation

protocol ClientServiceAPIDelegate: AnyObject {
  func characters() -> CharactersModel
  func locations() -> LocationsModel
  func episodes() -> EpisodesModel
}
