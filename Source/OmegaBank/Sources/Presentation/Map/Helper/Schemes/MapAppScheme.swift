//
//  MapAppScheme.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 07.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

protocol MapAppScheme {
    
    /// URL для открытия карт
    var url: URL? { get }
        
    /// URL для проверки установленного приложения
    var scheme: String { get }
    
    /// Лейбл кнопки
    var label: String { get }
    
    var annotation: MKAnnotation { get set }
    
}
