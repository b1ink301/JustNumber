//
//  ProviderDelegate.swift
//  JustNumber
//
//  Created by evan on 2017. 5. 23..
//  Copyright © 2017년 evan. All rights reserved.
//

import CallKit

class ProviderDelegate: NSObject {
    // 1.
    fileprivate let callManager: CallManager
    fileprivate let provider: CXProvider
    
    init(callManager: CallManager) {
        NSLog("ProviderDelegate:init:callManager")
        
        self.callManager = callManager
        // 2.
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        
        super.init()
        // 3.
        provider.setDelegate(self, queue: nil)
    }
    
    // 4.
    static var providerConfiguration: CXProviderConfiguration {
        NSLog("ProviderDelegate:providerConfiguration")
        
        let localizedName = NSLocalizedString("JustNumber", comment: "justNumber")
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
        
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
//        if let iconMaskImage = UIImage(named: "IconMask") {
//            providerConfiguration.iconTemplateImageData = UIImagePNGRepresentation(iconMaskImage)
//        }
        
//        providerConfiguration.ringtoneSound = "Ringtone.caf"
        
        return providerConfiguration
    }
    
    
    // MARK: Incoming Calls
    /// Use CXProvider to report the incoming call to the system
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil) {
        NSLog("ProviderDelegate:reportIncomingCall")
        
        // Construct a CXCallUpdate describing the incoming call, including the caller.
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        
        // Report the incoming call to the system
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            /*
             Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
             since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
             */
            if error == nil {
                let call = JNCall(uuid: uuid)
                call.handle = handle
                
                self.callManager.addCall(call)
            }
            
            completion?(error as NSError?)
        }
    }
}

extension ProviderDelegate: CXProviderDelegate {
    // MARK: CXProviderDelegate
    func providerDidReset(_ provider: CXProvider) {
        NSLog("ProviderDelegate:providerDidReset")
        
//        stopAudio()
        
        /*
         End any ongoing calls if the provider resets, and remove them from the app's list of calls,
         since they are no longer valid.
         */
        for call in callManager.calls {
            call.endCall()
        }
        
        // Remove all calls from the app's list of calls.
        callManager.removeAllCalls()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        NSLog("ProviderDelegate:provider")
        
        // Create & configure an instance of SpeakerboxCall, the app's model class representing the new outgoing call.
        let call = JNCall(uuid: action.callUUID, isOutgoing: true)
        call.handle = action.handle.value
        
        /*
         Configure the audio session, but do not start call audio here, since it must be done once
         the audio session has been activated by the system after having its priority elevated.
         */
//        configureAudioSession()
        
        /*
         Set callback blocks for significant events in the call's lifecycle, so that the CXProvider may be updated
         to reflect the updated state.
         */
        call.hasStartedConnectingDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: call.connectingDate)
        }
        call.hasConnectedDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, connectedAt: call.connectDate)
        }
        
        // Trigger the call to be started via the underlying network service.
        call.startCall { success in
            if success {
                // Signal to the system that the action has been successfully performed.
                action.fulfill()
                
                // Add the new outgoing call to the app's list of calls.
                self.callManager.addCall(call)
            } else {
                // Signal to the system that the action was unable to be performed.
                action.fail()
            }
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        /*
         Configure the audio session, but do not start call audio here, since it must be done once
         the audio session has been activated by the system after having its priority elevated.
         */
//        configureAudioSession()
        
        // Trigger the call to be answered via the underlying network service.
        call.answerCall()
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        // Stop call audio whenever ending the call.
//        stopAudio()
        
        // Trigger the call to be ended via the underlying network service.
        call.endCall()
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
        
        // Remove the ended call from the app's list of calls.
        callManager.removeCall(call)
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        // Update the SpeakerboxCall's underlying hold state.
        call.isOnHold = action.isOnHold
        
        // Stop or start audio in response to holding or unholding the call.
//        if call.isOnHold {
//            stopAudio()
//        } else {
//            startAudio()
//        }
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("Timed out \(#function)")
        
        // React to the action timeout if necessary, such as showing an error UI.
    }
    
//    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
//        print("Received \(#function)")
//        
//        // Start call audio media, now that the audio session has been activated after having its priority boosted.
////        startAudio()
//    }
//    
//    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
//        print("Received \(#function)")
//        
//        /*
//         Restart any non-call related audio now that the app's audio session has been
//         de-activated after having its priority restored to normal.
//         */
//    }
}
