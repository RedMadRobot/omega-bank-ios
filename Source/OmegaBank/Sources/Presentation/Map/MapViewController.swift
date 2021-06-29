//
//  MapViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 28.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

final class MapViewController: PageViewController, AlertPresentable {
    
    // MARK: - Private types
    
    private enum CameraZoom {
        case zoomIn
        case zoomOut
    }
    
    // MARK: - Private properties
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var locationButton: UIButton!
    
    // MARK: - Init
    
    static func make(delegate: ProfileViewControllerDelegate?) -> UIViewController {
        let controller = MapViewController()
        controller.delegate = delegate
        let navigationController = NavigationController(rootViewController: controller)
        
        return navigationController
    }
    
    init() {
        super.init(title: "Map", tabBarImage: #imageLiteral(resourceName: "map"))
        
        navigationItem.title = "Offices"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.userTrackingMode = .follow
        
        updateLocationStatus(CLLocationManager.authorizationStatus())
    }
    
    // MARK: - Private methods
    
    private func updateLocationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationButton.isHidden = false
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationButton.isHidden = true
        case .denied:
            locationButton.isHidden = false
            mapView.showsUserLocation = false
            showAlert(title: "Geo settings are disabled",
                      message: "Turn on on settings",
                      actions: [
                        UIAlertAction(title: "Cancel", style: .cancel),
                        UIAlertAction(title: "Settings", style: .default, handler: { _ in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl)
                            }
                        })
                      ],
                      preferredAction: nil)
        case .authorizedAlways, .authorizedWhenInUse:
            locationButton.isHidden = false
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            locationButtonPressed()
        default:
            break
        }
    }
    
    private func changeCamera(with zoom: CameraZoom) {
        var region: MKCoordinateRegion = mapView.region
        
        switch zoom {
        case .zoomOut:
            region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
            region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        case .zoomIn:
            region.span.latitudeDelta /= 2.0
            region.span.longitudeDelta /= 2.0
        }
        mapView.animatedZoom(zoomRegion: region, duration: 0.2)
    }
    
    // MARK: - IB Action
    
    @IBAction private func zoomInButtonPressed() {
        changeCamera(with: .zoomIn)
    }
    
    @IBAction private func zoomOutButtonPressed() {
        changeCamera(with: .zoomOut)
    }
    
    @IBAction private func locationButtonPressed() {
        guard let location = mapView.userLocation.location else { return }
        mapView.setCenter(location.coordinate, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateLocationStatus(status)
    }
}

extension MKMapView {
    func animatedZoom(zoomRegion: MKCoordinateRegion, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.setRegion(zoomRegion, animated: true)
        }
    }
}
