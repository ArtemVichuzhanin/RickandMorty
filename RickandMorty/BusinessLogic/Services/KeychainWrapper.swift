import Foundation

final class KeychainWrapper: KeychainWrapperProtocol {
  private let prefixKey = "RickandMorty"
  private let userKey = ".user"

  func getUser() -> UserModel? {
    return self.read(self.prefixKey + self.userKey)
  }

  func saveUser(_ userModel: UserModel?) {
    guard let userModel = userModel else { return }
    self.save(self.prefixKey + self.userKey, data: userModel)
  }

  // MARK: Private

  private func read(_ key: String) -> UserModel? {
    let query: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: key as AnyObject,
      kSecAttrAccount as String: self.prefixKey as AnyObject,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: kCFBooleanTrue,
      kSecReturnData as String: kCFBooleanTrue
    ]
    var queryResult: AnyObject?
    let status = withUnsafeMutablePointer(to: &queryResult) {
      SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
    }

    guard
      status != errSecItemNotFound,
      status == noErr
    else { return nil }

    guard let existingItem = queryResult as? [String: AnyObject],
      let userData = existingItem[kSecValueData as String] as? Data,
      let userModel = try? JSONDecoder().decode(UserModel.self, from: userData)
    else { return nil }

    return userModel
  }

  private func save(_ key: String, data: UserModel) {
    guard let encodedData = try? JSONEncoder().encode(data) else { return }

    if self.read(key) != nil {
      let attributesToUpdate: [String: AnyObject] = [
        kSecValueData as String: encodedData as AnyObject,
        kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
      ]
      let query: [String: AnyObject] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: key as AnyObject,
        kSecAttrAccount as String: self.prefixKey as AnyObject
      ]

      SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
      return
    }

    let newItem: [String: AnyObject] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: key as AnyObject,
      kSecAttrAccount as String: self.prefixKey as AnyObject,
      kSecValueData as String: encodedData as AnyObject,
      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
    ]

    SecItemAdd(newItem as CFDictionary, nil)
  }
}
