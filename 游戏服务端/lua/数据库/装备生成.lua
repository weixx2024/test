---@diagnostic disable: redundant-parameter
local ENV = setmetatable({}, { __index = _G })
local 装备库 = require('数据库/装备库')
local 仙器属性库 = require('数据库/仙器库')
function 生成装备(名称, 等级, 序号, 禁止交易)
    local t = 装备库[名称]
    if not t then
        return
    end
    if t.神兵 then
        return 生成神兵(名称, 等级, 序号, 禁止交易)
    elseif t.仙器 then
        return 生成仙器(名称, 等级, 序号, 禁止交易)
    end

    if t.装备类别 == '武器' then
        return 生成武器(名称, 禁止交易)
    elseif t.装备类别 == '帽子' then
        return 生成帽子(名称, 禁止交易)
    elseif t.装备类别 == '衣服' then
        return 生成衣服(名称, 禁止交易)
    elseif t.装备类别 == '鞋子' then
        return 生成鞋子(名称, 禁止交易)
    elseif t.装备类别 == '项链' then
        return 生成项链(名称, 禁止交易)
    elseif t.装备类别 == '披风' then
        return 生成披风(名称, 禁止交易)
    elseif t.装备类别 == '面具' then
        return 生成面具(名称, 禁止交易)
    elseif t.装备类别 == '挂件' then
        return 生成挂件(名称, 禁止交易)
    elseif t.装备类别 == '腰带' then
        return 生成腰带(名称, 禁止交易)
    elseif t.装备类别 == '戒指' then
        return 生成戒指(名称, 禁止交易, 序号)
    elseif t.装备类别 == '护身符' then
        return 生成护身符(名称, 禁止交易)
    end
end

local _仙器等级要求 = {
    [1] = { 0, 60 },
    [2] = { 0, 100 },
    [3] = { 1, 120 },
    [4] = { 2, 140 },
    [5] = { 3, 160 },
    [6] = { 3, 180 },
}
_仙器等级要求2 = {
    [1] = { 0, 10 },
    [2] = { 0, 30 },
    [3] = { 0, 50 },
    [4] = { 0, 80 },
    [5] = { 1, 60 },
    [6] = { 1, 70 }
}
function 生成仙器(名称, 等级, 序号)
    if not 装备库[名称] or not 仙器属性库[名称] then
        return
    end
    local js = 等级 or 1
    local r = 仙器属性库[名称][js][序号 or math.random(#仙器属性库[名称][js])]
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.原名 = 名称
    t.耐久 = t.最大耐久
    t.属性要求 = r.属性要求
    t.阶数 = js
    t.基本属性 = r.属性
    t.编号 = math.random(1000) + 10000
    t.名称 = 名称 .. "#" .. js
    t.等级需求 = { _仙器等级要求2[js][2], _仙器等级要求2[js][1] } --真实
    t.等级要求 = { _仙器等级要求2[js][2], _仙器等级要求2[js][1] } --显示
    if r.角色 then
        -- body
    end
    -- 编号
    -- t.炼化属性 --绿字属性
    -- t.追加属性 --绿字属性
    -- t.炼器属性 --绿字属性
    -- 特技
    -- 开光次数

    -- print(t.名称, t.级别, t.属性要求 and t.属性要求[1], t.等级需求[1], t.耐久)
    -- for i, v in ipairs(t.基本属性) do
    --     print('\t', v[1], v[2])
    -- end

    return t
end

local _原形 = {
    逍遥生 = 1,
    剑侠客 = 2,
    猛壮士 = 3,
    俏千金 = 4,
    飞燕女 = 5,
    英女侠 = 6,
    巨魔王 = 7,
    夺命妖 = 8,
    虎头怪 = 9,
    狐美人 = 10,
    骨精灵 = 11,
    小蛮妖 = 12,
    神天兵 = 13,
    龙战将 = 14,
    智圣仙 = 15,
    舞天姬 = 16,
    精灵仙 = 17,
    玄剑娥 = 18,

    飞剑侠 = 40,
    燕山雪 = 41,
    逆天魔 = 42,
    媚灵狐 = 43,
    武尊神 = 44,
    玄天姬 = 45,

    纯阳子 = 50,
    红拂女 = 51,
    混天魔 = 52,
    九尾狐 = 53,
    紫薇神 = 54,
    霓裳仙 = 55,

    猎魂引 = 60,
    无涯子 = 61,
    祭剑魂 = 62,
    夜溪灵 = 63,
    幽梦影 = 64,
    墨衣行 = 65,
}

local 索引 = {
    盘古锤 = {
        { 范围 = { 1, 12 }, 名称 = '盘古锤#1_12' },
        { 范围 = { 13, 32 }, 名称 = '盘古锤#13_32' },
    },
    芭蕉扇 = {
        { 范围 = { 1, 12 }, 名称 = '芭蕉扇#1_12' },
    },
    宣花斧 = {
        { 范围 = { 1, 4 }, 名称 = '宣花斧#1_4' },
        { 范围 = { 5, 32 }, 名称 = '宣花斧#5_32' },
    },
    混天绫 = {
        { 范围 = { 1, 20 }, 名称 = '混天绫#1_20' },
        { 范围 = { 21, 32 }, 名称 = '混天绫#21_32' },
    },
    毁天灭地 = {
        { 范围 = { 1, 20 }, 名称 = '毁天灭地#1_20' },
        { 范围 = { 21, 32 }, 名称 = '毁天灭地#21_32' },
        { 范围 = { 33, 44 }, 名称 = '毁天灭地#33_44' },
    },
    枯骨刀 = {
        { 范围 = { 1, 8 }, 名称 = '枯骨刀#1_8' },
        { 范围 = { 9, 32 }, 名称 = '枯骨刀#9_32' },
        { 范围 = { 33, 49 }, 名称 = '枯骨刀#33_49' },
        { 范围 = { 50, 61 }, 名称 = '枯骨刀#50_61' },
    },
    震天戟 = {
        { 范围 = { 1, 4 }, 名称 = '震天戟#1_4' },
        { 范围 = { 5, 20 }, 名称 = '震天戟#5_20' },
        { 范围 = { 21, 43 }, 名称 = '震天戟#21_43' },
        { 范围 = { 44, 55 }, 名称 = '震天戟#44_55' },
    },
    生死簿 = {
        { 范围 = { 1, 13 }, 名称 = '生死簿#1_13' },
        -- { 范围 = { 14, 37 }, 名称 = '生死簿#14_37' },
    },
    多情环 = {
        { 范围 = { 1, 4 }, 名称 = '多情环#1_4' },
        { 范围 = { 5, 24 }, 名称 = '多情环#5_24' },
        { 范围 = { 25, 36 }, 名称 = '多情环#25_36' },
    },
    赤炼鬼爪 = {
        { 范围 = { 1, 8 }, 名称 = '赤炼鬼爪#1_8' },
        { 范围 = { 9, 24 }, 名称 = '赤炼鬼爪#9_24' },
    },
    索魂幡 = {
        { 范围 = { 1, 4 }, 名称 = '索魂幡#1_4' },
        { 范围 = { 5, 24 }, 名称 = '索魂幡#5_24' },
        { 范围 = { 25, 36 }, 名称 = '索魂幡#25_36' },
    },
    缚龙索 = {
        { 范围 = { 1, 4 }, 名称 = '缚龙索#1_4' },
        { 范围 = { 5, 32 }, 名称 = '缚龙索#5_32' },
        { 范围 = { 33, 44 }, 名称 = '缚龙索#33_44' },
    },
    八景灯 = {
        { 范围 = { 1, 20 }, 名称 = '八景灯#1_20' },
        { 范围 = { 21, 32 }, 名称 = '八景灯#21_32' },
    },
    斩妖剑 = {
        { 范围 = { 1, 28 }, 名称 = '斩妖剑#1_28' },
        { 范围 = { 29, 48 }, 名称 = '斩妖剑#29_48' },
        { 范围 = { 49, 52 }, 名称 = '斩妖剑#49_52' },

    },
    搜魂钩 = {
        { 范围 = { 1, 24 }, 名称 = '搜魂钩#1_24' },
        { 范围 = { 25, 28 }, 名称 = '搜魂钩#25_28' },
        { 范围 = { 29, 40 }, 名称 = '搜魂钩#29_40' },
    },
    金箍棒 = {
        { 范围 = { 1, 4 }, 名称 = '金箍棒#1_4' },
        { 范围 = { 5, 28 }, 名称 = '金箍棒#5_28' },
        { 范围 = { 29, 48 }, 名称 = '金箍棒#29_48' },
    },
    乾坤无定 = {
        { 范围 = { 1, 20 }, 名称 = '乾坤无定#1_20' },
    },


}

function 生成神兵(名称, 等级, 序号, 禁止交易)
    if not 装备库[名称] or not __脚本['scripts/make/神兵库.lua'][名称] then
        return
    end

    local n = 序号 or math.random(#__脚本['scripts/make/神兵库.lua'][名称])
    local r = __脚本['scripts/make/神兵库.lua'][名称][n]
    if not r then
        n = math.random(#__脚本['scripts/make/神兵库.lua'][名称])
        r = __脚本['scripts/make/神兵库.lua'][名称][n]
    end



    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.等级 = 等级 or 1
    for k, v in pairs(r.属性要求) do
        t.属性要求 = { k, v * t.等级 }
    end
    t.基本属性 = {}
    local sz = 0


    local 锁死属性 = "忽视防御程度"
    if t.装备类型 == "爪" or t.装备类型 == "刀" or t.装备类型 == "斧" or t.装备类型 == "棒" then
        锁死属性 = "忽视防御几率"
    end

    for k, v in ipairs(r.属性) do
        sz = v.数值
        if v.类型 ~= 锁死属性 then
            sz = sz * t.等级
        end
        table.insert(t.基本属性, { v.类型, sz })
    end
    t.种族 = r.种族
    --神兵 武器 名称#条数  帽子 衣服 名称#等级_条数    项链鞋子 名称
    t.原名 = 名称
    t.条数 = n
    if t.装备类别 == "武器" then
        for k, v in pairs(索引[名称]) do
            if n >= v.范围[1] and n <= v.范围[2] then
                t.名称 = v.名称
                break
            end
        end
        t.角色 = {}

        local 角色 = GGF.分割文本(r.角色, '|')
        for k, v in pairs(角色) do
            if _原形[v] then
                t.角色[_原形[v]] = true
            end
        end
    elseif t.装备类别 == "帽子" or t.装备类别 == "衣服" then
        t.名称 = 名称 .. "#" .. t.等级 .. "_" .. n
    end
    t.禁止交易 = 禁止交易

    return t
end

function 生成武器(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_武器')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = T.取属性要求(t.级别, t.装备类型)

    local 属性 = t.属性要求 and t.属性要求[1]
    t.等级需求 = T.取等级需求(t.级别, 属性)
    t.禁止交易 = 禁止交易
    t.基本属性 = {}
    if t.级别 < 11 then
        table.insert(t.基本属性, T.取攻击(t.级别))
        table.insert(t.基本属性, T.取物理(t.级别))
    elseif t.级别 < 15 then
        if 属性 ~= '力量' then
            table.insert(t.基本属性, T.取强法(t.级别, 属性, t.装备类型))
        end
        local r = T.取物理(t.级别)
        table.insert(t.基本属性, r)
        table.insert(t.基本属性, T.取攻击2(t.级别, 属性))
    else
        if 属性 == '根骨' then
            table.insert(t.基本属性, T.取强法(t.级别, 属性, t.装备类型))
        elseif 属性 == '灵性' then
            t.基本属性[1] = T.取强法(t.级别, 属性, t.装备类型)
            t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, nil, 11) --用11级的范围
            local a, b = t.基本属性[1], t.基本属性[2]
            if a and b then
                if a[1] == '忽视抗水' and b[1] == '加强水' then
                    t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, '加强雷')
                elseif a[1] == '忽视抗火' and b[1] == '加强火' then
                    t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, ({ '加强雷', '加强水' })[
                    math.random(2)])
                elseif a[1] == '忽视抗雷' and b[1] == '加强雷' then
                    t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, '加强水')
                elseif a[1] == '忽视抗风' and b[1] == '加强风' then
                    t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, ({ '加强雷', '加强水' })[
                    math.random(2)])
                end
            end
        elseif 属性 == '力量' then
            t.基本属性[1] = T.取强法(t.级别, 属性, t.装备类型, '忽视防御几率')
            t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, '忽视防御程度')
        elseif 属性 == '敏捷' then
            t.基本属性[1] = T.取强法(t.级别, 属性, t.装备类型, '加强震慑')
            t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型)
        end
        table.insert(t.基本属性, T.取物理(t.级别))
        table.insert(t.基本属性, T.取攻击(t.级别))
    end




    return t
end

function 生成帽子(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_帽子')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = T.取属性要求(t.级别)
    local 属性 = t.属性要求 and t.属性要求[1]
    t.等级需求 = T.取等级需求(t.级别, t.属性要求)
    t.禁止交易 = 禁止交易
    t.基本属性 = {}
    if t.级别 < 11 then
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '物理吸收'))
        if t.级别 > 5 then
            table.insert(t.基本属性, T.取强法(t.级别, 属性, '命中率'))
        end
    elseif t.级别 < 15 then
        if 属性 ~= '力量' then --防止两条物理吸收
            table.insert(t.基本属性, T.取基础(t.级别, 属性))
        end
        table.insert(t.基本属性, T.取抗性(t.级别))
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '命中率'))
        table.insert(t.基本属性, T.取强法(t.级别, 属性))
    else
        if 属性 == '根骨' or 属性 == '灵性' then
            table.insert(t.基本属性, T.取基础(t.级别, 属性))
        end

        for i, v in ipairs(T.随机不重复强法(t.级别, 属性, 2)) do
            table.insert(t.基本属性, T.取强法(t.级别, 属性, v))
        end
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '命中率'))
        for i, v in ipairs(T.随机不重复抗性(t.级别, 2)) do
            table.insert(t.基本属性, T.取抗性(t.级别, v))
        end
    end
    return t
end

function 生成衣服(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_衣服')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = T.取属性要求(t.级别)
    local 属性 = t.属性要求 and t.属性要求[1]
    t.等级需求 = T.取等级需求(t.级别, t.属性要求)
    t.禁止交易 = 禁止交易
    t.基本属性 = {}
    if t.级别 < 11 then
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '物理吸收'))
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '防御值'))
        if t.级别 > 5 then
            table.insert(t.基本属性, T.取强法(t.级别, 属性, '速度'))
        end
    elseif t.级别 < 15 then
        if 属性 ~= '力量' then --防止两条物理吸收
            table.insert(t.基本属性, T.取基础(t.级别, 属性))
            table.insert(t.基本属性, T.取强法(t.级别, 属性))
        end
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '物理吸收'))
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '防御值'))
        table.insert(t.基本属性, T.取抗性(t.级别))
    else
        if 属性 == '根骨' or 属性 == '灵性' then
            table.insert(t.基本属性, T.取基础(t.级别, 属性))
        end

        table.insert(t.基本属性, T.取强法(t.级别, 属性, '物理吸收'))
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '防御值'))
        for i, v in ipairs(T.随机不重复强法(t.级别, 属性, 2)) do
            table.insert(t.基本属性, T.取强法(t.级别, 属性, v))
        end

        for i, v in ipairs(T.随机不重复抗性(t.级别, 2)) do
            table.insert(t.基本属性, T.取抗性(t.级别, v))
        end
    end
    return t
end

function 生成鞋子(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_鞋子')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = nil
    t.等级需求 = T.取等级需求(t.级别)
    t.禁止交易 = 禁止交易
    t.基本属性 = {}
    if t.级别 < 11 then
        table.insert(t.基本属性, T.取附加指定(t.级别, '速度'))
    else
        table.insert(t.基本属性, T.取附加属性(t.级别))
        table.insert(t.基本属性, T.取附加指定(t.级别, '速度'))
        table.insert(t.基本属性, T.取附加抗性(t.级别))
    end
    return t
end

function 生成项链(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_项链')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = nil
    t.等级需求 = T.取等级需求(t.级别)
    t.禁止交易 = 禁止交易
    t.基本属性 = { T.取附加指定(t.级别, '附加气血'), T.取附加指定(t.级别, '附加魔法') }

    if t.级别 > 10 then
        table.insert(t.基本属性, T.取附加属性(t.级别))
        table.insert(t.基本属性, T.取附加抗性(t.级别))
    end
    return t
end

function 生成披风(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_披风')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.等级需求 = T.取佩饰等级需求(t.级别)
    t.属性要求 = T.取佩饰属性需求(t.级别)
    t.默契值 = 1


    t.基本属性 = T.取基础属性(t.级别, t.属性要求[1])
    t.附加属性 = T.取附加抗性(t.级别)
    t.默契值上限 = t.级别 * 1000
    if t.级别 > 3 then
        t.默契值上限 = t.默契值上限 + (t.级别 - 2) * 1000
    end
    return t
end

function 生成面具(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_面具')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.等级需求 = T.取佩饰等级需求(t.级别)
    t.属性要求 = T.取佩饰属性需求(t.级别)
    t.默契值 = 1


    t.基本属性 = T.取基础属性(t.级别, t.属性要求[1])
    t.附加属性 = T.取附加抗性(t.级别)
    t.默契值上限 = t.级别 * 1000
    if t.级别 > 3 then
        t.默契值上限 = t.默契值上限 + (t.级别 - 2) * 1000
    end
    return t
end

function 生成挂件(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_挂件')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.等级需求 = T.取佩饰等级需求(t.级别)
    t.属性要求 = T.取佩饰属性需求(t.级别)
    t.属性要求[2] = 10
    t.默契值 = 1


    t.基本属性 = T.取基础属性(t.级别, t.属性要求[1])
    t.附加属性 = T.取附加抗性(t.级别)
    t.默契值上限 = t.级别 * 1000
    if t.级别 > 3 then
        t.默契值上限 = t.默契值上限 + (t.级别 - 2) * 1000
    end
    return t
end

function 生成腰带(名称, 禁止交易)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_腰带')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.等级需求 = T.取佩饰等级需求(t.级别)
    t.属性要求 = T.取佩饰属性需求(t.级别)
    t.属性要求[2] = 10
    t.默契值 = 1


    t.基本属性 = T.取基础属性(t.级别, t.属性要求[1])
    t.附加属性 = T.取附加抗性(t.级别)
    t.默契值上限 = t.级别 * 1000
    if t.级别 > 3 then
        t.默契值上限 = t.默契值上限 + (t.级别 - 2) * 1000
    end
    return t
end

function 生成戒指(名称, 禁止交易, 部位)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_戒指')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.等级需求 = T.取佩饰等级需求(t.级别)
    t.属性要求 = T.取佩饰属性需求(t.级别)
    t.属性要求[2] = 10
    t.默契值 = 1
    t.部位 =math.random(7, 8) or 部位
    t.原名 = 名称
    if t.部位 == 7 then
        t.名称 = t.名称 .. "#右"
    else
        t.名称 = t.名称 .. "#左"
    end

    t.基本属性 = T.取基础属性(t.级别, t.属性要求[1])
    t.附加属性 = T.取附加抗性(t.级别)
    t.默契值上限 = t.级别 * 1000
    if t.级别 > 3 then
        t.默契值上限 = t.默契值上限 + (t.级别 - 2) * 1000
    end

    return t
end

function 生成护身符(名称, 禁止交易, 品质)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_护身符')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.等级需求 = T.取佩饰等级需求(t.级别)
    t.品质 = 品质 or 200
    t.基本属性 = T.取基础属性(t.级别, t.品质)
    t.附加属性 = T.取附加抗性(t.级别, t.品质)
   
    return t
end

return ENV
