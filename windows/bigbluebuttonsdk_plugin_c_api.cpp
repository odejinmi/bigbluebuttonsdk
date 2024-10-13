#include "include/bigbluebuttonsdk/bigbluebuttonsdk_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "bigbluebuttonsdk_plugin.h"

void BigbluebuttonsdkPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  bigbluebuttonsdk::BigbluebuttonsdkPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
