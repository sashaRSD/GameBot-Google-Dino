#Region
#AutoIt3Wrapper_Icon = img\icon.ico
#AutoIt3Wrapper_OutFile = DinoBot.exe
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Res_FileVersion=1.1.2.9
#AutoIt3Wrapper_Res_Description= Dino bot for google game
#AutoIt3Wrapper_Res_ProductVersion=1.2
#AutoIt3Wrapper_Res_LegalCopyright=©2022 Sasha_RSD
#AutoIt3Wrapper_Res_Field=ProductName|DinoBot
#AutoIt3Wrapper_Res_Field=OriginalFilename|DinoBot.exe
#EndRegion

#include <Misc.au3>
Opt("WinTitleMatchMode", 2)
if _Singleton("TopWindow",1) = 0 Then Exit TrayTip("Внимание", "Приложение уже запущенно!", 0, 2)
HotKeySet("^+!q", "_EndScript")
HotKeySet("^+!й", "_EndScript")
HotKeySet("^+!w", "_OpenWindow")
HotKeySet("^+!ц", "_OpenWindow")
HotKeySet("^+!s", "_Work")
HotKeySet("^+!ы", "_Work")

$X_plus = 2
$jump = False
$reload = True
$StartX = 290
$DayColorAll = 16777215
$DayColorLet = 5460819
$NightColorAll = 0
$NightColorLet = 11316396

$X_coord = $StartX
$ColorAll = $DayColorAll
$ColorLet = $DayColorLet
$hk1 = 'Ctrl+Alt+Shift+W - Открыть окно игры Dino (chrome)'
$hk2 = 'Ctrl+Alt+Shift+S - Запуск бота (в окне dino game)'
$hk3 = 'Ctrl+Alt+Shift+Q - Выход из бота'
MsgBox(64,'ИНФОРМАЦИЯ', $hk1& @CRLF& $hk2& @CRLF& $hk3)
While 1
	Sleep(100)
WEnd

Func _Work()
	Local $GGL = WinWait("chrome://dino/", "", 1)
	If (Not $GGL) Then Exit MsgBox(4112,'Exit', 'Рабочее окно не найдено!'&@CRLF&'Завершаю работу...', 2)
	If Not WinActive($GGL) Then WinActivate($GGL)

	Local $position = WinGetPos($GGL)
	Select
		Case $position[1] = -8
			$Y_top = 590
			$Y_buttom = 660
			$Y_tail = 645
			$Y_back = 850
			$Y_end = 580
		Case $position[1] = -1088
			$Y_top = -490
			$Y_buttom = -420
			$Y_tail = -435
			$Y_back = -250
			$Y_end = -500
	EndSelect
	Send("{SPACE}")

	Global $TimerUpdate = TimerInit()
	While 1
		if not $jump Then
			PixelSearch($X_coord, $Y_top ,$X_coord+80, $Y_buttom, $ColorLet,0, 2)
			If Not @error Then Space_DOWN()
		Else
			If PixelGetColor(90, $Y_tail) = $ColorLet Then Space_UP()
		EndIf
		if PixelGetColor(1000, $Y_back) <> $ColorAll Then _NewColor()
		if Ceiling(TimerDiff($TimerUpdate)) > 5000 Then _EndRun(PixelGetColor(1000, $Y_end), $ColorLet)
	WEnd
EndFunc

Func Space_DOWN()
	Send("{SPACE down}")
	$X_coord += $X_plus
	ConsoleWrite($X_coord&@CRLF)
	$jump = True
EndFunc

Func Space_UP()
	Send("{SPACE up}")
	$jump = False
EndFunc

Func _NewColor()
	If $reload Then
		If $ColorAll = $DayColorAll Then
			$ColorLet = $NightColorLet
			$ColorAll = $NightColorAll
		Else
			$ColorLet = $DayColorLet
			$ColorAll = $DayColorAll
		EndIf
		$X_plus +=1
		$reload = False
		$TimerUpdate = TimerInit()
	EndIf
EndFunc

Func _EndRun($Color, $EndColor)
	$TimerUpdate = TimerInit()
	$reload = True
	If $Color = $EndColor Then
		$ColorLet = $DayColorLet
		$ColorAll = $DayColorAll
		$X_coord = $StartX

		Send("{SPACE}")
		Sleep(2000)
	EndIf
EndFunc

Func _OpenWindow()
	$GGL = WinWait("Chrome", "", 1)
	If Not $GGL Then
		Run("C:\Program Files\Google\Chrome\Application\chrome.exe")
		While (Not $GGL)
			Local $GGL = WinWait("Chrome", "", 5)
		WEnd
		If Not WinActive($GGL) Then WinActivate($GGL)
		WinSetState($GGL, "", @SW_MAXIMIZE)
	EndIf
	If Not WinActive($GGL) Then WinActivate($GGL)
	If @KBLayout=0419 Then
		Send("^е")
	ElseIf @KBLayout=0409 Then
		Send("^t")
	EndIf
	Sleep(1500)
	Send("chrome://dino/{ENTER}")
EndFunc

Func _EndScript()
	MsgBox(4112,'Exit', 'Завершение работы бота!', 2)
	Exit
EndFunc