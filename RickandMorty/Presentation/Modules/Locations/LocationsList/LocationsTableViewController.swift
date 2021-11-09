import UIKit

class LocationsTableViewController: UITableViewController, StoryboardCreatable {
  private weak var clientAPI: ClientServiceAPIDelegate?

  private var locationsInfo: LocationInfo?
  private var locations: [LocationResult] = []

  private var isFetchInProgress = false
  private var currentPage = 1

  private let loadingIndicator = UIActivityIndicatorView()

  private var locationsCount: Int {
    return self.locationsInfo?.info.count ?? 0
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

    self.clientAPI?.locations().getLocationsByPageNumber(pageNumber: pageNumber) { responseAPI in
      do {
        try self.locationsInfo = responseAPI.get()
      } catch {
        DispatchQueue.main.async {
          self.isFetchInProgress = false

          let errorMessage = errorHandling(error: error)

          self.onFetchFailed(with: errorMessage.outputMsg)
        }
      }

      DispatchQueue.main.async {
        self.isFetchInProgress = false

        guard let result = self.locationsInfo?.results else { return }

        self.locations.append(contentsOf: result)

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

  private func calculateIndexPathsToReload(from newCharacters: [LocationResult]) -> [IndexPath] {
    let startIndex = locations.count - newCharacters.count
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

extension LocationsTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.locationsCount
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "LocationCell",
      for: indexPath
    ) as? LocationsTableViewCell
    else { fatalError("Unable to dequeue LocationCell") }

    if isLoadingCell(for: indexPath) {
      cell.configure(with: .none)
    } else {
      cell.configure(with: self.locations[indexPath.row])
    }
    return cell
  }
}

// MARK: - Extension UITableViewDataSourcePrefetching

extension LocationsTableViewController: UITableViewDataSourcePrefetching {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= self.locations.count
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
