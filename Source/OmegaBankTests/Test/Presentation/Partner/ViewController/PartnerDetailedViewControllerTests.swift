//
//  PartnerDetailedViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 4/6/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import XCTest
import struct OmegaBankAPI.Partner

final class PartnerDetailedViewControllerTests: ViewControllerTestCase, PartnerMock {

    private var viewController: PartnterDetailedViewController!
    private var partner: Partner!
    
    override func setUp() {
        super.setUp()

        let currency = makeCurrency()
        
        let limits = [
            makeLimit(currency: currency),
            makeLimit(currency: currency),
            makeLimit(currency: currency)
        ]
        
        let dailyLimits = [
            makeDailylimit(currency: currency),
            makeDailylimit(currency: currency),
            makeDailylimit(currency: currency),
            makeDailylimit(currency: currency),
            makeDailylimit(currency: currency)
        ]
        
        partner = makePartner(limits: limits, dailyLimits: dailyLimits)
        viewController = PartnterDetailedViewController(partner: partner)
        rootViewController = viewController
    }
    
    func testCheckLimitsCount() {
        checkCountOfCells(count: 3, accessibilityIdentifier: "limits")
    }
    
    func testCheckDailyLimitsCount() {
        checkCountOfCells(count: 5, accessibilityIdentifier: "dailyLimits")
    }
    
    // MARK: - Private
    
    private func checkCountOfCells(
        count: Int,
        accessibilityIdentifier: String,
        file: StaticString = #file,
        line: UInt = #line) {
        
        guard
            let collectionView = viewController.view.assertSubview(UICollectionView.self, by: accessibilityIdentifier),
            let dataSource = collectionView.dataSource
        else {
            XCTFail("DataSource не настроен.")
            return
        }
        
        let result = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, result)
    }
}
