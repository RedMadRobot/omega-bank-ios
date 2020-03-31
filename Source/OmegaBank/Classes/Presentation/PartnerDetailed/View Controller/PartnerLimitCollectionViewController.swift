//
//  PartnerLimitCollectionViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/30/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class PartnerLimitCollectionViewController: UICollectionViewController {
    
    // MARK: - Constants
    
    private enum Size {
        static let cellSpace: CGFloat = 15
        static let collectionViewInset = UIEdgeInsets(top: 0, left: Size.cellSpace, bottom: 0, right: Size.cellSpace)
    }
    
    // MARK: - Private Properties
    
    private let viewModels: [PartnerDescriptionViewModel]
    
    // MARK: - Initialization
    
    init(viewModels: [PartnerDescriptionViewModel]) {
        self.viewModels = viewModels
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = Size.collectionViewInset
        layout.scrollDirection = .horizontal
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerCellNib(PartnerLimitCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(PartnerLimitCell.self, for: indexPath)
        let viewModel = viewModels[indexPath.row]
        
        cell.setup(with: viewModel, for: indexPath.row)
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        viewModels.count
    }
}

extension PartnerLimitCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = collectionView.frame.size.height - Size.cellSpace * 2
        
        return CGSize(width: side * 2, height: side)
    }
}
