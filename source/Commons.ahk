/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

AX = ; 游戏左上角相对模拟器窗口的X坐标
AY = ; 游戏左上角相对模拟器窗口的Y坐标
AW = ; 实际游戏宽度
AH = ; 实际游戏高度
VW = 2160 ; 100%游戏宽度，实际可能会放缩
VH = 1080 ; 100%游戏高度，实际可能会放缩
DELAY_VERY_SHORT = 200 ; 等待时间，很短
DELAY_SHORT = 500 ; 等待时间，短
DELAY_MIDDLE = 1000 ; 等待时间，中等
DELAY_LONG = 2000 ; 等待时间，长
DELAY_VERY_LONG = 3000 ; 等待时间，很长
DELAY_SUPER_LONG = 15000 ; 等待时间，超级长

WaitWin() ; 等待模拟器运行
{
	global EMU_AHK_CLASS, EMU_AHK_EXE, EMU_AHK_ID
	if EMU_AHK_CLASS
		WinWait ahk_class %EMU_AHK_CLASS%
	else if EMU_AHK_EXE
		WinWait ahk_exe %EMU_AHK_EXE%
	else
		MsgBox 配置有误
	WinGet EMU_AHK_ID
}

ActivateWin() ; 激活模拟器窗口
{
	global EMU_AHK_ID
	IfWinNotActive ahk_id %EMU_AHK_ID%
	{
		WinActivate
		WinWaitActive
	}
}

CalcWin() ; 发现窗口大小变化后，重新计算AX AY AW AH
{
	global TOP_HEIGHT, BOTTOM_HEIGHT, LEFT_WIDTH, RIGHT_WIDTH, AX, AY, AW, AH, VW, VH, EMU_AHK_ID
	ActivateWin()
	WinGetPos ,,, winW, winH
	static lastW = 0, lastH = 0 ; 上次检测的窗口大小，用于判断窗口大小是否变化
	if winW != lastW || winH != lastH
	{
		lastW := winW
		lastH := winH
		if ((winH - TOP_HEIGHT - BOTTOM_HEIGHT) * VW > (winW - LEFT_WIDTH - RIGHT_WIDTH) * VH) ; 过高
		{
			AW := winW - LEFT_WIDTH - RIGHT_WIDTH
			AH := AW * VH / VW
			AX := LEFT_WIDTH
			AY := (winH - TOP_HEIGHT - BOTTOM_HEIGHT - AH) / 2 + TOP_HEIGHT
		}
		else ; 过宽
		{
			AH := winH - TOP_HEIGHT - BOTTOM_HEIGHT
			AW := AH * VW / VH
			AY := TOP_HEIGHT
			AX := (winW - LEFT_WIDTH - RIGHT_WIDTH - AW) / 2 + LEFT_WIDTH
		}
	}
}

ResizeWin() ; 用于设置窗口位置以便于debug
{
	global TOP_HEIGHT, BOTTOM_HEIGHT, LEFT_WIDTH, RIGHT_WIDTH, VW, VH, EMU_AHK_ID
	WinMove ahk_id %EMU_AHK_ID%, , 0, 0, VW + LEFT_WIDTH + RIGHT_WIDTH, VH + TOP_HEIGHT + BOTTOM_HEIGHT
}

GetX(x) ; 获取实际位置X坐标
{
	global AW, VW, AX
	return x * AW / VW + AX
}

GetY(y) ; 获取实际位置Y坐标
{
	global AH, VH, AY
	return y * AH / VH + AY
}

GetPixel(x, y) ; 获取像素
{
	CalcWin()
	PixelGetColor pixel, GetX(x), GetY(y)
	return pixel
}

CheckPixel(x, y, colors*) ; 验证像素颜色
{
	static colorDeviation := 50 ; 由于模拟器渲染问题，这里允许少量误差
	pixel := GetPixel(x, y)
	pr := pixel & 0xFF
	pg := (pixel & 0xFF00) >> 8
	pb := pixel >> 16
	For k, color in colors
	{
		cr := color & 0xFF
		cg := (color & 0xFF00) >> 8
		cb := color >> 16
		if (Abs(pr - cr) + Abs(pg - cg) + Abs(pb - cb) < colorDeviation)
			return true
	}
	return false
}

CheckPixelWithDeviation(x, y, color, deviation:=200) ; 验证像素颜色，允许误差
{
	pixel := GetPixel(x, y)
	pr := pixel & 0xFF
	pg := (pixel & 0xFF00) >> 8
	pb := pixel >> 16
	cr := color & 0xFF
	cg := (color & 0xFF00) >> 8
	cb := color >> 16
	Debug("误差：" . Abs(pr - cr) + Abs(pg - cg) + Abs(pb - cb))
	return (Abs(pr - cr) + Abs(pg - cg) + Abs(pb - cb) < deviation)
}

WaitColor(x, y, color*) ; 等待目标位置出现指定颜色的像素，检测10次后仍不出现就重置脚本
{
	global DELAY_SHORT, DELAY_MIDDLE, DELAY_LONG, DELAY_VERY_LONG
	dt = DELAY_SHORT
	Loop 10
	{
		For k, v in color
			if CheckPixel(x, y, v)
				return
		if A_Index > 5
			dt += DELAY_MIDDLE
		Sleep dt
	}
	ShowTrayTip("检测不到特征值，脚本即将重置", DELAY_LONG)
	Sleep DELAY_LONG
	Restart()
	Sleep DELAY_VERY_LONG
	ShowTrayTip("重置失败，脚本即将退出", DELAY_LONG)
	Sleep DELAY_LONG
	ExitApp
}

RandomClick(x, y, timePrepare:=0, timeAppend:=0, mode:=0) ; 坐标附近随机点击。timePrepare>0时点击前等待一定时间，timeAppend>0时点击后等待一定时间，mode可指定哪些坐标随机偏移，0：偏移xy、1：只偏移x、2：只偏移y、其他：都不偏移
{
	CalcWin()
	global AW, AH
	if (mode = 0 || mode = 1)
		Random dx, -0.003 * AW, 0.003 * AW
	else
		dx := 0
	if (mode = 0 || mode = 2)
		Random dy, -0.003 * AH, 0.003 * AH
	else
		dy := 0
	resultX := GetX(x) + dx
	resultY := GetY(y) + dy
	IfGreater timePrepare, 0, Sleep timePrepare
	Click %resultX%, %resultY%
	IfGreater timeAppend, 0, Sleep timeAppend
}

Swipe(fromX, fromY, toX, toY) ; 滑动
{
	CalcWin()
	global AH, VH, DELAY_VERY_SHORT
	dragFromX := GetX(fromX)
	dragFromY := GetY(fromY)
	dragToX := GetX(toX)
	dragToY := GetY(toY)
	SetMouseDelay 0
	Click %dragFromX%, %dragFromY%, D
	dx := Abs(dragToX - dragFromX)
	dy := Abs(dragToY - dragFromY)
	part := (dx > dy ? dx : dy)
	dxPart := dx / part
	if (dragFromX > dragToX)
		dxPart := -dxPart
	dyPart := dy / part
	if (dragFromY > dragToY)
		dyPart := -dyPart
	Loop %part%
	{
		MouseMove dxPart, dyPart, , R
		if (A_Index & 0xF = 0) ; 减少二进制位1的个数，来提高精度，但会增加延迟
			Sleep 1
	}
	MouseMove dragToX, dragToY
	Sleep DELAY_VERY_SHORT
	Click %dragToX%, %dragToY%, U
	SetMouseDelay 10ms
	Sleep DELAY_VERY_SHORT
}

ShowTrayTip(text, period:=1000) ; 显示period毫秒的托盘区提示
{
	TrayTip A9 Script, %text%, , 16
	SetTimer HideTrayTip, -%period%
}

HideTrayTip() ; 隐藏托盘区提示
{
	TrayTip
}

ShowToolTip(text, period:=1000) ; 显示period毫秒的气泡提示
{
	Tooltip %text%
	SetTimer HideToolTip, -%period%
}

HideToolTip() ; 隐藏气泡提示
{
	ToolTip
}

Debug(text*) ; 记录日志，用于debug
{
	global enableDebug
	if (enableDebug)
	{
		for k, v in text
			formatted .= formatted = "" ? v : ("`n" . v)
		MsgBox %formatted%
	}
}
