import Foundation

class ClientServiceAPI: ClientServiceAPIDelegate {
  static let shared = ClientServiceAPI()

  private init() {}

  public func characters() -> CharactersModelDelegate {
    let characters = CharactersModel()
    return characters
  }

  public func locations() -> LocationsModelDelegate {
    let locations = LocationsModel()
    return locations
  }

  public func episodes() -> EpisodesModelDelegate {
    let episodes = EpisodesModel()
    return episodes
  }
}

extension ClientServiceAPI: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
