//
//  PartnetListService.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 11.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI

/// Сервис загрузки списка партнеров
protocol PartnerListService {

    /// Обработчик ответа на загрузку списка партнеров
    typealias PartnerListHandler = ResultHandler<[Partner]>

    /// Загрузка списка партнеров
    func load(completion: @escaping PartnerListHandler) -> Progress
}

final class PartnerListServiceImplementation: APIService, PartnerListService {

    func load(completion: @escaping PartnerListHandler) -> Progress {
        apiClient.request(PartnersEndpoint(), completionHandler: completion)
    }
}
