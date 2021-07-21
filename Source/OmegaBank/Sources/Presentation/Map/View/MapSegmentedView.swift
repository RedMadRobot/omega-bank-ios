//
//  MapSegmentedView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 20.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

final class MapSegmentedView: View {
    
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
}
