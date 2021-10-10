//
//  DataViewController.swift
//  RickandMorty
//
//  Created by Артем  on 05.09.2021.
//

import UIKit

class DataViewController: UIViewController {
  @IBOutlet weak var displayImage: UIImageView!
  var itemIndex = 0
  var imageName: String = "" {
    didSet {
      if let imageView = displayImage {
        imageView.image = UIImage(named: imageName)
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    displayImage.image = UIImage(named: imageName)
  }
}
