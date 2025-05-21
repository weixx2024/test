

local 物品 = 窗口层:创建我的窗口('召唤兽物品', 0, 0, 366, 315)

function 物品:初始化()
    self:置精灵(__res:getspr('ui/zhswp.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

--===============================================================================================
local 道具网格 = 物品:创建物品网格2('道具网格', 22, 42, 305, 203)
local 禁止精灵 = require('SDL.精灵')(0, 0, 0, 50, 50):置颜色(0, 0, 0, 180)
function 道具网格:前显示2(x, y, i)
    if self.数据[i] and not self.数据[i].召唤是否可用 then
        禁止精灵:显示(x, y)
    end
end

function 道具网格:获取道具(p)
    return __rpc:角色_物品列表(p, true)
end

function 道具网格:右键弹起(x, y, i)
    local m = self.数据[i]
    if m and m.召唤是否可用 and _数据 then
        self:物品提示()
        local r, v = __rpc:召唤_物品使用(_数据.nid, m.I)
        if r == 1 and type(v) == 'table' then --更新
            m:刷新(v)
        elseif r == 2 then --删除
            m:删除()
            self.当前选中 = nil
        elseif type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif type(v) == 'string' then
            窗口层:提示窗口(v)
        else
            窗口层:提示窗口('#R该物品无法使用。')
        end
    end
end

--=========================================================================================================

物品:创建关闭按钮(0, 1)
local 放生按钮 = 物品:创建中按钮('放生按钮', 52, 270, '放   生', 85)
function 放生按钮:左键弹起()
    if _数据 and 窗口层:确认窗口('真的要放生#R%s#W这个召唤兽吗？', _数据.名称) then
        local r = __rpc:召唤_放生(_数据.nid)
        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif r == true then
            窗口层:提示窗口("#Y已经成功放生#R".._数据.名称.."#Y召唤兽。")
            窗口层:放生召唤兽()
            物品:置可见(false)

        end
    end
end

local 使用按钮 = 物品:创建中按钮('使用按钮', 207, 270, '使   用', 85)
function 使用按钮:左键弹起()
    道具网格:右键弹起(x, y, 道具网格.当前选中)
end

function 窗口层:刷新召唤兽物品(r)
    if 物品.是否可见 then
        _数据 = r
    end
end

function 窗口层:打开召唤物品(r)
    物品:置可见(not 物品.是否可见)
    if not 物品.是否可见 then
        return
    end
    _数据 = r
    道具网格:打开()
end

return 物品
