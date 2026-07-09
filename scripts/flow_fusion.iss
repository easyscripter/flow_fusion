; Inno Setup script for Flow Fusion — per-user install (no admin rights).
;
; Installs into %LOCALAPPDATA%\Programs\Flow Fusion so the app can overwrite its
; own files during OTA self-update (desktop_updater). A system-wide install into
; Program Files would break OTA, since a non-elevated app can't rewrite files
; there.
;
; The build is UNSIGNED, so SmartScreen still shows an "unknown publisher"
; warning on setup.exe — testers dismiss it via "More info -> Run anyway"
; (documented in INSTALL.md).
;
; Build:  ISCC.exe /DMyAppVersion=0.1.0-beta.1 scripts\flow_fusion.iss
; Paths in this script are relative to the script's own directory (scripts/).

#define MyAppName "Flow Fusion"
#define MyAppPublisher "easyscripter"
#define MyAppExeName "flow_fusion.exe"
#define MyAppUrl "https://github.com/easyscripter/flow_fusion"

#ifndef MyAppVersion
  #define MyAppVersion "0.0.0-dev"
#endif

#ifndef SourceDir
  #define SourceDir "..\build\windows\x64\runner\Release"
#endif

[Setup]
; Keep this AppId stable across releases so upgrades replace the old install
; instead of creating a duplicate.
AppId={{7A3B9C10-4E2F-4A6D-9B1E-2C5F8D3A1E90}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppUrl}
AppSupportURL={#MyAppUrl}/issues
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
; Per-user install: no UAC prompt, installs under the current user's profile.
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
OutputDir=..\dist\installers
OutputBaseFilename={#MyAppName}-{#MyAppVersion}-windows-setup
SetupIconFile=..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
