//
//  PrivacyProtectionViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 22.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

final class PrivacyProtectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurEffect()
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(blurEffectView, with: view)
    }
}
