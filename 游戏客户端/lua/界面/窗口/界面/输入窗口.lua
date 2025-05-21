

local 输入窗口 = 窗口层:创建我的窗口('输入窗口', 0, 0, 430, 130)
function 输入窗口:初始化()
    self:置精灵(__res:getspr('gires/0x05784154.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 输入窗口:可见事件(v)
    if not v and 输入窗口.co then
        输入窗口:置可见(false)
        coroutine.resume(输入窗口.co, false)
    end
end

local 描述文本 = 输入窗口:创建我的文本('描述文本', 40, 15, 355, 40)
local 输入控件
local 文本输入 = 输入窗口:创建文本输入('文本输入', 45, 70, 345, 15)
local 数字输入 = 输入窗口:创建数字输入('数字输入', 45, 70, 345, 15)
文本输入:置颜色(255, 255, 255, 255)
数字输入:置颜色(255, 255, 255, 255)

local 确定按钮 = 输入窗口:创建小按钮('确定按钮', 280, 95, '确定')
function 确定按钮:左键弹起()
    local r=输入控件:取内容()
    if require("数据/敏感词库")(r, 1) then
        窗口层:提示窗口("#Y你的输入的内容包含敏感词汇！")
        return
    end


    if  string.find( r,"#") then 
        窗口层:提示窗口("#Y你的输入的名称包含特殊符号！")
        return
    end




    coroutine.resume(输入窗口.co, r)
    输入窗口.co = nil
    输入窗口:置可见(false)
end

function 确定按钮:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
        self:左键弹起()
    end
end

local 取消按钮 = 输入窗口:创建小按钮('取消按钮', 340, 95, '取消')
function 取消按钮:左键弹起()
    输入窗口:置可见(false)
end

local function 打开输入(s, ...)
    if select('#', ...) > 0 then
        s = s:format(...)
    end
    输入窗口:置可见(true)
    输入窗口:置坐标(引擎.宽度2 - 214, 引擎.高度2 - 65)
    描述文本:置文本(s)
    输入窗口.co = coroutine.running()
    输入控件:清空()
    输入控件:置焦点(true)
end

function 窗口层:输入窗口(v,...)
    输入控件 = 文本输入
    打开输入(...)
    数字输入:置可见(false)
    文本输入:置可见(true)
    
    输入控件:置文本(v)
    return coroutine.yield()
end

function 窗口层:整数输入窗口(v,...)
    输入控件 = 数字输入
    打开输入(...)
    数字输入:置可见(true)
    文本输入:置可见(false)
    
    
    输入控件:置文本(v)
    return coroutine.yield()
end

function RPC:数值输入窗口(v,...)
    return 窗口层:整数输入窗口(v,...)
end

function RPC:输入窗口(v,...)
    return 窗口层:输入窗口(v,...)
end







return 输入窗口
