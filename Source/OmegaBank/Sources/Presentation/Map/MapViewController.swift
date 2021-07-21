//
//  MapViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 19.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import CoreLocation
import MapKit

final class MapViewController: UIViewController, AlertPresentable {
    
    // MARK: - Private types
    
    private enum CameraZoom {
        case zoomIn
        case zoomOut
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let coordinateMoscow = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        static let scaleMoscow = 35000.0
        static let scaleUserLocation = 1000.0
        static let coordinateMoscowRegion = MKCoordinateRegion(
            center: coordinateMoscow,
            latitudinalMeters: scaleMoscow,
            longitudinalMeters: scaleMoscow)
        
        static let durationAnimation = 0.2
    }
    
    // MARK: - Private Properties
    
    private let mapView = MapView()
    private let locationManager: CLLocationManager
    private var locationStatus: CLAuthorizationStatus?
    
    // MARK: - Init
    
    init(annotations: [MKAnnotation], locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        mapView.addAnnotations(annotations)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.mapControlsDelegate = self
        locationManager.delegate = self
        
        registerMapAnnotationView()
        updateLocationStatus(CLLocationManager.authorizationStatus())
    }
    
    // MARK: - Public methods
    
    override func loadView() {
        view = mapView
    }
    
    // MARK: - Private methods
    
    private func registerMapAnnotationView() {
        mapView.registerAnnotationView(OfficeMarkerAnnotationView.self)
        mapView.registerAnnotationView(ClusterMarkerAnnotationView.self)
        mapView.registerAnnotationView(AtmMarkerAnnotationView.self)
    }
    
    private func showMoscow() {
        mapView.setRegion(Constants.coordinateMoscowRegion, animated: true)
    }
    
    private func showUserLocation() {
        guard let location = locationManager.location else { return }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: Constants.scaleUserLocation,
            longitudinalMeters: Constants.scaleUserLocation)
        
        mapView.setRegion(region, animated: true)
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
        
        mapView.animatedZoom(zoomRegion: region, duration: Constants.durationAnimation)
    }
    
    private func updateLocationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            mapView.locationButton.isHidden = false
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            mapView.locationButton.isHidden = true
            mapView.showsUserLocation = false
            showMoscow()
        case .denied:
            mapView.locationButton.isHidden = false
            mapView.showsUserLocation = false
            showMoscow()
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.locationButton.isHidden = false
            locationManager.requestLocation()
            mapView.showsUserLocation = true
            showUserLocation()
        default:
            break
        }
    }
    
    /// Алерт перехода в настройки, для включения геолокации
    private func showSettingsAlert() {
        showAlert(
            title: "Geo settings are disabled",
            message: "Turn on settings",
            actions: [
                UIAlertAction(title: "Cancel", style: .cancel),
                UIAlertAction(title: "Settings", style: .default) { _ in
                    guard
                        let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                        UIApplication.shared.canOpenURL(settingsUrl)
                    else {
                        return }
                    UIApplication.shared.open(settingsUrl)
                }
            ])
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        if let annotation = annotation as? MapAnnotation {
            let view = mapView.dequeueReusableView(annotation.type.viewType, for: annotation)
            view.clusteringIdentifier = String(describing: BankPointMarkerAnnotationView.self)
            view.setup(annotation)
            return view
        } else if let annotation = annotation as? MKClusterAnnotation {
            let view = mapView.dequeueReusableView(ClusterMarkerAnnotationView.self, for: annotation)
            view.setup(annotation)
            return view
        }
        return nil
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = view.annotation else { return }
        
        let mapHelper = AppSchemeRouter(annotation: annotation)
        let placemark = MKPlacemark(
            coordinate: CLLocationCoordinate2D(
                latitude: annotation.coordinate.latitude,
                longitude: annotation.coordinate.longitude
            )
        )
        let mapItem = MKMapItem(placemark: placemark)
        
        showAlert(mapOptions: mapHelper.availableMapApps) {
            mapItem.openInMaps(launchOptions: mapHelper.availableMapApps)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateLocationStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showUserLocation()
    }
}

// MARK: - MapViewControlsDelegate

extension MapViewController: MapViewControlsDelegate {
    func mapViewControlsDidSelectLocationButton(_ mapView: MapView) {
        showUserLocation()
    }
    
    func mapViewControlsDidSelectZoomInButton(_ mapView: MapView) {
        changeCamera(with: .zoomIn)
    }
    
    func mapViewControlsDidSelectZoomOutButton(_ mapView: MapView) {
        changeCamera(with: .zoomOut)
    }
    
}

// MARK: - MKMapView

extension MKMapView {
    func animatedZoom(zoomRegion: MKCoordinateRegion, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.setRegion(zoomRegion, animated: true)
        }
    }
}

// MARK: - AnnotationType

extension AnnotationType {
    var viewType: BankPointMarkerAnnotationView.Type {
        switch self {
        case .atm:
            return AtmMarkerAnnotationView.self
        case .office:
            return OfficeMarkerAnnotationView.self
        }
    }
}
