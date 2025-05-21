

local 灯谜窗口 = 窗口层:创建我的窗口('灯谜窗口', 0, 0, 196, 479)
function 灯谜窗口:初始化()
    self:置精灵(__res:getspr('gires2/dialog/dmjm.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 灯谜窗口:可见事件(v)
    if not v and 灯谜窗口.co then
        灯谜窗口:置可见(false)
        coroutine.resume(灯谜窗口.co, false)
    end
end

local 描述文本 = 灯谜窗口:创建我的文本('描述文本', 32, 180, 130, 240)
local 输入控件
local 文本输入 = 灯谜窗口:创建文本输入('文本输入', 51, 430, 100, 15)
--local 数字输入 = 灯谜窗口:创建数字输入('数字输入', 45, 70, 345, 15)
文本输入:置颜色(255, 255, 255, 255)
--数字输入:置颜色(255, 255, 255, 255)

local 确定按钮 = 灯谜窗口:创建小按钮('确定按钮', 280, 95, '确定')
function 确定按钮:左键弹起()
    local r=输入控件:取内容()
    coroutine.resume(灯谜窗口.co, r)
    灯谜窗口.co = nil
    灯谜窗口:置可见(false)
end

function 确定按钮:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
        self:左键弹起()
    end
end

local 取消按钮 = 灯谜窗口:创建小按钮('取消按钮', 340, 95, '取消')
function 取消按钮:左键弹起()
    灯谜窗口:置可见(false)
end

local function 打开输入(s, ...)
    if select('#', ...) > 0 then
        s = s:format(...)
    end
    灯谜窗口:置可见(true)
  --  灯谜窗口:置坐标(引擎.宽度2 - 214, 引擎.高度2 - 65)
    描述文本:置文本(s)
    灯谜窗口.co = coroutine.running()
    输入控件:清空()
    输入控件:置焦点(true)
end

function 窗口层:灯谜窗口(v,...)
    输入控件 = 文本输入
    打开输入(v,...)
    文本输入:置可见(true)
    输入控件:置文本("")
    return coroutine.yield()
end


function RPC:灯谜窗口(v,...)
    return 窗口层:灯谜窗口(v,...)
end







return 灯谜窗口
