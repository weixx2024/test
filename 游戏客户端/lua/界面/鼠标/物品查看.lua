

local SDL = require 'SDL'
local GUI = require '界面'


local 物品查看 = 窗口层:创建窗口('物品查看', 0, 0)
function 物品查看:显示(x, y)
    if self.图标 then
        self.图标:显示(x + 5, y + 5)
    end
    if self.印章 then
        self.印章:显示(x + 5, y + 5)
    end
end

local 提示文本 = 物品查看:创建文本('提示文本', 125, 5, 185, 600)
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


function 物品查看:左键弹起(x, y)
    if gge.platform ~= 'Windows' then
        物品查看:置可见(false)
    end
end

local 类型字体 = __res:getfont('simsun.ttc', 14, true, 13):置颜色(255, 0, 0) --FIXME
local _t
function 窗口层:打开物品提示(t)
    if type(t) ~= 'table' then
        物品查看:置可见(false)
        return
    end

    if t == _t and t.刷新显示 == false then
        物品查看:置可见(true)
        return
    end
    _t = t
    t.刷新显示 = false

    local txt = string.format('#Y#F名称19:%s#r#W#F默认14:%s#r', t.名称, t.描述)

    if t.属性 then
        txt = txt .. t.属性
    end

    local _, h = 提示文本:置文本(txt)
    h = h + 10
    if h < 160 then
        h = 160
    end
    物品查看.图标 = t.图标120
    物品查看.印章 = self:取拉伸精灵_高度('gires3/button/szyzk.tcp', utf8.len(t.类别) * 16 + 4,
    类型字体:取图像(t.类别):置中心(-2, -2))
    物品查看:置精灵(self:取拉伸精灵_宽高('gires4/jdmh/yjan/tmk2.tcp', 310, h), true)
    物品查看:置坐标((引擎.宽度 - 物品查看.宽度) // 2, (引擎.高度 - 物品查看.高度) // 2)
    物品查看:置可见(true, true)
end
