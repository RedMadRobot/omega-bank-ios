//
//  PinCodeView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

// MARK: - Types

/// Состояния правой кнопки
enum RightButtonItem {
    case delete
    case nothing
    case touchID
    case faceID
    
    var image: UIImage? {
        switch self {
        
        case .delete:
            return .backspace
        case .nothing:
            return nil
        case .touchID:
            return .touchid
        case .faceID:
            return .faceid
        }
    }
}

final class PinCodeView: UIView {
    
    // MARK: - Private Types
    
    enum Constants {
        static let imageCornerRadius: CGFloat = 36
        
        static let pinViewShadowRadius: CGFloat = 10
        static let pinViewShadowOpacity: Float = 0.2
        
        static let textNumberLines = 2
        
        static let backgroundImageHeight: CGFloat = 228
        static let backgroundImageWeight: CGFloat = 375
        
        static let backgroundImageMultiplier = backgroundImageWeight / backgroundImageHeight
        
        static let keyboardBottomConstraint: CGFloat = -51
        
        static let viewLeadingConstraint: CGFloat = 24
        static let viewTrailingConstraint: CGFloat = -24
        
        static let customSpacingAfterTitleLabel: CGFloat = 25
        
        static let errorBottomConstraint: CGFloat = 16
        
        static let stackViewSpacing: CGFloat = 0
    }
    
    // MARK: - Public Properties
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var isAvatarImageHidden: Bool = true {
        didSet {
            imageView.isHidden = isAvatarImageHidden
        }
    }
    
    var isExitButtonHidden: Bool = true {
        didSet {
            let name = isExitButtonHidden ? nil : "Exit"
            keyboardView.setLeftButton(name: name)
        }
    }
    
    var indicatorValue: Int = 0 {
        didSet {
            indicatorView.value = indicatorValue
            
            if indicatorValue > 0 {
                errorLabel.isHidden = true
            }
        }
    }
    
    var isEnableKeyboard: Bool = true {
        didSet {
            keyboardView.isUserInteractionEnabled = isEnableKeyboard
        }
    }
    
    weak var delegate: PinCodeKeyBoardViewDelegate? {
        didSet {
            keyboardView.delegate = delegate
        }
    }
    
    // MARK: - Private Properties
    
    private let keyboardView = PinCodeKeyboardView.loadFromNib()
    private let indicatorView = PinCodeIndicatorView.loadFromNib()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.stackViewSpacing
        return stackView
    }()
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = .defaultUser
        image.layer.cornerRadius = Constants.imageCornerRadius
        return image
    }()
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .ph3
        label.numberOfLines = Constants.textNumberLines
        label.font = .authTitle
        label.textAlignment = .center
        return label
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = Constants.textNumberLines
        label.textAlignment = .center
        label.textColor = .red
        label.font = .authError
        return label
    }()
    private let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage.background
        return image
    }()
    
    private let topGuide = UILayoutGuide()
    private let bottomGuide = UILayoutGuide()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    
    func setRightButton(rightButtonItem: RightButtonItem) {
        keyboardView.setRightButton(image: rightButtonItem.image)
    }
    
    func showError(errorMessage: String) {
        errorLabel.text = errorMessage
        errorLabel.isHidden = false
        indicatorView.showError()
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    func clearInput(animation: ClearAnimation, completion: VoidClosure?) {
        indicatorView.clear(with: animation, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        setupBackgroundImage()
        setupKeyboardView()
        setupStackView()
        setupLayoutGuide()
        setupImageLabel()
        setupTitleLabel()
        setupIndicatorView()
        setupErrorLabel()
        setupShadowView()
    }
    
    private func setupBackgroundImage() {
        addSubview(backgroundImage, activate: [
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.widthAnchor.constraint(
                equalTo: backgroundImage.heightAnchor,
                multiplier: Constants.backgroundImageMultiplier)
        ])
    }
    
    private func setupKeyboardView() {
        addSubview(keyboardView, activate: [
            keyboardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            keyboardView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: Constants.keyboardBottomConstraint)
        ])
    }
    
    private func setupShadowView() {
        keyboardView.layer.shadowColor = UIColor.black.cgColor
        keyboardView.layer.shadowOpacity = Constants.pinViewShadowOpacity
        keyboardView.layer.shadowPath = UIBezierPath(rect: keyboardView.bounds).cgPath
        keyboardView.layer.shadowRadius = Constants.pinViewShadowRadius
        keyboardView.layer.shadowOffset = .zero
    }
    
    private func setupLayoutGuide() {
        addLayoutGuide(topGuide)
        addLayoutGuide(bottomGuide)
        
        NSLayoutConstraint.activate([
            topGuide.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topGuide.bottomAnchor.constraint(equalTo: stackView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomGuide.topAnchor),
            bottomGuide.bottomAnchor.constraint(equalTo: keyboardView.topAnchor),
            
            topGuide.heightAnchor.constraint(equalTo: bottomGuide.heightAnchor)
        ])
    }
    
    private func setupStackView() {
        
        addSubview(stackView, activate: [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.viewLeadingConstraint),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.viewTrailingConstraint)
        ])
    }
    
    private func setupImageLabel() {
        stackView.addArrangedSubview(imageView)
    }
    
    private func setupTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(Constants.customSpacingAfterTitleLabel, after: titleLabel)
    }
    
    private func setupIndicatorView() {
        stackView.addArrangedSubview(indicatorView)
    }
    
    private func setupErrorLabel() {
        
        addSubview(errorLabel, activate: [
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Constants.errorBottomConstraint)
        ])
    }
    
}
