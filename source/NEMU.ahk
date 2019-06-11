/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

EMU_AHK_CLASS = Qt5QWindowIcon ; 模拟器的ahk_class
EMU_AHK_EXE = ; 模拟器的ahk_exe
TOP_HEIGHT = 35 ; 标题栏高度
BOTTOM_HEIGHT = 53 ; 底栏高度
LEFT_WIDTH = 0 ; 左侧宽度
RIGHT_WIDTH = 0 ; 右侧宽度
APP_CLOSE_X := 257 + APP_INDEX * 142 ; 应用关闭按钮X坐标
APP_CLOSE_Y = 16 ; 应用关闭按钮Y坐标
EMU_HOME_X = 205 ; 首页X坐标
EMU_HOME_Y = 16 ; 首页X坐标
APP_OPEN_X = 340 ; A9图标X坐标
APP_OPEN_Y = 217 ; A9图标Y坐标

CloseApp() ; 关闭A9
{
	global EMU_AHK_CLASS, APP_CLOSE_X, APP_CLOSE_Y, DELAY_SHORT, DELAY_MIDDLE
	WinActivate ahk_class %EMU_AHK_CLASS%
	Sleep DELAY_SHORT
	Click %APP_CLOSE_X%, %APP_CLOSE_Y%
	Click %APP_CLOSE_X%, %APP_CLOSE_Y%
	Sleep DELAY_MIDDLE
}

RunApp() ; 启动A9
{
	global EMU_AHK_CLASS, APP_INDEX, EMU_HOME_X, EMU_HOME_Y, APP_OPEN_X, APP_OPEN_Y, DELAY_MIDDLE, DELAY_LONG, DELAY_SUPER_LONG
	WinActivate ahk_class %EMU_AHK_CLASS%
	Sleep DELAY_MIDDLE
	if APP_INDEX > 1
		Click %EMU_HOME_X%, %EMU_HOME_Y%
	RandomClick(APP_OPEN_X, APP_OPEN_Y, DELAY_LONG, DELAY_MIDDLE)
	RandomClick(APP_OPEN_X, APP_OPEN_Y, , DELAY_SUPER_LONG)
}
