local 技能库 = require('数据/技能库')

local 法术界面 = 窗口层:创建我的窗口('法术界面')
function 法术界面:初始化()
    self:置精灵(self:取拉伸精灵_宽高('gires/main/border.bmp', 274, 350))
end

local x, y = 0, 10
local 小叹号 = __res:getspr('gires4/ty/xth.tcp')
for i, v in ipairs { '技能1', '技能2' } do
    local 区域 = 法术界面:创建控件('区域' .. i, x, y, 137, 350)
    do
        -- local 技能 = 区域:创建文本('文本', 0, 0, 20, 150)
        -- 技能:置文字(__res.F16B)
        -- 技能:置文本('#cCBB55B' .. v)
        local 列表 = 区域:创建列表('列表', 0, 0, 137, 350)
        列表.行高度 = 25
        -- 列表.行间距 = 3
        列表.选中精灵 = nil
        列表.焦点精灵 = nil
        function 列表:检查消息(v)
            if v == SDL.MOUSE_DOWN or v == SDL.MOUSE_UP then
                return false
            end
        end

        function 列表:添加技能(t)
            local r = self:添加(t.名称):置精灵()
            --  r:置精灵(__res:getspr('magic/icon/%04d.png', t.图标 or 0):置拉伸(28, 28))
            function r:显示(x, y)
                if t.消耗MP and t.消耗MP > t.当前MP then
                    小叹号:显示(x + 13, y + 12)
                end
                if t.消耗HP and t.消耗HP > t.当前HP then
                    小叹号:显示(x + 13, y + 12)
                end
            end

            local 文本 = r:创建我的文本('文本', 30, 5, 90, 30)
            文本:置文字(__res.F16B)
            文本:置文本(t.名称)

            r:置可见(true, true)
            r.t = t
        end

        function 列表:获得鼠标(x, y, i, item)
            local t = item.t

            x, y = 法术界面:取坐标()
            鼠标层:技能提示(x, y, self.记录1)

            x, y = 引擎:取鼠标坐标()
            鼠标层:坐标提示(x + 35, y + 35, self.记录2)

            local 说明
            if 法术界面.是否召唤 then
                说明 = __rpc:召唤_战斗技能描述(法术界面.是否召唤, t.nid)
            else
                说明 = __rpc:角色_战斗技能描述(t.nid)
            end
            if t.门派 then
                x, y = 法术界面:取坐标()
                self.记录1 = string.format('消耗MP：%s,当前MP：%s', t.消耗MP, t.当前MP)
                鼠标层:技能提示(x, y, self.记录1)

                x, y = 引擎:取鼠标坐标()
                self.记录2 = string.format('【门派】%s#r【师傅】%s#r【法术系】%s#r【熟练度】%s#r【消耗MP】%s#r#G%s'
                , t.门派, t.师傅, t.法系, t.熟练度, t.消耗MP, 说明)
                鼠标层:坐标提示(x + 35, y + 35, self.记录2)
            else
                x, y = 法术界面:取坐标()
                self.记录1 = string.format('消耗MP：%s,当前MP：%s', t.消耗MP, t.当前MP)
                鼠标层:技能提示(x, y, self.记录1)

                x, y = 引擎:取鼠标坐标()
                self.记录2 = 说明
                鼠标层:坐标提示(x + 35, y + 35, self.记录2)
            end
        end

        function 列表:左键弹起(x, y, i, item)
            local t = item.t
            if t.nid then
                鼠标层:法术形状()
                法术界面:置可见(false)
                if 法术界面.是否召唤 then
                    鼠标层.召唤法术 = t
                else
                    鼠标层.角色法术 = t
                end
                鼠标层.法术 = t
                coroutine.resume(co, t.nid)
            end
        end

        -- 列表:添加技能({名称 = '作茧自缚', 图标 = 0})
        -- 列表:添加技能({名称 = '作茧自缚', 图标 = 1})
        -- 列表:添加技能({名称 = '作茧自缚', 图标 = 2})
        -- 列表:添加技能({名称 = '作茧自缚', 图标 = 3})
        -- 列表:添加技能({名称 = '作茧自缚', 图标 = 4})
    end
    x = 137
end






function 窗口层:打开人物法术界面()
    法术界面:置可见(true)
    法术界面.是否召唤 = nil
    for i = 1, 2 do
        local t = 法术界面['区域' .. i]
        t.列表:清空()
    end

    法术界面:置精灵(self:取拉伸精灵_宽高('gires/main/border.bmp', 274, 350), true)
    法术界面:置坐标((引擎.宽度 - 法术界面.宽度) // 2, (引擎.高度 - 法术界面.高度) // 2)

    local list, MP, HP = __rpc:角色_战斗技能列表()
    table.print(list)
    local nlist = {}
    for _, v in pairs(list) do
        if 技能库[v.名称] then
            v.当前MP = MP or 0
            v.当前HP = HP or 0
            v.消耗MP = v.消耗 and v.消耗.消耗MP or 0
            v.消耗HP = v.消耗 and v.消耗.消耗HP or 0
            setmetatable(v, { __index = 技能库[v.名称] })

            if v.区域 then
                v.位置 = v.区域 * 100 + v.位置
                table.insert(nlist, v)
            end
        end
    end

    table.sort(
        nlist,
        function(a, b)
            return a.位置 < b.位置
        end
    )

    for i, v in ipairs(nlist) do
        if i > 12 then --区域2
            法术界面.区域2.列表:添加技能(v)
        else           --区域1
            法术界面.区域1.列表:添加技能(v)
        end
    end

    co = coroutine.running()
    return coroutine.yield()
end

function 窗口层:打开召唤法术界面()
    法术界面:置可见(true)
    法术界面.是否召唤 = 战场层.sum.nid
    法术界面:置精灵(self:取拉伸精灵_宽高('gires/main/border.bmp', 274, 350), true)
    法术界面:置坐标((引擎.宽度 - 法术界面.宽度) // 2, (引擎.高度 - 法术界面.高度) // 2)
    local list, MP, HP = __rpc:召唤_战斗技能列表(战场层.sum.nid)
    if type(list) == 'table' then
        法术界面.区域1.列表:清空()
        法术界面.区域2.列表:清空()
        for k, v in pairs(list) do
            v.当前MP = MP or 0
            v.当前HP = HP or 0
            v.消耗MP = v.消耗 and v.消耗.消耗MP or 0
            v.消耗HP = v.消耗 and v.消耗.消耗HP or 0
            setmetatable(v, { __index = 技能库[v.名称] })
            if k > 12 then
                法术界面.区域2.列表:添加技能(v)
            else
                法术界面.区域1.列表:添加技能(v)
            end
        end
    end
    co = coroutine.running()
    return coroutine.yield()
end

function 窗口层:关闭法术界面()
    法术界面:置可见(false)
end

return 法术界面
