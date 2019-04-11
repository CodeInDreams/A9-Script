# A9 Script <img src="https://raw.githubusercontent.com/CodeInDreams/A9-Script/master/source/logo_b.ico" width="40" hegiht="40" div align ="left"/>

#### 基于AutoHotKey的A9脚本

名称：A9 Script  
作者：CodeInDreams  
适用于：MuMu模拟器、BlueStacks 4模拟器  
分辨率：2160×1080（任意2:1分辨率的设备）  
  
本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。  
This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
#### 特性
1. 每日、多人、生涯交替刷（不启用多人每小时100000+积分、6*冠军声望，启用多人视情况而定）
1. 多模拟器支持（很容易扩展到任意可用的模拟器）
1. 随机时间、位置点击，随机选路，模拟器物理隔离防检测
1. 可处理游戏崩溃、网络重试、各类弹窗等，出现异常都会在几秒到几十秒内快速重置
1. 可以配置任意的运行时段（精确到分钟），和手肝无缝对接
1. 在最大化容错能力的前提下，有着很快的响应速度
#### 使用方法
1. 配置环境、更改脚本设置（Config.ahk）
1. 双击运行模拟器和脚本（A9 Script.ahk）
1. 【可选，增加**稳定性**，并实现**单文件可移植**到其他电脑】首次成功运行后，可以自行选中source/A9-Script，右键-Compile Script，这时将生成可独立运行的exe单文件，不再依赖AHK程序。由于配置也被编译，所以**更改配置文件或更换模拟器后需要重新Compile Script才生效**
1. 【可选，**图标**】如果运行Ahk2Exe.exe来在图形界面生成exe的话，可以选择图标、压缩与否，启用压缩可能会被杀软误报。编译的脚本默认都会使用上次编译时的图标，所以Ahk2Exe.exe只需转换一次，以后直接右键Compile Script也是有图标的。
#### 详细步骤
1. 安装最新版的AutoHotKey，官网下载地址：https://www.autohotkey.com/download/ahk-install.exe
1. 安装模拟器，同时自行安装好科学上网软件
1. 安装好A9并登录Play账号同步数据
1. 根据需要自行修改Config.ahk中的配置（每个配置都有详细的解释）
1. 启动模拟器，启动完成后双击脚本运行即可
#### 注意事项
1. **如果**模拟器是以管理员身份运行，那么本脚本也需要**以管理员身份运行**
1. 尽量保持模拟器**默认布局**，不要显示侧栏，不要超出屏幕，也不要有其他窗口置顶遮挡，以免影响点击和坐标计算
1. **MuMu模拟器**需要一键安装**Google环境**，完成后在play store安装**Play游戏**
1. **MuMu模拟器**需要手动安装A9的**apk文件**（由于x86模拟器的原因，play商店会提示不兼容而不提供下载），之后开加速器启动A9让它自己下载数据包即可。
1. **MuMu模拟器**需要将A9图标置于安卓桌面**左上的第一个位置**
1. **Bluestacks 4模拟器**的分辨率比例2:1，可能需要过改**注册表**HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0下的GuestHeight、GuestWidth的值（注意**十进制**）来实现
1. 本脚本完整适配中文界面，本人不处理其他语言可能出现的颜色判定问题
1. 降低分辨率可以提升模拟器性能，但是会导致脚本失败准确度降低（在1080×540分辨率下识别准确度大于99%），设定能够**整除2160×1080的分辨率**有利于提高精确度
1. 使用时**可以**关闭显示器，但是要**避免**Windows自动睡眠，也**不要**锁定Windows。如果你使用的是笔记本，合上盖子前请确认：控制面板-电源选项-侧栏-选择关闭笔记本计算机盖的功能，设置为关闭盖子时**不采取任何操作**。
1. 因本人肝有限，**首氪前的广告**未做处理，欢迎提交PR，欢迎反馈其他问题
#### 快捷键
| 快捷键 | 功能 |
| :--- | :--- |
| Ctrl+F1 | 启用每日赛事 |
| Ctrl+Shift+F1 | 关闭每日赛事 |
| Ctrl+F2 | 启用多人赛事 |
| Ctrl+Shift+F2 | 关闭多人赛事 |
| Ctrl+F3 | 启用生涯赛事 |
| Ctrl+Shift+F3 | 关闭生涯赛事 |
| Ctrl+F9 | 暂停/恢复 |
| Ctrl+Shift+F9 | 重置 |
| Ctrl+F12 | 关闭A9并退出 |
| Ctrl+Shift+F12 | 强制退出 |
#### 新功能

> 参阅[此看板](https://github.com/CodeInDreams/A9-Script/projects/1)

#### 常见问题

> 参阅[此Wiki页面](https://github.com/CodeInDreams/A9-Script/wiki/%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98-FAQ)
