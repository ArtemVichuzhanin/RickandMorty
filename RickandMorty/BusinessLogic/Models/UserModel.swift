import Foundation

struct UserModel: Codable {
  var login: String?
  var password: String?

  enum CodingKeys: String, CodingKey {
    case login
    case password
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.login, forKey: .login)
    try container.encode(self.password, forKey: .password)
  }
}
