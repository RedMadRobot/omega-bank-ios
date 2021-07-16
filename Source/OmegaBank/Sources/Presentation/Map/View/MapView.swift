//
//  MapView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 15.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

final class MapView: MKMapView {
    
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
        
        static let trailingConstraint: CGFloat = -18
        static let bottomConstraint: CGFloat = -21
    }
    
    // MARK: - Public Properties
    let locationManager: CLLocationManager
    
    let locationButton: MapButton = {
        let button = MapButton()
        button.setImage(Asset.location.image, for: .normal)
        button.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private Properties
    
    private let zoomInButton: MapButton = {
        let button = MapButton()
        button.setImage(Asset.plus.image, for: .normal)
        button.addTarget(self, action: #selector(zoomInButtonPressed), for: .touchUpInside)
        return button
    }()
    private let zoomOutButton: MapButton = {
        let button = MapButton()
        button.setImage(Asset.minus.image, for: .normal)
        button.addTarget(self, action: #selector(zoomOutButtonPressed), for: .touchUpInside)
        return button
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Init
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func showMoscow() {
        self.setRegion(
            MKCoordinateRegion(
                center: Constants.coordinateMoscow,
                latitudinalMeters: Constants.scaleMoscow,
                longitudinalMeters: Constants.scaleMoscow),
            animated: false)
    }
    
    func showUserLocation() {
        guard let location = locationManager.location else {
            return }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: Constants.scaleUserLocation,
            longitudinalMeters: Constants.scaleUserLocation)
        
        self.setRegion(region, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        
        setupStackView()
        stackView.addArrangedSubview(zoomInButton)
        stackView.addArrangedSubview(zoomOutButton)
        
        setupLocationButton()
    }
    
    private func setupStackView() {
        self.addSubview(
            stackView,
            activate: [
                stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                stackView.trailingAnchor.constraint(
                    equalTo: self.trailingAnchor,
                    constant: Constants.trailingConstraint)
            ])
    }
    
    private func setupLocationButton() {
        self.addSubview(
            locationButton,
            activate: [
                locationButton.trailingAnchor.constraint(
                    equalTo: self.trailingAnchor,
                    constant: Constants.trailingConstraint),
                locationButton.bottomAnchor.constraint(
                    equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                    constant: Constants.bottomConstraint)
            ])
    }
    
    private func changeCamera(with zoom: CameraZoom) {
        var region: MKCoordinateRegion = self.region
        
        switch zoom {
        case .zoomOut:
            region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
            region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        case .zoomIn:
            region.span.latitudeDelta /= 2.0
            region.span.longitudeDelta /= 2.0
        }
        
        self.animatedZoom(zoomRegion: region, duration: Constants.durationAnimation)
    }
    
    // MARK: - Actions
    
    @objc func locationButtonPressed() {
        showUserLocation()
    }
    
    @objc private func zoomOutButtonPressed() {
        changeCamera(with: .zoomOut)
    }
    
    @objc private func zoomInButtonPressed() {
        changeCamera(with: .zoomIn)
    }
}
