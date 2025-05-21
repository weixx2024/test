

local 确认窗口 = 窗口层:创建我的窗口('确认窗口', 0, 0, 400, 160)
function 确认窗口:初始化()
    self:置精灵(__res:getspr('ui/qrck.png'))
end

function 确认窗口:可见事件(v)
    if not v and 确认窗口.co then
        确认窗口:置可见(false)
        coroutine.resume(确认窗口.co, false)
    end
end

local 文本 = 确认窗口:创建我的文本('文本', 20, 40, 355, 65)

local 确定按钮 = 确认窗口:创建小按钮('确定按钮', 100, 115, '确定')
function 确定按钮:左键弹起()
    if 确认窗口.co then
        coroutine.resume(确认窗口.co, true)
        确认窗口.co = nil
        确认窗口:置可见(false)
    end
end

function 确定按钮:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
        self:左键弹起()
    end
end

local 取消按钮 = 确认窗口:创建小按钮('取消按钮', 240, 115, '取消')
function 取消按钮:左键弹起()
    确认窗口:置可见(false)
end

function 窗口层:确认窗口(s, ...)
    确认窗口:置可见(true)
    确认窗口:置坐标(引擎.宽度2 - 200, 引擎.高度2 - 80)
    s = tostring(s)
    if select('#', ...) > 0 then
        s = s:format(...)
    end
    文本:置文本(s)
    确认窗口.co = coroutine.running()
    return coroutine.yield()
end

function RPC:确认窗口(...)
    return 窗口层:确认窗口(...)
end
return 确认窗口
