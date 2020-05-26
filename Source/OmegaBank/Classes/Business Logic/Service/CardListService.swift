//
//  ProductListService.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
import OmegaBankAPI

protocol CardListService {
    
    /// Обработчик ответа на загрузку списка карт
    typealias CardListHandler = ResultHandler<[Card]>
    
    /// Обработчик ответа на регистрацию карты
    typealias CardHandler = ResultHandler<Card>
    
    /// Обработчик ответа на загрузку типов карт
    // TODO: После мерджа убрать приставку "OmegaBankAPI"
    typealias CardTypesHandler = ResultHandler<[OmegaBankAPI.CardInfo]>

    /// Загрузка списка карт
    @discardableResult
    func load(completion: @escaping CardListHandler) -> Progress
    
    /// Регистрация новой карты
    @discardableResult
    func apply(
        with type: String,
        completion: @escaping CardHandler) -> Progress
    
    /// Получение всех типов карт
    @discardableResult
    func loadTypes(completion: @escaping CardTypesHandler) -> Progress
 
}

final class CardListServiceImpl: APIService, CardListService {
    
    @discardableResult
    func load(completion: @escaping CardListHandler) -> Progress {
        apiClient.request(CardsEndpoint(), completionHandler: completion)
    }
    
    @discardableResult
    func apply(
        with type: String,
        completion: @escaping CardHandler) -> Progress {
        apiClient.request(ApplyCardEndpoint(type: type), completionHandler: completion)
    }

    @discardableResult
    func loadTypes(completion: @escaping CardTypesHandler) -> Progress {
        apiClient.request(CardTypesEndpoint(), completionHandler: completion)
    }

}
