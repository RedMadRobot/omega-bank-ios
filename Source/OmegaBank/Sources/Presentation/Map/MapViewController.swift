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
        static let durationAnimation = 0.2
    }
    
    // MARK: - Private properties
    
    private let officesService: OfficesService
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    private var progress: Progress?
    private var locationStatus: CLAuthorizationStatus?
    private var errorViewController: ErrorViewController?
    
    // MARK: - IBOutlets
    
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var locationButton: UIButton!
    
    // MARK: - Init
    
    init(officesService: OfficesService = ServiceLayer.shared.officesService) {
        self.officesService = officesService
        
        super.init(title: "Map", tabBarImage: #imageLiteral(resourceName: "map"))
        
        navigationItem.title = "Offices"
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
        registerMapAnnotationView()
        
        loadOffices()
        
        updateLocationStatus(CLLocationManager.authorizationStatus())
    }
    
    // MARK: - Private methods
    
    private func registerMapAnnotationView() {
        registerAnnotationViewNib(mapView: mapView, OfficeMarkerAnnotationView.self)
        registerAnnotationViewNib(mapView: mapView, ClusterMarkerAnnotationView.self)
    }
    
    /// Добавление аннотаций на карту
    private func addAnnotations(_ offices: [Office]) {
        let annotations = offices.map { $0.annotation }
        
        mapView.addAnnotations(annotations)
    }
    
    private func updateLocationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationButton.isHidden = false
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationButton.isHidden = true
            mapView.showsUserLocation = false
            showMoscow()
        case .denied:
            locationButton.isHidden = false
            mapView.showsUserLocation = false
            showMoscow()
        case .authorizedAlways, .authorizedWhenInUse:
            locationButton.isHidden = false
            locationManager.requestLocation()
            mapView.showsUserLocation = true
            showUserLocation()
        default:
            break
        }
        
        self.locationStatus = status
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
    
    /// Отображение Москвы на карте
    private func showMoscow() {
        mapView.setRegion(
            MKCoordinateRegion(
                center: Constants.coordinateMoscow,
                latitudinalMeters: Constants.scaleMoscow,
                longitudinalMeters: Constants.scaleMoscow),
            animated: false)
        
    }
    
    /// Отображение пользователя на карте
    private func showUserLocation() {
        guard let location = locationManager.location else {
            return }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: Constants.scaleUserLocation,
            longitudinalMeters: Constants.scaleUserLocation)
        
        mapView.setRegion(region, animated: true)
    }
    
    /// Изменение зума карты
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
    
    /// Загрузка офисов
    private func loadOffices() {
        progress = officesService.load { [weak self] result in
            switch result {
            case .success(let offices):
                self?.addAnnotations(offices)
            case .failure(let error):
                self?.showError(.error(error), onAction: { [weak self] in
                    self?.removeError()
                    self?.loadOffices()
                })
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func zoomInButtonPressed() {
        changeCamera(with: .zoomIn)
    }
    
    @IBAction private func zoomOutButtonPressed() {
        changeCamera(with: .zoomOut)
    }
    
    @IBAction private func locationButtonPressed() {
        guard locationStatus != .denied else {
            showSettingsAlert()
            return
        }
        showUserLocation()
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        if let annotation = annotation as? MapAnnotation {
            let view = dequeueReusableView(mapView: mapView, OfficeMarkerAnnotationView.self, for: annotation)
            view.clusteringIdentifier = String(describing: OfficeMarkerAnnotationView.self)
            view.setup(annotation)
            return view
        } else if let annotation = annotation as? MKClusterAnnotation {
            let view = dequeueReusableView(mapView: mapView, ClusterMarkerAnnotationView.self, for: annotation)
            view.setup(annotation)
            return view
        }
        return nil
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = view.annotation as? MapAnnotation else {
            return
        }
        
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
        locationButtonPressed()
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
