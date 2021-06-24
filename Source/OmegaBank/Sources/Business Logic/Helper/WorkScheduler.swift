//
//  WorkScheduler.swift
//
//  Created by Alexander Ignatev on 20.09.2018.
//  Copyright © 2018 Redmadrobot OOO. All rights reserved.
//

import Foundation

/// Маркер работы для отмены.
final class WorkToken {
    private let cancelationHandler: VoidClosure
    
    private let logoutScheduler: WorkScheduler = DispatсhWorkScheduler()
    
    init(_ cancelationHandler: @escaping VoidClosure) {
        self.cancelationHandler = cancelationHandler
    }
    
    func cancel() {
        cancelationHandler()
    }
}

/// Планировщик одной отложенной работы.
protocol WorkScheduler: AnyObject {
    
    /// Выполнить асинхронно через заданный интервал времени работу.
    ///
    /// - Note: Всегда выполняет только одну задачу. Если пришла вторая, то отменяет первую.
    /// - Parameters:
    ///   - interval: Интервал времени через, который нужно выполнить замыкание.
    ///   - work: Замыкание которое нужно отложено выполнить.
    func async(after interval: TimeInterval, execute work: @escaping VoidClosure)
    
    /// Отменить все запланированные работы.
    func cancel()
}

/// Очередь выполняющая задачи с задержкой.
protocol DelayQueue: AnyObject {
    
    /// Выполнить замыкание после указанного времени.
    func asyncAfter(deadline: DispatchTime, execute: DispatchWorkItem)
}

extension DispatchQueue: DelayQueue {}

final class DispatсhWorkScheduler: WorkScheduler {
    private let queue: DelayQueue
    private var currentWorkItem: DispatchWorkItem?
    
    init(queue: DelayQueue = DispatchQueue.main) {
        self.queue = queue
    }
    
    deinit {
        cancel()
    }
    
    // MARK: - OneWorkScheduler
    
    /// Выполнить асинхронно через заданный интервал времени работу.
    ///
    /// - Note: Всегда выполняет только одну задачу. Если пришла вторая, то отменяет первую.
    /// - Parameters:
    ///   - interval: Интервал времени через, который нужно выполнить замыкание.
    ///   - work: Замыкание, которое нужно отложено выполнить.
    func async(after interval: TimeInterval, execute work: @escaping VoidClosure) {
        assert(interval > 0, "interval must be greater than zero")
        dispatchPrecondition(condition: .onQueue(.main))
        
        cancel()
        
        let workItem = DispatchWorkItem(block: work)
        queue.asyncAfter(deadline: .now() + interval, execute: workItem)
        currentWorkItem = workItem
    }

    /// Отменить все запланированные работы.
    func cancel() {
        currentWorkItem?.cancel()
        currentWorkItem = nil
    }
}
