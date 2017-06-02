//
//  CallManager.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 29..
//  Copyright © 2017년 evan. All rights reserved.
//

import Foundation
import CallKit

final class CallManager: NSObject {
    private(set) var calls = [JNCall]()
    let callController = CXCallController()
    
    var callsChangedHandler: (() -> Void)?
    
    // MARK: Actions
    func startCall(handle: String, video: Bool = false) {
        NSLog("CallManager:startCall")
        
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: UUID(), handle: handle)
        
        startCallAction.isVideo = video
        
        let transaction = CXTransaction(action:startCallAction)
        
        requestTransaction(transaction)
    }
    
    func end(call: JNCall) {
        NSLog("CallManager:end")
        
        let endCallAction = CXEndCallAction(call: call.uuid)
        let transaction = CXTransaction(action:endCallAction)
        
        requestTransaction(transaction)
    }
    
    func setHeld(call: JNCall, onHold: Bool) {
        NSLog("CallManager:setHeld")
        
        let setHeldCallAction = CXSetHeldCallAction(call: call.uuid, onHold: onHold)
        let transaction = CXTransaction(action:setHeldCallAction)
        
        requestTransaction(transaction)
    }
    
    private func requestTransaction(_ transaction: CXTransaction) {
        NSLog("CallManager:requestTransaction")
        
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
    
    // MARK: Call Management
    func callWithUUID(uuid: UUID) -> JNCall? {
        NSLog("CallManager:callWithUUID")

        guard let index = calls.index(where: { $0.uuid == uuid }) else {
            return nil
        }
        return calls[index]
    }
    
    func addCall(_ call: JNCall) {
        NSLog("CallManager:addCall")
        
        calls.append(call)
        
        call.stateDidChange = { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.callsChangedHandler?()
        }
        
        callsChangedHandler?()
    }
    
    func removeCall(_ call: JNCall) {
        NSLog("CallManager:removeCall")
        
        guard let index = calls.index(where: { $0 === call }) else { return }
        calls.remove(at: index)
        callsChangedHandler?()
    }
    
    func removeAllCalls() {
        NSLog("CallManager:removeAllCalls")
        
        calls.removeAll()
        callsChangedHandler?()
    }
}
