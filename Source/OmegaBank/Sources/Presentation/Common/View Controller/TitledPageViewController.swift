//
//  TitledPageViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/7/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

class TitledPageViewController: ViewController {

    // MARK: - IBOutlets

    @IBOutlet private var titledCurvedView: TitledCurvedView!
    @IBOutlet private var contentView: UIView!
    
    // MARK: - Private Properties
    
    private let embeddedViewController: UIViewController?
    
    // MARK: - Initialization

    init(
        title: String,
        embeddedViewController: UIViewController? = nil,
        hasDismissedButton: Bool = false) {
        self.embeddedViewController = embeddedViewController
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
        self.hasDismissedButton = hasDismissedButton
        navigationItem.title = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ScrollablePageViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titledCurvedView.setup(with: title ?? "")
        
        if let vc = embeddedViewController {
            addEmbeddedViewController(vc)
        }
        
    }
    
    // MARK: - Public Methods
    
    func addEmbeddedViewController(_ viewController: UIViewController) {
        addChildViewController(viewController, to: contentView)
    }

}
