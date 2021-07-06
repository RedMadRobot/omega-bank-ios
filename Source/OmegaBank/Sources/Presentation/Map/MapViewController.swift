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

final class MapViewController: PageViewController, AlertPresentable, MKMapViewDelegate {
    
    // MARK: - Private types
    
    private enum CameraZoom {
        case zoomIn
        case zoomOut
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let coordinatesMoscow = (latitude: 55.751244, longitude: 37.618423)
        static let scaleMoscow = 35000.0
        static let scaleUserLocation = 1000.0
        static let durationAnimation = 0.2
    }
    
    // MARK: - Private properties
    
    private var progress: Progress?
    private let officesService: OfficesService
    private var locationStatus: CLAuthorizationStatus?
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
        registerMapAnnotationView()
        
        showMapCenter()
        loadOffices()
        
        updateLocationStatus(CLLocationManager.authorizationStatus())
    }
    
    // MARK: - Private methods
    
    private func registerMapAnnotationView() {
        mapView.register(
            MarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    /// Добавление аннотаций на карту
    private func addAnnotations(_ offices: [Office]) {
        let annotations: [MKAnnotation] = offices.compactMap { office in
            let annotation = MapAnnotation(
                latitude: office.location.latitude,
                longitude: office.location.longitude,
                title: office.name,
                subtitle: office.address)
            return annotation
        }
        
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
            showMapCenter()
        case .denied:
            locationButton.isHidden = false
            mapView.showsUserLocation = false
            showMapCenter()
        case .authorizedAlways, .authorizedWhenInUse:
            locationButton.isHidden = false
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            showUserLocation()
        default:
            break
        }
        
        self.locationStatus = status
    }
    
    /// Алерт перехода в настройки, для включения геолокации
    private func showSettingsAlert() {
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
    }
    
    /// Отображение Москвы на карте
    private func showMapCenter() {
        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: Constants.coordinatesMoscow.latitude,
                    longitude: Constants.coordinatesMoscow.longitude),
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
            case .failure:
                break
            }
        }
    }
    
    // MARK: - IB Action
    
    @IBAction private func zoomInButtonPressed() {
        changeCamera(with: .zoomIn)
    }
    
    @IBAction private func zoomOutButtonPressed() {
        changeCamera(with: .zoomOut)
    }
    
    @IBAction private func locationButtonPressed() {
        guard locationStatus != .denied else {
            showSettingsAlert()
            return }
        showUserLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateLocationStatus(status)
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
