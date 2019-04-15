/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

#NoEnv
CAREER_RACE_X = 1530
#SingleInstance Force
#Persistent
SetBatchLines -1
Process Priority, , High
SetWorkingDir %A_ScriptDir%
Menu Tray, Icon, logo_w.ico, , 1
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
; 多人游戏
MULTI_PLAYER_RACE_X = 851
MULTI_PLAYER_RACE_Y = 973
MULTI_PLAYER_RACE_COLOR = 0xFFFFFF
; 我的生涯
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
; 多人首页
MP_RACE_FIRST_X = 1724
MP_RACE_FIRST_Y = 351
MP_RACE_GAP_Y = 480
; 多人二级页面
MP_START_X_1 = 778
MP_START_X_2 = 1363
MP_START_Y = 966
MP_START_COLOR_NORMAL = 0x10FBC3
MP_START_COLOR_DARK = 0x2B402F
; 多人段位检测
MP_LEVEL_DETECT_X = 1520
MP_LEVEL_DETECT_Y = 547
MP_LEVEL_COLORS := {0x5400FF: 1, 0x6184DA: 1, 0xC09F8C: 2, 0x30C8F2: 3, 0xF86492: 4, 0xA2E1F5: 5}
; 多人首页误触
MP_START_MISTAKE_X = 1732
MP_START_MISTAKE_Y = 201
MP_START_MISTAKE_COLOR = 0x5500FF
; 多人选车段位
MP_LEVEL_X = 1441
MP_LEVEL_Y = 215
MP_LEVEL_GAP = 135
; 多人选车动画
MP_CAR_HEAD_1_X = 167
MP_CAR_HEAD_1_Y = 885
MP_CAR_HEAD_1_COLOR = 0x240E04
MP_CAR_HEAD_2_X = 299
MP_CAR_HEAD_2_Y = 885
MP_CAR_HEAD_2_COLOR = 0x240E04
; 多人报错
MP_ERROR_X = 1843
MP_ERROR_Y = 304
MP_ERROR_COLOR = 0x5500FF
; 促销广告
SALE_AD_X = 1744
SALE_AD_Y = 186
NICK_CLOSE_X = 1765
NICK_CLOSE_Y = 80
; 入队申请
REQUEST_X = 763
REQUEST_Y = 871
REQUEST_COLOR = 0xFFFFFF
; 多人包
MP_PACK_X = 1233
MP_PACK_Y = 837
MP_PACK_COLOR = 0x01D9FC
; 氮气
NITRO_X = 1830
NITRO_Y = 559
; 刹车
BRAKE_X = 345
BRAKE_Y = 480
; 欧洲赛事
EURO_CHAPTER_X = 1742
EURO_CHAPTER_Y = 1025
EURO_SEASON_X = 908
EURO_SEASON_Y = 277
EURO_RACE_X = 761
EURO_RACE_Y = 640
EURO_RACE_Y_DEVIATION = 65
EURO_RACE_COLOR = 0x12FBC3
; A9运行检测
GAME_RUNNING_CHECK_X = 686
GAME_RUNNING_CHECK_Y = 23
GAME_RUNNING_CHECK_COLOR_DARK = 0x191919
GAME_RUNNING_CHECK_COLOR_GRAY = 0x343434
GAME_RUNNING_CHECK_COLOR_LIGHT_GRAY = 0x4A4A4A
GAME_RUNNING_CHECK_COLOR_NORMAL = 0xFFFFFF
GAME_RUNNING_CHECK_COLOR_CROSS_1 = 0x363636
GAME_RUNNING_CHECK_COLOR_CROSS_2 = 0x2E2E2E
GAME_RUNNING_CHECK_X_2 = 822
GAME_RUNNING_CHECK_Y_2 = 53
GAME_RUNNING_CHECK_COLOR_2 = 0x040404
; 比赛中检测
RACING_CHECK_X = 158
RACING_CHECK_Y = 104
RACING_CHECK_COLOR = 0xFFFFFF
; 比赛结束检测
RACE_FINISH_X = 158
RACE_FINISH_Y = 104
RACE_FINISH_COLOR = 0x4200F5
RACE_FINISH_X_2 = 400
RACE_FINISH_Y_2 = 114
RACE_FINISH_COLOR_2 = 0x4500F7
; 油，用于选车
CAR_FIRST_OIL_X = 630
CAR_UPPER_OIL_Y = 633
CAR_LOWER_OIL_Y = 993
CAR_GAP_W = 514
CAR_RUNABLE_COLOR_MIN = 0x12260C
CAR_RUNABLE_COLOR_MAX = 0x39FBC3
; 多人选车纠正
MP_CAR_FIRST_OIL_X = 780
MP_CAR_UPPER_OIL_Y = 623
MP_CAR_LOWER_OIL_Y = 973
MP_CAR_GAP_W = 499
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
TICKET_FROM_X = 1888
TICKET_TO_X = 1913
TICKET_Y = 192
TICKET_COLOR_BG = 0x000000
TICKET_COLOR = 0x0DB090
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
; 每日赛事可领取弹窗
DAILY_REWORD_READY_X = 788
DAILY_REWORD_READY_X_2 = 1378
DAILY_REWORD_READY_Y = 573
DAILY_REWORD_READY_COLOR = 0xFFFFFF
; 自动/手动判断相关
OPERATE_MODE_X = 2003
OPERATE_MODE_Y = 840
OPERATE_MODE_RANGE = 12
; 每日车辆用车顺序
DAILY_CARS := [1, 5, 14, 2, 3, 4]

; 全局变量

tickets := 0 ; 记录当前票数(开始时视为0票，通过满票识别来修正此误差)
ticketTime := A_TickCount ; 票数计时器，表示当前票数是在何时记录的
needFullTicketCheck := true ; 是否需要满票检测来消除tickets初始值的误差，每个运行时间段只需要纠正一次
enableDebug := false ; 是否启用调试

; A9专用函数

CheckTime() ; 用于限制脚本运行时段，时间范围外退出A9，回到时间范围内时启动A9
{
	global RUN_TIME_SCOPE, DELAY_SUPER_LONG, runTimeScope, needFullTicketCheck
    static current = 0
	if (runTimeScope == "") ; 懒加载运行时段配置
	{
		runTimeScope := []
		StringSplit timeScopes, RUN_TIME_SCOPE, `,, A_Space
		Loop %timeScopes0%
		{
			StringSplit beginAndEnd, timeScopes%A_Index%, "-",
			runTimeScope.Insert([beginAndEnd1, beginAndEnd2])
		}
	}
	current := A_Hour . ":" . A_Min
	For k, scope in runTimeScope
		if (current >= scope[1] && current <= scope[2])
			return
	ShowTrayTip("当前时段不运行游戏")
	needFullTicketCheck := true
	RevertControlSetting()
	CloseApp()
	Loop
	{
		Sleep DELAY_SUPER_LONG
		current := A_Hour . ":" . A_Min
		For k, scope in runTimeScope
			if (current >= scope[1] && current <= scope[2])
				Restart()
	}
}

WaitPopUp() ; 消除弹窗，这包括促销广告、入队申请、俱乐部奖励、多人包，每次跑完概率弹出
{
	global
	Sleep DELAY_MIDDLE
	while CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
	{
		if (A_Index <= 3) ; 第1~3次尝试关闭促销广告
			RandomClick(SALE_AD_X, SALE_AD_Y, , DELAY_LONG)
		if (A_Index > 3 && A_Index <= 6 && CheckPixel(REQUEST_X, REQUEST_Y, REQUEST_COLOR)) ; 第4~6次尝试关闭关闭入队申请
			RandomClick(REQUEST_X, REQUEST_Y, , DELAY_LONG)
		if (A_Index > 6 && A_Index <= 9) ; 第7~9次尝试关闭误触导致的改昵称弹窗
			RandomClick(NICK_CLOSE_X, NICK_CLOSE_Y, , DELAY_LONG)
		if (A_Index > 9) ; 10次直接重置
			Restart()
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
		if CheckPixel(GAME_RUNNING_CHECK_X_2, GAME_RUNNING_CHECK_Y_2, GAME_RUNNING_CHECK_COLOR_2) && CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
		{
			Sleep DELAY_LONG
			Debug("Finish launching app. Matching color: " . GetPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y) . " " . GetPixel(GAME_RUNNING_CHECK_X_2, GAME_RUNNING_CHECK_Y_2))
			Break
		}
		if CheckPixel(NETWORK_ERROR_X, NETWORK_ERROR_Y, NETWORK_ERROR_COLOR)
			RandomClick(NETWORK_ERROR_X, NETWORK_ERROR_Y, , DELAY_VERY_LONG)
		else
			Sleep DELAY_LONG
		if (Mod(A_Index, 10) = 0)
			Debug(NETWORK_ERROR_X . "/" . NETWORK_ERROR_Y . " " . GetPixel(NETWORK_ERROR_X, NETWORK_ERROR_Y))
	}
}

Restart() ; 重置，不会影响票数计时器
{
	global BACK_X, BACK_Y, BACK_COLOR, GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_CROSS_1, GAME_RUNNING_CHECK_COLOR_CROSS_2, GAME_RUNNING_CHECK_X_2, GAME_RUNNING_CHECK_Y_2, GAME_RUNNING_CHECK_COLOR_2, lastRestartTime, enableDebug
	CheckTime()
	forceRestart := lastRestartTime != "" && lastRestartTime + 60000 > A_TickCount
	hasBack := CheckPixel(BACK_X, BACK_Y, BACK_COLOR)
	mainCross := CheckPixelWithDeviation(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_CROSS_1) || CheckPixelWithDeviation(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_CROSS_2)
	mainNormal := CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_NORMAL)
	secondNormal := CheckPixel(GAME_RUNNING_CHECK_X_2, GAME_RUNNING_CHECK_Y_2, GAME_RUNNING_CHECK_COLOR_2)
	if (forceRestart || !(hasBack && mainCross || mainNormal && secondNormal)) ; 60秒内重置过，或者检测不到菜单页特征值
	{
		if (enableDebug)
		{
			Debug("Restarting.", "forceRestart: " . forceRestart, "hasBack: " . hasBack, "mainCross: " . mainCross, "mainNormal: " . mainNormal, "secondNormal: " . secondNormal)
		}
		if (!enableDebug)
			CloseApp()
		OpenApp()
	}
	lastRestartTime := A_TickCount
	RunRaces()
}

RunRaces() ; 开始比赛
{
	global ENABLE_DAILY_RACE, ENABLE_MULTI_PLAYER_RACE, ENABLE_CAREER_RACE
	Loop
	{
		if (ENABLE_DAILY_RACE)
			RunDailyRace()
		if (ENABLE_MULTI_PLAYER_RACE)
			RunMultiPlayerRace()
		if (ENABLE_CAREER_RACE)
			RunCareerRace()
	}
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
	WaitPopUp()
}

CheckTicket() ; 检查票数，不实际执行更新，返回值表示票数是否变化
{
	global ticketTime, ENABLE_DAILY_RACE
	ticketChange := (A_TickCount - ticketTime) // 600000
	return (ENABLE_DAILY_RACE && ticketChange > 0)
}

UpdateTicket() ; 检查并更新票数，返回值表示票数是否变化
{
	global tickets, ticketTime
	ticketChange := (A_TickCount - ticketTime) // 600000
	if (ticketChange > 0) ; 票数变化时，更新票和计时器
	{
		tickets += ticketChange
		ticketTime += ticketChange * 600000
		if (tickets > 10)
		{
            tickets := 10
            ticketTime := A_TickCount
        }
		else if (tickets < 0)
			tickets := 0
		return true
	}
	return false
}

CheckFullTicket() ; 满票识别，使用"10"的十位"1"作为特征识别；如果票满，会刷新票数和票数计时器；在每个时间段，只检测到一次满票即可，后续全程由票数计时器计算
{
	global TICKET_FROM_X, TICKET_TO_X, TICKET_Y, TICKET_COLOR, TICKET_COLOR_BG, tickets, ticketTime, needFullTicketCheck
	if (!needFullTicketCheck)
		return
	CheckReward()
	ticketFlag := 0 ; 二进制最低位标记背景，次低位标记特征颜色，当匹配到"背景-特征颜色-背景"的时候认为票满
	while (A_Index + TICKET_FROM_X < TICKET_TO_X && tickets < 10) ; 判断票是否已满，这里使用界面上"10/10"分子中"10"的"1"这个数字作为特征识别
	{
		if CheckPixelWithDeviation(A_Index + TICKET_FROM_X, TICKET_Y, TICKET_COLOR, 120) ; 检测到1数字颜色，因为1很细，所以缩小显示后颜色偏差较大，这里允许120误差
		{
			Debug("第" . A_Index . "次：1 " . GetX(A_Index + TICKET_FROM_X) . " " . GetY(TICKET_Y))
			ticketFlag |= 2
		}
		else if CheckPixel(A_Index + TICKET_FROM_X, TICKET_Y, TICKET_COLOR_BG) ; 检测到1背景色
		{
			if (ticketFlag & 3 = 3) ; 检测到背景色是来自右边
			{
				Debug("第" . A_Index . "次：右背景 " . GetX(A_Index + TICKET_FROM_X) . " " . GetY(TICKET_Y))
				tickets := 10
				ticketTime := A_TickCount
				needFullTicketCheck := false
			}
			else ; 检测到背景色是来自左边
			{
				Debug("第" . A_Index . "次：左背景 " . GetX(A_Index + TICKET_FROM_X) . " " . GetY(TICKET_Y))
				ticketFlag |= 1
			}
		}
		else ; 其他
		{
			Debug("第" . A_Index . "次：失败 " . GetX(A_Index + TICKET_FROM_X) . " " . GetY(TICKET_Y) . " " . GetPixel(A_Index + TICKET_FROM_X, TICKET_Y))
		}
	}
}

CheckReward() ; 检查是否有需要结算的奖励可以领取
{
	global GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_LIGHT_GRAY, DAILY_REWORD_READY_X, DAILY_REWORD_READY_X_2, DAILY_REWORD_READY_Y, DAILY_REWORD_READY_COLOR, DELAY_LONG
	if CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_LIGHT_GRAY) 
		&& CheckPixel(DAILY_REWORD_READY_X, DAILY_REWORD_READY_Y, DAILY_REWORD_READY_COLOR) 
		&& CheckPixel(DAILY_REWORD_READY_X_2, DAILY_REWORD_READY_Y, DAILY_REWORD_READY_COLOR)
		RandomClick(DAILY_REWORD_READY_X_2, DAILY_REWORD_READY_Y, , DELAY_LONG)
}

RunDailyRace() ; 从A9首页打开每日车辆战利品赛事。只要票大于预留值，就开始比赛
{
	global
	GoHome()
	CheckTime()
	UpdateTicket()
	if !CheckPixel(DAILY_RACE_X, DAILY_RACE_Y, DAILY_RACE_COLOR)
		RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELAY_MIDDLE)
	RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELAY_MIDDLE)
	WaitColor(BACK_X, BACK_Y, BACK_COLOR)
	CheckFullTicket()
	if (tickets > TICKET_LIMIT) ; 当前票大于预留值(也就是还有票可用)
	{
		CheckReward()
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
				local matchRate := (feature1 ? 0.25 : 0) + (feature2 ? 0.15 : 0) + (feature3 ? 0.3 : 0) + (feature4 ? 0.3 : 0) ; 加权计算依据来自于实际误差平均值
				if (matchRate > 0.75)
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
			while (tickets > TICKET_LIMIT && ENABLE_DAILY_RACE)
			{
				CheckTime()
				UpdateTicket()
				tickets -= 1
				WaitPopUp()
				WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
				RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_LONG)
				local startIndex
				Random startIndex, 0, carArraySize
				while (A_Index < startIndex || !StartRace(DAILY_CARS[A_Index], 30, 50))
				{
					if (A_Index >= startIndex + carArraySize)
					{
						ShowTrayTip("无可用车辆")
						return
					}
				}
			}
		}
	}
}

RunMultiPlayerRace() ; 从A9首页打开并开始多人赛事
{
	global
	GoHome()
	CheckTime()
	if !CheckPixel(MULTI_PLAYER_RACE_X, MULTI_PLAYER_RACE_Y, MULTI_PLAYER_RACE_COLOR)
		RandomClick(MULTI_PLAYER_RACE_X, MULTI_PLAYER_RACE_Y, , DELAY_MIDDLE)
	if CheckPixel(MP_PACK_X, MP_PACK_Y, MP_PACK_COLOR) ; 检测多人包
	{
		RandomClick(MP_PACK_X, MP_PACK_Y, , DELAY_MIDDLE)
		RandomClick(MP_PACK_X, MP_PACK_Y, , DELAY_MIDDLE)
		WaitColor(NEXT_X_2, NEXT_Y, NEXT_COLOR_WHITE)
		RandomClick(NEXT_X_2, NEXT_Y, , DELAY_LONG)
	}
	RandomClick(MP_RACE_FIRST_X, MP_RACE_FIRST_Y + MP_RACE_GAP_Y, , DELAY_MIDDLE)
	WaitColor(BACK_X, BACK_Y, BACK_COLOR)
	while (!CheckTicket() && ENABLE_MULTI_PLAYER_RACE)
	{
		while !CheckPixel(MP_START_X_1, MP_START_Y, MP_START_COLOR_NORMAL) && !CheckPixel(MP_START_X_2, MP_START_Y, MP_START_COLOR_NORMAL) ; 减少按钮闪动带来的影响
		{
			if (CheckPixel(MP_START_X_1, MP_START_Y, MP_START_COLOR_DARK) || CheckPixel(MP_PACK_X, MP_PACK_Y, MP_PACK_COLOR)) ; 检测多人包
			{
				RandomClick(MP_PACK_X, MP_PACK_Y, , DELAY_MIDDLE)
				RandomClick(MP_PACK_X, MP_PACK_Y, , DELAY_MIDDLE)
				WaitColor(NEXT_X_2, NEXT_Y, NEXT_COLOR_WHITE)
				RandomClick(NEXT_X_2, NEXT_Y, , DELAY_LONG)
				RandomClick(MP_RACE_FIRST_X, MP_RACE_FIRST_Y + MP_RACE_GAP_Y, , DELAY_MIDDLE) ; 因为这里回到了多人首页，所以要重新进二级页面
				WaitColor(BACK_X, BACK_Y, BACK_COLOR)
			}
			if (CheckPixel(MP_START_MISTAKE_X, MP_START_MISTAKE_Y, MP_START_MISTAKE_COLOR))
				RandomClick(MP_START_MISTAKE_X, MP_START_MISTAKE_Y, , DELAY_MIDDLE)
			Sleep DELAY_SHORT
			if (A_Index > 10)
				return
		}
		local finish := false
		local maxLevel = 0
		for k, v in MP_LEVEL_COLORS ; 检测段位，青铜~传奇 分别对应 1~5
			if CheckPixel(MP_LEVEL_DETECT_X, MP_LEVEL_DETECT_Y, k)
				maxLevel := v
		Debug("段位：" . maxLevel)
		RandomClick(MP_START_X_1, MP_START_Y, , DELAY_MIDDLE)
		WaitColor(BACK_X, BACK_Y, BACK_COLOR)
		if (maxLevel = 5) ; 由于目前选车机制，后几辆车选不了，所以这里暂时不用传奇车辆
			maxLevel := 4
		Loop %maxLevel%
		{
			local levelX := MP_LEVEL_X + MP_LEVEL_GAP * (maxLevel - A_Index)
			RandomClick(levelX, MP_LEVEL_Y, , DELAY_MIDDLE)
			while (A_Index < 3 && !(CheckPixel(MP_CAR_HEAD_1_X, MP_CAR_HEAD_1_Y, MP_CAR_HEAD_1_COLOR) && CheckPixel(MP_CAR_HEAD_2_X, MP_CAR_HEAD_2_Y, MP_CAR_HEAD_2_COLOR)))
				Sleep DELAY_SHORT
			Loop %MP_MAX_CARS_PER_LEVEL%
			{
				local relativePos := A_Index
				ToolTip 正在检查第%relativePos%辆车
				local carX := (relativePos - 1) // 2 * (MP_CAR_GAP_W) + MP_CAR_FIRST_OIL_X
				local carY := relativePos & 1 = 0 ? MP_CAR_LOWER_OIL_Y : MP_CAR_UPPER_OIL_Y
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
				Debug("检测油量：" . carX . ":" . carY . " " . oilColor)
				if (oilR < minR || oilR > maxR || oilG < minG || oilG > maxG || oilB < minB || oilB > maxB)
					Continue
				ToolTip
				while (!finish)
				{
					if (A_Index > 10)
						Break
					RandomClick(levelX, MP_LEVEL_Y, , DELAY_MIDDLE)
					RandomClick(carX - 220, carY - 150, , DELAY_LONG)
					finish := StartRace(0, 300, 300)
				}
				if (finish)
					Break
			}
			if (finish)
			{
				WaitPopUp()
				Break
			}
		}
	}
}

RunCareerRace() ; 从A9首页打开并开始生涯EURO赛季的第12个赛事
{
	global
	GoHome()
	CheckTime()
	if !CheckPixel(CAREER_RACE_X, CAREER_RACE_Y, CAREER_RACE_COLOR)
		RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELAY_MIDDLE)
	RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELAY_MIDDLE)
	WaitColor(BACK_X, BACK_Y, BACK_COLOR)
	RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y, DELAY_SHORT, DELAY_SHORT, 2)
	RandomClick(EURO_SEASON_X, EURO_SEASON_Y, , DELAY_MIDDLE, 2)
	local carArraySize := CAREER_CARS.MaxIndex()
	while (!CheckTicket() && ENABLE_CAREER_RACE) ; 票无变化 且 启用生涯赛事
	{
		CheckTime()
		WaitPopUp()
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED) ; 等待进入
		Loop 6
			Swipe(1424, 200, 1424, 950)
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
			Swipe(1424, 200, 1424, 950)
		}
		if (!foundEuroRace)
			return
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
		RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_LONG)
		while (!StartRace(CAREER_CARS[A_Index], 30, 90))
		{
			if (A_Index >= carArraySize)
			{
				ShowTrayTip("无可用车辆")
				return
			}
		}
		ShowTrayTip("+2400")
	}
	Sleep DELAY_MIDDLE
}

StartRace(indexOfCar, waitStartTime:=30, maxRaceTime:=240) ; 开始比赛，需要指定用第几辆车，不需要选车指定0即可，waitStartTime：检测赛事开始与否的操作超时时间，maxRaceTime：比赛最大持续时间，超时后将重置脚本
{
	global
	if (indexOfCar > 0)
	{
		while (!CheckPixel(CAR_HEAD_1_X, CAR_HEAD_1_Y, CAR_HEAD_1_COLOR) ; 重置车辆位置，如果滑动次数超过10次，那么说明不正常，就要重置脚本
		|| !CheckPixel(CAR_HEAD_2_X, CAR_HEAD_2_Y, CAR_HEAD_2_COLOR))
		{
			if A_Index > 10
				Restart()
			Swipe(239, 503, 1837, 511)
		}
		ShowToolTip("正在检查第" . indexOfCar . "辆车")
		Sleep DELAY_SHORT
		local relativePos := indexOfCar
		while relativePos > 6
		{
			Swipe(1837, 520, 239, 520)
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
		RandomClick(carX - 220, carY - 150, , DELAY_LONG)
	}
	WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED)
	if !CheckOperateMode()
		RandomClick(OPERATE_MODE_X, OPERATE_MODE_Y, , DELAY_LONG, 3)
	RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_LONG)
	if CheckPixel(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED) ; 有时会由于过于相似而识别错误，导致车辆界面提前点击了开始，这里加判断，补一次
		RandomClick(NEXT_X, NEXT_Y, DELAY_SHORT, DELAY_LONG)
	Sleep DELAY_SUPER_LONG
	while (!CheckPixel(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR)) ; 检测比赛是否已开始，或者超过设定值强制视为已开始
	{
		if CheckPixel(MP_ERROR_X, MP_ERROR_Y, MP_ERROR_COLOR)
		{
			RandomClick(MP_ERROR_X, MP_ERROR_Y, , DELAY_LONG)
			return false
		}
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
		if CheckPixel(RACE_FINISH_X, RACE_FINISH_Y, RACE_FINISH_COLOR) ; 这里增强了检测条件，直接特征点匹配 或者 未在跑赛事且间接特征点匹配
			|| !CheckPixel(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR) && CheckPixel(RACE_FINISH_X_2, RACE_FINISH_Y_2, RACE_FINISH_COLOR_2)
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
	global enableDebug
	ShowTrayTip("脚本开始运行`n可以自由调整窗口大小位置")
	WaitWin()
	CalcWin()
	if (enableDebug)
		ResizeWin()
	Restart()
}

ShowRaceSwitchStatus() ; 气泡显示赛事开启/关闭状态
{
	global ENABLE_DAILY_RACE, ENABLE_MULTI_PLAYER_RACE, ENABLE_CAREER_RACE
	ShowToolTip("每日：" . (ENABLE_DAILY_RACE ? "开" : "关") . "`n多人：" . (ENABLE_MULTI_PLAYER_RACE ? "开" : "关") . "`n生涯：" . (ENABLE_CAREER_RACE ? "开" : "关"))
}

Init()
return

; 热键

^F9::Pause ; 暂停/恢复

^+F9::Restart() ; 重置

^F12:: ; 关闭A9并退出
RevertControlSetting()
CloseApp()
ExitApp
return

^+F12::ExitApp ; 强制退出

^+=:: ; 初始票+1
tickets++
if (tickets > 10)
	tickets := 10
ShowToolTip("当前票数为" . tickets)
return

^+-:: ; 初始票-1
tickets--
if (tickets < 0)
	tickets := 0
ShowToolTip("当前票数为" . tickets)
return

^F1:: ; 开启每日赛事
ENABLE_DAILY_RACE := true
ShowRaceSwitchStatus()
return

^+F1:: ; 关闭每日赛事
ENABLE_DAILY_RACE := false
ShowRaceSwitchStatus()
return

^F2:: ; 开启多人赛事
ENABLE_MULTI_PLAYER_RACE := true
ShowRaceSwitchStatus()
return

^+F2:: ; 关闭多人赛事
ENABLE_MULTI_PLAYER_RACE := false
ShowRaceSwitchStatus()
return

^F3:: ; 开启生涯赛事
ENABLE_CAREER_RACE := true
ShowRaceSwitchStatus()
return

^+F3:: ; 关闭生涯赛事
ENABLE_CAREER_RACE := false
ShowRaceSwitchStatus()
return
