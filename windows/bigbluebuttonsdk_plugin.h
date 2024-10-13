#ifndef FLUTTER_PLUGIN_BIGBLUEBUTTONSDK_PLUGIN_H_
#define FLUTTER_PLUGIN_BIGBLUEBUTTONSDK_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace bigbluebuttonsdk {

class BigbluebuttonsdkPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  BigbluebuttonsdkPlugin();

  virtual ~BigbluebuttonsdkPlugin();

  // Disallow copy and assign.
  BigbluebuttonsdkPlugin(const BigbluebuttonsdkPlugin&) = delete;
  BigbluebuttonsdkPlugin& operator=(const BigbluebuttonsdkPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace bigbluebuttonsdk

#endif  // FLUTTER_PLUGIN_BIGBLUEBUTTONSDK_PLUGIN_H_
