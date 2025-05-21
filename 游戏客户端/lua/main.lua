if gge.isdebug and os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    package.loaded['lldebugger'] = assert(loadfile(os.getenv('LOCAL_LUA_DEBUGGER_FILEPATH')))()
    require('lldebugger').start()
end

local SDL = require 'SDL'
local GGF = require('GGE.函数')
local MYF = require('我的函数')
local __版本 = 1.1
-- __风格="sm"
-- __种族 = 3
local warg = { 标题 = '怀旧西游 $Revision：1.0', 鼠标 = false }

if gge.platform == 'Windows' then
    warg.可调整 = true
    warg.渲染器 = 'opengl'
    warg.宽度 = 640
    warg.高度 = 480
    warg.帧率 = 60
    warg.隐藏 = true
    if gge.arg[1] == "tab" then
        warg.无边框 = true
        warg.宽度 = 640
        warg.高度 = 480
    end
else
    warg.宽度 = 640
    warg.高度 = 480
    warg.帧率 = 30
    warg.渲染器 = 'opengles2'
end

__自动寻路 = false
__自动遇敌 = false

引擎 = require 'SDL.窗口' (warg)

if gge.platform == 'Windows' and gge.arg[1] ~= "tab" then
    loading = require('窗口/载入')
end

function 引擎:初始化()
    if gge.platform ~= 'Windows' then
        引擎.逻辑宽度, 引擎.逻辑高度 = self:取逻辑宽高()
        self:置逻辑宽高(640, 480)
    end
    __res = require('资源')()
    if loading then
        loading:置按钮(__res:getsf('JZAN1.png'), __res:getsf('JZAN2.png'))
        loading:置文本(__res.F13:取图像('获取服务器列表'))
    end
    __ips = {}
    __rpc = require('通信/游戏')
    __rpc.版本 = __版本

    --gge.isdebug = false
    if gge.isdebug then
        __rpc.地址 = '127.0.0.1'
        __rpc.端口 = 9000
        __rpc.直接进入游戏 = function()
            local id = tonumber(gge.arg[2]) or 1
            __rpc:登录_验证账号('', '')
            local r = __rpc:登录_进入游戏(id)
            if r == false then
                r = __rpc:登录_强制进入游戏(id)
            end
            __几种族 = __rpc:获取种族()
            引擎:初始化界面()
            引擎:置隐藏(false)
        end
        __rpc:开始连接(__rpc.直接进入游戏)
        require('test')
    else
        __rpc.地址 = '127.0.0.1' -- 这里是你服务器IP
        __rpc.端口 = 9000 -- 服务器端口号
        __rpc:开始连接(
            function()
                __几种族 = __rpc:获取种族()
                引擎:初始化界面()
                引擎:置隐藏(false)
            end
        )
    end
end

function 引擎:初始化界面()
    __gui = require('界面')
    require('界面/自定义')
    __好友聊天记录 = {}
    -- require('界面/自定义')
    ----------------------------------
    __自动任务 = require('脚本/自动任务')(__gui)
    ------------------------------------
    __jump = {}
    for _, v in pairs(require('数据/路径库')) do
        if not __jump[v.mid] then
            __jump[v.mid] = {}
        end
        table.insert(__jump[v.mid], v) --把所有出口保存
    end

    local 已上报 = {}
    gge.onerror = function(err)
        if __rpc and __rpc:取状态() == '已经启动' then
            if gge.isdebug then
                引擎:错误事件(err)
            end
            __gui.窗口层:提示窗口('#R刚刚发现一只虫子，我们已经记录了#15')
            if not 已上报[err] then
                已上报[err] = true
                __rpc:上报BUG(gge.platform, err)
            end
        else
            引擎:消息框('错误', err)
        end
    end
end

function 引擎:更新事件(dt, x, y)
    if __gui then
        __gui:更新(dt, x, y)
    end
    if test and test.更新 then
        test:更新(dt)
    end
end

function 引擎:渲染事件(dt, x, y)
    if self:渲染开始(0, 0, 0) then
        if __gui then
            __gui:显示(x, y)
        end
        if test then
            test:显示(x, y)
        end

        if 引擎.切换地图回调 then --渲染完成，截图转场
            引擎.切换地图回调()
            引擎.切换地图回调 = nil
        end
        if 引擎.信息事件 then
            引擎.信息事件()
            引擎.信息事件 = nil
        end

        self:渲染结束()
    end
end

local 禁止切换
function 引擎:键盘事件(键码, 功能, 状态, 按住)
    if 功能 & SDL.KMOD_CTRL ~= 0 and 键码 == SDL.KEY_1 then
        __gui.窗口层:切换助战(1)
    elseif 功能 & SDL.KMOD_CTRL ~= 0 and 键码 == SDL.KEY_2 then
        __gui.窗口层:切换助战(2)
    elseif 功能 & SDL.KMOD_CTRL ~= 0 and 键码 == SDL.KEY_3 then
        __gui.窗口层:切换助战(3)
    elseif 功能 & SDL.KMOD_CTRL ~= 0 and 键码 == SDL.KEY_4 then
        __gui.窗口层:切换助战(4)
    elseif 功能 & SDL.KMOD_CTRL ~= 0 and 键码 == SDL.KEY_5 then
        __gui.窗口层:切换助战(5)
    end

    if not gge.isdebug then
        return
    end

    if 状态 and not 按住 then
        if 键码 == SDL.KEY_PRINTSCREEN then
            local path = string.format('screen/%s.png', os.date('%Y%m%d%H%M%S', os.time()))
            引擎:截图到文件(path, 'PNG')
            if __rol then
                __gui.界面层:添加聊天('截图已保存到->' .. path)
            end
        elseif 键码 == SDL.KEY_F2 then
        elseif 键码 == SDL.KEY_F3 then
        elseif 键码 == SDL.KEY_F4 then
        elseif 键码 == SDL.KEY_F5 then
        end
    end
end

function 引擎:窗口事件(消息, t)
    if 消息 == SDL.WINDOWEVENT_CLOSE then
        引擎:关闭()
    elseif 消息 == SDL.WINDOWEVENT_ENTER then
    elseif 消息 == SDL.WINDOWEVENT_FOCUS_LOST then
        if gge.platform == 'Windows' and __res then
            __res:暂停声音()
        end
    elseif 消息 == SDL.WINDOWEVENT_FOCUS_GAINED then
        if gge.platform == 'Windows' and __res then
            __res:恢复声音()
        end
    elseif 消息 == SDL.WINDOWEVENT_SIZE_CHANGED then
        __gui:重新初始化('地图层')
        __gui:重新初始化('战场层')
        __gui:重新初始化('界面层')
        __gui:重新初始化('窗口层')

        if __rol and __map then
            __map:置宽高(self.宽度, self.高度)
        end

        if 引擎.宽高事件回调 then
            引擎.宽高事件回调()
            引擎.宽高事件回调 = nil
        end
    elseif 消息 == SDL.WINDOWEVENT_SHOWN then
        if loading then
            loading:关闭() --加载窗口
            package.loaded['窗口/载入'] = nil
            loading = nil
        end
        if __res then
            __res:登录音乐()
        end
    end
end

function 引擎:销毁事件()
    __rol = nil
    __map = nil
    collectgarbage()
end

function 引擎:多开器事件()
end

function 引擎:错误事件(消息)
    __gui.界面层:添加聊天('#Y' .. 消息)
end
