//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bigbluebuttonsdk/bigbluebuttonsdk_plugin_c_api.h>
#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BigbluebuttonsdkPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BigbluebuttonsdkPluginCApi"));
  FlutterWebRTCPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWebRTCPlugin"));
}
