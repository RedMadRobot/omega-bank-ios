//
//  MainViewController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 03.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Partner

extension PartnerListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        partners.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(PartnterCell.self, for: indexPath)
        cell.setup(with: partners[indexPath.row], for: indexPath.row)
        
        return cell
    }
}

extension PartnerListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let partner = partners[indexPath.row]
        let vc = PartnterDetailedViewController(partner: partner)
        let nc = NavigationController(rootViewController: vc)
        navigationController?.present(nc, animated: true, completion: nil)
    }
}

extension PartnerListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        collectionView.frame.size
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

final class PartnerListViewController: PageViewController, ErrorHandler {

    // MARK: - IBOutlets

    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Private Properties
    
    private var partners: [Partner] = []
    private let partnerListService: PartnerListService
    private var progress: Progress?

    // MARK: - Initializers
    
    static func make(delegate: ProfileViewControllerDelegate?) -> UIViewController {
        let controller = PartnerListViewController()
        controller.delegate = delegate
        let navigationController = NavigationController(rootViewController: controller)

        return navigationController
    }
    
    init(partnerListService: PartnerListService = ServiceLayer.shared.partnerListService) {
        self.partnerListService = partnerListService
    
        super.init(nibName: nil, bundle: nil)
        
        title = "Partners"
        tabBarItem = UITabBarItem(title: "Partners", image: #imageLiteral(resourceName: "customers"), tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        progress?.cancel()
    }
    
    // MARK: - PartnerListViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        let layout = AnimatedCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.animator = CardAttributesAnimator(minAlpha: 0.5, itemSpacing: 0.4, scaleRate: 0.8)

        collectionView.collectionViewLayout = layout
        collectionView.accessibilityIdentifier = "collection view"
        
        loadPartners()
    }

    // MARK: - Private methods
    
    private func loadPartners() {
        progress = partnerListService.load { [weak self] result in
            self?.loadDidFinish(result)
        }
    }

    private func setupCollectionView() {
        collectionView.registerCellNib(PartnterCell.self)
    }

    private func loadDidFinish(_ result: Result<[Partner]>) {
        switch result {
        case .success(let list) where list.isEmpty:
            showError(.emptyPartners)
        case .success(let list):
            showPartner(list)
        case .failure(let error):
            self.showError(.error(error, onAction: { [weak self] in
                self?.loadPartners()
            }))
        }
    }

    private func showPartner(_ list: [Partner]) {
        partners = list
        collectionView.reloadData()
    }
}
