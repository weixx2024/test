local 召唤 = 窗口层:创建我的窗口('召唤', 0, 0, 340, 436)
do
    function 召唤:初始化()
        self:置精灵(__res:getspr('gires/0x73D07E65.tcp'))
        self:置坐标(10, (引擎.高度 - 515) // 2)
    end

    function 召唤:更新(dt)
        if self.动画 then
            self.动画:更新(dt)
        end
    end

    function 召唤:前显示(x, y)
        if self.动画 then
            self.动画:显示(x + 240, y + 200)
        end
    end

    function 召唤:置模型(t)
        self.动画 = require('对象/基类/动作') { 外形 = t.外形, 染色 = t.染色, 模型 = 'attack' }
        self.动画:置循环(true)
    end

    function 召唤:消息开始(v)
        if not 鼠标层.是否正常 then
            return true --拦截
        end
    end
end

function 召唤:刷新属性(t, nd)
    if type(t) == "table" then
        for k, v in pairs(t) do
            local k = k .. '文本'

            if k == '名称文本' then
                self.召唤兽名称:置文本(v)
            elseif k == '气血文本' then
                self[k]:置文本(tostring(v .. '/' .. t.最大气血))
            elseif k == '魔法文本' then
                self[k]:置文本(tostring(v .. '/' .. t.最大魔法))
            elseif k == '经验文本' then
                self[k]:置文本(tostring(v))
                self[k]:置提示(tostring('#Y经验值:' .. t.经验 .. '/' .. t.最大经验))
            elseif k == '等级文本' then
                if t.飞升 ~= 1 then
                    self[k]:置文本(tostring(t.转生 .. '转' .. t.等级))
                else
                    self[k]:置文本(tostring('飞升' .. t.等级))
                end
            elseif self[k] then
                self[k]:置文本(tostring(v))
            end
        end
        self:置模型(t)
        _加点 = { 0, 0, 0, 0 }
        _数据 = t
        if t.潜力 > 0 then
            for i = 1, 4 do
                self['增加属性' .. i]:置禁止(false)
            end
        end

        召唤.观看按钮:置选中(false)
        召唤.参战按钮:置选中(false)
        if t.是否观看 then
            召唤.观看按钮:置选中(true)
        end
        if t.是否参战 then
            召唤.参战按钮:置选中(true)
        end
        召唤.枯荣丹文本:置文本("")
        if t.nid == _krd then
            召唤.枯荣丹文本:置文本("      #G经验获得中")
        end

        self:刷新内丹(t.内丹, t.nid)
    else
        for i, v in ipairs { '等级文本', '忠诚文本', '气血文本', '魔法文本', '攻击文本', '速度文本',
            '经验文本', '根骨文本', '灵性文本', '力量文本', '敏捷文本', '潜力文本', '经验文本' } do
            召唤[v]:置文本('')
        end
        _数据 = nil
        召唤.动画 = nil
        召唤.召唤兽名称:置文本('')
        召唤.枯荣丹文本:置文本("")
    end
end

function 召唤:刷新内丹(内丹, nid)
    召唤.内丹列表:清空()
    for k, v in pairs(内丹) do
        召唤.内丹列表:添加内丹(k, v, nid)
    end
end

召唤:创建关闭按钮(0, 1)

local 名称输入 = 召唤:创建文本输入('召唤兽名称', 58, 165, 100, 18)
名称输入:置文字(__res.F16B:置颜色(255, 255, 255))
名称输入:置颜色(255, 255, 255, 255)
名称输入:置限制字数(14)
--local 标签 = 召唤:创建标签('标签', 0, 0, 340, 436)
--local 区域1 = 召唤:创建区域('标签1按钮',  0, 0, 340, 436)
--=======================================================================================
local 召唤列表 = 召唤:创建列表('召唤列表', 22, 50, 140, 106)
do
    召唤列表:置选中精灵宽度(117)
    function 召唤列表:初始化()
        self:置文字(__res.F18:置颜色(255, 255, 255))
        -- for i = 1, 20 do
        --     self:添加召唤(i, '召唤兽名称' .. i)
        -- end
        -- self:置项目颜色(1, 187, 165, 75)
    end

    function 召唤列表:添加召唤(i, t)
        local 名称 = t.名称
        if t.是否观看 then
            名称 = '(*)' .. 名称
        end
        if t.nid == _krd then
            名称 = 名称 .. "(获)"
        end
        local r = self:添加(名称)
        r.nid = t.nid
        r.原名 = t.名称
    end

    function 召唤列表:左键弹起(x, y, i, t)
        if 引擎:取功能键状态(SDL.KMOD_SHIFT) then --聊天框
            界面层:输入对象(t)
        else
            召唤.参战按钮:置选中(false)
            local r, nd = __rpc:召唤_取窗口属性(t.nid)
            if type(r) == 'table' then
                召唤:刷新属性(r, nd)
                if r.是否参战 then
                    召唤.参战按钮:置选中(true)
                end
                窗口层:刷新召唤兽物品(_数据)
                if 窗口层.召唤抗性.是否可见 then
                    窗口层.召唤抗性.是否可见 = false
                    窗口层:打开召唤抗性(_数据.nid)
                end
            end
        end
    end
end




local 滚动条 = 召唤列表:创建滚动条(召唤列表.宽度 - 23, 0, 23, 106 + 2)

local 滑块按钮 = 滚动条:创建滚动按钮(2, 20, 18, 106 - 36)
function 滑块按钮:初始化(v)
    self:置正常精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
    self:置经过精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
    self:置按下精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
end

local 减少按钮 = 滚动条:创建减少按钮(2, 0)
function 减少按钮:初始化(v)
    self:设置按钮精灵('gires/0x287AF2DA.tcp')
end

local 增加按钮 = 滚动条:创建增加按钮(2, -20)
function 增加按钮:初始化(v)
    self:设置按钮精灵('gires/0x03539D9C.tcp')
end

召唤列表:创建我的滑块()

local 内丹列表 = 召唤:创建列表('内丹列表', 165, 80, 14, 60)
do
    function 内丹列表:初始化()
        self.选中精灵 = nil
        self.焦点精灵 = nil
    end

    function 内丹列表:添加内丹(i, t, nid)
        local r = self:添加(t.名称):置精灵()
        r:置高度(20)
        r.携带者 = nid
        local 按钮 = r:创建按钮('内丹按钮')

        function 按钮:初始化(v)
            self:设置按钮精灵('gires4/%s/yjan/ndan.tcp', v or 'jdmh')
            self:置提示('#Y' .. t.名称)
        end

        function 按钮:左键弹起(v)
            窗口层:打开内丹栏(r.携带者, i)
        end

        r:置可见(true, true)
    end

    function 内丹列表:左键弹起(x, y, i)

    end
end

do
    for i, v in ipairs {
        --{name = '名称', x = 58, y = 165, k = 100, g = 18},
        { name = '等级', x = 58, y = 188, k = 100, g = 18 },
        { name = '忠诚', x = 58, y = 211, k = 100, g = 18 },
        -- {name = '亲密', x = 58, y = 286, k = 125, g = 20, txt = '亲密度影响召唤兽出现连击、致命及内丹效果。召唤兽转生需要亲密度:一转/10万, 二转/20万, 三转/30万。召唤兽点化需要亲密度50万'},
        { name = '气血', x = 54, y = 245, k = 138, g = 18 },
        { name = '魔法', x = 54, y = 270, k = 138, g = 18 },
        { name = '攻击', x = 54, y = 295, k = 138, g = 18 },
        { name = '速度', x = 54, y = 320, k = 138, g = 18 },
        { name = '经验', x = 54, y = 345, k = 138, g = 18, txt = '经验值' },
        { name = '根骨', x = 258, y = 245, k = 65, g = 18 },
        { name = '灵性', x = 258, y = 270, k = 65, g = 18 },
        { name = '力量', x = 258, y = 295, k = 65, g = 18 },
        { name = '敏捷', x = 258, y = 320, k = 65, g = 18 },
        { name = '潜力', x = 298, y = 345, k = 30, g = 18 }
    } do
        local 文本 = 召唤:创建文本(v.name .. '文本', v.x, v.y, v.k, v.g)
        文本:置文字(__res.F16B)
        if v.txt then
            文本:置提示('#Y' .. v.txt)
        end
    end

    local 文本 = 召唤:创建文本('枯荣丹文本', 186, 210, 135, 15)
    文本:置文字(__res.F12)
    --


    for i = 1, 4 do
        local 增加属性 = 召唤:创建加按钮('增加属性' .. i, 310, 245 + i * 25 - 25)
        function 增加属性:左键弹起()
            local 点数 = 1
            local 倍数加点 = 10
            if _数据 and _数据.潜力 > 0 then
                if 引擎:取功能键状态(SDL.KMOD_SHIFT) then
                    if _数据.潜力 >= 10 then
                        点数 = 倍数加点
                    else
                        点数 = _数据.潜力
                    end
                end

                local k = ({ '根骨', '灵性', '力量', '敏捷' })[i]
                _数据.潜力 = _数据.潜力 - 点数
                _加点[i] = _加点[i] + 点数

                召唤[k .. '文本']:置文本('#G' .. (_数据[k] + _加点[i]))
                召唤.潜力文本:置文本(tostring(_数据.潜力))
                召唤['减少属性' .. i]:置禁止(false)
                if _数据.潜力 <= 0 then
                    for i = 1, 4 do
                        召唤['增加属性' .. i]:置禁止(true)
                    end
                end
            end
        end

        --===============================================================================================
        local 减少属性 = 召唤:创建减按钮('减少属性' .. i, 299, 245 + i * 25 - 25)
        function 减少属性:左键弹起()
            if _数据 and _加点[i] > 0 then
                local k = ({ '根骨', '灵性', '力量', '敏捷' })[i]
                _加点[i] = _加点[i] - 1
                _数据.潜力 = _数据.潜力 + 1
                召唤.潜力文本:置文本(tostring(_数据.潜力))
                if _加点[i] > 0 then
                    召唤[k .. '文本']:置文本('#G' .. (_数据[k] + _加点[i]))
                else
                    召唤[k .. '文本']:置文本(tostring((_数据[k] + _加点[i])))
                    召唤['减少属性' .. i]:置禁止(true)
                end
                for i = 1, 4 do
                    召唤['增加属性' .. i]:置禁止(false)
                end
            end
        end
    end
end
--=======================================================================================
do
    local 更改名称按钮 = 召唤:创建中按钮('更改名称按钮', 20, 370, '更改名称', 85)
    function 更改名称按钮:左键弹起()
        if _数据 then
            local 输入名称 = 名称输入:取文本()
            if _数据.名称 == 输入名称 then
                窗口层:提示窗口('#Y我现在就叫这个名字呀')
                return
            end
            if require("数据/敏感词库")(输入名称, 1) then
                窗口层:提示窗口("#Y你的输入的名称包含敏感词汇！")
                return
            end
            local r = __rpc:召唤_改名(_数据.nid, 输入名称)
            if type(r) == 'string' then
                窗口层:提示窗口(r)
            elseif r == true then
                _数据.名称 = 输入名称
                窗口层:提示窗口('#Y改名成功！')
                召唤列表:置文本(召唤列表.选中行, _数据.名称)
            end
        end
    end

    local 参战按钮 = 召唤:创建我的多选按钮2('参战按钮', 128, 370, '设置参战', '设置待机')
    function 参战按钮:左键弹起()
        if _数据 then
            coroutine.xpcall(
                function()
                    local r = __rpc:召唤_参战(_数据.nid, not self.是否选中)

                    if type(r) == 'string' then
                        窗口层:提示窗口(r)
                    elseif r == true then
                        for k, v in 召唤列表:遍历项目() do
                            召唤列表:置项目颜色(k, 255, 255, 255)
                            v.参战 = false
                        end
                        召唤列表:置项目颜色(召唤列表.选中行, 187, 165, 75)
                        local r = 召唤列表:取项目(召唤列表.选中行)
                        if r then
                            r.参战 = true
                        end
                    end
                    --_数据.是否参战 = r
                end
            )
            return true
        end
        return false
    end

    local 更改属性按钮 = 召唤:创建中按钮('更改属性按钮', 237, 370, '更改属性', 85)
    function 更改属性按钮:左键弹起()
        if _数据 then
            local 加点总和 = 0
            for k, v in pairs(_加点) do
                加点总和 = 加点总和 + v
            end
            if 加点总和 > 0 then
                local t = __rpc:召唤_加点(_数据.nid, _加点)
                if type(r) == 'string' then
                    窗口层:提示窗口(r)
                elseif r == true then
                    召唤:刷新属性(t)
                end
            end
        end
    end

    --local 放生按钮 = 召唤:创建小按钮('放生按钮', 20, 402, '放生')
    -- function 放生按钮:左键弹起()
    --     if _数据 and 窗口层:确认窗口('真的要放生#R%s#W这个召唤兽吗？', _数据.名称) then
    --         if __rpc:召唤_放生(_数据.nid) then
    --             召唤列表:删除选中()
    --         end
    --     end
    -- end

    local 观看按钮 = 召唤:创建我的多选按钮3('观看按钮', 20, 402, '观看', '隐藏')
    function 观看按钮:左键弹起()
        if _数据 then
            coroutine.xpcall(
                function()
                    local r = __rpc:召唤_观看(_数据.nid, not self.是否选中)
                    if type(r) == 'string' then
                        窗口层:提示窗口(r)
                    elseif r == true then
                        for k, v in 召唤列表:遍历项目() do
                            召唤列表:置文本(k, v.原名)
                            if k == 召唤列表.选中行 then
                                召唤列表:置文本(k, '(*)' .. _数据.名称)
                            end
                            if v.参战 then
                                召唤列表:置项目颜色(k, 187, 165, 75)
                            end
                        end
                    end
                end
            )
            return true
        end
        return false
    end

    local 驯养按钮 = 召唤:创建小按钮('驯养按钮', 82, 402, '驯养')
    function 驯养按钮:左键弹起()
        if _数据 then
            local t = __rpc:召唤_驯养(_数据.nid)
            if type(r) == 'string' then
                窗口层:提示窗口(r)
            elseif r == true then
                召唤.忠诚文本:置文本(tostring(t))
            end
        end
    end

    local 抗性按钮 = 召唤:创建小按钮('抗性按钮', 146, 402, '抗性')
    function 抗性按钮:左键弹起()
        if _数据 then
            窗口层:打开召唤抗性(_数据.nid)
        end
    end

    local 物品按钮 = 召唤:创建小按钮('物品按钮', 210, 402, '物品')
    function 物品按钮:左键弹起()
        if _数据 then
            窗口层:打开召唤物品(_数据)
        end
    end

    local 技能按钮 = 召唤:创建小按钮('技能按钮', 276, 402, '技能')
    function 技能按钮:左键弹起()
        if _数据 then
            窗口层:打开召唤技能(_数据.nid)
        end
    end
end


function RPC:刷新召唤兽属性窗口(r)
    if type(r) == 'table' then
        召唤:刷新属性(r)
    end
end

function RPC:刷新召唤兽内丹(r)
    if type(r) == 'table' then
        if 召唤.是否可见 and _数据 then
            召唤:刷新内丹(r, _数据.nid)
        end
    end
end

function 窗口层:刷新召唤兽内丹(r)
    if type(r) == 'table' then
        if 召唤.是否可见 and _数据 then
            召唤:刷新内丹(r, _数据.nid)
        end
    end
end

function 窗口层:放生召唤兽()
    召唤.召唤列表:删除选中()
    召唤:刷新属性()
end

function 窗口层:打开召唤()
    召唤:置可见(not 召唤.是否可见)
    if not 召唤.是否可见 then
        return
    end
    self:重新打开召唤()
end

function 窗口层:重新打开召唤(nid)
    if nid then
        local t = __rpc:召唤_取窗口属性(nid)
        if t then
            召唤:刷新属性(t)
        end
        return
    end
    _数据 = nil
    召唤.动画 = nil
    召唤.观看按钮:置选中(false)
    召唤.参战按钮:置选中(false)
    召唤列表:清空()
    local list, krd = __rpc:角色_打开召唤窗口()
    _krd = krd
    if type(list) ~= 'table' then
        return
    end
    时间排序(list)

    local 参战召唤
    for i, v in ipairs(list) do
        召唤列表:添加召唤(i, v)
        if v.是否参战 then
            参战召唤 = v
            召唤列表:置项目颜色(i, 187, 165, 75)
            召唤列表:置选中(i)
        end
    end

    if 参战召唤 then
        local t = __rpc:召唤_取窗口属性(参战召唤.nid)
        if type(t) == "table" then
            召唤:刷新属性(t)
        end
    end
end

function RPC:召唤_刷新窗口属性(t)
    if t then
        召唤:刷新属性(t)
    end
end

return 召唤
