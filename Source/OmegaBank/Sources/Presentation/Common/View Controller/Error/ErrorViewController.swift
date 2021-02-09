//
//  ErrorViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 6/1/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class ErrorViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var repeatButton: SubmitButton!
    
    // MARK: - Private Properties
    
    private let item: ErrorItem
    private let onAction: (() -> Void)?

    // MARK: - Initialization

    init(_ item: ErrorItem,
         onAction: (() -> Void)? = nil) {
        self.item = item
        self.onAction = onAction
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ErrorViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = item.title
        subtitleLabel.isHidden = item.subtitle == nil
        
        if let subtitle = item.subtitle {
            subtitleLabel.text = subtitle
        }
        
        repeatButton.isHidden = onAction == nil
        if let action = item.actionTitle {
            repeatButton.setTitle(action, for: .normal)
        }

    }
    
    // MARK: - IBAction
    
    @IBAction func `repeat`(_ sender: Any) {
        onAction?()
    }

}
