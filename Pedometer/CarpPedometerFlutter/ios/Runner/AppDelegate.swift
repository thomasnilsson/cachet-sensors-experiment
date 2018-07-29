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
    
    private var stepCount = 0;
    
    // ---------------------------------------------------------------------------------------------------
    // Boilerplate setup
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // Method channel
        let methodChannel = FlutterMethodChannel.init(name: "samples.flutter.io/methodChannel", binaryMessenger: controller)
        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if ("getStepCount" == call.method) {
                self.receiveBatteryLevel(result: result)
            }
            else {
                result(FlutterMethodNotImplemented)
            }
        })
        
//         Set flutter communication channel for emitting charging events
        let eventChannel = FlutterEventChannel.init(name: "samples.flutter.io/eventChannel", binaryMessenger: controller)
        eventChannel.setStreamHandler(self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date)
        
        // Collects one datapoint, then stops listening.
        pedometer.startUpdates(from: todayAtMidnight) { (pedometerData, error) in
            if let data = pedometerData {
                
                // Dispatch method to main thread with an async call
                DispatchQueue.main.async {
                    self.stepCount = Int(data.numberOfSteps)
                    self.pedometer.stopUpdates()
                }
            }
        }
        
        result(stepCount)
    }
    
    
    
    // Code below not used currently
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {

        self.eventSink = eventSink

        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date)

        pedometer.startUpdates(from: todayAtMidnight) { (pedometerData, error) in
            if let data = pedometerData {

                // Dispatch method to main thread with an async call
                DispatchQueue.main.async {
                    self.stepCount = Int(data.numberOfSteps)
                    self.sendStepCountEvent(stepCount: "\(self.stepCount)")
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
