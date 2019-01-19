/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

#NoTrayIcon
SetWorkingDir %A_ScriptDir%

A9_FILE_NAME = source`\A9.ahk
COMMONS_FILE_NAME = source`\Commons.ahk
NEMU_FILE_NAME = source`\NEMU.ahk
BLUESTACKS_FILE_NAME = source`\BlueStacks.ahk
CONFIG_FILE_NAME = Config.ahk
GENERATED_FILE_NAME = source`\A9-Script.ahk
NEMU_AHK_CLASS = Qt5QWindowIcon
BLUESTACKS_AHK_EXE = Bluestacks.exe
LINEBREAK = `r`n

Loop
{
	file := FileOpen(GENERATED_FILE_NAME, "w")
	if file
		Break
	if (A_Index > 5)
		Send ^{F12}
	Sleep 1000
}
FileRead content, %CONFIG_FILE_NAME%
file.Write(content)
file.Write(LINEBREAK)
FileRead content, %COMMONS_FILE_NAME%
file.Write(content)
file.Write(LINEBREAK)
Loop
{
	if WinExist("ahk_class" . NEMU_AHK_CLASS)
		emuFileName := NEMU_FILE_NAME
	else if WinExist("ahk_exe" . BLUESTACKS_AHK_EXE)
		emuFileName := BLUESTACKS_FILE_NAME
	else
		Sleep 1000
	if emuFileName
		Break
	if A_Index = 1
		TrayTip A9 Script, 找不到支持的模拟器，脚本将在模拟器启动后继续运行, , 17
}
FileRead content, %emuFileName%
file.Write(content)
file.Write(LINEBREAK)
FileRead content, %A9_FILE_NAME%
file.Write(content)
file.Write(LINEBREAK)
file.Close()
Run %GENERATED_FILE_NAME%
