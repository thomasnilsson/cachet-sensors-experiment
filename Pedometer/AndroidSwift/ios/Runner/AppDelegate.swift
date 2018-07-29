// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    // ---------------------------------------------------------------------------------------------------
    // Boilerplate ahead!
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel.init(name: "samples.flutter.io/battery", binaryMessenger: controller)
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if ("getBatteryLevel" == call.method) {
                self.receiveBatteryLevel(result: result)
            }
            else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        // Set flutter communication channel for emitting charging events
        let chargingChannel = FlutterEventChannel.init(name: "samples.flutter.io/charging", binaryMessenger: controller)
        chargingChannel.setStreamHandler(self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // ---------------------------------------------------------------------------------------------------
    // Actual functions
    private func receiveBatteryLevel(result: FlutterResult) {
        // Get current battery level from UIDevice (from UI Kit)
        let device = UIDevice.current
        
        // Set monitoring flag - for privacy reasons I assume
        device.isBatteryMonitoringEnabled = true
        
        // Check if no battery status available - ex when running on simulator
        if (device.batteryState == UIDeviceBatteryState.unknown) {
            result(FlutterError.init(code: "UNAVAILABLE",
                                     message: "Battery info unavailable",
                                     details: nil))
        }
            // Otherwise set result to 100x battery level (percent)
        else {
            result(Int(device.batteryLevel * 100))
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        
        // I dont know why this is necessary
        self.eventSink = eventSink
        
        // This should alreayd have been set... not sure why this is needed
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // Emit battery level
        self.sendBatteryStateEvent()
        
        // Listen for battery level changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onBatteryStateDidChange),
            name: NSNotification.Name.UIDeviceBatteryStateDidChange,
            object: nil)
        
        // Listen for battery level changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onBatteryLevelDidChange),
            name: NSNotification.Name.UIDeviceBatteryLevelDidChange,
            object: nil)
        return nil
    }
    
    @objc private func onBatteryStateDidChange(notification: NSNotification) {
        // Whenever battery level changes, emit an event to Flutter
        self.sendBatteryStateEvent()
    }
    
    @objc private func onBatteryLevelDidChange(notification: NSNotification) {
        // Whenever battery level changes, emit an event to Flutter
        self.sendBatteryStateEvent()
    }
    
    private func sendBatteryLevelEvent() {
        // If no eventSink to emit events to, do nothing (wait)
        if (eventSink == nil) {
            return
        }
        
        // Get current battery level from UIDevice (from UI Kit)
        let device = UIDevice.current
        
        // Set monitoring flag - for privacy reasons I assume
        device.isBatteryMonitoringEnabled = true
        
        // Check if no battery status available - ex when running on simulator
        if (device.batteryState == UIDeviceBatteryState.unknown) {
            eventSink!(FlutterError.init(code: "UNAVAILABLE",
                                         message: "Battery level info unavailable",
                                         details: nil))
        }
            // Otherwise set result to 100x battery level (percent)
        else {
            let levelPercent = Int(device.batteryLevel * 100)
            eventSink!("\(levelPercent)")
        }
        
    }
    
    private func sendBatteryStateEvent() {
        // If no eventSink to emit events to, do nothing (wait)
        if (eventSink == nil) {
            return
        }
        // Battery state, ex unknown if simulator
        let state = UIDevice.current.batteryState
        
        // Check what the state is
        switch state {
        case UIDeviceBatteryState.full:
            eventSink!("charging (full)")
            break
        case UIDeviceBatteryState.charging:
            eventSink!("charging")
            break
        case UIDeviceBatteryState.unplugged:
            eventSink!("discharging")
            break
        default:
            eventSink!(FlutterError.init(code: "UNAVAILABLE",
                                         message: "Charging status unavailable",
                                         details: nil))
            break
        }
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
}
