//
//  PinCodeView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

// MARK: - Types
// Состояния правой кнопки
enum RightButtonItem {
    case delete
    case nothing
    case touchID
    case faceID
}

final class PinCodeView: UIView {
    
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
            if isExitButtonHidden {
                keyboardView.setLeftButton(name: nil)
            } else {
                keyboardView.setLeftButton(name: "Выход")
            }
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
            keyboardView.isEnabled = isEnableKeyboard
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
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage.defaultUser
        image.layer.cornerRadius = 36
        image.frame.size = CGSize(width: 72, height: 72)
        return image
    }()
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .ph3
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
        label.textAlignment = .center
        return label
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
        switch rightButtonItem {
        case .delete:
            keyboardView.setRightButton(image: UIImage.backspace)
        case .nothing:
            keyboardView.setRightButton(image: nil)
        case .touchID:
            keyboardView.setRightButton(image: UIImage.touchid)
        case .faceID:
            keyboardView.setRightButton(image: UIImage.faceid)
        }
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
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.widthAnchor.constraint(equalTo: backgroundImage.heightAnchor, multiplier: 375 / 228)
        ])
    }
    
    private func setupKeyboardView() {
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(keyboardView)
        
        NSLayoutConstraint.activate([
            keyboardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -51)
        ])
    }
    
    private func setupShadowView() {
        keyboardView.layer.shadowColor = UIColor.black.cgColor
        keyboardView.layer.shadowOpacity = 0.2
        keyboardView.layer.shadowPath = UIBezierPath(rect: keyboardView.bounds).cgPath
        keyboardView.layer.shadowRadius = 10
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    private func setupImageLabel() {
        stackView.addArrangedSubview(imageView)
        stackView.setCustomSpacing(15.0, after: imageView)
    }
    
    private func setupTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(25.0, after: titleLabel)
    }
    
    private func setupIndicatorView() {
        stackView.addArrangedSubview(indicatorView)
        stackView.setCustomSpacing(15.0, after: imageView)
    }
    
    private func setupErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16)
        ])
    }
    
}
