#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

IniRead, pid_log_path, config.ini, PID, PID_LOG_PATH
IniRead, setnlen, config.ini, PID, SET_NUMBER_CHAR_LENGTH

IniRead, Model, config.ini, CONFIG, MODEL
IniRead, StationName, config.ini, CONFIG, STATION_NAME
IniRead, StationNumber, config.ini, CONFIG, STATION_NUMBER
IniRead, JigN, config.ini, CONFIG, JIG
IniRead, Directory, config.ini, CONFIG, LOG_MES
IniRead, sendlogmes, config.ini, CONFIG, SEND_LOG_FAIL
IniRead, Database, config.ini, CONFIG, LOG_HUNT
IniRead, DebugInfo, config.ini, CONFIG, DEBUG
IniRead, checkagent, config.ini, CONFIG, CHECK_AGENT
if (checkagent="ERROR") { 
 IniWrite, Y, config.ini, CONFIG, CHECK_AGENT
 checkagent:="Y"
}
IniRead, SETN_FORMAT, config.ini, CONFIG, SETN_FORMAT
if (SETN_FORMAT="ERROR") { 
 IniWrite, 0x24, config.ini, CONFIG, SETN_FORMAT
 checkagent:="Y"
}

#include interface.ahk
#include Agent.ahk


#IfWinActive ahk_class WindowsForms10.Window.8.app.0.259f9d2, PID

^t::
 msgbox PID Log Generator is running

enter::

  ;~ filelog = %pid_log_path%PIDGenerate
  ;~ FormatTime, date2 , , yyyyMMdd  
  ;~ filelogbkp = %filelog%_%date2%.log
  ;~ IfNotExist, %filelogbkp%
   ;~ Filecopy, %filelog%.log, %filelogbkp%
  

Result := "" 
  Fail_Desc:= ""
  loginfo := ""
  sn_scanned := ""
  setn := ""
  
  IniRead, pass_count, config.ini, INTERFACE, PASS_COUNT
  IniRead, fail_count, config.ini, INTERFACE, FAIL_COUNT
  
 ControlGetFocus, control_focus
;~ control_focus := "WindowsForms10.EDIT.app.0.259f9d22"
 if (control_focus = "WindowsForms10.EDIT.app.0.259f9d22") {
   sleep, 40
   ControlGetText, sn_scanned, WindowsForms10.EDIT.app.0.259f9d22
   sleep, 20
   StringReplace, sn_scanned,sn_scanned,%A_Space%, , All
   ;~ Stringlen, snlen, sn_scanned
   ;~ StringMid ,sninit,sn_scanned, 0, 2
   ;~ if (snlen<>14 OR sninit<>"CC") {
	;~ ControlSetText, WindowsForms10.EDIT.app.0.259f9d22,
	;~ return
   ;~ }
   
   ;=====implementar Checagem Agente=========
  if (checkagent = "Y") {
   if (Not checkagent()) {
    ControlSetText, WindowsForms10.EDIT.app.0.259f9d23, 
    ;~ ControlSetText, WindowsForms10.EDIT.app.0.259f9d22, O Agente precisa ser aberto
    MsgBox, 16, Error, The Agent is not running. You must open the agent to continue.
    Return
   }
  }
   ;               AQUI
   ;=========================================
   
   GuiControl, ,bnlabel, %sn_scanned%
   loginfoA := ""
   filelog = %pid_log_path%PIDGenerate
   IfExist, %filelog%.log
    FileRead, loginfoA, %filelog%.log



send {enter}
   ;=====================LOOP (WAITING TEST)=======================
   
   ;~ WindowsForms10.STATIC.app.0.259f9d220
   
  while Result <> "OK" AND Result <> "Fail"  {
   sleep, 20
   ControlGetText, Result, WindowsForms10.STATIC.app.0.259f9d220
  }
   sleep, 20
   
  checklogfinished:   
   loginfoB := ""
   IfExist, %filelog%.log
	FileRead, loginfoB, %filelog%.log
    StringLen, lenA, loginfoA
    StringLen, lenB, loginfoB
    StringRight, loginfo, loginfoB, lenB-lenA
;~ StringLen, len, loginfo
   if (loginfo = "") {
     GuiControl, ,bnlabel,
    Return
   }
   StringGetPos, endlog, loginfo, FINISH PID ,, 0
   if (endlog >= 0) {
    FormatTime, date2 , , yyyyMMdd  
    FileAppend, %loginfo%`n, %filelog%_%date2%.log
    loginfoA:=""
    loginfoB:=""
   }
   else
    goto, checklogfinished
   
   	;=====GET SET NUMBER============ 
   StringGetPos, setnpos, loginfo, %SETN_FORMAT%: ,, 0

   if (setnpos >= 0) {
	StringMid, setn, loginfo, setnpos+6, setnlen
	GuiControl, ,setnlabel, %setn%
   }
   
   StringGetPos, errorpos, loginfo, ERROR: ,, 0
   StringGetPos, errorend, loginfo, `n ,, %errorpos%
   StringMid, FailDesc, loginfo, errorpos+7, errorend-errorpos-7
    
	if (FailDesc="") {
		Result := "PASS"
		pass_count+=1
        IniWrite, %pass_count%, config.ini, INTERFACE, PASS_COUNT
	}
	else {
		Result := "FAIL"
		fail_count+=1
        IniWrite, %fail_count%, config.ini, INTERFACE, FAIL_COUNT
    }
	
	
	
	;===========================================LOG===========================================
  FormatTime, date , , yyyy-MM-dd
  FormatTime, time , , HH:mm:ss
  FormatTime, date2 , , yyyyMMdd
  FormatTime, time2 , , HHmmss
  FormatTime, Folderdate , , yyMM
  

;-=-=-=-=-=-=-=-=Log to MES-=-=-=-=-=-=-
  if (sendlogmes="Y")  {

   FileCreateDir, %Directory%
   Filename = %Directory%%sn_scanned%_%date2%_%time2%_%Result%.txt

   Text= %date%,%time%,%Model%,%StationName%,%sn_scanned%,%setn%,%Result%,,%FailDesc%
   FileAppend ,%Text%, %Filename%
;~ MsgBox, 36, Reset, You will reset the count of PASS`, FAIL and Yield rate. Do you want continue?
  }
  else  {
   if (Result="PASS")  {
    FileCreateDir, %Directory%
    Filename = %Directory%%sn_scanned%_%date2%_%time2%_PASS.txt

    Text= %date%,%time%,%Model%,%StationName%,%sn_scanned%,%setn%,%Result%,,
    FileAppend ,%Text%, %Filename%

   }
  }
   
  ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  
  ;-=-=-=-=-=-=-=-=Log to Hunt Database-=-=-=-=-=-=-
  FileCreateDir, %Database%%Folderdate%
  Filename = %Database%%Folderdate%\%Model%_%date2%.txt

  Text= %date%,%time%,%StationNumber%,%JIGN%,%sn_scanned%,%Result%,,%FailDesc%,%setn%`n
  FileAppend ,%Text%, %Filename%
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	;=========================================================================================
  GuiControl, ,pass_count, %pass_count%
  GuiControl, ,fail_count, %fail_count%
  setformat, float, 0.1
  fpy := pass_count / (pass_count + fail_count) * 100 . "%"
  GuiControl, ,fpy, %fpy%
  sleep, 100
  GuiControl, ,bnlabel,
  GuiControl, ,setnlabel,

 
 }
 else 
   send {enter}
return 
#IfWinActive
