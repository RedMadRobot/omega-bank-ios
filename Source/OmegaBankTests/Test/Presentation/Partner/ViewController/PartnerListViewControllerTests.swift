//
//  PartnerListViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 4/3/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import XCTest
import struct OmegaBankAPI.Partner

final class PartnerListViewControllerTests: ViewControllerTestCase, PartnerMock {
    
    private var partnerListService: MockPartnerListService!
    private var viewController: PartnerListViewController!
    
    override func setUp() {
        super.setUp()

        partnerListService = MockPartnerListService()
        viewController = PartnerListViewController(partnerListService: partnerListService)
        rootViewController = viewController
    }
    
    private var partners: [Partner] {
        [
            makePartner(),
            makePartner(),
            makePartner()
        ]
    }

    func testSuccessLoadPartnerList() {
        XCTAssertNotNil(partnerListService.partnerListHandler?(.success(partners)))

        checkCountOfCells(count: 3)
    }
    
    func testLoadEmptyPartnerList() {
        XCTAssertNotNil(partnerListService.partnerListHandler?(.success([])))

        checkCountOfCells(count: 0)
        
        guard let alert = viewController.presentedViewController as? UIAlertController else {
            return XCTFail("Нет алрета, \(String(describing: viewController.presentedViewController))")
        }
        
        XCTAssertEqual(alert.preferredStyle, .alert)
    }
    
    func testLoadPartnerListWithError() {
        let error = URLError(.notConnectedToInternet)
        XCTAssertNotNil(partnerListService.partnerListHandler?(.failure(error)))
        
        checkCountOfCells(count: 0)
        
        guard let alert = viewController.presentedViewController as? UIAlertController else {
            return XCTFail("Нет алерта, \(String(describing: viewController.presentedViewController))")
        }
        
        XCTAssertEqual(alert.preferredStyle, .alert)
    }
    
    // MARK: - Private
    
    private func checkCountOfCells(
        count: Int,
        file: StaticString = #file,
        line: UInt = #line) {
        
        guard
            let collectionView = viewController.view.assertSubview(UICollectionView.self, by: "collection view"),
            let dataSource = collectionView.dataSource
        else {
            XCTFail("DataSource не настроен.")
            return
        }
        
        let result = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, result)
    }
}
