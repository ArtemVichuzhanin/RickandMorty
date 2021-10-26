import Foundation

protocol AuthServiceProtocol {
  func logIn(login: String, password: String) -> Bool
}
