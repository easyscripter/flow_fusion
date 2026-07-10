#include "app_blocker.h"

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include <windows.h>
#include <tlhelp32.h>

#include <algorithm>
#include <cctype>
#include <memory>
#include <string>
#include <unordered_set>

namespace {

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;

std::string WideToUtf8(const wchar_t* wide) {
  if (wide == nullptr) return std::string();
  int size =
      WideCharToMultiByte(CP_UTF8, 0, wide, -1, nullptr, 0, nullptr, nullptr);
  if (size <= 1) return std::string();
  std::string result(static_cast<size_t>(size - 1), '\0');
  WideCharToMultiByte(CP_UTF8, 0, wide, -1, result.data(), size, nullptr,
                      nullptr);
  return result;
}

std::string ToLowerAscii(std::string value) {
  std::transform(value.begin(), value.end(), value.begin(),
                 [](unsigned char c) {
                   return static_cast<char>(std::tolower(c));
                 });
  return value;
}

// Lower-cased image name of our own executable, so we never close ourselves.
std::string SelfExeName() {
  wchar_t path[MAX_PATH];
  DWORD length = GetModuleFileNameW(nullptr, path, MAX_PATH);
  if (length == 0) return std::string();
  std::wstring wide(path, length);
  size_t slash = wide.find_last_of(L"\\/");
  std::wstring name =
      slash == std::wstring::npos ? wide : wide.substr(slash + 1);
  return ToLowerAscii(WideToUtf8(name.c_str()));
}

// Passed to EnumWindows so the callback knows which process to act on.
struct WindowCloseContext {
  DWORD pid;
};

BOOL CALLBACK CloseWindowsForPid(HWND hwnd, LPARAM lparam) {
  auto* context = reinterpret_cast<WindowCloseContext*>(lparam);
  DWORD window_pid = 0;
  GetWindowThreadProcessId(hwnd, &window_pid);
  if (window_pid == context->pid && IsWindowVisible(hwnd)) {
    // Soft, store-compatible: ask the window to close and get it out of the way.
    ShowWindow(hwnd, SW_MINIMIZE);
    PostMessageW(hwnd, WM_CLOSE, 0, 0);
  }
  return TRUE;
}

// Soft-closes every running process whose image name is in |tokens|.
// Returns the image names actually acted upon (deduplicated).
EncodableList BlockApps(const EncodableList& tokens) {
  std::unordered_set<std::string> wanted;
  for (const EncodableValue& token : tokens) {
    if (const auto* name = std::get_if<std::string>(&token)) {
      if (!name->empty()) wanted.insert(ToLowerAscii(*name));
    }
  }

  EncodableList closed;
  if (wanted.empty()) return closed;

  HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (snapshot == INVALID_HANDLE_VALUE) return closed;

  const std::string self_exe = SelfExeName();
  const DWORD self_pid = GetCurrentProcessId();

  PROCESSENTRY32W entry;
  entry.dwSize = sizeof(entry);
  std::unordered_set<std::string> acted;
  if (Process32FirstW(snapshot, &entry)) {
    do {
      // Never close ourselves, even if our exe somehow ends up in the list.
      if (entry.th32ProcessID == self_pid) continue;
      std::string exe = WideToUtf8(entry.szExeFile);
      std::string exe_lower = ToLowerAscii(exe);
      if (!self_exe.empty() && exe_lower == self_exe) continue;
      if (wanted.count(exe_lower) == 0) continue;

      WindowCloseContext context{entry.th32ProcessID};
      EnumWindows(CloseWindowsForPid, reinterpret_cast<LPARAM>(&context));

      if (acted.insert(exe_lower).second) {
        closed.push_back(EncodableValue(exe));
      }
    } while (Process32NextW(snapshot, &entry));
  }
  CloseHandle(snapshot);
  return closed;
}

EncodableList ExtractTokens(const EncodableValue* arguments) {
  if (const auto* args = std::get_if<EncodableMap>(arguments)) {
    auto it = args->find(EncodableValue("tokens"));
    if (it != args->end()) {
      if (const auto* list = std::get_if<EncodableList>(&it->second)) {
        return *list;
      }
    }
  }
  return EncodableList();
}

// Opts the process in/out of Windows' background power throttling
// (Efficiency Mode / EcoQoS), which otherwise delays our polling timer once
// the window is minimized to the tray. |disable_throttling| = true keeps the
// process at normal priority; false restores default OS behavior.
void SetBackgroundThrottling(bool disable_throttling) {
  PROCESS_POWER_THROTTLING_STATE state{};
  state.Version = PROCESS_POWER_THROTTLING_CURRENT_VERSION;
  state.ControlMask = PROCESS_POWER_THROTTLING_EXECUTION_SPEED;
  state.StateMask =
      disable_throttling ? 0 : PROCESS_POWER_THROTTLING_EXECUTION_SPEED;
  SetProcessInformation(GetCurrentProcess(), ProcessPowerThrottling, &state,
                         sizeof(state));
}

}  // namespace

void RegisterAppBlockerChannel(flutter::FlutterEngine* engine) {
  // The channel is kept alive for the lifetime of the app so its handler stays
  // registered.
  static std::unique_ptr<flutter::MethodChannel<EncodableValue>> channel;
  channel = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      engine->messenger(), "flow_fusion/app_blocker",
      &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [](const flutter::MethodCall<EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
        if (call.method_name() == "blockApps") {
          EncodableList tokens = ExtractTokens(call.arguments());
          result->Success(EncodableValue(BlockApps(tokens)));
        } else if (call.method_name() == "listInstalledApps") {
          result->Success(EncodableValue(EncodableList()));
        } else if (call.method_name() == "beginBackgroundExecution") {
          SetBackgroundThrottling(true);
          result->Success();
        } else if (call.method_name() == "endBackgroundExecution") {
          SetBackgroundThrottling(false);
          result->Success();
        } else {
          result->NotImplemented();
        }
      });
}
