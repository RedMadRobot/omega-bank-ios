//
//  BankPlacesService.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 30.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit
import OmegaBankAPI

/// Сервис загрузки офисов для карт
protocol BankPlacesService {
    
    /// Обработчик ответа на загрузку списка офисов
    typealias AnnotationsHandler = ResultHandler<[[MKAnnotation]]>
    
    /// Загрузка списка партнеров
    func load(completion: @escaping AnnotationsHandler) -> Progress
}

final class OfficesServiceImpl: APIService, BankPlacesService {
    
    func load(completion: @escaping AnnotationsHandler) -> Progress {
        apiClient.request(BankPlacesEndpoint()) { result in
            switch result {
            case .success(let places):
                let officeAnnotations = places.offices.map { $0.annotation }
                let atmAnnotations = places.atms.map { $0.annotation }
                completion(.success([officeAnnotations, atmAnnotations]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
