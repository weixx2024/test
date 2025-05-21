local 伙伴 = 窗口层:创建我的窗口('伙伴', 0, 0, 562, 383)

-- 技能 人族 1混 2睡 3毒 4冰
-- 技能 魔族 1抽 2速 3盘 4牛
-- 技能 仙族 1风 2火 3雷 4水

local renderData = {}

local selectIndex = nil

function 伙伴:初始化()
    self:置精灵(__res:getspr('ui/hb.png')) -- 562 * 383
    self.动画 = nil
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 伙伴:显示(x, y)
    if self.动画 then
        self.动画:显示(x + 290, y + 260)
    end
end

function 伙伴:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
end

伙伴:创建关闭按钮(0, 1)

local 伙伴列表 = 伙伴:创建列表('伙伴列表', 55, 70, 130, 280)
do
    function 伙伴列表:初始化()
        self:置文字(__res.F18:置颜色(255, 255, 255))
    end

    function 伙伴列表:添加伙伴(t)
        local r = self:添加(t.名称文本)
        r:取精灵():置中心(0, 0)
        r:置高度(28)
    end

    function 伙伴列表:左键弹起(x, y, i, t)
        selectIndex = i
        伙伴:刷新属性()
    end

    伙伴列表:创建我的滑块()
end

do
    for i, v in ipairs {
        { name = '名称', x = 425, y = 75 + 0 * 35, k = 115, g = 20 },
        { name = '门派', x = 425, y = 70 + 1 * 30, k = 115, g = 20 },
        { name = '等级', x = 425, y = 70 + 2 * 30, k = 115, g = 20 },
        { name = '资质', x = 425, y = 70 + 3 * 29, k = 115, g = 20 },
        { name = '气血', x = 425, y = 70 + 4 * 28, k = 115, g = 20 },
        { name = '法力', x = 425, y = 70 + 5 * 28, k = 115, g = 20 },
        { name = '攻击', x = 425, y = 70 + 6 * 28, k = 115, g = 20 },
        { name = '速度', x = 425, y = 70 + 7 * 28, k = 115, g = 20 },
    } do
        local 文本 = 伙伴:创建文本(v.name .. '文本', v.x, v.y, v.k, v.g)
        文本:置文字(__res.F14)
    end
end

local 参战按钮 = 伙伴:创建中按钮('参战按钮', 260, 315, '参战', 50)

function 参战按钮:左键弹起()
    local selectData = renderData[selectIndex]
    if renderData[selectIndex] then
        __rpc:角色_招募机器人(selectData.种族, selectData.性别, selectData.外形, selectData.技能)

    end
end

function 伙伴:刷新属性()
    if renderData[selectIndex] then
        local data = renderData[selectIndex]
        self.动画 = require('对象/基类/动作') { 外形 = data.动画, 模型 = 'stand' }
        for i, v in ipairs { '名称文本', '门派文本', '等级文本', '资质文本', '气血文本', '法力文本', '攻击文本', '速度文本' } do
            伙伴[v]:置文本(data[v])
        end
    end
end

function 窗口层:打开伙伴()
    伙伴:置可见(not 伙伴.是否可见)
    if not 伙伴.是否可见 then
        return
    end
    伙伴:置坐标((引擎.宽度 - 伙伴.宽度) // 2, (引擎.高度 - 伙伴.高度) // 2)

    伙伴列表:清空()
    selectIndex = nil
    renderData = __rpc:角色_打开机器人窗口()

    for i, v in ipairs(renderData) do
        伙伴列表:添加伙伴(v)
    end
end

return 伙伴
