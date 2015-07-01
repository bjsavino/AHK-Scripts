#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

IniRead, Model, config.ini, CONFIG, MODEL
IniRead, StationName, config.ini, CONFIG, STATION_NAME
IniRead, StationNumber, config.ini, CONFIG, STATION_NUMBER
IniRead, JigN, config.ini, CONFIG, JIG
IniRead, Directory, config.ini, CONFIG, LOG_MES
IniRead, sendlogmes, config.ini, CONFIG, SEND_LOG_FAIL
IniRead, Database, config.ini, CONFIG, LOG_HUNT
IniRead, DebugInfo, config.ini, CONFIG, DEBUG
IniRead, checkagent, config.ini, CONFIG, CHECK_AGENT
;==============================ALERT=====================================
IniRead, path_alert_record, config.ini, ALERT, PATH_ALERT_RECORD
IniRead, acum_def_enable, config.ini, ALERT, ACUM_DEF_ENABLE
IniRead, acum_def_qty, config.ini, ALERT, ACUM_DEF_QTY
IniRead, acum_def_target, config.ini, ALERT, ACUM_DEF_TARGET
IniRead, yld_alert_enable, config.ini, ALERT, YLD_ALERT_ENABLE
IniRead, yld_value, config.ini, ALERT, YLD_VALUE
IniRead, yld_target, config.ini, ALERT, YLD_TARGET
if (path_alert_record="ERROR") { 
 InputBox, path_alert_record, Defina o Caminho para os registros de Alertas
 IniWrite, %path_alert_record%, config.ini, ALERT, PATH_ALERT_RECORD
 
 IniWrite, Y, config.ini, ALERT, ACUM_DEF_ENABLE
 IniWrite, 0, config.ini, ALERT, ACUM_DEF_QTY
 IniWrite, 5, config.ini, ALERT, ACUM_DEF_TARGET
 acum_def_enable:="Y"
 seq_def_qty=0
 acum_def_target=5
 
 IniWrite, Y, config.ini, ALERT, YLD_ALERT_ENABLE
 IniWrite, 100, config.ini, ALERT, YLD_VALUE
 IniWrite, 90, config.ini, ALERT, YLD_TARGET
 yld_alert_enable:="Y"
 IniRead, pass_count, config.ini, INTERFACE, PASS_COUNT
 IniRead, fail_count, config.ini, INTERFACE, FAIL_COUNT
 yld_value := pass_count / (pass_count + fail_count) * 100
 yld_target=90
}
;=================================================================================
if (checkagent="ERROR") { 
 IniWrite, Y, config.ini, CONFIG, CHECK_AGENT
 checkagent:="Y"
}
#include interface.ahk
#include Agent.ahk


#IfWinActive ahk_class WindowsForms10.Window.8.app.0.259f9d2, 1G: Auto Test

^t::
 msgbox 1G: Auto Test LOG Generator is running


enter::
 ControlGetFocus, control_focus
 if (control_focus = "WindowsForms10.EDIT.app.0.259f9d23") {
  sleep, 40
  ControlGetText, sn_scanned, WindowsForms10.EDIT.app.0.259f9d23
  sleep, 20
  
  ;=====implementar Checagem Agente=========
  ;~ if (checkagent = "Y") {
   ;~ if (Not checkagent()) {
    ;~ ControlSetText, WindowsForms10.EDIT.app.0.259f9d23, 
    ;~ ControlSetText, WindowsForms10.EDIT.app.0.259f9d22, O Agente precisa ser aberto
    ;~ MsgBox, 16, Error, The Agent is not running. You must be open the agent to continue.
    ;~ Return
   ;~ }
  ;~ }
   ;               AQUI
   ;=========================================
  send {enter}
  StringReplace, sn_scanned, sn_scanned,%A_Space%, , All
  GuiControl, ,bnlabel, %sn_scanned%
  
 if (DebugInfo = "Y") {
    FileCreateDir, %Database%Debug
    DebugFile = %Database%Debug\%sn_scanned%_debug.txt
    FileAppend ,01 - %sn_scanned%`n, %DebugFile%
  }
  
  try_count = 0
  tryagain_setn:
   sleep, 50
   ControlGetText, setn_scanned, WindowsForms10.EDIT.app.0.259f9d23
   ;~ if (setn_scanned="") { 
    ;~ try_count += 1
    ;~ if (try_count <= 5)
      ;~ goto, tryagain_setn
   ;~ }
   
  if (DebugInfo = "Y") 
    FileAppend ,02 - %setn_scanned%`n, %DebugFile%
  ;~ if (setn_scanned="") {
   ;~ ControlGet, MES_LOG, List, ,WindowsForms10.LISTBOX.app.0.259f9d21, Hazel
   ;~ StringGetPos, test_ng, MES_LOG, Test NG - ,, 0
   ;~ if (test_ng >= 0) {
    ;~ Return
   ;~ }
  ;~ }
   
  Result := "" 
  Fail_Code:= ""
  Fail_Desc:= ""
  MES_LOG := ""
  IniRead, pass_count, config.ini, INTERFACE, PASS_COUNT
  IniRead, fail_count, config.ini, INTERFACE, FAIL_COUNT
  
  if(setn_scanned="")
   return
  
  GuiControl, ,setnlabel, %setn_scanned%
  
  while Result = "" {
   sleep, 20
   ControlGetText, Result, WindowsForms10.STATIC.app.0.259f9d21
  }

  if (DebugInfo = "Y") 
   FileAppend ,03 - %Result%`n, %DebugFile%  
  if (Result = "OK") {
     Result := "PASS"
     
     pass_count+=1
     IniWrite, %pass_count%, config.ini, INTERFACE, PASS_COUNT
     
     ;==================Alert Sequence Defect=======================
     if(acum_def_enable="Y") {
      acum_def_qty=0
      IniWrite, %acum_def_qty%, config.ini, ALERT, ACUM_DEF_QTY
     }
     ;============================================================== 
     
     if (DebugInfo = "Y") 
      FileAppend ,04 - %Result%`n, %DebugFile% 
    }
   else {
     Result := "FAIL"
     if (DebugInfo = "Y") 
      FileAppend ,05 - %Result%`n, %DebugFile% 
     
     ControlGet, MES_LOG, List, ,WindowsForms10.LISTBOX.app.0.259f9d21, Hazel
     
     ;~ MES_LOG := "[Retry Question Message Box] Do you want to test again?`n[Retry Question Message Box] NORegistered failure board - C262`n>> [Test NG] was happened."
  ;-=-=-=-=-=-=-=-=-=-=-=-GET CODE-=-=-=-=-=-=-=-=-=-=-=-=-
     StringGetPos, pos_code, MES_LOG, Registered failure board - ,, 0
      if (DebugInfo = "Y") 
       FileAppend ,06 - %pos_code%`n, %DebugFile% 
     if (pos_code >= 0) {
       ;~ msgbox %pos_code%
       StringMid, Fail_Code, MES_LOG, pos_code+28, 5
       StringReplace, Fail_Code, Fail_Code, `n, , All
       if (DebugInfo = "Y") 
        FileAppend ,07 - %Fail_Code%`n, %DebugFile% 
       if (Fail_Code<>"") {
        IniRead, Fail_Desc, fail_code.ini, CODE, %Fail_Code%
        if (DebugInfo = "Y") 
         FileAppend ,08 - %Fail_Desc%`n, %DebugFile% 
        

        fail_count+=1
        IniWrite, %fail_count%, config.ini, INTERFACE, FAIL_COUNT
        
        ;===========Alert Acumutale Defect=========================
        if(acum_def_enable="Y") {
         acum_def_qty+=1
         IniWrite, %acum_def_qty%, config.ini, ALERT, ACUM_DEF_QTY
         if (acum_def_qty=acum_def_target)
          IniWrite, sequential_defect, %path_alert_record%Alert.ini, %Model%, %StationName%%JigN%
        }
        ;==========================================================
     ;~ msgbox %Fail_Code%
       }
     }
     else {
      if (DebugInfo = "Y") 
       FileAppend ,09 - Retur n`n, %DebugFile% 
      return
     }
  ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    ;~ if (setn_scanned="") {
     ;~ return
    ;~ }
   }
 
  FormatTime, date , , yyyy-MM-dd
  FormatTime, time , , HH:mm:ss
  FormatTime, date2 , , yyyyMMdd
  FormatTime, time2 , , HHmmss
  FormatTime, Folderdate , , yyMM
  

;-=-=-=-=-=-=-=-=Log to MES-=-=-=-=-=-=-
  if (sendlogmes="Y")  {

   FileCreateDir, %Directory%
   Filename = %Directory%%sn_scanned%_%date2%_%time2%_%Result%.txt
   if (DebugInfo = "Y") 
    FileAppend ,Filename MES - %filename%`n, %DebugFile%
   Text= %date%,%time%,%Model%,%StationName%,%sn_scanned%,%setn_scanned%,%Result%,%Fail_Code%,%Fail_Desc%
   FileAppend ,%Text%, %Filename%
   if (DebugInfo = "Y") 
    FileAppend ,10 - %Text%`n, %DebugFile% 
  }
  else  {
   if (Result="PASS")  {
    FileCreateDir, %Directory%
    Filename = %Directory%%sn_scanned%_%date2%_%time2%_PASS.txt

    Text= %date%,%time%,%Model%,%StationName%,%sn_scanned%,%setn_scanned%,%Result%,,
    FileAppend ,%Text%, %Filename%
    if (DebugInfo = "Y") 
     FileAppend ,11 - %Text%`n, %DebugFile% 
   }
  }
   
  ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  
  ;-=-=-=-=-=-=-=-=Log to Hunt Database-=-=-=-=-=-=-
  FileCreateDir, %Database%%Folderdate%
  Filename = %Database%%Folderdate%\%Model%_%date2%.txt
  if (DebugInfo = "Y") 
    FileAppend ,Filename HUNT- %filename%`n, %DebugFile%  ;
  
  Text= %date%,%time%,%StationNumber%,%JIGN%,%sn_scanned%,%Result%,%Fail_Code%,%Fail_Desc%,%setn_scanned%`n
  FileAppend ,%Text%, %Filename%
  if (DebugInfo = "Y") 
   FileAppend ,12 - %Text%`n, %DebugFile% 
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
  GuiControl, ,bnlabel,
  GuiControl, ,setnlabel,
  GuiControl, ,pass_count, %pass_count%
  GuiControl, ,fail_count, %fail_count%
  setformat, float, 0.1
  fpy := pass_count / (pass_count + fail_count) * 100 . "%"
  yld_value := pass_count / (pass_count + fail_count) * 100
  GuiControl, ,fpy, %fpy%
  
  ;==========Alert by Yield=============
  ;IniRead, yld_value, config.ini, ALERT, YLD_VALUE
  ;~ IniRead, yld_value, config.ini, ALERT, YLD_VALUE
;~ IniRead, yld_target, config.ini, ALERT, YLD_TARGET
  if(yld_alert_enable="Y") {
   IniWrite, %yld_value%, config.ini, ALERT, YLD_VALUE
   if (yld_value < yld_target)
    yld_target_t := yld_target . "%"
    IniWrite, yield_alert, %path_alert_record%Alert.ini, %Model%, %StationName%%JigN%   
   ;~ IniWrite, The FPY in the in the %JigN% of Station %StationName% on %Model% is below of the target (%yld_target_t%) with %fpy%, %path_alert_record%Alert.ini, %Model%, %StationName%%JigN%
  }

  ;============================
;Msgbox %date% / %time% / %setn_scanned%
 }
 else 
   send {enter}

 if (DebugInfo = "Y") 
  FileAppend ,`n`nMES_LOG - %MES_LOG%`n, %DebugFile%  ;
 Return

#IfWinActive