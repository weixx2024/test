
local 召唤界面 = 窗口层:创建我的窗口('召唤界面', 0, 0, 421, 444)
do
    function 召唤界面:初始化()
        self:置精灵(__res:getspr('ui/zdzh.png'))
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    end

    function 召唤界面:更新(dt)
        if self.动画 then
            self.动画:更新(dt)
        end
    end

    function 召唤界面:前显示(x, y)
        if self.动画 then
            self.动画:显示(x + 295, y + 240)
        end
    end

    function 召唤界面:置模型(t)
        self.动画 = nil
        if type(t)=="table" and t.外形  then
            self.动画 = require('对象/基类/动作') { 外形 = t.外形, 染色 = t.染色,模型 = 'attack' }
            self.动画:置循环(true)
        end

    end

    召唤界面:创建关闭按钮()
end

do
    文本列表 = {}
    for k, v in pairs {
        { name = '名称', x = 66, y = 303, w = 111 },
        { name = '等级', x = 66, y = 327, w = 111 },
        { name = '忠诚', x = 66, y = 351, w = 111 },
        { name = '亲密', x = 66, y = 376, w = 111 },
        { name = '气血', x = 260, y = 303, w = 136, fmt = '%s/%s' },
        { name = '魔法', x = 260, y = 327, w = 136, fmt = '%s/%s' },
        { name = '攻击', x = 260, y = 351, w = 136 },
        { name = '速度', x = 260, y = 375, w = 136 }
    } do
        local 文本 = 召唤界面:创建文本(v.name .. '#文本', v.x, v.y, v.w, 14)
        文本.fmt = v.fmt
        文本.name = v.name
        table.insert(文本列表, 文本)
    end
end

local 召唤列表 = 召唤界面:创建列表('召唤列表', 22, 64, 143, 184)
do
    function 召唤列表:初始化()
        self:置文字(__res.F18)
        self.行高度 = 42
    end

    local 头像背景 = 召唤列表:取拉伸精灵_宽高('gires/main/border.bmp', 38, 38)

    function 召唤列表:添加召唤(t)
        local r = self:添加(tostring(t)):置精灵()
        r.精灵 = __res:getspr('gires3/button/zhstx/%04d.tcp', t.原形 or t.外形)
        function r:显示(x, y)
            头像背景:显示(x + 5, y + 2)
            r.精灵:显示(x + 6, y + 3)
        end

        local 文本 = r:创建我的文本('文本', 46, 10, 155, 35)
        if t.已上场 then
            文本:置文本('#R' .. t.名称)
        else
            文本:置文本(t.名称)
        end

        r.id = t.id
        r.nid = t.nid
        r:置可见(true, true)
    end

    function 召唤列表:左键弹起(x, y, i, t)
        _id = t.id
        local r = __rpc:召唤_战斗属性(t.nid)
        if type(r) == 'table' then
            召唤界面:置模型(r)
            _数据 = r
            if 窗口层.召唤抗性.是否可见 then
                窗口层.召唤抗性.是否可见 = false
                窗口层:打开召唤抗性(_数据.nid)
            end
            t = _数据

            for i, v in ipairs(文本列表) do
                local 名称 = v.name
                if v.fmt then
                    local r = v.fmt:format(t[名称], t['最大' .. 名称])
                    v:置文本(r)
                else
                    v:置文本(tostring(t[名称]))
                end
            end
        end
    end

    -- for i = 2001, 2010 do
    --     召唤列表:添加召唤({ 名称 = '召唤' .. tostring(i), 外形 = i })
    -- end
end
召唤列表:创建我的滑块()

local 召唤技能 = 召唤界面:创建列表('召唤技能', 371, 47, 30, 220)
do
    召唤技能.行高度 = 30
    召唤技能.行间距 = 2
    local 技能背景 = 召唤技能:取拉伸精灵_宽高('gires/main/border.bmp', 30, 30)

    function 召唤技能:添加技能(t)
        local r = self:添加(tostring(t)):置精灵()
        r.精灵 = __res:getspr('magic/icon/%04d.png', t.图标):置拉伸(27, 27)
        function r:显示(x, y)
            技能背景:显示(x, y)
            r.精灵:显示(x + 1, y + 1)
        end

        r.nid = t.nid
    end

    function 召唤技能:获得鼠标(x, y)
    end

    -- for i = 1, 5 do
    --     召唤技能:添加技能({ nid = '召唤', 图标 = i })
    -- end
end

local 抗性按钮 = 召唤界面:创建小按钮('抗性按钮', 75, 265, '抗性')
function 抗性按钮:左键弹起()
    if _数据 then
        窗口层:打开召唤抗性(_数据.nid)
    end
end

local 召唤按钮 = 召唤界面:创建中按钮('召唤按钮', 155, 408, '召  唤')
function 召唤按钮:左键弹起()
    if co and _id then
        召唤界面:置可见(false)
        coroutine.resume(co, _id)
        _id = nil
        co = nil
    end
end

function 窗口层:打开战斗召唤界面(nid)
    召唤界面:置可见(true)
    召唤界面:置模型()
    召唤列表:清空()
    local list = __rpc:角色_战斗召唤列表(nid)
    if type(list) ~= 'table' then
        return
    end
    召唤排序(list)
    for i, v in ipairs(list) do
        v.id = i
        召唤列表:添加召唤(v)
    end
    if list[1] then
        召唤列表:置选中(1)
        召唤列表:左键弹起(0, 0, 1, list[1])
    end
    co = coroutine.running()
    return coroutine.yield()
end

--窗口层:打开战斗召唤界面()
return 召唤界面
