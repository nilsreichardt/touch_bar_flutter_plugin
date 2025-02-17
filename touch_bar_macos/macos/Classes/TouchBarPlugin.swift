// Copyright (c) 2020 Eduardo Vital Alencar Cunha
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import FlutterMacOS
import Foundation
import AppKit

public class TouchBarPlugin: FlutterViewController, FlutterPlugin {
  static var channel: FlutterMethodChannel!
  @available(OSX 10.12.2, *)
  static var touchBars: [TouchBar] = []

  public static func register(with registrar: FlutterPluginRegistrar) {
    self.channel = FlutterMethodChannel(
      name: "plugins.flutter.io/touch_bar",
      binaryMessenger: registrar.messenger,
      codec: FlutterStandardMethodCodec(
        readerWriter: TouchBarPluginReaderWritter()
      )
    )

    let instance = TouchBarPlugin()

    if #available(macOS 10.12.2, *) {
      NotificationCenter.default.addObserver(instance, selector: #selector(bindTouchBar), name: NSApplication.didBecomeActiveNotification, object: nil)
    }

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(macOS 10.12.2, *) else {
      // The plugin will not be used in macOS version below 10.12.2.
      return
    }

    switch call.method {
    case "setTouchBar":
      guard let touchBarJson = (call.arguments as? NSDictionary)?["touch_bar"] as? NSDictionary,
        let children = touchBarJson["children"] as? NSArray else {
        return result("FlutterUnexpectedArguments")
      }
      Self.touchBars = []
      self.touchBar = TouchBar(items: children)
      bindTouchBar()
    case "setTouchBarItem":
      guard let data = call.arguments as? NSDictionary,
        let id = data["id"] as? Int,
        let type = data["type"] as? String else {
          return result("FlutterUnexpectedArguments")
      }

      for touchBar in Self.touchBars {
        touchBar.setTouchBarItem(ofId: id, andType: type, withData: data)
      }
    default:
      result("FlutterMethodNotImplemented")
    }
  }

  @available(OSX 10.12.2, *)
  @objc func bindTouchBar() {
    NSApp.mainWindow?.bind(NSBindingName(#keyPath(touchBar)), to: self, withKeyPath: #keyPath(touchBar), options: nil)
  }
}
