//
//  MapView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 15.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

protocol MapViewControlsDelegate: AnyObject {
    
    func mapViewControlsDidSelectLocationButton(_ mapView: MapView)
    
    func mapViewControlsDidSelectZoomInButton(_ mapView: MapView)
    
    func mapViewControlsDidSelectZoomOutButton(_ mapView: MapView)
    
}

final class MapView: MKMapView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let trailingConstraint: CGFloat = -18
        static let bottomConstraint: CGFloat = -21
    }
    
    // MARK: - Public Properties
    
    weak var mapControlsDelegate: MapViewControlsDelegate?
    
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
        return stackView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        setupStackView()
        setupLocationButton()
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(zoomInButton)
        stackView.addArrangedSubview(zoomOutButton)
        
        addSubview(
            stackView,
            activate: [
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                stackView.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: Constants.trailingConstraint)
            ])
    }
    
    private func setupLocationButton() {
        addSubview(
            locationButton,
            activate: [
                locationButton.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: Constants.trailingConstraint),
                locationButton.bottomAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.bottomAnchor,
                    constant: Constants.bottomConstraint)
            ])
    }
    
    // MARK: - Actions
    
    @objc private func locationButtonPressed() {
        mapControlsDelegate?.mapViewControlsDidSelectLocationButton(self)
    }
    
    @objc private func zoomOutButtonPressed() {
        mapControlsDelegate?.mapViewControlsDidSelectZoomOutButton(self)
    }
    
    @objc private func zoomInButtonPressed() {
        mapControlsDelegate?.mapViewControlsDidSelectZoomInButton(self)
    }
}
