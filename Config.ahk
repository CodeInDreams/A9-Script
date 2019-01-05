/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

; 操作模式，0自动，1手动，设置为手动来在关闭时切换回手动模式
OPERATE_MODE = 1
; 应用是顶栏的"首页"后的第几个窗口
APP_INDEX = 1
; 票预留上限，0~10，建议小于9以免浪费浪费票
TICKET_LIMIT = 8
; 生涯用车顺序，第一排1、3、5、7，第二排2、4、6、8。都不可用时，会等待到有可用车辆为止
CAREER_CARS := [5, 6, 4, 7, 10, 12, 13]
; 脚本在哪些小时运行，范围0~23
RUN_HOURS := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
