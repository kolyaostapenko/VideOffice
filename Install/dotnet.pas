function GetUninstallString: string;
var
  sUnInstPath: string;
  sUnInstallString: String;
begin
  Result := '';
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{361E65A9-ABA7-44CA-A747-99B28252BA56}_is1'); //Your App GUID/ID
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade: Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

function IsDotNetDetected(version: string; release: cardinal): boolean;

var 
    reg_key: string;
    success: boolean; 
    release45: cardinal;
    key_value: cardinal;
    sub_key: string;

begin

    success := false;
    reg_key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\';
    

    if Pos('v3.0', version) = 1 then
      begin
          sub_key := 'v3.0';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'InstallSuccess', key_value);
          success := success and (key_value = 1);
      end;

    if Pos('v3.5', version) = 1 then
      begin
          sub_key := 'v3.5';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;


     if Pos('v4.0 Client Profile', version) = 1 then
      begin
          sub_key := 'v4\Client';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;


     if Pos('v4.0 Full Profile', version) = 1 then
      begin
          sub_key := 'v4\Full';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;


     if Pos('v4.5', version) = 1 then
      begin
          sub_key := 'v4\Full';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Release', release45);
          success := success and (release45 >= release);
      end;
        
    result := success;

end;


function IsRequiredDotNetDetected(): boolean;
begin
    result := IsDotNetDetected('v4.0 Full Profile', 0);
end;




function InitializeSetup: Boolean;
var
  V: Integer;
  iResultCode: Integer;
  sUnInstallString: string;
  ErrCode: integer;
begin
  Result := True; // in case when no previous version is found
  if RegValueExists(HKEY_LOCAL_MACHINE,'Software\Microsoft\Windows\CurrentVersion\Uninstall\{361E65A9-ABA7-44CA-A747-99B28252BA56}_is1', 'UninstallString') then  //Your App GUID/ID
  begin
    V := MsgBox(ExpandConstant('WARNING! Old version of MemoNote is found on your computer. Do you want to uninstall it?'), mbInformation, MB_YESNO); //Custom Message if App installed
    if V = IDYES then
    begin
      sUnInstallString := GetUninstallString();
      sUnInstallString :=  RemoveQuotes(sUnInstallString);
      Exec(ExpandConstant(sUnInstallString), '', '', SW_SHOW, ewWaitUntilTerminated, iResultCode);
      Result := True; //if you want to proceed after uninstall
                //Exit; //if you want to quit after uninstall
    end
    else
      Result := False; //when older version present and not uninstalled
  end;
  if  not  IsRequiredDotNetDetected() then 
	begin
        V := MsgBox('MemoNote requires Microsoft .NET Framework 4.0 Client Profile.'#13#13
            'Please install Microsoft .NET Framework 4.0 and re-install this app.'#13
            'Do you want to go to microsoft.com and download it now?', mbInformation, MB_YESNO);
        if V = IDYES then
		begin
			ShellExec('open', 'http://www.microsoft.com/en-us/download/details.aspx?id=42643','', '', SW_SHOW, ewNoWait, ErrCode);
			result := false;
		end
		else
			result := false;		
    end 
  else  
    result := true;
end;