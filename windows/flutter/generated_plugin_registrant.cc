//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <desktop_context_menu_windows/desktop_context_menu_windows_plugin.h>
#include <desktop_window/desktop_window_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DesktopContextMenuWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopContextMenuWindowsPlugin"));
  DesktopWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWindowPlugin"));
}
