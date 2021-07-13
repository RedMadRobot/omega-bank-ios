//
//  OfficesService.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 30.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import OmegaBankAPI

/// Сервис загрузки офисов для карт
protocol OfficesService {
    
    /// Обработчик ответа на загрузку списка офисов
    typealias OfficesHandler = ResultHandler<[Office]>
    
    /// Загрузка списка партнеров
    func load(completion: @escaping OfficesHandler) -> Progress
}

final class OfficesServiceImpl: APIService, OfficesService {
    
    func load(completion: @escaping OfficesHandler) -> Progress {
        apiClient.request(OfficesEndpoint(), completionHandler: completion)
    }
}
