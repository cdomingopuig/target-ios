//
//  HomeViewController.swift
//  target
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class HomeViewController: UIViewController {
  
  // MARK: - Outlets
  
  var viewModel: HomeViewModel!
  
  var locationManager = CLLocationManager()
  lazy var mapView = GMSMapView()
  lazy var userLocation = GMSMarker()
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    navigationController?.setupNavigationBar()
    title = "Target Points"
    let camera = GMSCameraPosition.camera(withLatitude: DefaultLatitude, longitude: DefaultLongitude, zoom: DefaultMapZoom)
    mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
    self.view.addSubview(mapView)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    locationManager.delegate = self
    mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    userLocation.iconView = UserMarker(frame: CGRect(x: 0, y: 0, width: UserMarkerHeight, height: UserMarkerHeight))
    userLocation.tracksViewChanges = true
  }
  
  // MARK: - Actions
  
}

extension HomeViewController: HomeViewModelDelegate {
  func didUpdateState() {
    switch viewModel.state {
    case .idle:
      UIApplication.hideNetworkActivity()
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      print(errorDescription)
    }
  }
}

extension HomeViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    locationManager.startUpdatingLocation()
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let position = locations.last?.coordinate else {
      return
    }
    let center = CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude)
    userLocation.position = center
    userLocation.groundAnchor = CGPoint(x: UserMarkerAnchor.x, y: UserMarkerAnchor.y)
    userLocation.map = mapView
  }
}
