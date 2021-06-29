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

final class MapViewController: PageViewController {
    
    // MARK: - Private types
    
    private enum CameraZoom {
        case zoomIn
        case zoomOut
    }
    
    // MARK: - Private properties
    
    private var locationManager = CLLocationManager()
    
    // MARK: - IBOutlets
    
    @IBOutlet private var mapView: MKMapView!
    
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
        
    }
    
    // MARK: - Private methods
    
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
        
    }
}

extension MKMapView {
    func animatedZoom(zoomRegion: MKCoordinateRegion, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.setRegion(zoomRegion, animated: true)
        }
    }
}
