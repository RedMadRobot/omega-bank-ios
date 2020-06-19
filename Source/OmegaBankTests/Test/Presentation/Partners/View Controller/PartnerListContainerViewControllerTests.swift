//
//  PartnerListContainerViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 4/3/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import XCTest
import struct OmegaBankAPI.Partner

final class PartnerListContainerViewControllerTests: ViewControllerTestCase, PartnerMock {
    
    private var partnerListService: MockPartnerListService!
    private var containerController: PartnerListContainerViewController!
    private var viewController: PartnerListViewController? {
        containerController.children.first as? PartnerListViewController
    }
    
    override func setUp() {
        super.setUp()

        partnerListService = MockPartnerListService()
        containerController = PartnerListContainerViewController(partnerListService: partnerListService)
        rootViewController = containerController
    }
    
    private var partners: [Partner] {
        [
            makePartner(),
            makePartner(),
            makePartner()
        ]
    }

    func testSuccessLoadPartnerList() throws {
        XCTAssertNotNil(partnerListService.partnerListHandler?(.success(partners)))

        try checkCountOfCells(count: 3)
    }
    
    // MARK: - Private
    
    private func checkCountOfCells(
        count: Int,
        file: StaticString = #file,
        line: UInt = #line) throws {
        
        let partnerListVC = try XCTUnwrap(viewController, "Partner List was not found")
        
        guard
            let collectionView = partnerListVC.view.assertSubview(UICollectionView.self, by: "collection view"),
            let dataSource = collectionView.dataSource
        else {
            XCTFail("DataSource не настроен.")
            return
        }
        
        let result = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, result)
    }
}
