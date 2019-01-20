/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	����Ŀ����GPL��ԴЭ�飬Э���������LICENSE.TXT��
*/

; ����ģʽ��0�Զ���1�ֶ�������Ϊ�ֶ����ڹر�ʱ�л����ֶ�ģʽ
OPERATE_MODE = 0
; Ӧ���Ƕ�����"��ҳ"��ĵڼ�������
APP_INDEX = 1
; ƱԤ�����ޣ�0~10������С��9�����˷��˷�Ʊ
TICKET_LIMIT = 8
; �����ó�˳�򣬵�һ��1��3��5��7���ڶ���2��4��6��8����������ʱ����ȴ����п��ó���Ϊֹ
CAREER_CARS := [5, 6, 4, 7, 10, 12, 13]
; �ű�����ЩСʱ���У���Χ0~23
RUN_HOURS := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	����Ŀ����GPL��ԴЭ�飬Э���������LICENSE.TXT��
*/

AX = ; ��Ϸ���Ͻ����ģ�������ڵ�X����
AY = ; ��Ϸ���Ͻ����ģ�������ڵ�Y����
AW = ; ʵ����Ϸ���
AH = ; ʵ����Ϸ�߶�
VW = 2160 ; 100%��Ϸ��ȣ�ʵ�ʿ��ܻ����
VH = 1080 ; 100%��Ϸ�߶ȣ�ʵ�ʿ��ܻ����
DELY_VERY_SHORT = 200 ; �ȴ�ʱ�䣬�ܶ�
DELY_SHORT = 500 ; �ȴ�ʱ�䣬��
DELY_MIDDLE = 1000 ; �ȴ�ʱ�䣬�е�
DELY_LONG = 2000 ; �ȴ�ʱ�䣬��
DELY_VERY_LONG = 3000 ; �ȴ�ʱ�䣬�ܳ�
DELY_SUPER_LONG = 15000 ; �ȴ�ʱ�䣬������

WaitWin() ; �ȴ�ģ��������
{
	global EMU_AHK_CLASS, EMU_AHK_EXE, EMU_AHK_ID
	if EMU_AHK_CLASS
		WinWait ahk_class %EMU_AHK_CLASS%
	else if EMU_AHK_EXE
		WinWait ahk_exe %EMU_AHK_EXE%
	else
		MsgBox ��������
	WinGet EMU_AHK_ID
}

ActivateWin() ; ����ģ��������
{
	global EMU_AHK_ID
	IfWinNotActive ahk_id %EMU_AHK_ID%
	{
		WinActivate
		WinWaitActive
	}
}

CalcWin() ; ���ִ��ڴ�С�仯�����¼���AX AY AW AH
{
	global TOP_HEIGHT, BOTTOM_HEIGHT, LEFT_WIDTH, RIGHT_WIDTH, AX, AY, AW, AH, VW, VH, EMU_AHK_ID
	ActivateWin()
	WinGetPos ,,, winW, winH
	static lastW = 0, lastH = 0 ; �ϴμ��Ĵ��ڴ�С�������жϴ��ڴ�С�Ƿ�仯
	if winW != lastW || winH != lastH
	{
		lastW := winW
		lastH := winH
		if ((winH - TOP_HEIGHT - BOTTOM_HEIGHT) * VW > (winW - LEFT_WIDTH - RIGHT_WIDTH) * VH) ; ����
		{
			AW := winW - LEFT_WIDTH - RIGHT_WIDTH
			AH := AW * VH / VW
			AX := LEFT_WIDTH
			AY := (winH - TOP_HEIGHT - BOTTOM_HEIGHT - AH) / 2 + TOP_HEIGHT
		}
		else ; ����
		{
			AH := winH - TOP_HEIGHT - BOTTOM_HEIGHT
			AW := AH * VW / VH
			AY := TOP_HEIGHT
			AX := (winW - LEFT_WIDTH - RIGHT_WIDTH - AW) / 2 + LEFT_WIDTH
		}
	}
}

ResizeWin() ; �������ô���λ���Ա���debug
{
	global TOP_HEIGHT, BOTTOM_HEIGHT, LEFT_WIDTH, RIGHT_WIDTH, VW, VH, EMU_AHK_ID
	WinMove ahk_id %EMU_AHK_ID%, , 0, 0, VW + LEFT_WIDTH + RIGHT_WIDTH, VH + TOP_HEIGHT + BOTTOM_HEIGHT
}

GetX(x) ; ��ȡʵ��λ��X����
{
	global AW, VW, AX
	return x * AW / VW + AX
}

GetY(y) ; ��ȡʵ��λ��Y����
{
	global AH, VH, AY
	return y * AH / VH + AY
}

GetPixel(x, y) ; ��ȡ����
{
	CalcWin()
	PixelGetColor pixel, GetX(x), GetY(y)
	return pixel
}

CheckPixel(x, y, colors*) ; ��֤������ɫ
{
	pixel := GetPixel(x, y)
	For k, color in colors
		if (pixel = color)
			return true
	return false
}

CheckPixelWithDeviation(x, y, color, deviation:=100) ; ��֤������ɫ���������
{
	pixel := GetPixel(x, y)
	pr := pixel & 0xFF
	pg := (pixel & 0xFF00) >> 8
	pb := pixel >> 16
	cr := color & 0xFF
	cg := (color & 0xFF00) >> 8
	cb := color >> 16
	return (Abs(pr - cr) < deviation && Abs(pb - cg) < deviation && Abs(pb - cb) < deviation)
}

WaitColor(x, y, color*) ; �ȴ�Ŀ��λ�ó���ָ����ɫ�����أ����10�κ��Բ����־����ýű�
{
	global HDELY_SHORT, DELY_MIDDLE, DELY_LONG, DELY_VERY_LONG
	dt = DELY_SHORT
	Loop 10
	{
		For k, v in color
			if CheckPixel(x, y, v)
				return
		if A_Index > 5
			dt += DELY_MIDDLE
		Sleep dt
	}
	ShowTrayTip("��ⲻ������ֵ���ű���������", DELY_LONG)
	Sleep DELY_LONG
	Reload
	Sleep DELY_VERY_LONG
	ShowTrayTip("����ʧ�ܣ��ű������˳�", DELY_LONG)
	Sleep DELY_LONG
	ExitApp
}

RandomClick(x, y, timePrepare:=0, timeAppend:=0, mode:=0) ; ���긽����������timePrepare>0ʱ���ǰ�ȴ�һ��ʱ�䣬timeAppend>0ʱ�����ȴ�һ��ʱ�䣬mode��ָ����Щ�������ƫ�ƣ�0��ƫ��xy��1��ֻƫ��x��2��ֻƫ��y������������ƫ��
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

Swipe(fromX, fromY, toX, toY, mode:=0) ; ������mode��0�����ٵ�����֤��ȷ��1����ȷ��������
{
	CalcWin()
	global AH, VH, DELY_SHORT
	dragFromX := GetX(fromX)
	dragFromY := GetY(fromY)
	dragToX := GetX(toX)
	dragToY := GetY(toY)
	Click %dragFromX%, %dragFromY%, D
	dx := Abs(dragToX - dragFromX)
	dy := Abs(dragToY - dragFromY)
	part := (dx > dy ? dx : dy)
	dxPart := dx // part
	if (dragFromX > dragToX)
		dxPart := -dxPart
	dyPart := dy // part
	if (dragFromY > dragToY)
		dyPart := -dyPart
	Loop %part%
	{
		MouseMove dxPart, dyPart, , R
		if (A_Index & 0xF = 0 && mode = 1) ; ���ٶ�����λ1�ĸ���������߾��ȣ����������ӳ�
			Sleep 1
	}
	MouseMove dragToX, dragToY
	Sleep DELY_SHORT
	Click %dragToX%, %dragToY%, U
}

ShowTrayTip(text, period:=1000) ; ��ʾperiod�������������ʾ
{
	TrayTip A9 Script, %text%, , 16
	SetTimer HideTrayTip, -%period%
}

HideTrayTip() ; ������������ʾ
{
	TrayTip
}

/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	����Ŀ����GPL��ԴЭ�飬Э���������LICENSE.TXT��
*/

EMU_AHK_CLASS = Qt5QWindowIcon ; ģ������ahk_class
EMU_AHK_EXE = ; ģ������ahk_exe
TOP_HEIGHT = 35 ; �������߶�
BOTTOM_HEIGHT = 53 ; �����߶�
LEFT_WIDTH = 0 ; �����
RIGHT_WIDTH = 0 ; �Ҳ���
APP_CLOSE_X := 257 + APP_INDEX * 142 ; Ӧ�ùرհ�ťX����
APP_CLOSE_Y = 16 ; Ӧ�ùرհ�ťY����
EMU_HOME_X = 205 ; ��ҳX����
EMU_HOME_Y = 16 ; ��ҳX����
APP_OPEN_X = 340 ; A9ͼ��X����
APP_OPEN_Y = 217 ; A9ͼ��Y����

CloseApp() ; �ر�A9
{
	global EMU_AHK_CLASS, APP_CLOSE_X, APP_CLOSE_Y
	WinActivate ahk_class %EMU_AHK_CLASS%
	Click %APP_CLOSE_X%, %APP_CLOSE_Y%
}

RunApp() ; ����A9
{
	global EMU_AHK_CLASS, APP_INDEX, EMU_HOME_X, EMU_HOME_Y, APP_OPEN_X, APP_OPEN_Y, DELY_SHORT, DELY_SUPER_LONG
	WinActivate ahk_class %EMU_AHK_CLASS%
	if APP_INDEX > 1
		Click %EMU_HOME_X%, %EMU_HOME_Y%
	RandomClick(APP_OPEN_X, APP_OPEN_Y, DELY_SHORT, DELY_SUPER_LONG)
}

/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	����Ŀ����GPL��ԴЭ�飬Э���������LICENSE.TXT��
*/

#NoEnv
#SingleInstance Force
#Persistent
Process Priority, , High
SendMode Input
SetWorkingDir %A_ScriptDir%
;Icon 
CoordMode Pixel, Client
CoordMode Mouse, Client

; 2160��1080�µ�A9ר�ó���

; �������
NETWORK_ERROR_X = 940
NETWORK_ERROR_Y = 765
NETWORK_ERROR_COLOR = 0xFFFFFF
; ÿ������
DAILY_RACE_X = 500
DAILY_RACE_Y = 973
DAILY_RACE_COLOR = 0xFFFFFF
; �ҵ�����
CAREER_RACE_X = 1530
CAREER_RACE_Y = 973
CAREER_RACE_COLOR = 0xFFFFFF
; ����
BACK_X = 45
BACK_Y = 100
BACK_COLOR = 0xFFFFFF
; ��ҳ
HOME_X = 2075
HOME_Y = 45
HOME_COLOR = 0xEEE7E3
; ��һ��
NEXT_X = 1650
NEXT_X_2 = 1850
NEXT_X_3 = 911
NEXT_Y = 973
NEXT_COLOR_GREEN = 0x12FBC3
NEXT_COLOR_BLACK = 0xA09692
NEXT_COLOR_WHITE = 0xFFFFFF
NEXT_COLOR_RED = 0x6412FB
; �������
SALE_AD_X = 1744
SALE_AD_Y = 186
; ����
NITRO_X = 1830
NITRO_Y = 559
; ɲ��
BRAKE_X = 345
BRAKE_Y = 480
; ŷ������
EURO_CHAPTER_X = 1816
EURO_CHAPTER_Y = 1025
EURO_SEASON_X = 908
EURO_SEASON_Y = 277
EURO_RACE_X = 761
EURO_RACE_Y = 640
EURO_RACE_Y_DEVIATION = 65
EURO_RACE_COLOR = 0x12FBC3
; A9���м��
GAME_RUNNING_CHECK_X = 637
GAME_RUNNING_CHECK_Y = 53
GAME_RUNNING_CHECK_COLOR_DARK = 0x191919
GAME_RUNNING_CHECK_COLOR_GRAY = 0x343434
GAME_RUNNING_CHECK_COLOR_NORMAL = 0xFFFFFF
; �����м��
RACING_CHECK_X = 158
RACING_CHECK_Y = 104
RACING_CHECK_COLOR = 0xFFFFFF
; �����������
RACE_FINISH_X = 158
RACE_FINISH_Y = 104
RACE_FINISH_COLOR = 0x4200F5
; �ͣ�����ѡ��
CAR_FIRST_OIL_X = 630
CAR_UPPER_OIL_Y = 633
CAR_LOWER_OIL_Y = 993
CAR_GAP_W = 514
CAR_RUNABLE_COLOR_MIN = 0x12260C
CAR_RUNABLE_COLOR_MAX = 0x39FBC3
; ѡ���������
CAR_HEAD_1_X = 101
CAR_HEAD_1_Y = 927
CAR_HEAD_1_COLOR = 0x230E04
CAR_HEAD_2_X = 140
CAR_HEAD_2_Y = 870
CAR_HEAD_2_COLOR = 0x230E04
CAR_TAIL_X = 2068
CAR_TAIL_Y = 355
CAR_TAIL_COLOR = 0x230E04
CAR_FEATURE_1_X = 184
CAR_FEATURE_1_Y = 432
CAR_FEATURE_2_X = 247
CAR_FEATURE_2_Y = 432
CAR_FEATURE_COLOR_NORMAL = 0xFFFFFF
CAR_FEATURE_COLOR_LOCKED = 0x7F7F7F
; Ʊ�������ж�Ʊȯ�Ƿ�����
TICKET_X = 1812
TICKET_Y = 205
TICKET_COLOR = 0x5400FF
; ÿ�ճ���ս��Ʒ�������
DAILY_CAR_FEATURE_1_X = 221
DAILY_CAR_FEATURE_1_Y = 888
DAILY_CAR_FEATURE_1_COLOR = 0xD2D2D2
DAILY_CAR_FEATURE_2_X = 200
DAILY_CAR_FEATURE_2_Y = 853
DAILY_CAR_FEATURE_2_COLOR = 0x5300FF
DAILY_CAR_FEATURE_3_X = 240
DAILY_CAR_FEATURE_3_Y = 866
DAILY_CAR_FEATURE_3_COLOR = 0xD7D7D7
DAILY_CAR_FEATURE_4_X = 231
DAILY_CAR_FEATURE_4_Y = 879
DAILY_CAR_FEATURE_4_COLOR = 0xC76529
DAILY_CAR_GAP_W = 280
DAILY_CAR_CLICK_X = 1920
DAILY_CAR_CLICK_Y = 905
; �Զ�/�ֶ��ж����
OPERATE_MODE_X = 2003
OPERATE_MODE_Y = 840
OPERATE_MODE_RANGE = 12

; A9ר�ú���

CheckTime() ; �������ƽű�����ʱ�䣬ʱ�䷶Χ���˳�A9���ص�ʱ�䷶Χ��ʱ����A9
{
	global RUN_HOURS, DELY_SUPER_LONG
	current := A_Hour
	For k, hour in RUN_HOURS
		if (hour - current = 0)
			return
	ShowTrayTip("��ǰʱ�β�������Ϸ")
	CloseApp()
	Loop
	{
		Sleep DELY_SUPER_LONG
		current := A_Hour
		For k, hour in RUN_HOURS
			if (hour - current = 0)
				Reload
	}
}

WaitUser() ; ��ʾ��ʼ���е���ʾ
{
	global DELY_SHORT
	ShowTrayTip("3�����Զ���ʼ����")
	countdown = 15
	while countdown > 0
	{
		Sleep DELY_SHORT
		countdown -= 1
	}
}

OpenApp() ; ����A9
{
	global
	RunApp()
	Loop
	{
		if A_Index > 120
			Reload
		if CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y,GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
		{
			Sleep DELY_LONG
			Break
		}
		if CheckPixel(NETWORK_ERROR_X, NETWORK_ERROR_Y, NETWORK_ERROR_COLOR)
			RandomClick(NETWORK_ERROR_X, NETWORK_ERROR_Y, , DELY_VERY_LONG)
		else
			Sleep DELY_LONG
	}
}

GoHome() ; �ص�A9��ҳ(�����в�����)��
{
	global
	while CheckPixel(BACK_X, BACK_Y, BACK_COLOR)
	{
		IfGreater A_Index, 5, RandomClick(BACK_X, BACK_Y, , DELY_LONG)
		IfGreater A_Index, 10, Reload
		RandomClick(HOME_X, HOME_Y, , DELY_MIDDLE)
	}
	Sleep DELY_MIDDLE
	while CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
	{
		IfGreater A_Index, 10, Reload
		RandomClick(SALE_AD_X, SALE_AD_Y, , DELY_MIDDLE)
	}
}

RunDailyRace() ; ��A9��ҳ��ÿ�ճ���ս��Ʒ���¡�ֻҪƱ����Ԥ��ֵ���Ϳ�ʼ��������Ʊ���ĵ�Ԥ��ֵʱ����ʼ������
{
	global
	GoHome()
	lastDailyRaceTime := A_TickCount
	if !CheckPixel(DAILY_RACE_X, DAILY_RACE_Y, DAILY_RACE_COLOR)
		RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELY_MIDDLE)
	RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELY_LONG)
	static tickets = 0
	if (!CheckPixel(TICKET_X, TICKET_Y, TICKET_COLOR))
		tickets := 10
	if (tickets > TICKET_LIMIT) ; ��ǰƱ����Ԥ��ֵ(Ҳ���ǻ���Ʊ����)
	{
		RandomClick(DAILY_CAR_CLICK_X, DAILY_CAR_CLICK_Y, , DELY_MIDDLE) ; ����Ϊ����ͼ����С��ͬ����С������ƥ�������㡣����������������Ҫ�ҵ�Ŀ��(��ʱ�������������)���Ǿ�ƥ�䲻����ֱ���´���˵
		Loop 2 ; ��ʱ��ս���Ϸ���ز�������������������
		{
			local findDailyCar := false
			Loop 6
			{
				local dx := (A_Index - 1) * DAILY_CAR_GAP_W
				local feature1 = CheckPixelWithDeviation(DAILY_CAR_FEATURE_1_X + dx, DAILY_CAR_FEATURE_1_Y, DAILY_CAR_FEATURE_1_COLOR)
				local feature2 = CheckPixelWithDeviation(DAILY_CAR_FEATURE_2_X + dx, DAILY_CAR_FEATURE_2_Y, DAILY_CAR_FEATURE_2_COLOR)
				local feature3 = CheckPixelWithDeviation(DAILY_CAR_FEATURE_3_X + dx, DAILY_CAR_FEATURE_3_Y, DAILY_CAR_FEATURE_3_COLOR)
				local feature4 = CheckPixelWithDeviation(DAILY_CAR_FEATURE_4_X + dx, DAILY_CAR_FEATURE_4_Y, DAILY_CAR_FEATURE_4_COLOR)
				if (feature1 && feature2 && feature3 && feature4)
				{
					findDailyCar := true
					local dailyRaceX := DAILY_CAR_FEATURE_4_X + dx
					local dailyRaceY := DAILY_CAR_FEATURE_4_Y
					Break
				}
			}
			if (findDailyCar)
				Break
			Sleep DELY_VERY_LONG
			Sleep DELY_VERY_LONG
		}
		if (findDailyCar)
		{
			RandomClick(dailyRaceX, dailyRaceY, , DELY_MIDDLE)
			RandomClick(dailyRaceX, dailyRaceY, , DELY_MIDDLE)
			while (tickets > TICKET_LIMIT)
			{
				tickets -= 1
				lastDailyRaceTime := A_TickCount
				WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
				RandomClick(NEXT_X, NEXT_Y, DELY_SHORT, DELY_LONG)
				local carIndex := 1
				while (!StartRace(carIndex)) ; ���ﶼû�;͵���
					carIndex := Mod(A_Index, 6) + 1
			}
		}
	}
	RunCareerRace()
}

RunCareerRace() ; ����ҳ�򿪲���ʼ����EURO�����ĵ�12�����£��������10minû�����£�����һ��ÿ������
{
	global
	GoHome()
	if !CheckPixel(CAREER_RACE_X, CAREER_RACE_Y, CAREER_RACE_COLOR)
		RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_MIDDLE)
	RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_MIDDLE)
	WaitColor(BACK_X, BACK_Y, BACK_COLOR)
	RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y, DELY_SHORT, DELY_SHORT, 2)
	RandomClick(EURO_SEASON_X, EURO_SEASON_Y, , DELY_MIDDLE, 2)
	local carArraySize := CAREER_CARS.MaxIndex()
	while (lastDailyRaceTime + 600000 > A_TickCount)
	{
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED) ; �ȴ�����
		Loop 6
			Swipe(1424, 200, 1415, 950)
		Sleep DELY_VERY_SHORT
		Loop 4 ; �����������ǰ��Ļ�Ҳ���EURO 12���ͼ����������ظ�4���Ҳ����ͷ���
		{
			local foundEuroRace := false
			while (!foundEuroRace) ; ����������ڵ�ǰ��Ļ�ڲ���EURO 12
			{
				local yDevition := (A_Index - 1) * EURO_RACE_Y_DEVIATION
				if CheckPixel(EURO_RACE_X, EURO_RACE_Y + yDevition, EURO_RACE_COLOR)
				{
					RandomClick(EURO_RACE_X, EURO_RACE_Y + yDevition, DELY_SHORT)
					foundEuroRace := true
				}
				else if (A_Index > 1 && CheckPixel(EURO_RACE_X, EURO_RACE_Y - yDevition, EURO_RACE_COLOR))
				{
					RandomClick(EURO_RACE_X, EURO_RACE_Y - yDevition, DELY_SHORT)
					foundEuroRace := true
				}
				else if A_Index > 6
					Break
			}
			if (foundEuroRace)
				Break
			Swipe(1424, 200, 1415, 950)
		}
		if (!foundEuroRace)
			RunDailyRace()
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
		RandomClick(NEXT_X, NEXT_Y, DELY_SHORT, DELY_LONG)
		local carArrayIndex := 1
		while (!StartRace(CAREER_CARS[carArrayIndex]))
		{
			carArrayIndex := Mod(A_Index, carArraySize) + 1
			if (A_Index > carArraySize * 2)
			{
				ShowTrayTip("�޿��ó���")
				Break
			}
		}
		ShowTrayTip("+2400")
	}
	Sleep DELY_MIDDLE
	RunDailyRace()
}

StartRace(indexOfCar, waitTime:=20) ; ��ʼ��������Ҫָ���õڼ�������Ŀǰ�������ڶ೵��ѡ�����£�waitTime��������¿�ʼ���Ĳ�����ʱʱ�䣬Ĭ��20��
{
	global
	CheckTime()
	while (!CheckPixel(CAR_HEAD_1_X, CAR_HEAD_1_Y, CAR_HEAD_1_COLOR) ; ���ó���λ�ã����������������10�Σ���ô˵������������Ҫ���ýű�
		|| !CheckPixel(CAR_HEAD_2_X, CAR_HEAD_2_Y, CAR_HEAD_2_COLOR))
	{
		if A_Index > 10
			Reload
		Swipe(239, 503, 1837, 511)
	}
	ToolTip ���ڼ���%indexOfCar%����
	Sleep DELY_SHORT
	local relativePos := indexOfCar
	while relativePos > 6
	{
		Swipe(1837, 520, 239, 521, 1)
		relativePos -= 6
		if (releativePos > 6 && CheckPixel(CAR_TAIL_X, CAR_TAIL_Y, CAR_TAIL_COLOR))
			return false
	}
	local carX := (relativePos - 1) // 2 * CAR_GAP_W + CAR_FIRST_OIL_X
	local carY := (relativePos & 1 = 0 ? CAR_LOWER_OIL_Y : CAR_UPPER_OIL_Y)
	local oilColor := GetPixel(carX, carY)
	local oilR := oilColor & 0xFF
	local oilG := (oilColor & 0xFF00) >> 8
	local oilB := oilColor >> 16
	local minR := CAR_RUNABLE_COLOR_MIN & 0xFF
	local minG := (CAR_RUNABLE_COLOR_MIN & 0xFF00) >> 8
	local minB := CAR_RUNABLE_COLOR_MIN >> 16
	local maxR := CAR_RUNABLE_COLOR_MAX & 0xFF
	local maxG := (CAR_RUNABLE_COLOR_MAX & 0xFF00) >> 8
	local maxB := CAR_RUNABLE_COLOR_MAX >> 16
	if (oilR < minR || oilR > maxR || oilG < minG || oilG > maxG || oilB < minB || oilB > maxB)
		return false
	ToolTip
	RandomClick(carX - 220, carY - 150, , DELY_LONG)
	if !CheckOperateMode()
		RandomClick(OPERATE_MODE_X, OPERATE_MODE_Y, , DELY_LONG, 3)
	RandomClick(NEXT_X, NEXT_Y, , DELY_SUPER_LONG)
	while (!CheckPixel(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR)) ; �������Ƿ��ѿ�ʼ�����߳����趨ֵǿ����Ϊ�ѿ�ʼ
	{
		if (A_Index > waitTime)
		{
			ShowTrayTip("�޷��������Ƿ��Ѿ���ʼ�����ڰ����ѿ�ʼ����")
			Break
		}
		Sleep DELY_MIDDLE
	}
	local maxRaceTime := A_TickCount + 300000 ; �趨������ʱʱ��5���ӣ���ʱ�����ýű�
	local dt
	Loop
	{
		Random dt, -200, 500
		IfLess dt, 0, dt := 0
		if dt < 50
			RandomClick(NITRO_X, NITRO_Y, dt)
		if dt < 400
			RandomClick(NITRO_X, NITRO_Y, dt, DELY_MIDDLE)
		else if dt < 450
			RandomClick(BRAKE_X, BRAKE_Y, dt, DELY_LONG)
		if (dt > 0 && dt < 100) ; 1/7 ѡ�ұ�
			Swipe(1825, 530, 1884, 532)
		else if (dt > 0 && dt < 200) ; 1/7 ѡ���
			Swipe(1884, 530, 1825, 532)
		if CheckPixel(RACE_FINISH_X, RACE_FINISH_Y, RACE_FINISH_COLOR)
			Break
		if (A_TickCount > maxRaceTime)
			Reload
	}
	local successCount = 0
	while (successCount < 3 || A_Index > 100)
	{
		local checkBack := CheckPixel(BACK_X, BACK_Y, BACK_COLOR)
		local checkNext := CheckPixel(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK)
		local checkNext2 := checkNext ? false : CheckPixel(NEXT_X_2, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK) ; ��ʱ������ťλ�ñȽ�Զ������˸�λ���ж�
		local checkNext3 := checkNext2 ? false : CheckPixel(NEXT_X_3, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK) ; �ﵽ���ֲ���̱����ݲ���ȡ
		if (checkBack) ; ͬʱ���ַ��ذ�ť�ͼ�����ťʱ˵���Ѿ��ص�ѡ��ǰҳ�棬�����3����Ϊ�˱����콱����������
		{
			successCount++
			Sleep DELY_SHORT
		}
		else if (checkNext)
			RandomClick(NEXT_X, NEXT_Y, DELY_VERY_SHORT, DELY_MIDDLE)
		else if (checkNext2)
			RandomClick(NEXT_X_2, NEXT_Y, DELY_VERY_SHORT, DELY_MIDDLE)
		else if (checkNext3)
			RandomClick(NEXT_X_3, NEXT_Y, DELY_VERY_SHORT, DELY_MIDDLE)
		else
			Sleep DELY_SHORT
	}
	return true
}

CheckOperateMode() ; ������ģʽ�Ƿ����Զ���
{
	global OPERATE_MODE_X, OPERATE_MODE_Y, OPERATE_MODE_RANGE
	operateModeX := OPERATE_MODE_X
	operateModeY := OPERATE_MODE_Y
	Loop %OPERATE_MODE_RANGE% ; �жϲ���ģʽ�Ƿ�Ϊ�ֶ�
	{
		operateModeColor := GetPixel(operateModeX, operateModeY)
		if ((operateModeColor & 0xFF00) > 0x7FFF) ; ������ɫ > 127
			return true
	}
	return false
}

Init() ; �ű����߼�
{
	;OnExit RevertControlSetting
	ShowTrayTip("�ű���ʼ����`n�������ɵ������ڴ�Сλ��")
	WaitWin()
	CalcWin()
	;ResizeWin()
	;WaitUser()
	CloseApp()
	OpenApp()
	RunDailyRace()
}

Init()
return

; �ȼ�

^F8::Pause ; ��ͣ/�ָ�
^F9::Reload ; ����
^F10:: ; �ر�A9���˳�
Gosub RevertControlSetting
CloseApp()
ExitApp
return
^F11::ExitApp ; ���˳�
Gosub RevertControlSetting
ExitApp
return
^F12::ExitApp ; ǿ���˳�

; �¼�����

RevertControlSetting: ; �˳�ʱ�������
if A_ExitReason in Logoff,Shutdown,Close,Menu ; �����������, ע�ⲻҪ�ڶ�����Χ���пո�
{
	if (OPERATE_MODE = 1)
	{
		if CheckPixel(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR) ; �����������˳���������������м��ʧЧ�������ﲻ����ȷ�Ļز���ģʽ
		{
			RandomClick(RACING_CHECK_X, RACING_CHECK_Y, , DELY_MIDDLE, 3)
			RandomClick(NEXT_X, NEXT_Y, DELY_SHORT, DELY_VERY_LONG, 3)
		}
		else if !CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
			return
		GoHome()
		if !CheckPixel(CAREER_RACE_X, CAREER_RACE_Y, CAREER_RACE_COLOR)
			RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_MIDDLE)
		RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_MIDDLE)
		WaitColor(BACK_X, BACK_Y, BACK_COLOR)
		RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y, DELY_SHORT, DELY_SHORT, 2)
		RandomClick(EURO_SEASON_X, EURO_SEASON_Y, , DELY_MIDDLE)
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
		RandomClick(NEXT_X, NEXT_Y, DELY_SHORT, DELY_LONG)
		RandomClick(CAR_FIRST_OIL_X - 220, CAR_UPPER_OIL_Y - 150, , DELY_LONG)
		if CheckOperateMode()
			RandomClick(OPERATE_MODE_X, OPERATE_MODE_Y, , DELY_LONG, 3)
	}
}
return

