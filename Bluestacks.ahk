/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

EMU_AHK_CLASS = ; 模拟器的ahk_class
EMU_AHK_EXE = Bluestacks.exe ; 模拟器的ahk_exe
TOP_HEIGHT = 35 ; 标题栏高度
BOTTOM_HEIGHT = 53 ; 底栏高度
LEFT_WIDTH = 0 ; 左侧宽度
RIGHT_WIDTH = 0 ; 右侧宽度
APP_CLOSE_X := 257 + APP_INDEX * 142 ; 应用关闭按钮X坐标
APP_CLOSE_Y = 16 ; 应用关闭按钮Y坐标
EMU_HOME_X = 205 ; 模拟器首页X坐标
EMU_HOME_Y = 16 ; 模拟器首页X坐标
RUN_COMMAND = %ProgramFiles%\BlueStacks\HD-RunApp.exe -json "{\"app_icon_url\": \"\", \"app_name\": \"狂野飙车9\", \"app_url\": \"\", \"app_pkg\": \"com.gameloft.android.ANMP.GloftA9HM\"}"

CloseApp() ; 关闭A9
{
	global EMU_AHK_CLASS, APP_CLOSE_X, APP_CLOSE_Y
	WinActivate ahk_class %EMU_AHK_CLASS%
	Click %APP_CLOSE_X%, %APP_CLOSE_Y%
}

RunApp() ; 启动A9
{
	global DELY_SUPER_LONG
	Run %RUN_COMMAND%
	Sleep DELY_SUPER_LONG
}
