   if (Not checkagent()) {
	  
	MsgBox, 16, Error, The Agent is not running. You must open the agent to continue.
	ControlSetText, WindowsForms10.EDIT.app.0.259f9d22,
	Return
	
   }

checkagent() {
IniRead, Folder, config.ini, AGENT, AGENT_PATH
If Not WinExist("ahk_exe ts_agent_V3.exe") {
  return 0
}
return 1
}

;~ E:\ts_agent_v3 FUNTEST\ts_agent_V3.exe
;~ ahk_class ConsoleWindowClass
;~ ahk_exe ts_agent_V3-FUNTEST.exe

;~ MIS-MESSAGE
;~ ahk_class WindowsForms10.Window.8.app.0.378734a
;~ ahk_exe mismsg.exe


;~ ClassNN:	WindowsForms10.STATIC.app.0.378734a1
;~ Text:	You success running in test phase...
;~ Color:	F0F0F0 (Red=F0 Green=F0 Blue=F0)


;~ ClassNN:	WindowsForms10.BUTTON.app.0.378734a1
;~ Text:	OK
;~ Color:	FF8000 (Red=FF Green=80 Blue=00)