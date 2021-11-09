import Foundation

class ClientServiceAPI: ClientServiceAPIDelegate {
  static var shared: ClientServiceAPI = {
    let instance = ClientServiceAPI()
    return instance
  }()

  private init() {}

  public func characters() -> CharactersModel {
    let characters = CharactersModel()
    return characters
  }

  public func locations() -> LocationsModel {
    let locations = LocationsModel()
    return locations
  }

  public func episodes() -> EpisodesModel {
    let episodes = EpisodesModel()
    return episodes
  }
}

extension ClientServiceAPI: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
