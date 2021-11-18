import UIKit

class InAppTimeViewController: UIViewController, StoryboardCreatable {
  @IBOutlet weak var hoursLabel: UILabel!
  @IBOutlet weak var minutesLabel: UILabel!
  @IBOutlet weak var secondsLabel: UILabel!

  let timeInAppService = AppData.shared.timeInAppManaged()
  var timer: Timer?
  var timeInApp = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    startTimer()
  }

  func startTimer() {
    self.timeInApp = timeInAppService.getTimeInApp()

    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      let hours = self.timeInApp / 3600 % 24
      let minutes = self.timeInApp / 60 % 60
      let seconds = self.timeInApp % 60

      self.hoursLabel.text = self.timeFormat(time: hours)
      self.minutesLabel.text = self.timeFormat(time: minutes)
      self.secondsLabel.text = self.timeFormat(time: seconds)

      self.timeInApp += 1
    }
  }

  private func timeFormat(time: Int) -> String {
    let formattedTime: String
    switch time {
    case 0...9:
      formattedTime = "0" + String(time)

    default:
      formattedTime = String(time)
    }
    return formattedTime
  }

  @IBAction func onResetTimeTapped(_ sender: UIButton) {
    self.showAlert()
  }

  func showAlert() {
    let alert = UIAlertController(
      title: "Reset time",
      message: "Do you want to reset time?",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "Yes", style: .cancel) { _ in
      self.timeInAppService.resetTimeInApp()
      self.timer?.invalidate()
      self.startTimer()
    })

    alert.addAction(UIAlertAction(title: "No", style: .default))

    self.present(alert, animated: true, completion: nil)
  }
}
