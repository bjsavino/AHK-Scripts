#NoTrayIcon

IniRead, fail_count, config.ini, INTERFACE, FAIL_COUNT
IniRead, pass_count, config.ini, INTERFACE, PASS_COUNT
setformat, float, 0.1
fpy := pass_count / (pass_count + fail_count) * 100 . "%"

Gui, Add, Text, x10 y10 w110 h20 , Board Number
Gui, Add, Text, x10 y50 w110 h20 , Set Number
Gui, Add, GroupBox, x10 y90 w145 h90 , Status

Gui, Font, S12 CGreen Bold, Arial
Gui, Add, Text, x15 y25 w160 h20 vbnlabel, 
Gui, Add, Text, x15 y65 w160 h25 vsetnlabel, 
Gui, Add, Text, x15 y110 w60 h25, PASS :
Gui, Add, Text, x80 y110 w60 h25 vpass_count, %pass_count%

Gui, Font, S12 CRed Bold, Arial
Gui, Add, Text, x15 y135 w60 h25, FAIL :
Gui, Add, Text, x80 y135 w60 h25 vfail_count, %fail_count%

Gui, Font, S12 CBlue Bold, Arial
Gui, Add, Text, x15 y160 w60 h25, Yield:
Gui, Add, Text, x80 y160 w55 h24 vfpy, %fpy%

Gui, Font, S16 CRED Bold, Arial
Gui, Add, GroupBox, x330 y18 w99 h74 , FAIL

Gui, Font, S10 CRED Bold, Arial
Gui, Add, Button, x137 y156 w20 h20 , R
;Gui, Add, Button, x230 y104 w100 h25 , aumenta
; Generated using SmartGUI Creator for SciTE
Gui, Show, w165 h190, PID Generate Log Generator
return

GuiClose:
InputBox, password, Enter Password, Enter the password to reset, hide 
IF (password="calcomp123")
	ExitApp
return

Buttonr:
;~ MsgBox, 36, Reset, You will reset the count of PASS`, FAIL and Yield rate. Do you want continue?
;~ IfMsgBox,Yes {
 MsgBox, 4, , Are you sure you want to exit?
  IfMsgBox, No
	Return
  IniWrite,0, config.ini, INTERFACE, PASS_COUNT
  IniWrite,0, config.ini, INTERFACE, FAIL_COUNT
  GuiControl, ,pass_count, 0
  GuiControl, ,fail_count, 0
  GuiControl, ,fpy,
