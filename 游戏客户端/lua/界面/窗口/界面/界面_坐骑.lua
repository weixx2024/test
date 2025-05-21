

local 坐骑 = 窗口层:创建我的窗口('坐骑', 0, 0, 329, 448)
function 坐骑:初始化()
    self:置精灵(__res:getspr('gires/0x433F5919.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.动画 = require('对象/基类/动作') { 外形 = 1, 模型 = 'guard' }
end

function 坐骑:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
end

function 坐骑:显示(x, y)
    if self.动画 then
        self.动画:显示(x + 80, y + 200)
    end
end

function 坐骑:置动画(id)
    self.动画 = nil
    if id then
        self.动画 = require('对象/基类/动作') { 外形 = id, 模型 = 'guard' }
        self.动画:置循环(true)
    end

end

function 坐骑:刷新属性(t)
    if type(t) ~= "table" then
        return
    end
    local s = "%s/%s"
    for k, v in pairs(t) do
        if self[k .. "文本"] then
            if k == "体力" or k == "经验" then
                self[k .. "文本"]:置文本(s:format(v, t["最大" .. k]))
            else
                self[k .. "文本"]:置文本(v)
            end
        end
    end
    self.乘骑按钮:置选中(t.是否乘骑)
    _选择坐骑数据 = t




    坐骑:置动画(t.外形)
end

坐骑:创建关闭按钮(0, 1)
--====================================================================

for i, v in ipairs {
    { name = '等级', x = 216, y = 37, k = 96, g = 15 },
    { name = '体力', x = 216, y = 74, k = 96, g = 15 },
    { name = '灵性', x = 216, y = 110, k = 96, g = 15 },
    { name = '力量', x = 216, y = 145, k = 96, g = 15 },
    { name = '根骨', x = 216, y = 180, k = 96, g = 15 },
    { name = '经验', x = 216, y = 214, k = 96, g = 15 }
} do
    local 文本 = 坐骑:创建文本(v.name .. '文本', v.x, v.y, v.k, v.g)
    文本:置文字(__res.F15)
    if v.txt then
        文本:置提示('#Y' .. v.txt)
    end
    文本:置文本('123')
end
--====================================================================
local 坐骑列表 = 坐骑:创建列表('坐骑列表', 17, 263, 134, 129)
do
    function 坐骑列表:初始化()
        self:置文字(self:取文字():置颜色(255, 255, 255, 255):置大小(16))
        self:置项目颜色(1, 187, 165, 75)
    end

    function 坐骑列表:添加坐骑(i, t)
        local 名称 = t.名称
        if t.是否乘骑 then
            名称 = 名称 .. '(*)'
        end
        local r = self:添加(名称)
        r:取精灵():置中心(0, -2)
        r:置高度(20)
        r.外形 = t.外形
        r.nid = t.nid
        r.原名 = t.名称
    end

    function 坐骑列表:左键弹起(x, y, i, t)
        local r = __rpc:坐骑_取窗口属性(t.nid)
        坐骑:刷新属性(r)

    end

end

--====================================================================
local 召唤列表 = 坐骑:创建多列列表('召唤列表', 171, 263, 121+23, 129)
do
    function 召唤列表:初始化()
        self:置选中精灵宽度(120)
        self:置文字(self:取文字():置颜色(255, 255, 255, 255):置大小(16))
        self:添加列(0, 0, 70, 20) --召唤兽名称
        self:添加列(70, 0, 50, 20) --坐骑名称
    end

    function 召唤列表:添加召唤(i, t)
         local ys = "#W"
        local 管制名称 = ""
        if t.被管制 then
            ys = "#G"
            管制名称 = t.被管制.名称
        end

        local r = self:添加(ys..t.名称,ys.. 管制名称)
        r.nid = t.nid
    end

    function 召唤列表:左键弹起(x, y, i, t)
        _选择召唤数据 = t
    end

    召唤列表:创建我的滑块()
end



local 乘骑按钮 = 坐骑:创建多选按钮('乘骑按钮', 20, 405)
function 乘骑按钮:初始化()
    do
        self:置正常精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 1, '乘骑'))
        self:置按下精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 2, '乘骑'))
        self:置经过精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 3, '乘骑'))

        self:置选中正常精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 1, '下乘'))
        self:置选中按下精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 2, '下乘'))
        self:置选中经过精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 3, '下乘'))
    end

    self:注册事件(
        self,
        {
            获得鼠标 = function(_, x, y)
                GUI.鼠标层:手指形状()
            end
        }
    )
end

function 乘骑按钮:左键弹起()
    if _选择坐骑数据 then
        coroutine.xpcall(
            function()
                local r = __rpc:坐骑_乘骑(_选择坐骑数据.nid, not self.是否选中)
                if type(r) == 'string' then
                    窗口层:提示窗口(r)
                elseif r == true then
                    for k, v in 坐骑列表:遍历项目() do
                        坐骑列表:置文本(k, v.原名)
                        if k == 坐骑列表.选中行 then
                            坐骑列表:置文本(k, _选择坐骑数据.名称 .. '*')
                        end
                    end
                else
                    for k, v in 坐骑列表:遍历项目() do
                        坐骑列表:置文本(k, v.原名)
                    end
                end

            end
        )
        return true
    end
    return false
end

for k, v in pairs { '技能', '喂养', '管制' } do
    local 按钮 = 坐骑:创建小按钮(v .. '按钮', 100 + k * 80 - 80, 405, v)

    function 按钮:左键弹起()
        if v == "技能" then
            if _选择坐骑数据 then
                窗口层:打开坐骑技能(_选择坐骑数据.nid)
            end
        elseif v == "管制" then
            if _选择坐骑数据 and _选择召唤数据 then
                local r = __rpc:坐骑_管制召唤(_选择坐骑数据.nid, _选择召唤数据.nid)
                if r == 0 then --取消管制
                    召唤列表:清空()
                    for a, b in pairs(召唤数据) do
                        if b.nid==_选择召唤数据.nid then
                            b.被管制=nil
                        end
                        召唤列表:添加召唤(a, b)
                    end
                    _选择召唤数据=nil
                    --召唤列表:置文本(召唤列表.选中行,"召唤兽"  )
                elseif r == 1 then --被管制
                    召唤列表:清空()
                    for a, b in pairs(召唤数据) do
                        if b.nid==_选择召唤数据.nid then
                            b.被管制={nid=_选择坐骑数据.nid,名称=_选择坐骑数据.名称}
                        end
                        召唤列表:添加召唤(a, b)
                    end
                    _选择召唤数据=nil
                    --召唤列表:置文本(召唤列表.选中行,"#G召唤兽" ,"#G坐骑"  )
                elseif type(r)=="string" then
                        窗口层:提示窗口(r)

                end
            else
                窗口层:提示窗口("#Y请先选中需要操作的坐骑或者召唤兽")
            end
        end
    end
end


function 窗口层:打开坐骑()
    坐骑:置可见(not 坐骑.是否可见)
    if not 坐骑.是否可见 then
        return
    end
    local list, list2 = __rpc:角色_打开坐骑窗口()

    if type(list) ~= 'table' or type(list2) ~= 'table' then
        return
    end
    坐骑列表:清空()
    召唤列表:清空()
    _选择坐骑数据 = nil
    _选择召唤数据 = nil
    坐骑:置动画()
    坐骑排序(list)
    坐骑数据 = list
    for i, v in ipairs(list) do
        坐骑列表:添加坐骑(i, v)
        for c, d in pairs(v.管制) do
            for a, b in pairs(list2) do
                if d==b.nid then
                    b.被管制 = { nid = v.nid, 名称 = v.名称 }
                end
            end
        end
    end
    时间排序(list2)
    召唤数据 = list2
    for i, v in ipairs(list2) do
        召唤列表:添加召唤(i, v)
    end
end

function RPC:刷新坐骑信息(k, v)
    if 坐骑.是否可见 then
        if 坐骑[k .. "文本"] then
            坐骑[k .. "文本"]:置文本(v)
        end
    end

end

return 坐骑
