//
//  MockSavingsService.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 5/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
@testable import OmegaBank
import struct OmegaBankAPI.Card
import struct OmegaBankAPI.Deposit

final class MockCardListService: CardListService, SavingMock {

    private(set) var cardListHandler: CardListHandler?
    private(set) var cardHandler: CardHandler?
    private(set) var typesHandler: CardTypesHandler?
    
    private(set) var card: Card?
    
    let progress = Progress()
    
    // MARK: - SavingListService

    func load(completion: @escaping CardListHandler) -> Progress {
        cardListHandler = completion
        return progress
    }
    
    func applyNewCard(with type: String, completion: @escaping CardHandler) -> Progress {
        card = makeCard()
        cardHandler = completion
        
        return progress
    }
    
    func loadTypes(completion: @escaping CardTypesHandler) -> Progress {
        typesHandler = completion
        return progress
    }

}
