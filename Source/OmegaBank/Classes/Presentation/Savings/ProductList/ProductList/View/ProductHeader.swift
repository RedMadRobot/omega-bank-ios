//
//  ProductHeader.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class ProductHeader: UIControl, NibLoadable {
    
    // MARK: - IBOutlets

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collapedIndicatorImageView: UIImageView!
    @IBOutlet private var addNewProductButton: UIButton!
    @IBOutlet private var addNewProductImage: UIImageView!
    
    // MARK: - Private Properties
    
    private var activityIndicator: UIActivityIndicatorView?
    private var addNewProductAccessibilityIdentifier: String?
    
    // MARK: - Public Properties
    
    var isCollapsed = false {
        willSet {
            collapedIndicatorImageView.image = newValue ? #imageLiteral(resourceName: "arrowRight") : #imageLiteral(resourceName: "arrowDown")
        }
    }
    
    var isAnimated = false {
        willSet {
            newValue ? activityIndicator?.startAnimating() : activityIndicator?.stopAnimating()
            collapedIndicatorImageView.isHidden = newValue
            addNewProductButton.isHidden = newValue
            addNewProductImage.isHidden = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private var onTap: (() -> Void)?
    private var onPlusTap: (() -> Void)?

    // MARK: - ProductHeader
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: View.noIntrinsicMetric, height: 35)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .tableSectionHeader
        addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
        addActivityIndicator()
    }
    
    // MARK: - Initialization
    
    static func make(
        title: String,
        onTap: @escaping () -> Void,
        onPlusTap: @escaping () -> Void,
        accessibilityIdentifier: String? = nil,
        addNewProductAccessibilityIdentifier: String? = nil) -> ProductHeader {
        let view = ProductHeader.loadFromNib()
        
        view.titleLabel.text = title
        view.onTap = onTap
        view.onPlusTap = onPlusTap
        view.accessibilityIdentifier = accessibilityIdentifier
        view.addNewProductButton.accessibilityIdentifier = addNewProductAccessibilityIdentifier
        
        return view
    }
    
    deinit {
        removeTarget(self, action: nil, for: .allEvents)
    }
    
    // MARK: - Private Methods
    
    private func addActivityIndicator() {
        let ai: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            ai = UIActivityIndicatorView(style: .medium)
        } else {
            ai = UIActivityIndicatorView(style: .gray)
        }
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        
        addSubview(ai, activate: [
            ai.centerXAnchor.constraint(equalTo: addNewProductImage.centerXAnchor),
            ai.centerYAnchor.constraint(equalTo: addNewProductImage.centerYAnchor)])
        
        activityIndicator = ai
    }
    
    @IBAction private func addButtonPressed(_ sender: Any) {
        onPlusTap?()
    }

    @objc private func onTapAction() {
        guard !isAnimated else { return }
        
        isCollapsed.toggle()
        onTap?()
    }

}
