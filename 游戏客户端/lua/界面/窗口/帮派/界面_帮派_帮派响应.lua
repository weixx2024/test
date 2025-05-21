

local 帮派响应 = 窗口层:创建我的窗口('帮派响应', 0, 0, 329, 425)
function 帮派响应:初始化()
    self:置精灵(__res:getspr('gires/0x39363774.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 帮派响应:显示(x, y)
end

帮派响应:创建关闭按钮(0, 1)
function 帮派响应:可见事件(v)
    if v == false and co then
        coroutine.resume(co)
    end
end

local 文本 = 帮派响应:创建我的文本("宗旨文本", 30, 237, 249, 142)
文本:创建我的文本("宗旨文本", 30, 237, 249, 142)
文本:创建我的滑块()
local 帮派列表 = 帮派响应:创建多列列表('帮派列表', 30, 56, 249+23, 142)
do
    function 帮派列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20)
        self:添加列(5, 3, 95, 20) --名称
        self:添加列(100, 3, 100, 20) --创始人
        self:添加列(215, 3, 58, 20) --响应人数
        self:置选中精灵宽度(249)
        -- for i = 1, 5 do
        --     self:添加('帮派名称' .. i, '1转155', 0)
        -- end
    end

    function 帮派列表:添加帮派(i, t)
        local r = self:添加(t.名称, t.创始人, t.响应)
        r.帮派名称 = t.名称
        r.宗旨 = t.宗旨
    end

    function 帮派列表:左键弹起(x, y, i, t)
        _响应帮派 = t.帮派名称
        文本:置文本(t.宗旨)
    end

    帮派列表:创建我的滑块()
end

local 响应按钮 = 帮派响应:创建小按钮('响应按钮', 143, 393, '响应')

function 响应按钮:左键弹起()
    if _响应帮派 and co then
        coroutine.resume(co, _响应帮派)
        self.父控件:置可见(false)
    end
end

function 窗口层:打开帮派响应(t)
    帮派响应:置可见(not 帮派响应.是否可见)
    if not 帮派响应.是否可见 then
        return
    end
    帮派列表:清空()
    _响应帮派 = nil
    if type(t) ~= "table" then
        return
    end

    for k, v in pairs(t) do
        帮派列表:添加帮派(k, v)
    end


end

function RPC:响应帮派窗口(t)
    co = coroutine.running()
    窗口层:打开帮派响应(t)
    return coroutine.yield()
end

return 帮派响应
