import UIKit

class EpisodesTableViewCell: UITableViewCell {
  private var buttonState = false

  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var episodeName: UILabel!
  @IBOutlet weak var episodeCode: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    configure(with: .none)
  }

  func configure(with episode: EpisodeResult?) {
    if let episode = episode {
      self.episodeName.text = episode.name
      self.episodeCode.text = decodeEpisodeCode(with: episode.episode)

      self.episodeName.alpha = 1
      self.episodeCode.alpha = 1
      self.heartButton.alpha = 1
      self.accessoryType = .disclosureIndicator
      self.loadingIndicator.stopAnimating()
    } else {
      self.episodeName.alpha = 0
      self.episodeCode.alpha = 0
      self.heartButton.alpha = 0
      self.accessoryType = .none
      self.loadingIndicator.startAnimating()
    }
  }

  func decodeEpisodeCode(with code: String) -> String {
    let separetedString = code.components(separatedBy: CharacterSet.decimalDigits.inverted)

    return "Season \(separetedString[1]), Episode \(separetedString[2])"
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
