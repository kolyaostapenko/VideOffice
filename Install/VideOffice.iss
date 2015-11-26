#define Name "VideOffice"
#define Version
#define Publisher "KolyaOstapenko"
#define URL "https://github.com/kolyaostapenko/VideOffice"
#define ExeName "VideOffice.exe"

[Setup]
AppId={{BC1E0AC6-EEB8-43E5-934F-C2697B546788}
AppName={#Name}
AppVersion={#Version}
AppPublisher={#Publisher}
AppPublisherURL={#URL}
AppSupportURL={#URL}
AppUpdatesURL={#URL}
DefaultDirName={pf}\{#Name}
DefaultGroupName={#Name}
OutputDir=..\VideOffice\Install\Installer
OutputBaseFileName=setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; 
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; 
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl";

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\VideOffice\bin\Debug\DownloadManager.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\VideOffice\bin\Debug\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Code]
#include "dotnet.pas"