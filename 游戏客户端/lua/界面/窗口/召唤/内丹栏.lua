


local 内丹栏 = 窗口层:创建我的窗口('内丹栏', 0, 0, 251, 356)
function 内丹栏:初始化()
    self:置精灵(__res:getspr('ui/ndl.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

内丹栏:创建关闭按钮()

local 内丹列表 = 内丹栏:创建网格('内丹列表', 80, 30, 77, 17)
do
    内丹列表.rect = require('SDL.矩形')(0, 0, 17, 17)
    function 内丹列表:添加内丹(i, t)
        local r = self:添加格子((i - 1) * 30, 0, 17, 17)

        local 按钮 = r:创建按钮('内丹按钮', 1, 1)
        function 按钮:初始化(v)
            self:设置按钮精灵('gires4/%s/yjan/ndan.tcp', v or 'jdmh')
        end

        function 按钮:左键弹起(v)
            _选中 = i
            内丹栏:刷新内丹数据(_数据[i])
        end

        r:置可见(true, true)
    end

    function 内丹列表:子显示(x, y, i)
        if _选中 == i then
            self.rect:显示(x, y)
        end
    end
end
local 名称文本 = 内丹栏:创建文本("名称文本", 108, 88, 111, 14)
local 等级文本 = 内丹栏:创建文本("等级文本", 108, 111, 111, 14)
local 元气文本 = 内丹栏:创建文本("元气文本", 108, 134, 111, 14)
local 经验文本 = 内丹栏:创建文本("经验文本", 66, 268, 151, 14)
local 介绍文本 = 内丹栏:创建文本("介绍文本", 31, 162, 187, 92)

local 转换经验按钮 = 内丹栏:创建中按钮('转换经验按钮', 25, 296, '转换经验')
function 转换经验按钮:左键弹起()
    if _数据[_选中] and _携带者 then
        local r = __rpc:召唤_内丹经验转换(_携带者, _数据[_选中].名称)
        if type(r) == 'string' then
            窗口层:提示窗口(r)
        end
    end
end

local 吐出内丹按钮 = 内丹栏:创建中按钮('吐出内丹按钮', 135, 296, '吐出内丹')
function 吐出内丹按钮:左键弹起()
    if _数据[_选中] and _携带者 then
        if 窗口层:确认窗口("吐出内丹将使该内丹等级#R降低3级#W，您确定要吐出这颗内丹吗?") then
            local r = __rpc:召唤_吐出内丹(_携带者, _数据[_选中].名称)
            if type(r) == 'string' then
                窗口层:提示窗口(r)
            elseif r == true then
                local list = __rpc:召唤_取内丹列表(_携带者)
                窗口层:刷新召唤兽内丹(list)
                内丹栏:置可见(false)
            end
        end
    end
end

function 内丹栏:刷新内丹数据(t)
    if t then
        名称文本:置文本(t.名称)
        介绍文本:置文本(t.描述)
        if t.点化 ~= 0 then
            等级文本:置文本("点化" .. t.等级 .. "级")
        else
            if t.转生 > 0 then
                等级文本:置文本(t.转生 .. "转" .. t.等级 .. "级")
            else
                等级文本:置文本(t.等级 .. "级")
            end
        end
        元气文本:置文本(t.元气 .. "/" .. t.最大元气)
        经验文本:置文本(t.经验 .. "/" .. t.最大经验)
    end
end

function 内丹栏:刷新内丹列表()
    if _携带者 then
        local t = __rpc:召唤_取内丹列表(_携带者)
        _数据 = t
        内丹列表:删除格子()
        for k, v in pairs(t) do
            内丹列表:添加内丹(k, v)
        end
        内丹列表:置坐标((251 - 17 - (#t - 1) * 30) // 2, 45)
        内丹列表[_选中].内丹按钮:左键弹起()
    end
end

function 窗口层:打开内丹栏(携带者, i)
    内丹栏:置可见(true)

    _携带者 = 携带者
    _选中 = i
    if not _选中 then
        _选中 = 1
    end
    内丹栏:刷新内丹列表()
end

function 窗口层:重新打开内丹栏(nid)
    if nid ~= _携带者 then
        内丹栏:置可见(false)
    end
    内丹栏:刷新内丹列表()
end

return 内丹栏
