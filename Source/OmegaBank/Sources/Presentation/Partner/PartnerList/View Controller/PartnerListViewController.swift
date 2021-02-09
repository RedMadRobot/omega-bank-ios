//
//  MainViewController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 03.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Partner

final class PartnerListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Private Properties
    
    private var partners: [Partner]

    // MARK: - Initializers
    
    init(partners: [Partner]) {
        self.partners = partners
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PartnerListViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        let layout = AnimatedCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.animator = CardAttributesAnimator(minAlpha: 0.5, itemSpacing: 0.4, scaleRate: 0.8)
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0

        collectionView.collectionViewLayout = layout
        collectionView.accessibilityIdentifier = "collection view"
    }

    // MARK: - Private Methods

    private func setupCollectionView() {
        collectionView.registerCellNib(PartnerCell.self)
    }
}

extension PartnerListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        partners.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(PartnerCell.self, for: indexPath)
        cell.setup(with: partners[indexPath.row], for: indexPath.row)
        
        return cell
    }
}

extension PartnerListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let partner = partners[indexPath.row]
        let vc = PartnterDetailedViewController(partner: partner)
        
        let titledVC = TitledPageViewController(
            title: partner.name,
            embeddedViewController: vc,
            hasDismissedButton: true)
        
        let nc = NavigationController(rootViewController: titledVC)
        navigationController?.present(nc, animated: true)
    }
}

extension PartnerListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        collectionView.frame.size
    }
    
}
