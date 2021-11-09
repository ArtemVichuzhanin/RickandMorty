import UIKit

class LocationsTableViewCell: UITableViewCell {
  private var buttonState = false

  @IBOutlet weak var locationName: UILabel!
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    configure(with: .none)
  }

  func configure(with location: LocationResult?) {
    if let location = location {
      self.locationName.text = location.name

      self.locationName.alpha = 1
      self.heartButton.alpha = 1
      self.accessoryType = .disclosureIndicator
      self.loadingIndicator.stopAnimating()
    } else {
      self.locationName.alpha = 0
      self.heartButton.alpha = 0
      self.accessoryType = .none
      self.loadingIndicator.startAnimating()
    }
  }

  @IBAction func onHeartTapped(_ sender: UIButton) {
    buttonState.toggle()

    if buttonState {
      sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      sender.configuration?.baseForegroundColor = UIColor(named: AppColorKeys.colorForInterface.rawValue)
    } else {
      sender.setImage(UIImage(systemName: "heart"), for: .normal)
      sender.configuration?.baseForegroundColor = .gray
    }
  }
}
