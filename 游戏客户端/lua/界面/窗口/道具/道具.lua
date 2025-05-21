local 道具 = 窗口层:创建我的窗口('道具', 0, 0, 349, 482)
do
    function 道具:初始化()
        -- self:置精灵(__res:getspr('gires/0x83084DEB.tcp'))
        self:置精灵(__res:getspr('ui/dj.png'))
        self:置坐标(10, (引擎.高度 - 500) // 2)
    end

    function 道具:更新(dt)
        if self.动画 then
            self.动画:更新(dt)
        end
    end

    function 道具:前显示(x, y)
        if self.动画 then
            self.动画:显示(x + 275, y + 140)
        end
    end

    function 道具:置动画模型(id)
        self.动画 = require('对象/基类/动作') { 外形 = id or __rol.原形, 模型 = 'magic' } --attack
        self.动画:置循环(true)
    end
end
道具:创建关闭按钮()

for i, v in ipairs {
    { name = '师贡', x = 62, y = 208, k = 120, g = 15 },
    { name = '银子', x = 62, y = 238, k = 120, g = 15 },
    { name = '存款', x = 237, y = 238, k = 120, g = 15 }
} do
    local 文本 = 道具:创建文本(v.name .. '文本', v.x, v.y, v.k, v.g)
    文本:置文字(__res.F14B)
    文本:置文本('0')
end

local 装备网格 = 道具:创建网格('装备网格', 11, 33, 195, 165)
do
    function 装备网格:初始化()
        self:添加格子(1, 1, 1, 1) --1披风
        self:添加格子(4, 4, 40, 40) --2帽子
        self:添加格子(1, 1, 1, 1) --3面具
        self:添加格子(64, 4, 40, 40) --4项链
        self:添加格子(125, 4, 65, 65) --5武器
        self:添加格子(4, 62, 100, 100) --6衣服
        self:添加格子(1, 1, 1, 1) --7戒指
        self:添加格子(1, 1, 1, 1) --8戒指
        self:添加格子(1, 1, 1, 1) --9挂件
        self:添加格子(125, 97, 65, 65) --10鞋子
        self:添加格子(1, 1, 1, 1) --11腰带
        self:添加格子(1, 1, 1, 1) --12护身符
        self.数据 = {}
        self.记录格子 = 0
    end

    function 装备网格:清空()
        self.记录格子 = 0
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end
    end

    function 装备网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 装备网格:获得鼠标(x, y, i)
        if self.记录格子 ~= i then
            self:清空请求记录(self.记录格子)
        end
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            if self.数据[i].nid then
                self:物品提示(x, y, self.数据[i]) --先显示缓存.
                if not self.数据[i].已请求 then
                    local r = __rpc:取物品描述(self.数据[i].nid)
                    if r and self.数据[i] then
                        self.数据[i].刷新显示 = true
                        self.数据[i].属性 = r
                        self:物品提示(x, y, self.数据[i])
                    end
                    if  self.数据[i] then
                        self.数据[i].已请求 = true
                    end
                end
            elseif self.数据[i].名称 then -- 本地
                self:物品提示(x, y, self.数据[i])
            end
        end
        self.记录格子 = i
    end

    function 装备网格:清空请求记录(i)
        if self.数据 and self.数据[i] then
            self.数据[i].已请求 = nil
        end
    end

    function 装备网格:右键弹起(x, y, i)
        if self.数据[i] then
            if __rpc:角色_脱下装备(i) then
                self.数据[i] = nil
            else
                窗口层:提示窗口('#R没有多余的空位。')
            end
        end
    end

    function 装备网格:左键弹起(x, y, i)
        if gge.platform ~= 'Windows' then
            self:右键弹起(x, y, i)
        end
    end
end

-- ===============================================================================================
local 道具网格 = 道具:创建物品网格('道具网格', 13, 268, 305, 203)
do
    function 道具网格:左键弹起(x, y, i)
        if gge.platform ~= 'Windows' then
            if self.数据[i] then
                self.当前选中 = i
            end
        else
            if 鼠标层.附加 then
                local m = 鼠标层.附加
                if m.来源 == '物品' then
                    if m.i ~= i then --原地
                        if m.是否拆分 then
                            if not self.数据[i] then
                                local r, a, b = __rpc:角色_物品拆分(m.I, (_P - 1) * 24 + i, m.拆分数量)
                                if r == 1 then
                                    self:添加(m.i, a)
                                    self:添加(i, b)
                                elseif r == 2 then
                                    self:添加(m.i, self.数据[i])
                                    self:添加(i, m.self) -- m.self才是真身
                                end
                            end
                        else
                            local r, a, b = __rpc:角色_物品交换(m.I, (_P - 1) * 24 + i)
                            if r == 1 then -- 合并
                                m:删除()
                                self:添加(i, a)
                            elseif r == 2 then -- 交换
                                self:添加(m.i, self.数据[i])
                                self:添加(i, m.self) -- m.self才是真身
                            elseif r == 3 then -- 合并2
                                self:添加(m.i, a)
                                self:添加(i, b)
                            end
                        end
                    end
                elseif m.来源 == '装备' and not self.数据[i] then
                    -- local r = __rpc:角色_物品卸下装备(m.i, (_P - 1) * 24 + i)

                    -- if type(r) == 'number' then
                    --     self.数据[i] = require('界面/数据/物品')(_装备[m.i])
                    --     _装备[m.i] = nil
                    -- elseif type(r) == 'string' then
                    --     窗口层:提示窗口(r)
                    -- end
                end
                鼠标层.附加 = m:返回()
            elseif self.数据[i] then
                if __rol.是否战斗 then
                    return
                end
                if 引擎:取功能键状态(SDL.KMOD_SHIFT) then --聊天框
                    界面层:输入对象(self.数据[i])
                else
                    鼠标层.附加 = self.数据[i]:拿起()
                end
            end
        end
    end

    function 道具网格:右键弹起(x, y, i)
        local m = self.数据[i]
        if m then
            if __rol.是否战斗 then
                if not m.战斗是否可用 then
                    return
                end
                道具:置可见(false)
                鼠标层:道具形状()
                鼠标层.道具 = m
                coroutine.resume(co, m.I)
                return
            end
            self:物品提示()
            local r, v = __rpc:角色_物品使用(m.I)
            if r == 1 and type(v) == 'table' then      --更新
                m:刷新(v)
            elseif r == 2 then                         --删除
                m:删除()
            elseif r == 3 and type(v) == 'number' then --装备
                m:到装备(装备网格.数据, v)
            elseif type(r) == 'string' then
                窗口层:提示窗口(r)
            elseif type(v) == 'string' then
                窗口层:提示窗口(v)
            else
                窗口层:提示窗口('#R该物品无法使用。')
            end
        end
    end

    function 道具网格:键盘弹起(键码, 功能)
        local m = 鼠标层.附加
        if m and m.来源 == '物品' and m.数量 > 1 then
            if 键码 ~= SDL.KEY_LSHIFT and 键码 ~= SDL.KEY_RSHIFT then
                return
            end
            鼠标层.附加 = m:返回()
            local r = 窗口层:打开拆分窗口(m.数量)
            if r and r > 0 and r <= m.数量 then
                鼠标层.附加 = m:拆分拿起(r)
            end
        end
    end
end

-- ===============================================================================================
for i = 1, 4 do
    local 按钮 = 道具:创建单选按钮('物品栏' .. i, 321, 268 + i * 52 - 52)
    function 按钮:初始化()
        self:设置按钮精灵2('gires/0xC3622E6B.tcp')
    end

    function 按钮:左键弹起()
        local m = 鼠标层.附加
        if ggetype(m) == '物品' then
            if m.是否拆分 then
                return false
            end
            鼠标层.附加 = m:返回()
            coroutine.xpcall(
                function()
                    -- 为了return false
                    if __rpc:角色_物品交换(m.I, i << 8) then
                        m:删除()
                    end
                end
            )
            return false
        end
    end

    function 按钮:选中事件(v)
        if v then
            窗口层:刷新道具(i,道具.lsnid)
        end
    end
end

道具.物品栏1:置选中(true)

local function 置物品栏数量(n)
    n = n or 1
    for i = 1, 4 do
        道具['物品栏' .. i]:置可见(i <= n)
    end
end

if gge.platform ~= 'Windows' then
    local 使用按钮 = 道具:创建小按钮('使用按钮', 227, 173, '使用')
    function 使用按钮:左键弹起()
        if 道具网格.当前选中 and 道具网格.数据[道具网格.当前选中] then
            local m = 道具网格.数据[道具网格.当前选中]
            if __rol.是否战斗 then
                if not m.战斗是否可用 then
                    return
                end
                道具:置可见(false)
                鼠标层:道具形状()
                鼠标层.道具 = m
                coroutine.resume(co, m.I)
                return
            end

            self:物品提示()
            local r, v = __rpc:角色_物品使用(m.I)
            if r == 1 and type(v) == 'table' then -- 更新
                m:刷新(v)
            elseif r == 2 then                    -- 删除
                m:删除()
                道具网格.当前选中 = nil
            elseif r == 3 and type(v) == 'number' then -- 装备
                m:到装备(装备网格.数据, v)
                道具网格.当前选中 = nil
            elseif type(r) == 'string' then
                窗口层:提示窗口(r)
            elseif type(v) == 'string' then
                窗口层:提示窗口(v)
            else
                窗口层:提示窗口('#R该物品无法使用。')
            end
        end
    end

    local 丢弃按钮 = 道具:创建小按钮('丢弃按钮', 290, 173, '丢弃')
    function 丢弃按钮:左键弹起()
        if 道具网格.当前选中 and 道具网格.数据[道具网格.当前选中] then
            local m = 道具网格.数据[道具网格.当前选中]
            if m then
                m:丢弃()
            end
        end
        道具网格.当前选中 = nil
    end

    local 解锁按钮 = 道具:创建小按钮('解锁按钮', 227, 203, '解锁')
    function 解锁按钮:左键弹起()
        local r = 窗口层:输入窗口('', "请输入安全码")
        if r then
            __rpc:角色_解交易锁(r)
        end
        道具:置可见(true)
    end

    local 整理按钮 = 道具:创建小按钮('整理按钮', 290, 203, '整理')
    function 整理按钮:左键弹起()
        道具网格.当前选中 = nil
        __rpc:角色_物品整理(道具网格.当前页)
    end    
else
    local 整理按钮 = 道具:创建小按钮('整理按钮', 227, 173, '整理')
    function 整理按钮:左键弹起()
        __rpc:角色_物品整理(道具网格.当前页)
    end

    local 摆摊按钮 = 道具:创建小按钮('摆摊按钮', 290, 173, '摆摊')
    function 摆摊按钮:左键弹起()
        if __rol.是否摆摊 then
            窗口层:打开摆摊盘点()
        else
            local r = __rpc:角色_摆摊出摊()
            if type(r) == 'string' then
                窗口层:提示窗口(r)
            else
                窗口层:打开摆摊盘点()
            end
        end
        道具:置可见(false)
    end

    local 解锁按钮 = 道具:创建小按钮('解锁按钮', 227, 203, '解锁')
    function 解锁按钮:左键弹起()
        local r = 窗口层:输入窗口('', "请输入安全码")
        if r then
            __rpc:角色_解交易锁(r)
        end
        道具:置可见(true)
    end
end

function 窗口层:刷新道具(p,nid)
    _P = p
    道具网格:刷新道具(p,nid)
end

function 窗口层:刷新银子()
    local n = __rpc:角色_取银子()
    道具.银子文本:置文本(银两颜色(n))
end

function 窗口层:刷新师贡()
    local n = __rpc:角色_取师贡()
    道具.师贡文本:置文本(银两颜色(n))
end

function 窗口层:打开道具(nid)
    道具:置可见(not 道具.是否可见)
    if not 道具.是否可见 then
        return
    end
    装备网格:清空()
    
    local 现金, 存款, 师贡, 栏数, 原形 = __rpc:角色_打开物品窗口(nid)
    道具.银子文本:置文本(银两颜色(现金 or 0))
    道具.存款文本:置文本(银两颜色(存款 or 0))
    道具.师贡文本:置文本(银两颜色(师贡 or 0))
    置物品栏数量(栏数)
    if not _P then -- 首次打开
        _P = 1
        _装备 = {}
    end

    local list = __rpc:角色_装备列表(nid) or {}
    for k, v in pairs(list) do
        require('界面/数据/物品')(v):到装备(装备网格.数据, k)
    end
    道具.lsnid = nid
    窗口层:刷新道具(_P,nid)
    道具.物品栏1:置选中(true)
    道具:置动画模型(原形)
end

function 窗口层:打开战斗道具(nid)
    道具:置可见(true) -- 重连
    道具.是否可见 = false
    道具网格:清空()
    窗口层:打开道具(nid)
    
    co = coroutine.running()
    return coroutine.yield()
end

return 道具
