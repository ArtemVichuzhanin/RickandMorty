import Foundation

protocol KeychainWrapperProtocol {
  func getUser() -> UserModel?
  func saveUser(_ userModel: UserModel?)
}
