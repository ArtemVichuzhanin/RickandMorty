import UIKit
import Kingfisher

class CharactersTableViewController: UITableViewController, StoryboardCreatable {
  private weak var clientAPI: ClientServiceAPIDelegate?

  private var filterCharactersInfo: CharacterInfo?
  private var filterCharacters: [CharacterResult] = []
  private var charactersInfo: CharacterInfo?
  private var characters: [CharacterResult] = []
  private var searchTimer: Timer?
  private var isFetchInProgress = false
  private var currentPage = 1

  private let loadingIndicator = UIActivityIndicatorView()
  private let searchBarController = UISearchController()

  private var isSearchBarEmpty: Bool {
    return self.searchBarController.searchBar.text?.isEmpty ?? true
  }
  private var isFiltering: Bool {
    return !self.searchBarController.searchBar.isHidden && !isSearchBarEmpty
  }
  private var isFilterRequestDone: Bool {
    return self.filterCharactersInfo != nil
  }
  private var charactersCount: Int {
    return self.charactersInfo?.info.count ?? 0
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

    self.searchBarController.searchBar.delegate = self
    self.tableView.prefetchDataSource = self

    setupLoadingIndicator()
    setupSearchBar()
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

  private func setupSearchBar() {
    self.navigationItem.searchController = self.searchBarController
    self.navigationItem.hidesSearchBarWhenScrolling = false

    self.searchBarController.searchBar.searchBarStyle = .minimal

    self.searchBarController.searchBar.searchTextField.backgroundColor = .white
    self.searchBarController.searchBar.searchTextField.tintColor = UIColor(
      named: AppColorKeys.colorForSelectedItem.rawValue
    )
  }

  private func requestAPI(pageNumber: Int) {
    guard !isFetchInProgress else {
      print("Fetch in Progress")
      return
    }

    isFetchInProgress = true

    self.clientAPI?.characters().getCharactersByPageNumber(pageNumber: pageNumber) { responseAPI in
      do {
        try self.charactersInfo = responseAPI.get()
      } catch {
        DispatchQueue.main.async {
          self.isFetchInProgress = false

          let errorMessage = errorHandling(error: error)

          self.onFetchFailed(with: errorMessage.outputMsg)
        }
      }

      DispatchQueue.main.async {
        self.isFetchInProgress = false

        guard let result = self.charactersInfo?.results else { return }

        self.characters.append(contentsOf: result)

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

  private func showInformationAlert(with searchName: String) {
    let alertMessage = "Character with name: \"\(searchName)\" not found"
    let alert = UIAlertController(title: "Not found", message: alertMessage, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "OK", style: .default))

    self.present(alert, animated: true, completion: nil)
  }

  private func calculateIndexPathsToReload(from newCharacters: [CharacterResult]) -> [IndexPath] {
    let startIndex = characters.count - newCharacters.count
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
    if isFiltering {
      guard let searchText = self.searchBarController.searchBar.text
      else {
        print("SearchBar.text is nil")
        return
      }
      self.searchRequestAPI(with: searchText)
    } else {
      DispatchQueue.global(qos: .utility).async { [weak self] in
        guard let currentPage = self?.currentPage else { return }
        self?.requestAPI(pageNumber: currentPage)
      }
    }
  }
}

// MARK: - Extension TableViewController

extension CharactersTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering {
      guard isFilterRequestDone else { return 0 }

      return self.filterCharacters.count
    } else {
      return self.charactersCount
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "CharacterCell",
      for: indexPath
    ) as? CharactersTableViewCell
    else { fatalError("Unable to dequeue CharacterCell") }

    if isLoadingCell(for: indexPath) {
      cell.configure(with: .none)
    } else {
      if isFilterRequestDone {
        cell.configure(with: self.filterCharacters[indexPath.row])
      } else {
        cell.configure(with: self.characters[indexPath.row])
      }
    }
    return cell
  }
}

// MARK: - Extension UISearchBarDelegate

extension CharactersTableViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchTimer?.invalidate()

    if searchText.isEmpty {
      return
    }

    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
      self?.showLoadingIndicator()
      self?.searchRequestAPI(with: searchText)
      self?.isFetchInProgress = true
    }
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.searchBarController.searchBar.text = ""
    self.filterCharacters.removeAll()
    self.filterCharactersInfo = nil
    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
    self.tableView.reloadData()
  }

  private func searchRequestAPI(with searchText: String) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      self?.clientAPI?.characters().getCharactersByNameFilter(nameFilter: searchText) { responseAPI in
        do {
          try self?.filterCharactersInfo = responseAPI.get()
        } catch {
          DispatchQueue.main.async {
            self?.isFetchInProgress = false

            let errorMessage = errorHandling(error: error)

            if errorMessage.code == 404 {
              self?.showInformationAlert(with: searchText)
            } else {
              self?.onFetchFailed(with: errorMessage.outputMsg)
            }
            self?.filterCharacters.removeAll()
            self?.filterCharactersInfo = nil
          }
        }
      }
      DispatchQueue.main.async {
        self?.isFetchInProgress = false

        guard let result = self?.filterCharactersInfo?.results else { return }

        self?.filterCharacters = result
        self?.onFetchCompleted(with: .none)
      }
    }
  }
}

// MARK: - Extension UITableViewDataSourcePrefetching

extension CharactersTableViewController: UITableViewDataSourcePrefetching {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    if isFiltering {
      guard isFilterRequestDone else { return true }

      return indexPath.row >= self.filterCharacters.count
    } else {
      return indexPath.row >= self.characters.count
    }
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }

  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    guard !isFiltering else { return }

    if indexPaths.contains(where: isLoadingCell) {
      self.requestAPI(pageNumber: self.currentPage)
    }
  }
}
