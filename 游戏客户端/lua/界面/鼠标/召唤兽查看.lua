local 召唤兽查看 = 窗口层:创建我的窗口('召唤兽查看')
local _技能库 = require('数据/技能库')

function 召唤兽查看:初始化()
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 召唤兽查看:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
end

function 召唤兽查看:显示(x, y)
    if self.动画 then
        self.动画:显示(x + 80, y + 170)
    end
end

function 召唤兽查看:置动画(t)
    self.动画 = nil
    if type(t) == "table" and t.外形 then
        self.动画 = require('对象/基类/动作') { 外形 = t.外形, 染色 = t.染色, 模型 = 'guard' }
        self.动画:置循环(true)
    end
end

function 召唤兽查看:左键弹起(x, y)
    if gge.platform ~= 'Windows' then
        召唤兽查看:置可见(false)
    end
end

local 文本 = 召唤兽查看:创建文本('描述', 140, 117, 260, 260)
文本:置文字(__res.F16)

local function 取龙之骨2(t)
    if t.龙之骨 and t.龙之骨.次数 and t.龙之骨.次数 > 0 then
        local lz = ' 龙之骨x' .. t.龙之骨.次数
        return string.format('%s', lz)
    end

    return ""
end

local function 取最长(t)
    local l = 0
    for i, v in ipairs(t) do
        if #tostring(v) > l then
            l = #tostring(v)
        end
    end
    return l
end

local _kxb = {}
local _五行 = { '金', '木', '水', '火', '土' }
local function 取抗性(t)
    local ts = {}
    for k, v in pairs(t.天生抗性) do
        ts[k] = {}
        ts[k].名称 = _kxb[k]
        ts[k].值 = v
        for a, b in pairs(t.炼妖) do
            if k == a then
                ts[k].值2 = b
            end
        end
    end
    for k, v in pairs(t.炼妖) do
        local 找到 = false
        for a, b in pairs(t.天生抗性) do
            if k == a then
                找到 = true
            end
        end
        if not 找到 and k ~= '次数' then
            table.insert(ts, { 名称 = _kxb[k] or k, 值 = v })
        end
    end
    local r = '#G'
    local rr = {}
    for k, v in pairs(ts) do
        table.insert(rr, string.format('#G%s:%0.1f', ts[k].名称 or k, ts[k].值 + (ts[k].值2 or 0)))
    end
    for k, v in pairs(_五行) do
        if t[v] and t[v] > 0 then
            table.insert(rr, string.format('%s:%s ', v, t[v] or 0))
        end
    end
    r = table.concat(rr, ' ')
    return r
end

local function 取次数(t)
    local n = 0
    if t and t.炼妖 then
        n = t.炼妖.次数 or 0
    end
    return string.format('#G转生次数:%s,打炼妖石次数:%s', t.转生 or 0, n)
end
local function 取内丹等级(v)
    if v.点化 and v.点化 > 0 then
        return string.format('点化%s级', v.等级)
    end
    return string.format('%s转%s级', v.转生, v.等级)
end
local function 取内丹(t)
    local r = ':#cFEFF72'
    for k, v in pairs(t.内丹) do
        -- if k == 1 then
        r = r .. string.format('%s %s  ', v.名称, 取内丹等级(v))
        -- end
    end
    return r
end

local function 取技能(t)
    local r = ':#cFEFF72'
    for k, v in pairs(t.技能) do
        r = r .. string.format('%s #r', v.名称)
    end
    return r
end

function 召唤兽查看:刷新属性(t)
    self:置精灵(
        生成精灵(
            409,
            285,
            function()
                __res:getsf('ui/zhsck.png'):显示(0, 0)
                __res.F16:置颜色(254, 255, 114)
                __res.F16:取图像(t.名称 .. " 等级:" .. t.等级 .. 取龙之骨2(t)):显示(140, 15)
                __res.F16:取图像("HP:" .. t.气血 .. "/" .. t.最大气血):显示(140, 32)
                __res.F16:取图像("MP:" .. t.魔法 .. "/" .. t.最大魔法):显示(140, 49)
                __res.F16:取图像("攻击:" .. t.攻击):显示(280, 32)
                __res.F16:取图像("速度:" .. t.速度):显示(280, 49)
                __res.F16:取图像("忠诚度:" .. t.忠诚):显示(140, 66)
                __res.F16:取图像("初始HP:" .. t.初血):显示(140, 83)
                __res.F16:取图像("初始MP:" .. t.初法):显示(140, 100)
                __res.F16:取图像("初始攻击:" .. t.初攻):显示(280, 83)
                __res.F16:取图像("初始速度:" .. t.初敏):显示(280, 100)
                __res.F16:置颜色(255, 255, 255)
            end
        )
    )
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 窗口层:打开召唤兽查看(t)
    召唤兽查看:置可见(true)
    召唤兽查看:刷新属性(t)
    local r = string.format('%s#r%s#r#G成长率:%s#r内丹%s#r技能%s', 取抗性(t), 取次数(t), t.成长, 取内丹(t), 取技能(t))
    文本:置文本(r)
    召唤兽查看:置动画(t)
end

return 召唤兽查看
