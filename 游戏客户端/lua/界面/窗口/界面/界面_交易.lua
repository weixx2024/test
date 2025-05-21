

local 交易 = 窗口层:创建我的窗口('物品交易', 0, 0, 531, 496)
--29E319DD 307-391
function 交易:初始化()
    self:置精灵(__res:getspr('ui/jiaoyi.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.禁止滚动=true
end

function 交易:可见事件(v)
    if v == false and self.是否可见 then
        __rpc:角色_交易结束()
    end
end

交易:创建关闭按钮()

--===============================================================================================
for i = 1, 3 do
    local 我方召唤 = 交易:创建文字按钮2('我方召唤' .. i, 22, 296 + i * 21 - 21)

    function 我方召唤:左键弹起(x, y)
        if self.nid then
            local t, d = __rpc:角色_查看对象(self.nid)
            if t == 2 then --召唤
                窗口层:打开召唤兽查看(d)
            end
        end
    end

    function 我方召唤:右键弹起(x, y)
        self:置可见(false)
    end
end

local 召唤列表 = 交易:创建列表('召唤列表', 23, 64, 134, 155)
do
    function 召唤列表:初始化()
        self:置文字(__res.F18:置颜色(255, 255, 255))

        self.禁止精灵 = require('SDL.精灵')(0, 0, 0, 134, 155):置颜色(50, 50, 50, 100)
    end

    function 召唤列表:前显示(x, y)
        if self.是否禁止 then
            self.禁止精灵:显示(x, y)
        end
    end

    function 召唤列表:添加召唤(t)
        local r = self:添加(t.名称)
        r:取精灵():置中心(0, -2)
        r:置高度(20)
        r.nid  = t.nid
        r.禁止交易= t.禁止交易
    end

    function 召唤列表:左键弹起(x, y, i, t)
        for i = 1, 3 do
            local 我方召唤 = 交易['我方召唤'..i]
            if  我方召唤.是否可见 then
                if 我方召唤.nid==t.nid then
                    return 
                end
            end
        end

        for i = 1, 3 do
            local 我方召唤 = 交易['我方召唤'..i]
            if not 我方召唤.是否可见 then
                我方召唤.nid = t.nid
                我方召唤:置文本(t.名称)
                我方召唤:置宽度(82)
                我方召唤:置可见(true)
                break
            end
        end
    end
end
召唤列表:创建我的滑块()

--===============================================================================================
local 道具网格 = 交易:创建物品网格2('道具网格', 188, 44, 309, 207)
do
    function 道具网格:初始化()
        self.禁止精灵 = require('SDL.精灵')(0, 0, 0, 309, 207):置颜色(50, 50, 50, 100)
        self.提交 = {}
    end

    function 道具网格:前显示(x, y)
        if self.是否禁止 then
            self.禁止精灵:显示(x, y)
        end
    end

    function 道具网格:左键弹起(x, y, i)
        if self.数据[i] and self.数据[i].禁止交易 then
            return
        end
        if self.数据[i] then
            if self.数据[i].sell then
                self.数据[i]:提交()
                return
            end
            for n = 1, 10 do
                if not 交易.我方道具网格.数据[n] then
                    交易.我方道具网格:添加(n, self.数据[i]:提交())
                    return
                end
            end
        end
    end
end

--===============================================================================================


local 我方现金 = 交易:创建文本('我方现金', 60, 235, 117, 14)

local 我方道具网格 = 交易:创建物品网格('我方道具网格', 14, 306, 207, 156)
do
    function 我方道具网格:初始化()
        self:添加格子(103, 2, 50, 50)
        self:添加格子(154, 2, 50, 50)
        for i = 1, 8 do
            if i <= 4 then
                self:添加格子(1 + i * 51 - 51, 53, 50, 50)
            else
                self:添加格子(1 + (i - 4) * 51 - 51, 104, 50, 50)
            end
        end
    end

    function 我方道具网格:清空()
        self.数据 = {}
    end
end

local 我方银两 = 交易:创建数字输入('我方银两', 60, 257, 117, 15)
我方银两:置颜色(255, 255, 255, 255)

local 我方确认 = 交易:创建我的多选按钮('我方确认', 122, 277)
function 我方确认:左键弹起()
    我方确认:置禁止(true)
    召唤列表:置禁止(true)
    道具网格:置禁止(true)
    我方银两:置禁止(true)
    local 银两 = 我方银两:取数值()
    local 召唤 = {}
    for i = 1, 3 do
        local 我方召唤 = 交易['我方召唤' .. i]
        if 我方召唤.是否可见 then
            table.insert(召唤, 我方召唤.nid)
        end
    end
    local 物品 = {}
    for i = 1, 10 do
        local t = 我方道具网格.数据[i]
        if t then
            table.insert(物品, { id = t.self.I, 数量 = t.数量 })
        end
    end

    local r = __rpc:角色_交易确认(银两, 召唤, 物品)
    if type(r)=='string' then
        窗口层:提示窗口(r)
    end
end

local 确定按钮 = 交易:创建小按钮('确定按钮', 155, 277, '确定')
function 确定按钮:左键弹起()
    __rpc:角色_交易确定()
end

--===============================================================================================
local 对方确认 = 交易:创建多选按钮('对方确认', 477, 256)
function 对方确认:初始化()
    self:置禁止精灵(__res:getspr('gires/0x337A55AC.tcp'))
    self:置选中禁止精灵(取按钮精灵('gires/0x337A55AC.tcp', 1, '√'))
    self:置禁止(true)
end

for i = 1, 3 do
    local 对方召唤 = 交易:创建文字按钮2('对方召唤' .. i, 412, 296 + i * 21 - 21, '1123123')

    function 对方召唤:左键弹起(x, y)
        if self.nid then
            local t, d = __rpc:角色_查看对象(self.nid)
            if t == 2 then --召唤
                窗口层:打开召唤兽查看(d)
            end
        end
    end
end


local 对方银两 = 交易:创建文本('对方银两', 350, 261, 117, 14)
local 对方名字 = 交易:创建文本('对方名字', 280, 280, 117, 14)
local 对方道具网格 = 交易:创建物品网格('对方道具网格', 286, 306, 207, 156)
do
    function 对方道具网格:初始化()
        self:添加格子(1, 2, 50, 50)
        self:添加格子(52, 2, 50, 50)
        for i = 1, 8 do
            if i <= 4 then
                self:添加格子(1 + i * 51 - 51, 53, 50, 50)
            else
                self:添加格子(1 + (i - 4) * 51 - 51, 104, 50, 50)
            end
        end
    end

    function 对方道具网格:清空()
        self.数据 = {}
    end
end

function 窗口层:打开交易(名字, 银子, 召唤)
    交易:置可见(true)
    对方确认:置选中(false)
    我方确认:置选中(false):置禁止(false)
    我方银两:置文本(''):置禁止(false)
    我方银两.最大值 = 银子
    我方现金:置文本(银两颜色(银子))
    召唤列表:置禁止(false)
    道具网格:置禁止(false)

    我方道具网格:清空()
    对方道具网格:清空()
    对方名字:置文本('#Y' .. 名字)
    对方银两:置文本('')
    for i = 1, 3 do
        交易['我方召唤' .. i]:置可见(false)
        交易['对方召唤' .. i]:置可见(false)
    end
    _选中召唤兽={}
    召唤列表:清空()
    for _, v in ipairs(召唤) do
        召唤列表:添加召唤(v)
    end
    道具网格:刷新道具()
    道具网格:打开()
end

function RPC:交易窗口(名字, 银子, 召唤)
    for _, v in ipairs(_物品) do
        for _, vv in pairs(v) do
            vv:清空提交()
        end
    end
    if 银子 then
        窗口层:打开交易(名字, 银子, 召唤)
    else
        交易:置可见(false)
    end
end

function RPC:交易确认(银子, 召唤, 物品)
    对方银两:置文本(银两颜色(银子))
    for i, t in ipairs(召唤) do
        local 对方召唤 = 交易['对方召唤' .. i]
        对方召唤.nid = t.nid
        对方召唤:置文本(t.名称)
        对方召唤:置宽度(82)
        对方召唤:置可见(true)
    end

    for i, v in ipairs(物品) do
        对方道具网格:添加(i, v)
    end
    对方确认:置选中(true)
end

return 交易
