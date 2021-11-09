import UIKit

class EpisodesTableViewController: UITableViewController, StoryboardCreatable {
  private weak var clientAPI: ClientServiceAPIDelegate?

  private var episodesInfo: EpisodeInfo?
  private var episodes: [EpisodeResult] = []

  private var isFetchInProgress = false
  private var currentPage = 1

  private let loadingIndicator = UIActivityIndicatorView()

  private var episodesCount: Int {
    return self.episodesInfo?.info.count ?? 0
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    clientAPI = ClientServiceAPI.shared
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let currentPage = self?.currentPage else { return }
      self?.requestAPI(pageNumber: currentPage)
    }
    setupView()
    showLoadingIndicator()
  }

  private func setupView() {
    let navigationBar = self.navigationController?.navigationBar

    guard let apperance = navigationBar?.standardAppearance else { return }

    apperance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navigationBar?.standardAppearance = apperance
    navigationBar?.scrollEdgeAppearance = apperance

    self.tableView.prefetchDataSource = self

    setupLoadingIndicator()
  }

  private func setupLoadingIndicator() {
    self.loadingIndicator.hidesWhenStopped = true
    self.loadingIndicator.style = .large
    self.tableView.backgroundView = self.loadingIndicator
  }

  private func showLoadingIndicator() {
    self.loadingIndicator.startAnimating()
  }

  private func hideLoadingIndicator() {
    self.loadingIndicator.stopAnimating()
  }

  private func requestAPI(pageNumber: Int) {
    guard !isFetchInProgress else {
      print("Fetch in Progress")
      return
    }

    isFetchInProgress = true

    self.clientAPI?.episodes().getEpisodesByPageNumber(pageNumber: currentPage) { responseAPI in
      do {
        try self.episodesInfo = responseAPI.get()
      } catch {
        DispatchQueue.main.async {
          self.isFetchInProgress = false

          let errorMessage = errorHandling(error: error)

          self.onFetchFailed(with: errorMessage.outputMsg)
        }
      }

      DispatchQueue.main.async {
        self.isFetchInProgress = false

        guard let result = self.episodesInfo?.results else { return }

        self.episodes.append(contentsOf: result)

        if self.currentPage > 1 {
          let indexPathsToReload = self.calculateIndexPathsToReload(from: result)
          self.onFetchCompleted(with: indexPathsToReload)
        } else {
          self.onFetchCompleted(with: .none)
        }
        self.currentPage += 1
      }
    }
  }

  private func showErrorAlert(msg: String) {
    let alertTitle = "Request error"

    let range = (alertTitle as NSString).range(of: alertTitle)
    let attribute = NSMutableAttributedString.init(string: alertTitle)
    attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)

    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)

    alert.setValue(attribute, forKey: "attributedTitle")

    let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
      self.retryRequestAPI()
    }

    alert.addAction(retryAction)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    self.present(alert, animated: true, completion: nil)
  }

  private func calculateIndexPathsToReload(from newCharacters: [EpisodeResult]) -> [IndexPath] {
    let startIndex = episodes.count - newCharacters.count
    let endIndex = startIndex + newCharacters.count
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
  }

  private func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    guard let newIndexPathsToReload = newIndexPathsToReload else {
      self.hideLoadingIndicator()
      self.tableView.reloadData()
      return
    }
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .automatic)
  }

  private func onFetchFailed(with reason: String) {
    self.hideLoadingIndicator()

    self.showErrorAlert(msg: reason)
  }

  private func retryRequestAPI() {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let currentPage = self?.currentPage else { return }
      self?.requestAPI(pageNumber: currentPage)
    }
  }
}

// MARK: - Extension TableViewController

extension EpisodesTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.episodesCount
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "EpisodesCell",
      for: indexPath
    ) as? EpisodesTableViewCell
    else { fatalError("Unable to dequeue EpisodesCell") }

    if isLoadingCell(for: indexPath) {
      cell.configure(with: .none)
    } else {
      cell.configure(with: self.episodes[indexPath.row])
    }
    return cell
  }
}

// MARK: - Extension UITableViewDataSourcePrefetching

extension EpisodesTableViewController: UITableViewDataSourcePrefetching {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= self.episodes.count
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }

  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      self.requestAPI(pageNumber: self.currentPage)
    }
  }
}
