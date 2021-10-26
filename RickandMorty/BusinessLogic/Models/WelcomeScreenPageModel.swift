import Foundation

class WelcomePageModel {
  var pages: [WelcomePage] = []

  func addPage (_ newPage: WelcomePage) {
    pages.append(newPage)
  }
}
