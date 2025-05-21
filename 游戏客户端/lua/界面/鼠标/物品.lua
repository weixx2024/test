

local SDL = require 'SDL'
local GUI = require '界面'
local GUI控件 = require('GUI.控件')
local jjy = __res:getspr('gires4/ty/jy/jjy.tcp')
local 提示控件 = GUI:创建提示控件('提示控件', 0, 0)
function 提示控件:显示(x, y)
    if self.图标 then
        self.图标:显示(x + 5, y + 5)
    end
    if self.印章 then
        self.印章:显示(x + 5, y + 5)
    end
end

function 提示控件:前显示(x, y)
    if self.禁止交易 then
        jjy:显示(x + 225, y + 5)
    end
end

local 提示文本 = 提示控件:创建文本('提示文本', 125, 5, 185, 600)
do
    提示文本.行间距 = 2
    提示文本:添加文字('名称', __res:getfont('simsun.ttc', 19, true):置颜色(255, 255, 115):置样式(SDL.TTF_STYLE_BOLD))

    local 宝石 = {
        __res:getsf('item/item120/25594.png'):置拉伸(20, 20):到精灵():置中心(0, 16),
        __res:getsf('item/item120/25604.png'):置拉伸(20, 20):到精灵():置中心(0, 16),
        __res:getsf('item/item120/25614.png'):置拉伸(20, 20):到精灵():置中心(0, 16)
    }
    for i, v in ipairs(宝石) do
        v.高度 = 15
        v.宽度 = 15 
    end
    提示文本:置精灵表(宝石)
end





-- if gge.platform ~= 'Windows' then

--     local 发送按钮 = 提示控件:创建小按钮('发送按钮', 5, 130, "发送")

--     local 丢弃按钮 = 提示控件:创建小按钮('丢弃按钮', 55, 130, "丢弃")
--     function 发送按钮:左键弹起(v)
--         if 提示控件.数据 then
--             界面层:输入对象(提示控件.数据)
--         end
--     end
--     function 丢弃按钮:左键弹起(v)
--         if 提示控件.数据 then
--             提示控件.数据:丢弃()
--         end
--     end

-- end



function 提示控件:可见事件(v)

    if not v then
        self.数据 = nil
    end

end

local 类型字体 = __res:getfont('simsun.ttc', 14, true, 13):置颜色(255, 0, 0) --FIXME
local _t
function GUI控件:物品提示(x, y, t)
    if type(t) ~= 'table' then
        提示控件:置可见(false)
        return
    end

    if x .. y .. tostring(t) == _t and t.刷新显示 == false then
        提示控件:置可见(true)
        return
    end
    _t = x .. y .. tostring(t)
    t.刷新显示 = false
    local txt = string.format('#Y#F名称19:%s#r#W#F默认13:%s#r', t.名称, t.描述)

    if t.属性 and type(t.属性) == "string" then
        txt = txt .. t.属性
    end
    -- for i = 1, 2 do
    --     txt = txt .. string.format('#Y属性属性 %d#r', i)
    -- end
    -- for i = 1, 2 do
    --     txt = txt .. string.format('#C属性属性 %d#r', i)
    -- end
    -- for i = 1, 2 do
    --     txt = txt .. string.format('#cE89A4D属性属性 %d#r', i)
    -- end
    -- for i = 1, 3 do
    --     txt = txt .. string.format('#%d#cC15D32 99级 属性属性 %d%%#r', i, 999)
    -- end

    -- txt = txt .. string.format('#W【炼器】#C属性属性 %d#r', 999)
    -- for i = 1, 2 do
    --     txt = txt .. string.format('#G属性属性 %d#r', i)
    -- end
    -- txt = txt .. string.format('#cA0A0C8特技#r')
    -- for i = 1, 2 do
    --     txt = txt .. string.format('#cA0A0C8属性属性 %d#r', i)
    -- end

    local _, h = 提示文本:置文本(txt)
    h = h + 10

    if h < 160 then
        h = 160
    end

    if x + 310 > 引擎.宽度 then
        x = 引擎.宽度 - 310
    end

    if y + h > 引擎.高度 then
        y = 引擎.高度 - h
    end
    提示控件.数据 = t
    提示控件.禁止交易 = t.禁止交易
    提示控件.图标 = t.图标120
    提示控件.印章 = self:取拉伸精灵_高度('gires3/button/szyzk.tcp', utf8.len(t.类别) * 16 + 4,
        类型字体:取图像(t.类别):置中心(-2, -2))
    提示控件:置中心(-x, -y)
    提示控件:置精灵(self:取拉伸精灵_宽高('gires4/jdmh/yjan/tmk2.tcp', 310, h), true)
    提示控件:置可见(true, true)
end
