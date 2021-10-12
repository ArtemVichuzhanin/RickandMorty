//
//  PageForWelcomeScreenModel.swift
//  RickandMorty
//
//  Created by Артем  on 12.10.2021.
//

import Foundation

class WelcomePageModel {
  var pages: [WelcomePage] = []

  func addPage (_ newPage: WelcomePage) {
    pages.append(newPage)
  }
}
