//
//  MockDepositListService.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 5/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
@testable import OmegaBank
import struct OmegaBankAPI.Card
import struct OmegaBankAPI.Deposit

final class MockDepositListService: DepositListService, SavingMock {

    private(set) var depositListHandler: DepositListHandler?
    private(set) var depositHandler: DepositHandler?
    private(set) var typesHandler: DepositTypesHandler?
    
    private(set) var deposit: Deposit?
    
    let progress = Progress()
    
    // MARK: - SavingListService
    
    func load(completion: @escaping DepositListHandler) -> Progress {
        depositListHandler = completion
        return progress
    }
    
    func apply(with type: String, completion: @escaping DepositHandler) -> Progress {
        deposit = makeDeposit()
        depositHandler = completion
        
        return progress
    }
    
    func loadTypes(completion: @escaping DepositTypesHandler) -> Progress {
        typesHandler = completion
        return progress
    }

}
