/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

; 操作模式，0自动，1手动，设置为手动来在关闭时切换回手动模式
OPERATE_MODE = 0
; 应用是顶栏的"首页"后的第几个窗口
APP_INDEX = 2
; 生涯用车顺序，第一排1、3、5、7，第二排2、4、6、8，建议前6以加快选车过程
CAREER_CARS := [5, 6, 4, 7, 10, 12, 13]
; 脚本在哪些时间范围运行，多个时间段用英文逗号分隔，如 00:00-08:00, 09:00-12:15, 13:55-18:30，注意小于10的加0
RUN_TIME_SCOPE = 00:00-23:59
; true/false，默认开启/关闭每日赛事
ENABLE_DAILY_RACE := false
; true/false，默认开启/关闭多人赛事
ENABLE_MULTI_PLAYER_RACE := false
; true/false，默认开启/关闭生涯赛事
ENABLE_CAREER_RACE := true

; true/false，默认开启/关闭自定义赛事
ENABLE_CUSTOM_RACE := false
; special/daily，自定义赛事类型，特殊赛事/每日赛事
CUSTOM_TYPE = daily
; 自定义赛事次序
CUSTOM_INDEX = 3
; 自定义赛事票数消耗
CUSTOM_TICKET = 2
; 自定义赛事用车顺序
CUSTOM_CARS := [12, 14, 16, 18, 24, 21]

; 脚本跑第几个多人赛事
MP_RACE_INDEX = 1
; 允许脚本使用每个段位的前几辆车来跑多人
MP_MAX_CARS_PER_LEVEL = 6
