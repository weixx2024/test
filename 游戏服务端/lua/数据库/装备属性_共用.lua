local _ENV = setmetatable({}, { __index = _G })
_整数范围 = {
    根骨 = true,
    灵性 = true,
    敏捷 = true,
    力量 = true,
    基础攻击 = true,
    附加攻击 = true,
    每回合HP = true,
    每回合MP = true,
    速度 = true,
    防御值 = true,
    附加气血 = true,
    附加魔法 = true,
    连击次数 = true,
    反击次数 = true,
    抗毒伤害 = true,
    尘埃落定 = true,
    化血成碧 = true,
    上善若水 = true,
    灵犀一点 = true,
    明珠有泪 = true,
    加强毒伤害 = true,
    美人迟暮 = true,
    抗三尸虫 = true,
    加强三尸虫 = true,
    -- 孩子装备属性
    气质 = true,
    悟性 = true,
    智力 = true,
    内力 = true,
    耐力 = true,
}
_属性范围 = { '根骨', '灵性', '敏捷', '力量' }
_属性要求 = {
    [1] = { 等级 = 0, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 5, 敏捷 = 0 },
    [2] = { 等级 = 0, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 20, 敏捷 = 0 },
    [3] = { 等级 = 10, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 35, 敏捷 = 0 },
    [4] = { 等级 = 20, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 50, 敏捷 = 0 },
    [5] = { 等级 = 30, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 65, 敏捷 = 0 },
    [6] = { 等级 = 40, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 80, 敏捷 = 0 },
    [7] = { 等级 = 50, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 110, 敏捷 = 0 },
    [8] = { 等级 = 60, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 140, 敏捷 = 0 },
    [9] = { 等级 = 70, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 180, 敏捷 = 0 },
    [10] = { 等级 = 80, 转生 = nil, 或转生 = 0, 根骨 = 0, 灵性 = 0, 力量 = 250, 敏捷 = 0 },
    [11] = { 等级 = 100, 转生 = nil, 或转生 = 0, 根骨 = 250, 灵性 = 200, 力量 = 280, 敏捷 = 250 },
    [12] = { 等级 = 100, 转生 = nil, 或转生 = 0, 根骨 = 320, 灵性 = 260, 力量 = 340, 敏捷 = 300 },
    [13] = { 等级 = 100, 转生 = nil, 或转生 = 0, 根骨 = 400, 灵性 = 320, 力量 = 400, 敏捷 = 360 },
    [14] = { 等级 = 100, 转生 = nil, 或转生 = 0, 根骨 =500, 灵性 = 400, 力量 = 450, 敏捷 = 420 },
    [15] = { 等级 = 140, 转生 = 2, 或转生 = 0, 根骨 = 500, 灵性 = 400, 力量 = 450, 敏捷 = 400 },
    [16] = { 等级 = 160, 转生 = 3, 或转生 = 0, 根骨 = 600, 灵性 = 500, 力量 = 550, 敏捷 = 500 }
}
--通用
function 取数值(名称, t, 级别, 属性)
    属性 = 属性 or '根骨'
    t = t[属性] and t[属性][级别]
    if t then
        local a, b = t[1] * 1000, t[2] * 1000
        if _整数范围[名称] then
            return math.floor(math.random(math.min(a, b), math.max(a, b)) / 1000)
        end
        local f = math.random(math.min(a, b), math.max(a, b)) / 1000
        return f - f % 0.01
    end
    return 0
end

--通用
function 随机不重复(t, n)
    local r, 重复 = {}, {}
    if #t <= n then
        for i, v in ipairs(t) do
            r[i] = v
        end
        return r
    end

    repeat
        local 名称 = t[math.random(#t)]
        if not 重复[名称] then
            重复[名称] = true
            table.insert(r, 名称)
        end
    until #r == n
    return r
end

function 随机表(t, n)
    if t then
        return t[math.random(#t)]
    end
end

function 取等级需求(级别) -- 等级，等级或3转 ，转生+等级，飞升
    local t = _属性要求[级别]
    if t then
        return { t.等级, t.转生 }
    end
    return { 255 }
end

function 取属性要求(级别)
    if 级别 < 11 then
        return
    end

    local 属性 = 随机表(_属性范围)
    return { 属性, _属性要求[级别][属性] }
end

local _佩饰佩戴要求 = {
    根骨 = { 80, 120, 120, 260, 380, 500, 600 },
    力量 = { 60, 80, 120, 240, 400, 450, 550 },
    灵性 = { 60, 70, 90, 180, 340, 450, 500 },
    敏捷 = { 60, 60, 100, 200, 360, 420, 520 },
    等级 = {
        { 60,  0 },
        { 90,  0 },
        { 80,  1 },
        { 120, 1 },
        { 100, 2 },
        { 120, 2 },
        { 160, 3 },
    },
}

function 取佩饰等级需求(级别)
    local t = _佩饰佩戴要求.等级[级别]
    if t then
        return { t[1], t[2] }
    end
    return { 255 }
end

function 取佩饰属性需求(级别)
    local 属性 = 随机表(_属性范围)
    return { 属性, _佩饰佩戴要求[属性][级别] }
end

function 取升级佩饰等级需求(级别, 属性)
    local t = _佩饰佩戴要求.等级[级别]
    if t then
        return { t[1], t[2] }
    end
    return { 255 }
end

function 取升级佩饰属性需求(级别, 属性)
    return { 属性, _佩饰佩戴要求[属性][级别] }
end

return _ENV
