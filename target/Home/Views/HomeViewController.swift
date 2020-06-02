//
//  HomeViewController.swift
//  target
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {
  
  // MARK: - Outlets
  
  var viewModel: HomeViewModel!
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    navigationController?.setupNavigationBar()
    title = "Target Points"
    let camera = GMSCameraPosition.camera(withLatitude: -34.9011, longitude: -56.1645, zoom: 6.0)
    let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
    view.addSubview(mapView)
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
