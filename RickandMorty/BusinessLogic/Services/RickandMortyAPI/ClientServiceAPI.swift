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
}

extension ClientServiceAPI: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
