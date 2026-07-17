#ifndef RUNNER_APP_BLOCKER_H_
#define RUNNER_APP_BLOCKER_H_

#include <flutter/flutter_engine.h>

// Registers the "flow_fusion/app_blocker" method channel on |engine|.
//
// The channel handles `blockApps` by minimizing the windows of any running
// process whose image name matches one of the supplied tokens (SW_MINIMIZE only
// — never closed or terminated, so the app keeps running and loses no state).
// `listInstalledApps` is a no-op on Windows because the app is chosen through a
// file dialog on the Dart side.
void RegisterAppBlockerChannel(flutter::FlutterEngine* engine);

#endif  // RUNNER_APP_BLOCKER_H_
