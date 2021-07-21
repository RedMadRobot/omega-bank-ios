//
//  MapContainerViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 28.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import CoreLocation
import MapKit
import struct OmegaBankAPI.BankPlace

final class MapContainerViewController: PageViewController, AlertPresentable {
    
    // MARK: - Private properties
    
    private let bankPlacesService: BankPlacesService
    private var progress: Progress?
    private var errorViewController: ErrorViewController?
    
    // MARK: - Init
    
    init(officesService: BankPlacesService = ServiceLayer.shared.officesService) {
        bankPlacesService = officesService

        super.init(title: "Map", tabBarImage: #imageLiteral(resourceName: "map"))
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
        
        loadOffices()
    }
    
    // MARK: - Private methods
    
    private func showError(_ item: ErrorItem, onAction: VoidClosure? = nil) {
        let vc = ErrorViewController(item, onAction: onAction)
        addChildViewController(vc, to: view)
        errorViewController = vc
    }
    
    private func removeError() {
        errorViewController?.removeChildFromParent()
        errorViewController = nil
    }
    
    private func showMap(annotations: [MKAnnotation]) {
        let mapViewController = MapViewController(annotations: annotations)
        addChildViewController(mapViewController, to: view)
        
        let segmentedView = MapSegmentedView()
        segmentedView.delegate = mapViewController
        navigationItem.titleView = segmentedView
    }
    
    /// Загрузка офисов
    private func loadOffices() {
        progress = bankPlacesService.load { [weak self] result in
            switch result {
            case .success(let (offices, atms)):
                self?.showMap(annotations: offices + atms)
            case .failure(let error):
                self?.showError(.error(error), onAction: { [weak self] in
                    self?.removeError()
                    self?.loadOffices()
                })
            }
        }
    }
}
