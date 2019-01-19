/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

#NoEnv
#SingleInstance Force
#Persistent
SetBatchLines -1
Process Priority, , High
SetWorkingDir %A_ScriptDir%
;Icon source\icon.ico
CoordMode Pixel, Client
CoordMode Mouse, Client

; 2160×1080下的A9专用常量

; 网络错误
NETWORK_ERROR_X = 940
NETWORK_ERROR_Y = 765
NETWORK_ERROR_COLOR = 0xFFFFFF
; 每日赛事
DAILY_RACE_X = 500
DAILY_RACE_Y = 973
DAILY_RACE_COLOR = 0xFFFFFF
; 我的生涯
CAREER_RACE_X = 1530
CAREER_RACE_Y = 973
CAREER_RACE_COLOR = 0xFFFFFF
; 返回
BACK_X = 45
BACK_Y = 100
BACK_COLOR = 0xFFFFFF
; 主页
HOME_X = 2075
HOME_Y = 45
HOME_COLOR = 0xEEE7E3
; 下一步
NEXT_X = 1650
NEXT_X_2 = 1850
NEXT_X_3 = 911
NEXT_Y = 973
NEXT_COLOR_GREEN = 0x12FBC3
NEXT_COLOR_BLACK = 0xA09692
NEXT_COLOR_WHITE = 0xFFFFFF
NEXT_COLOR_RED = 0x6412FB
; 促销广告
SALE_AD_X = 1744
SALE_AD_Y = 186
; 氮气
NITRO_X = 1830
NITRO_Y = 559
; 刹车
BRAKE_X = 345
BRAKE_Y = 480
; 欧洲赛事
EURO_CHAPTER_X = 1816
EURO_CHAPTER_Y = 1025
EURO_SEASON_X = 908
EURO_SEASON_Y = 277
EURO_RACE_X = 761
EURO_RACE_Y = 640
EURO_RACE_Y_DEVIATION = 65
EURO_RACE_COLOR = 0x12FBC3
; A9运行检测
GAME_RUNNING_CHECK_X = 637
GAME_RUNNING_CHECK_Y = 53
GAME_RUNNING_CHECK_COLOR_DARK = 0x191919
GAME_RUNNING_CHECK_COLOR_GRAY = 0x343434
GAME_RUNNING_CHECK_COLOR_NORMAL = 0xFFFFFF
; 比赛中检测
RACING_CHECK_X = 158
RACING_CHECK_Y = 104
RACING_CHECK_COLOR = 0xFFFFFF
; 比赛结束检测
RACE_FINISH_X = 158
RACE_FINISH_Y = 104
RACE_FINISH_COLOR = 0x4200F5
; 油，用于选车
CAR_FIRST_OIL_X = 630
CAR_UPPER_OIL_Y = 633
CAR_LOWER_OIL_Y = 993
CAR_GAP_W = 514
CAR_RUNABLE_COLOR_MIN = 0x12260C
CAR_RUNABLE_COLOR_MAX = 0x39FBC3
; 选车滑动检测
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
; 票，用于判断票券是否已满
TICKET_X = 1812
TICKET_Y = 205
TICKET_COLOR = 0x5400FF
; 每日车辆战利品搜索相关
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
; 自动/手动判断相关
OPERATE_MODE_X = 2003
OPERATE_MODE_Y = 840
OPERATE_MODE_RANGE = 12
; 每日车辆用车顺序
DAILY_CARS := [1, 5, 2, 3, 4, 6]

; A9专用函数

CheckTime() ; 用于限制脚本运行时间，时间范围外退出A9，回到时间范围内时启动A9
{
	global RUN_HOURS, DELAY_SUPER_LONG
	current := A_Hour
	For k, hour in RUN_HOURS
		if (hour - current = 0)
			return
	ShowTrayTip("当前时段不运行游戏")
	RevertControlSetting()
	CloseApp()
	Loop
	{
		Sleep DELAY_SUPER_LONG
		current := A_Hour
		For k, hour in RUN_HOURS
			if (hour - current = 0)
				Reload
	}
}

WaitUser() ; 显示开始运行的提示
{
	global DELAY_SHORT
	ShowTrayTip("3秒内自动开始运行")
	countdown := 3000 // DELAY_SHORT
	while countdown > 0
	{
		Sleep DELAY_SHORT
		countdown -= 1
	}
}

WaitSaleAd() ; 消除促销广告弹窗
{
	global DELAY_MIDDLE, GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY, SALE_AD_X, SALE_AD_Y
	Sleep DELAY_MIDDLE
	while CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
	{
		IfGreater A_Index, 10, Restart()
		RandomClick(SALE_AD_X, SALE_AD_Y, , DELAY_MIDDLE)
	}
}

OpenApp() ; 启动A9
{
	global
	RunApp()
	Loop
	{
		if A_Index > 120
			Restart()
		if CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y,GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
		{
			Sleep DELAY_LONG
			Break
		}
		if CheckPixel(NETWORK_ERROR_X, NETWORK_ERROR_Y, NETWORK_ERROR_COLOR)
			RandomClick(NETWORK_ERROR_X, NETWORK_ERROR_Y, , DELAY_VERY_LONG)
		else
			Sleep DELAY_LONG
	}
}

Restart() ; 重置
{
	global GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY, lastRestartTime
	ShowTrayTip("脚本重置")
	if (lastRestartTime = "" || lastRestartTime + 60000 > A_TickCount || !CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY))
	{
		CloseApp()
		OpenApp()
	}
	lastRestartTime := A_TickCount
	RunDailyRace()
}

GoHome() ; 回到A9首页(比赛中不可用)，
{
	global
	while CheckPixel(BACK_X, BACK_Y, BACK_COLOR)
	{
		IfGreater A_Index, 5, RandomClick(BACK_X, BACK_Y, , DELAY_LONG)
		IfGreater A_Index, 10, Restart()
		RandomClick(HOME_X, HOME_Y, , DELAY_MIDDLE)
	}
	WaitSaleAd()
}

RunDailyRace() ; 从A9首页打开每日车辆战利品赛事。只要票大于预留值，就开始比赛；在票消耗到预留值时，开始跑生涯
{
	global
	GoHome()
	lastDailyRaceTime := A_TickCount
	if !CheckPixel(DAILY_RACE_X, DAILY_RACE_Y, DAILY_RACE_COLOR)
		RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELAY_MIDDLE)
	RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELAY_MIDDLE)
	WaitColor(BACK_X, BACK_Y, BACK_COLOR)
	static tickets = 0
	if (!CheckPixel(TICKET_X, TICKET_Y, TICKET_COLOR))
		tickets := 10
	if (tickets > TICKET_LIMIT) ; 当前票大于预留值(也就是还有票可用)
	{
		RandomClick(DAILY_CAR_CLICK_X, DAILY_CAR_CLICK_Y, DELAY_SHORT, DELAY_MIDDLE) ; 这里为了让图标缩小到同样大小，便于匹配特征点。如果被点击的赛事是要找的目标(有时会出现乱序现象)，那就匹配不到，直接下次再说
		Loop 2 ; 有时候刚进游戏加载不出来，所以搜索两次
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
			Sleep DELAY_VERY_LONG
			Sleep DELAY_VERY_LONG
		}
		local carArraySize := DAILY_CARS.MaxIndex()
		if (findDailyCar)
		{
			RandomClick(dailyRaceX, dailyRaceY, , DELAY_MIDDLE)
			RandomClick(dailyRaceX, dailyRaceY, , DELAY_MIDDLE)
			while (tickets > TICKET_LIMIT)
			{
				tickets -= 1
				lastDailyRaceTime := A_TickCount
				WaitSaleAd()
				WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
				RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_LONG)
				while (!StartRace(DAILY_CARS[A_Index], 30, 50))
				{
					if (A_Index >= carArraySize)
					{
						ShowTrayTip("无可用车辆")
						RunCareerRace()
					}
				}
			}
		}
	}
	RunCareerRace()
}

RunCareerRace() ; 从首页打开并开始生涯EURO赛季的第12个赛事，当连续跑生涯超过10min时，检查一次每日赛事
{
	global
	GoHome()
	if !CheckPixel(CAREER_RACE_X, CAREER_RACE_Y, CAREER_RACE_COLOR)
		RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELAY_MIDDLE)
	RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELAY_MIDDLE)
	WaitColor(BACK_X, BACK_Y, BACK_COLOR)
	RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y, DELAY_SHORT, DELAY_SHORT, 2)
	RandomClick(EURO_SEASON_X, EURO_SEASON_Y, , DELAY_MIDDLE, 2)
	local carArraySize := CAREER_CARS.MaxIndex()
	while (lastDailyRaceTime + 600000 > A_TickCount)
	{
		WaitSaleAd()
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED) ; 等待进入
		Loop 6
			Swipe(1424, 200, 1415, 950)
		Sleep DELAY_VERY_SHORT
		Loop 4 ; 解决滑动误差，当前屏幕找不到EURO 12，就继续滑动，重复4次找不到就放弃
		{
			local foundEuroRace := false
			while (!foundEuroRace) ; 解决滑动误差，在当前屏幕内查找EURO 12
			{
				local yDevition := (A_Index - 1) * EURO_RACE_Y_DEVIATION
				if CheckPixel(EURO_RACE_X, EURO_RACE_Y + yDevition, EURO_RACE_COLOR)
				{
					RandomClick(EURO_RACE_X, EURO_RACE_Y + yDevition, DELAY_SHORT)
					foundEuroRace := true
				}
				else if (A_Index > 1 && CheckPixel(EURO_RACE_X, EURO_RACE_Y - yDevition, EURO_RACE_COLOR))
				{
					RandomClick(EURO_RACE_X, EURO_RACE_Y - yDevition, DELAY_SHORT)
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
		RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_LONG)
		local startIndex := 1
		Random startIndex, 0, 2
		while (A_Index >= startIndex && !StartRace(CAREER_CARS[A_Index], 30, 90))
		{
			if (A_Index >= carArraySize)
			{
				ShowTrayTip("无可用车辆")
				RunDailyRace()
			}
		}
		ShowTrayTip("+2400")
	}
	Sleep DELAY_MIDDLE
	RunDailyRace()
}

StartRace(indexOfCar, waitStartTime:=30, maxRaceTime:=240) ; 开始比赛，需要指定用第几辆车，目前仅适用于多车可选的赛事，waitStartTime：检测赛事开始与否的操作超时时间，maxRaceTime：比赛最大持续时间，超时后将重置脚本
{
	global
	CheckTime()
	while (!CheckPixel(CAR_HEAD_1_X, CAR_HEAD_1_Y, CAR_HEAD_1_COLOR) ; 重置车辆位置，如果滑动次数超过10次，那么说明不正常，就要重置脚本
		|| !CheckPixel(CAR_HEAD_2_X, CAR_HEAD_2_Y, CAR_HEAD_2_COLOR))
	{
		if A_Index > 10
			Restart()
		Swipe(239, 503, 1837, 511)
	}
	ToolTip 正在检查第%indexOfCar%辆车
	Sleep DELAY_SHORT
	local relativePos := indexOfCar
	while relativePos > 6
	{
		Swipe(1837, 520, 239, 521)
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
	RandomClick(carX - 220, carY - 150, , DELAY_LONG)
	WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED)
	if !CheckOperateMode()
		RandomClick(OPERATE_MODE_X, OPERATE_MODE_Y, , DELAY_LONG, 3)
	RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_SUPER_LONG)
	while (!CheckPixel(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR)) ; 检测比赛是否已开始，或者超过设定值强制视为已开始
	{
		if (A_Index > waitStartTime)
		{
			ShowTrayTip("无法检测比赛是否已经开始，现在按照已开始处理")
			Break
		}
		Sleep DELAY_MIDDLE
	}
	local raceTimeLimit := A_TickCount + maxRaceTime * 1000 ; 超时后重置脚本
	local dt
	Loop
	{
		Random dt, -200, 500
		IfLess dt, 0, dt := 0
		if dt < 50
			RandomClick(NITRO_X, NITRO_Y, dt)
		if dt < 400
			RandomClick(NITRO_X, NITRO_Y, dt, DELAY_MIDDLE)
		else if dt < 450
			RandomClick(BRAKE_X, BRAKE_Y, dt, DELAY_LONG)
		if (dt > 0 && dt < 100) ; 1/7 选右边
			Swipe(1825, 530, 1884, 532)
		else if (dt > 0 && dt < 200) ; 1/7 选左边
			Swipe(1884, 530, 1825, 532)
		if CheckPixel(RACE_FINISH_X, RACE_FINISH_Y, RACE_FINISH_COLOR)
			Break
		if (A_TickCount > raceTimeLimit)
			Restart()
	}
	local successCount = 0
	while (successCount < 3 && A_Index < 100)
	{
		local checkBack := CheckPixel(BACK_X, BACK_Y, BACK_COLOR)
		local checkNext := CheckPixel(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK)
		local checkNext2 := checkNext ? false : CheckPixel(NEXT_X_2, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK) ; 有时继续按钮位置比较远，多加了个位置判断
		local checkNext3 := checkNext2 ? false : CheckPixel(NEXT_X_3, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK) ; 达到俱乐部里程碑，暂不领取
		if (checkBack) ; 同时出现返回按钮和继续按钮时说明已经回到选车前页面，这里加3次是为了避免领奖励引发误判
		{
			successCount++
			Sleep DELAY_SHORT
		}
		else if (checkNext)
			RandomClick(NEXT_X, NEXT_Y, DELAY_VERY_SHORT, DELAY_MIDDLE)
		else if (checkNext2)
			RandomClick(NEXT_X_2, NEXT_Y, DELAY_VERY_SHORT, DELAY_MIDDLE)
		else if (checkNext3)
			RandomClick(NEXT_X_3, NEXT_Y, DELAY_VERY_SHORT, DELAY_MIDDLE)
		else
			Sleep DELAY_SHORT
	}
	return true
}

CheckOperateMode() ; 检查操作模式是否是自动挡
{
	global OPERATE_MODE_X, OPERATE_MODE_Y, OPERATE_MODE_RANGE
	operateModeX := OPERATE_MODE_X
	operateModeY := OPERATE_MODE_Y
	Loop %OPERATE_MODE_RANGE% ; 判断操作模式是否为手动
	{
		operateModeColor := GetPixel(operateModeX, operateModeY)
		if ((operateModeColor & 0xFF00) > 0x3FFF) ; 即：绿色 > 63
			return true
	}
	return false
}

RevertControlSetting() ; 如果是手动挡，恢复操作模式为手动，目前在赛事开始前读取时和赛事结束后下一步时不可用
{
	if (OPERATE_MODE = 1)
	{
		if CheckPixel(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR) ; 比赛中则先退出比赛，如果比赛中检测失效，那这里不会正确改回操作模式
		{
			RandomClick(RACING_CHECK_X, RACING_CHECK_Y, , DELAY_MIDDLE, 3)
			RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_VERY_LONG, 3)
		}
		else if !CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
			return
		GoHome()
		if !CheckPixel(CAREER_RACE_X, CAREER_RACE_Y, CAREER_RACE_COLOR)
			RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELAY_MIDDLE)
		RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELAY_MIDDLE)
		WaitColor(BACK_X, BACK_Y, BACK_COLOR)
		RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y, DELAY_SHORT, DELAY_SHORT, 2)
		RandomClick(EURO_SEASON_X, EURO_SEASON_Y, , DELAY_MIDDLE)
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
		RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_LONG)
		RandomClick(CAR_FIRST_OIL_X - 220, CAR_UPPER_OIL_Y - 150, , DELAY_LONG)
		if CheckOperateMode()
			RandomClick(OPERATE_MODE_X, OPERATE_MODE_Y, , DELAY_LONG, 3)
	}
}

Init() ; 脚本主逻辑
{
	ShowTrayTip("脚本开始运行`n可以自由调整窗口大小位置")
	WaitWin()
	CalcWin()
	;ResizeWin()
	;WaitUser()
	Restart()
}

Init()
return

; 热键

^F8::Pause ; 暂停/恢复
^F9::Restart() ; 重置
^F10:: ; 关闭A9并退出
RevertControlSetting()
CloseApp()
ExitApp
return
^F11:: ; 仅退出
RevertControlSetting()
ExitApp
return
^F12::ExitApp ; 强制退出
