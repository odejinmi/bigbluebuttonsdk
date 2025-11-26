//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bigbluebuttonsdk/bigbluebuttonsdk_plugin_c_api.h>
#include <flutter_sound/flutter_sound_plugin_c_api.h>
#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <record_windows/record_windows_plugin_c_api.h>
#include <screen_capturer_windows/screen_capturer_windows_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BigbluebuttonsdkPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BigbluebuttonsdkPluginCApi"));
  FlutterSoundPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterSoundPluginCApi"));
  FlutterWebRTCPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWebRTCPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  RecordWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RecordWindowsPluginCApi"));
  ScreenCapturerWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenCapturerWindowsPluginCApi"));
}
