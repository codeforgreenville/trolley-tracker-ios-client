//
//  GetETAOperation.swift
//  
//
//  Created by Austin Younts on 8/23/15.
//
//

import Foundation

class ConcurrentOperation: Operation {

    override var isAsynchronous: Bool {
        return true
    }

    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        let keys = ["isReady", "isExecuting", "isFinished", "isCancelled"]
        if keys.contains(key) {
            return ["state"]
        }
        return []
    }
    
    private enum State: Int {
        /// The initial state of an `Operation`.
        case initialized
        
        /// The `Operation` is executing.
        case executing
        
        /// The `Operation` has finished executing.
        case finished
        
        /// The `Operation` has been cancelled.
        case cancelled
    }
    
    private var _state = State.initialized
    
    private var state: State {
        get {
            return _state
        }
        
        set(newState) {
            // Manually fire the KVO notifications for state change, since this is "private".
            
            willChangeValue(forKey: "state")
            
            switch (_state, newState) {
            case (.finished, _):
                break // cannot leave the finished state
            default:
                _state = newState
            }
            
            didChangeValue(forKey: "state")
        }
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isCancelled: Bool {
        return state == .cancelled
    }
    
    override final func start() {
        
        if !(state == .cancelled) {
            state = .executing
        }
        
        execute()
    }
    
    func execute() {
        print("\(type(of: self)) must override `execute()`.", terminator: "")
        
        finish()
    }
    
    override func cancel() {
        state = .cancelled
    }
    
    final func finish() {
        state = .finished
    }
}
