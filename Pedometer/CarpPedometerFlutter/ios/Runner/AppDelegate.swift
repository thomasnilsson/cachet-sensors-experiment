// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import UIKit
import Flutter

import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    var pedometer = CMPedometer()
    
    // ---------------------------------------------------------------------------------------------------
    // Boilerplate setup
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // Set flutter communication channel for emitting charging events
        let chargingChannel = FlutterEventChannel.init(name: "samples.flutter.io/charging", binaryMessenger: controller)
        chargingChannel.setStreamHandler(self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        
        self.eventSink = eventSink
        
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date)
        
        pedometer.startUpdates(from: todayAtMidnight) { (pedometerData, error) in
            if let data = pedometerData {
                
                // Dispatch method to main thread with an async call
                DispatchQueue.main.async {
                    self.sendStepCountEvent(stepCount: "\(data.numberOfSteps)")
                }
            }
        }
        
        return nil
    }
    
    private func sendStepCountEvent(stepCount: String) {
        // If no eventSink to emit events to, do nothing (wait)
        if (eventSink == nil) {
            return
        }
        // Emit step count event to Flutter
        eventSink!(stepCount)
    }
    
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
}
