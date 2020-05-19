//
//  ProductListService.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
import OmegaBankAPI

protocol DepositListService {
    
    /// Обработчик ответа на загрузку списка счетов
    typealias DepositListHandler = ResultHandler<[Deposit]>
    
    /// Обработчик ответа на регистрацию счета
    typealias DepositHandler = ResultHandler<Deposit>
    
    /// Обработчик ответа на загрузку типов карт / счетов
    typealias TypesHandler = ResultHandler<[String]>
    
    /// Загрузка списка счетов
    @discardableResult
    func load(completion: @escaping DepositListHandler) -> Progress
    
    /// Регистрация нового счета
    @discardableResult
    func apply(
        with type: String,
        completion: @escaping DepositHandler) -> Progress
    
    /// Получение всех типов счетов
    @discardableResult
    func loadTypes(completion: @escaping TypesHandler) -> Progress
 
}

final class DepositListImpl: APIService, DepositListService {
    
    @discardableResult
    func load(completion: @escaping DepositListHandler) -> Progress {
        apiClient.request(DepositsEndpoint(), completionHandler: completion)
    }

    @discardableResult
    func apply(
        with type: String,
        completion: @escaping DepositHandler) -> Progress {

        apiClient.request(ApplyDepositEndpoint(type: type), completionHandler: completion)
    }
    
    @discardableResult
    func loadTypes(completion: @escaping TypesHandler) -> Progress {
        apiClient.request(DepositTypesEndpoint(), completionHandler: completion)
    }

}
