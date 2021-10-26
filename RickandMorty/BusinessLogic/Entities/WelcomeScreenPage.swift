import Foundation

struct WelcomePage: Decodable {
  var topic: String
  var description: String
  var links: [String: String]?

  init(_ topic: String, _ description: String, _ links: [String: String]? = nil) {
    self.topic = topic
    self.description = description
    self.links = links
  }
}
