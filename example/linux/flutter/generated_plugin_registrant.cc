//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bigbluebuttonsdk/bigbluebuttonsdk_plugin.h>
#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>
#include <screen_capturer_linux/screen_capturer_linux_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) bigbluebuttonsdk_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BigbluebuttonsdkPlugin");
  bigbluebuttonsdk_plugin_register_with_registrar(bigbluebuttonsdk_registrar);
  g_autoptr(FlPluginRegistrar) flutter_webrtc_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterWebRTCPlugin");
  flutter_web_r_t_c_plugin_register_with_registrar(flutter_webrtc_registrar);
  g_autoptr(FlPluginRegistrar) screen_capturer_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ScreenCapturerLinuxPlugin");
  screen_capturer_linux_plugin_register_with_registrar(screen_capturer_linux_registrar);
}
