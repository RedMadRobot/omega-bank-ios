//
//  MapSegmentedView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 20.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

protocol MapSegmentedControlsDelegate: AnyObject {
    
    func mapSegmentedControlsDidSelectAll(_ mapSegmentedView: MapSegmentedView)
    
    func mapSegmentedControlsDidSelectOffices(_ mapSegmentedView: MapSegmentedView)
    
}

final class MapSegmentedView: View {
    
    weak var delegate: MapSegmentedControlsDelegate?
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Offices", "All"])
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.backgroundColor = .textPrimary
        segmentedControl.addTarget(self, action: #selector(segmentedDidChange), for: .valueChanged)
        return segmentedControl
    }()
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(segmentedControl, with: self)
    }
    
    @objc private func segmentedDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.mapSegmentedControlsDidSelectOffices(self)
        case 1:
            delegate?.mapSegmentedControlsDidSelectAll(self)
        default:
            break
        }
    }
}
