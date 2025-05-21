

local 确认数据窗口 = 窗口层:创建我的窗口('确认数据窗口', 0, 0, 400, 160)
function 确认数据窗口:初始化()
    self:置精灵(__res:getspr('ui/qrck.png'))
end

function 确认数据窗口:可见事件(v)
    if not v and 确认数据窗口.co then
        确认数据窗口:置可见(false)
        coroutine.resume(确认数据窗口.co, false)
    end
end

local 文本 = 确认数据窗口:创建我的文本('文本', 20, 40, 355, 65)

local 确定按钮 = 确认数据窗口:创建小按钮('确定按钮', 100, 115, '确定')
function 确定按钮:左键弹起()
    __rpc:角色_指定召唤兽领悟技能(确认数据窗口.nid,true)
    确认数据窗口:置可见(false)
end

function 确定按钮:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
        self:左键弹起()
    end
end

local 取消按钮 = 确认数据窗口:创建小按钮('取消按钮', 240, 115, '取消')
function 取消按钮:左键弹起()
    __rpc:角色_指定召唤兽领悟技能(确认数据窗口.nid,false)
    确认数据窗口:置可见(false)
end

function 窗口层:确认数据窗口(s, ...)
    确认数据窗口:置可见(true)
    确认数据窗口:置坐标(引擎.宽度2 - 200, 引擎.高度2 - 80)
    s = tostring(s)
    if select('#', ...) > 0 then
        s = s:format(...)
    end
    确认数据窗口.nid = ...
    文本:置文本(s)
end

function RPC:确认数据窗口(...)
    return 窗口层:确认数据窗口(...)
end
return 确认数据窗口
