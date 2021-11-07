import UIKit

class CharactersTableViewCell: UITableViewCell {
  private var buttonState = false

  @IBOutlet weak var characterImage: UIImageView!
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterStatus: UILabel!
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  override func prepareForReuse() {
    super.prepareForReuse()

    configure(with: .none)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func configure(with character: CharacterResult?) {
    if let character = character {
      let urlImage = URL(string: character.image)
      self.characterImage.kf.setImage(with: urlImage)

      self.characterName.text = character.name

      switch character.status {
      case Status.alive.rawValue:
        self.characterStatus.textColor = .green
        self.characterStatus.text = "\u{2022}" + character.status
        self.heartButton.isHidden = false

      case Status.dead.rawValue:
        self.characterStatus.textColor = .red
        self.characterStatus.text = "\u{2022}" + character.status
        self.heartButton.isHidden = true

      case Status.unknown.rawValue:
        self.characterStatus.textColor = .gray
        self.characterStatus.text = "\u{2022}" + character.status

      default:
        self.characterStatus.text = ""
      }
      self.characterImage.alpha = 1
      self.characterName.alpha = 1
      self.characterStatus.alpha = 1
      self.heartButton.alpha = 1
      self.accessoryType = .disclosureIndicator
      self.loadingIndicator.stopAnimating()
    } else {
      self.characterImage.alpha = 0
      self.characterName.alpha = 0
      self.characterStatus.alpha = 0
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
