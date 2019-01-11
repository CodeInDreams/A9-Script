/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

EMU_AHK_CLASS = ; 模拟器的ahk_class
EMU_AHK_EXE = Bluestacks.exe ; 模拟器的ahk_exe
TOP_HEIGHT = 46 ; 标题栏高度
BOTTOM_HEIGHT = 47 ; 底栏高度
LEFT_WIDTH = 7 ; 左侧宽度
RIGHT_WIDTH = 7 ; 右侧宽度
APP_CLOSE_X := 350 + APP_INDEX * 206 ; 应用关闭按钮X坐标
APP_CLOSE_Y = 13 ; 应用关闭按钮Y坐标
EMU_HOME_X = 267 ; 模拟器首页X坐标
EMU_HOME_Y = 24 ; 模拟器首页X坐标
RUN_COMMAND = %ProgramFiles%\BlueStacks\HD-RunApp.exe -json "{\"app_icon_url\": \"\", \"app_name\": \"狂野飙车9\", \"app_url\": \"\", \"app_pkg\": \"com.gameloft.android.ANMP.GloftA9HM\"}"

CloseApp() ; 关闭A9
{
	global EMU_AHK_CLASS, APP_CLOSE_X, APP_CLOSE_Y
	WinActivate ahk_class %EMU_AHK_CLASS%
	Click %APP_CLOSE_X%, %APP_CLOSE_Y%
}

RunApp() ; 启动A9
{
	global RUN_COMMAND, DELAY_SUPER_LONG
	Run %RUN_COMMAND%
	Sleep DELAY_SUPER_LONG
}
