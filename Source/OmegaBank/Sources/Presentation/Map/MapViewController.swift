//
//  MapViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 28.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import CoreLocation
import MapKit
import struct OmegaBankAPI.Office

final class MapViewController: PageViewController, AlertPresentable {
    
    // MARK: - Private properties
    
    private let officesService: BankPlacesService
    private var locationManager: CLLocationManager
    private var progress: Progress?
    private var locationStatus: CLAuthorizationStatus?
    private var errorViewController: ErrorViewController?

    private var mapView: MapView
    
    // MARK: - Init
    
    init(officesService: BankPlacesService = ServiceLayer.shared.officesService) {
        self.officesService = officesService
        self.locationManager = CLLocationManager()
        self.mapView = MapView(locationManager: locationManager)

        super.init(title: "Map", tabBarImage: #imageLiteral(resourceName: "map"))
        
        navigationItem.title = "Offices & Bankomats"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progress?.cancel()
    }
    
    // MARK: - View controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        registerMapAnnotationView()
        
        loadOffices()
        
        updateLocationStatus(CLLocationManager.authorizationStatus())
    }
    
    override func loadView() {
        view = mapView
    }
    
    // MARK: - Private methods
    
    private func registerMapAnnotationView() {
        mapView.registerAnnotationView(OfficeMarkerAnnotationView.self)
        mapView.registerAnnotationView(ClusterMarkerAnnotationView.self)
        mapView.registerAnnotationView(AtmMarkerAnnotationView.self)
    }
    
    private func updateLocationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            mapView.locationButton.isHidden = false
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            mapView.locationButton.isHidden = true
            mapView.showsUserLocation = false
            mapView.showMoscow()
        case .denied:
            mapView.locationButton.isHidden = false
            mapView.showsUserLocation = false
            mapView.showMoscow()
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.locationButton.isHidden = false
            locationManager.requestLocation()
            mapView.showsUserLocation = true
            mapView.showUserLocation()
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
    
    private func showError(_ item: ErrorItem, onAction: VoidClosure? = nil) {
        let vc = ErrorViewController(item, onAction: onAction)
        addChildViewController(vc, to: view)
        errorViewController = vc
    }
    
    private func removeError() {
        errorViewController?.removeChildFromParent()
        errorViewController = nil
    }
    
    /// Загрузка офисов
    private func loadOffices() {
        progress = officesService.load { [weak self] result in
            switch result {
            case .success(let (offices, atms)):
                self?.mapView.addAnnotations(offices)
                self?.mapView.addAnnotations(atms)
            case .failure(let error):
                self?.showError(.error(error), onAction: { [weak self] in
                    self?.removeError()
                    self?.loadOffices()
                })
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        if let annotation = annotation as? OfficeMapAnnotation {
            let view = mapView.dequeueReusableView(OfficeMarkerAnnotationView.self, for: annotation)
            view.clusteringIdentifier = String(describing: BankPointMarkerAnnotationView.self)
            view.setup(annotation)
            return view
        } else if let annotation = annotation as? MKClusterAnnotation {
            let view = mapView.dequeueReusableView(ClusterMarkerAnnotationView.self, for: annotation)
            view.setup(annotation)
            return view
        } else if let annotation = annotation as? AtmMapAnnotation {
            let view = mapView.dequeueReusableView(AtmMarkerAnnotationView.self, for: annotation)
            view.clusteringIdentifier = String(describing: BankPointMarkerAnnotationView.self)
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
        mapView.showUserLocation()
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
