import Flutter
import UIKit
import AVFoundation

public class BigbluebuttonsdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bigbluebuttonsdk", binaryMessenger: registrar.messenger())
    let instance = BigbluebuttonsdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//     switch call.method {
//     case "getPlatformVersion":
//       result("iOS " + UIDevice.current.systemVersion)
//     default:
//       result(FlutterMethodNotImplemented)
//     }
    let session = AVAudioSession.sharedInstance()
          do {
            switch call.method {
            case "getPlatformVersion":
              result("iOS " + UIDevice.current.systemVersion)
            case "earpiece":
              try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
              try session.overrideOutputAudioPort(.none)
            case "speaker":
              try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
              try session.overrideOutputAudioPort(.speaker)
            case "bluetooth":
              try session.setCategory(.playAndRecord, mode: .voiceChat, options: [.allowBluetooth])
              try session.setActive(true)
            case "headset":
              try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
              try session.overrideOutputAudioPort(.none)
            default:
              result(FlutterMethodNotImplemented)
              return
            }
            result(nil)
          } catch {
            result(FlutterError(code: "AUDIO_ERROR", message: error.localizedDescription, details: nil))
          }
  }
}
