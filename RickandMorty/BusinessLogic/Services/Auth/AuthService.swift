import Foundation

class AuthService: AuthServiceProtocol {
  private let keychainWrapper: KeychainWrapperProtocol = KeychainWrapper()

  init() {
    self.loadUser()
  }

  func logIn(login: String, password: String) -> Bool {
    let user = self.keychainWrapper.getUser()
    return user?.login == login && user?.password == password
  }

  private func loadUser() {
    guard let fileLocation = Bundle.main.url(forResource: "User", withExtension: ".json") else { return }
    do {
      let data = try Data(contentsOf: fileLocation)
      let user = try JSONDecoder().decode(UserModel.self, from: data)
      self.keychainWrapper.saveUser(user)
    } catch let error {
      print(error)
    }
  }
}
