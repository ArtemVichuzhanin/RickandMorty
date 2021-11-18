import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
  private let appLaunchLocation = AppData.shared.appLaunchLocations()
  private var appLocations: [AppLaunchLocation]?

  private var count: Int {
    return self.appLocations?.count ?? 0
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  func setupView() {
    loadAppLocations()

    let camera = GMSCameraPosition.camera(
      withLatitude: self.appLocations?[count - 1].latitude ?? -33.86,
      longitude: self.appLocations?[count - 1].longitude ?? 151.20,
      zoom: 15.0
    )

    let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
    self.view.addSubview(mapView)

    for i in 0..<count {
      let marker = GMSMarker()

      let location = CLLocationCoordinate2D(
        latitude: self.appLocations?[i].latitude ?? -33.86,
        longitude: self.appLocations?[i].longitude ?? 151.20
      )

      marker.position = location
      marker.title = "Rick and Morty"
      marker.map = mapView
    }
  }

  func loadAppLocations() {
    self.appLaunchLocation.loadLocations { locations in
      self.appLocations = locations
    }
  }
}
