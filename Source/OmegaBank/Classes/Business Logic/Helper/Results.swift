//
//  Results.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 19.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

/// Результат асинхронного выполнения.
typealias Result<Value> = Swift.Result<Value, Swift.Error>

/// Обработчик результата.
typealias ResultHandler<Value> = (Result<Value>) -> Void
