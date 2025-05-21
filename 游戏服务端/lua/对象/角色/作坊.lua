local 角色 = require('角色')

--local _炼器属性库 = require("数据库/炼器属性库")--__脚本['scripts/make/炼器属性库.lua']
--local _装备炼化属性库 = require("数据库/普通装备炼化属性库")--__脚本['scripts/make/普通装备炼化属性库.lua']

local _打造材料 = {
    [2] = { '', '乌金', '补天神石' },
    [3] = { '', '金刚石', '补天神石' },
    [4] = { '', '寒铁', '补天神石' },
    [5] = { '', '百炼精铁', '补天神石' },
    [6] = { '', '龙之鳞', '补天神石' },
    [7] = { '', '千年寒铁', '补天神石' },
    [8] = { '', '天外飞石', '补天神石' },
    [9] = { '', '盘古精铁', '补天神石' },
    [10] = { '', '补天神石', '补天神石' },
    [11] = { '', '千年寒铁', '血玲珑' },
    [12] = { '', '天外飞石', '血玲珑' },
    [13] = { '', '盘古精铁', '血玲珑' },
    [14] = { '', '补天神石', '血玲珑' },
    [15] = { '', '六魂之玉', '血玲珑' },
    [16] = { '', '无量琉璃', '血玲珑' },
}

local _锻造材料 = {
    [9] = { '', '千年寒铁', '内丹精华' },
    [10] = { '', '千年寒铁', '内丹精华' },
    [11] = { '', '千年寒铁', '内丹精华' },
    [12] = { '', '天外飞石', '内丹精华' },
    [13] = { '', '盘古精铁', '内丹精华' },
    [14] = { '', '补天神石', '内丹精华' },
    [15] = { '', '六魂之玉', '内丹精华' },
    [16] = { '', '无量琉璃', '内丹精华' },
}

local _重铸材料 = {
    [11] = { '', '千年寒铁', '内丹精华' },
    [12] = { '', '天外飞石', '内丹精华' },
    [13] = { '', '盘古精铁', '内丹精华' },
    [14] = { '', '补天神石', '内丹精华' },
    [15] = { '', '六魂之玉', '内丹精华' },
    [16] = { '', '无量琉璃', '内丹精华' },
}

local _生产装备 = {
    需要数量 = 3,
    需要数量_低级 = 2,
    fun = function(item)
        if not item[1].是否装备 then
            return
        end
        if item[1].新手装备 then
            return
        end

        local t = _打造材料[item[1].级别 + 1]

        if #item == 2 then
            if item[1].级别 >= 14 or item[2].名称 ~= t[2] and item[2].名称 ~= t[3] then
                return
            end
        elseif #item == 3 then
            for i, v in ipairs(t) do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
        end

        -- local jb = item[1].级别
        local yzxh = 50000
        if item[1].级别 > 14 then
            yzxh = 1 * 2 ^ (item[1].级别 - 10) * 50000
        end
        --价值，金钱，体力
        return '打造', nil, yzxh, 10
    end
}

local _重铸装备 = {
    需要数量 = 3,
    fun = function(item)
        if not item[1].是否装备 then
            return
        end

        if item[1].级别 < 14 then
            return
        end

        local t = _重铸材料[item[1].级别]
        if t then
            for i, v in ipairs(t) do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
        else
            return
        end

        local yzxh = 1000000
        --价值，金钱，体力
        return '重铸', nil, yzxh, 10
    end
}

local _炼化装备 = {
    需要数量 = 6,
    fun = function(item, 保留)
        if not item[1].是否装备 then
            return
        end
        if item[1].新手装备 then
            return
        end
        if item[1].级别 > 16 then
            return
        end
        for i, v in ipairs { '', '内丹精华', '血玲珑', '九彩云龙珠', '九彩云龙珠', '九彩云龙珠' } do
            if v ~= '' and item[i].名称 ~= v then
                return
            end
        end
        local 价值 = 0
        for k, v in pairs(item) do
            if v.价值 then
                价值 = 价值 + v.价值
            end
        end
        local yzxh = 50000

        if 保留 then
            yzxh = 200000
        end

        -- 价值，金钱，体力
        -- 取材料剩余可炼化次数
        return '炼化', 价值, yzxh, 10
    end
}

local _炼器装备 = {
    开光 = {
        需要数量 = 2,
        fun = function(item)
            if not item[1].是否装备 then
                return
            end
            if item[1].新手装备 then
                return
            end
            if item[1].级别 < 11 then
                return --"#Y只有高级装备才可以进行此操作"
            end
            for i, v in ipairs { '', '九玄仙玉' } do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
            local yzxh = 100000
            --价值，金钱，体力
            return '开光', nil, yzxh, 10
        end
    },
    炼器 = {
        需要数量 = 2,
        fun = function(item)
            if not item[1].是否装备 then
                return
            end
            if item[1].新手装备 then
                return
            end
            -- if  not item[1].开光 then
            --     return --"#Y只有开光过的武器才可以炼器。"
            -- end
            if item[1].级别 < 11 then
                return --"#Y只有高级装备才可以进行此操作"
            end
            local 价值 = 0
            for i, v in ipairs { '', '落魂砂' } do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
                if v.价值 then
                    价值 = 价值 + v.价值
                end
            end
            local yzxh = 100000
            if item[3] and item[3].名称 == "神功笔录" then
                yzxh = 500000
            end
            --价值，金钱，体力
            return '炼器', 价值, yzxh, 10
        end
    },
}

local _炼化佩饰 = {
    升级 = {
        需要数量 = 2,
        fun = function(item)
            if not item[1].是否装备 or not item[1].佩饰 or not item[1].默契值 then
                return
            end

            if item[2].名称 ~= "无量琉璃" then
                return
            end

            local yzxh = item[1].级别 * 400000
            --价值，金钱，体力
            return '升级', nil, yzxh, 0
        end
    },
    培养 = {
        需要数量 = 2,
        fun = function(item)
            if not item[1].是否装备 or not item[1].佩饰 or not item[1].默契值 then
                return
            end
            if not item[2].是否宝石 and not item[2].炼妖石 and not item[2].名称 == "佩饰精华" then
                return
            end

            local yzxh = item[1].级别 * 20000
            --价值，金钱，体力
            return '培养', nil, yzxh, 0
        end
    },
    重炼 = {
        需要数量 = 6,
        fun = function(item)
            if not item[1].是否装备 or not item[1].佩饰 then
                return
            end
            for i, v in ipairs { '', '六魂之玉', '血玲珑', '九彩云龙珠', '九彩云龙珠', '九彩云龙珠' } do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
            local yzxh = 500000
            --价值，金钱，体力
            -- 取材料剩余可炼化次数
            return '重炼', nil, yzxh, 0
        end
    },
    培养护身符 = {
        需要数量 = 2,
        fun = function(item)
            if not item[1].是否装备 or not item[1].佩饰 or not item[1].品质 then
                return
            end
            if not item[2].佩饰 and not item[2].装备类型 == '护身符' then
                return
            end

            local yzxh = item[1].级别 * 20000
            --价值，金钱，体力
            return '培养', nil, yzxh, 0
        end
    },
    升级护身符 = {
        需要数量 = 3,
        fun = function(item)
            if not item[1].是否装备 or not item[1].佩饰 then
                return
            end

            if item[2].名称 ~= "无量琉璃" then
                return
            end

            if item[3].名称 ~= "血玲珑" then
                return
            end

            local yzxh = item[1].级别 * 400000
            --价值，金钱，体力
            return '升级', nil, yzxh, 0
        end
    },
    重炼护身符 = {
        需要数量 = 3,
        fun = function(item)
            if not item[1].是否装备 or not item[1].佩饰 then--黄字
                return
            end

            if item[2].名称 ~= "六魂之玉" then
                return
            end

            if item[3].名称 ~= "内丹精华" then
                return
            end

            local yzxh = item[1].级别 * 400000
            --价值，金钱，体力
            return '重炼', nil, yzxh, 0
        end
    },
}

local _整数范围 = require('数据库/装备属性_共用')._整数范围
local _装备信息库 = require("数据库/装备信息库")
function 角色:角色_取作坊列表()
    return self.作坊, self.银子, self.体力, self.好心值
end

local function _检查物品(self, list)
    if type(list) ~= 'table' then
        return
    end
    local 数量 = {}
    for _, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            if not 数量[nid] then
                数量[nid] = 0
            end
            数量[nid] = 数量[nid] + 1
        else
            return
        end
    end
    for i, nid in ipairs(list) do
        if 数量[nid] > __物品[nid].数量 then
            return
        end
        list[i] = __物品[nid]
    end
    return true
end

function 角色:角色_炼化装备(作坊, list, 保留)
    if not _检查物品(self, list) then
        return
    end

    if 作坊 == nil then
        return '因为此装备不能在这个作坊炼化，炼化失败。'
    end

    local num, res = #list, {}

    if num == 1 then
        return
    end

    if _生产装备.需要数量 == num or _生产装备.需要数量_低级 == num then
        if list[1].数据.炼化属性 then
            return '#Y炼化过的装备无法打造'
        end

        if type(list[1].级别) == 'number' and list[1].级别 > 14 then
            return "#Y装备无法继续升级"
        end

        res = { _生产装备.fun(list) }
        if res[1] and res[1] == "打造" then
            return res
        end
    end

    if _重铸装备.需要数量 == num then
        if list[1].数据.炼化属性 then
            return '#Y炼化过的装备无法重铸'
        end

        res = { _重铸装备.fun(list) }

        if res[1] and res[1] == "重铸" then
            return res
        end
    end

    if _炼化装备.需要数量 == num then
        res = { _炼化装备.fun(list, 保留) }

        if res[1] and res[1] == "炼化" then
            return res
        end
    end

    return
end

local _作坊限制 = { "帽子", "武器", "衣服", "鞋子", "项链" }
local _作坊打造限制 = {
    { dw = 0, lv = 0 },
    { dw = 1, lv = 8 },
    { dw = 1, lv = 16 },
    { dw = 2, lv = 24 },
    { dw = 2, lv = 32 },
    { dw = 3, lv = 40 },
    { dw = 3, lv = 48 },
    { dw = 4, lv = 56 },
    { dw = 4, lv = 64 },
    { dw = 5, lv = 72 },
    { dw = 5, lv = 80 },
    { dw = 6, lv = 88 },
    { dw = 6, lv = 96 },
    { dw = 7, lv = 104 },
    { dw = 7, lv = 126 },
}

function 角色:角色_高级装备打造(作坊, list, nid)
    if not _检查物品(self, list) then
        return
    end
    if #list < 3 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].新手装备 then
        return '#Y新手装备无法进行此操作。'
    end
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if list[1].宝石属性 or list[1].高级宝石属性 then
        return '#Y镶嵌过的装备无法打造。'
    end
    if list[1].禁止交易 then
        return '#Y禁止交易的的装备无法打造。'
    end

    local jb = list[1].级别

    local t = _打造材料[list[1].级别 + 1]

    if #list == 2 then
        if list[2].名称 ~= t[2] and list[2].名称 ~= t[3] then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
        if list[2].名称 == t[3] then
            jb = 9
        end
    else
        for i, v in ipairs(t) do
            if v ~= '' and list[i].名称 ~= v then
                return '#Y你提供的原料有问题，请重新执行一遍。'
            end
        end
    end


    if list[1].数据.炼化属性 then
        return '#Y炼化过的装备不可生产。'
    end
    if list[1].级别 >= 14 then
        return '#Y最高只能打造14级装备'
    end
    local zf --= self.作坊[作坊]

    local 秘籍
    if nid then
        if __物品[nid] and __物品[nid].rid == self.id then
            秘籍 = __物品[nid]
            作坊 = 秘籍.作坊
            zf = { 熟练度 = 0 }
            zf.等级 = 秘籍.等级
            zf.段位 = 秘籍.段位
        end
    else
        zf = self.作坊[作坊]
    end

    if not zf then
        return '#Y因为此装备不能在这个作坊生产，生产失败。'
    end


    if not 作坊 or not _作坊限制[作坊] or list[1].装备类别 ~= _作坊限制[作坊] then
        return '#Y因为此装备不能在这个作坊生产，生产失败。'
    end

    local xz = _作坊打造限制[jb + 1]
    local zf = self.作坊[作坊]

    if zf.等级 < xz.lv or zf.段位 < zf.段位 then
        return '#Y因为你的生产作坊等级不足以生产此装备，生产失败。'
    end

    local yzxh = 50000
    if jb > 10 then
        yzxh = 1 * 2 ^ (jb - 10) * 50000
    end
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    local tlxh = 10
    if zf.等级 == 1 and zf.熟练 < 100 then
        tlxh = 0
    end
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end
    self:角色_扣除银子(yzxh, "高级打造")
    self:角色_扣除体力(tlxh)
    local 武器类别 = list[1].装备类别
    local 名称 = ""

    if 武器类别 == "武器" then
        名称 = _装备信息库.武器名称表[list[1].装备类型][jb + 1]
    elseif 武器类别 == "衣服" or 武器类别 == "帽子" then
        名称 = _装备信息库[武器类别 .. "名称表"][list[1].性别][jb + 1]
    elseif 武器类别 == "项链" then
        名称 = _装备信息库.项链名称表[jb + 1]
    elseif 武器类别 == "鞋子" then
        名称 = _装备信息库.鞋子名称表[jb + 1]
    end
    list[1]:减少(1)
    list[2]:减少(1)
    if list[3] then
        list[3]:减少(1)
    end
    if 秘籍 then
        秘籍:减少(1)
    end
    self:物品_添加 {
        __沙盒.生成装备 { 名称 = 名称 },
    }
    return { self.银子, self.体力, string.format("#Y你获得了#R%s", 名称) }
end

function 角色:角色_高级装备重铸(作坊, list, nid)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 3 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].新手装备 then
        return '#Y新手装备无法进行此操作。'
    end
    local t = _重铸材料[list[1].级别]
    for i, v in ipairs(t) do
        if v ~= '' and list[i].名称 ~= v then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
    end
    if list[1].数据.炼化属性 then
        return '#Y炼化过的装备不可锻造。'
    end

    -- if list[1].装备类别 ~= "武器" then
    --     return '#Y只有武器可以重铸。'
    -- end

    if list[1].级别 < 10 or list[1].级别 > 14 then
        return '#Y只有高级装备才可以在此锻造'
    end
    local zf

    local 秘籍
    if nid then
        if __物品[nid] and __物品[nid].rid == self.id then
            秘籍 = __物品[nid]
            作坊 = 秘籍.作坊
            zf = { 熟练度 = 0 }
            zf.等级 = 秘籍.等级
            zf.段位 = 秘籍.段位
        end
    else
        zf = self.作坊[作坊]
    end

    if not zf then
        return '#Y因为此装备不能在这个作坊生产，生产锻造。'
    end


    if not 作坊 or not _作坊限制[作坊] or list[1].装备类别 ~= _作坊限制[作坊] then
        return '#Y因为此装备不能在这个作坊生产，生产锻造。'
    end
    local xz = _作坊打造限制[list[1].级别]

    -- if zf.等级 < xz.lv or zf.段位 < xz.dw then
    --     return '#Y因为你的生产作坊等级不足以生产此装备，生产锻造。'
    -- end

    local yzxh = 1000000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    local tlxh = 10
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end

    self:角色_扣除银子(yzxh, "高级重组")
    self:角色_扣除体力(tlxh)

    local 名称 = list[1].名称


    list[1]:减少(1)
    list[2]:减少(1)
    list[3]:减少(1)
    if 秘籍 then
        秘籍:减少(1)
    end

    self:物品_添加 {
        __沙盒.生成装备 { 名称 = 名称 },
    }
    return { self.银子, self.体力, string.format("#R%s#Y的属性发生了些许变化", 名称) }
end

function 角色:角色_装备炼化(作坊, list, 保留, nid)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 6 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].新手装备 then
        return '#Y新手装备无法进行此操作。'
    end
    if list[1].级别 <= 10 then
        return '#Y只有高级装备才可以炼化属性。'
    end
    if list[1].宝石属性 or list[1].高级宝石属性 then
        return '#Y镶嵌过宝石的装备无法炼化'
    end
    if list[1].佩饰 or list[1].仙器 or list[1].神兵 then
        return '#Y只有装备才可以炼化属性。'
    end
    local zf

    local 秘籍
    if nid then
        if __物品[nid] and __物品[nid].rid == self.id then
            秘籍 = __物品[nid]
            作坊 = 秘籍.作坊
            zf = { 熟练度 = 0 }
            zf.等级 = 秘籍.等级
            zf.段位 = 秘籍.段位
        end
    else
        zf = self.作坊[作坊]
    end
    if not zf then
        return '#Y因为此装备不能在这个作坊炼化，炼化失败。'
    end

    if not 作坊 or not _作坊限制[作坊] or list[1].装备类别 ~= _作坊限制[作坊] then
        return '#Y因为此装备不能在这个作坊炼化，炼化失败。'
    end
    local xz = _作坊打造限制[list[1].级别]
    if zf.等级 < xz.lv or zf.段位 < xz.dw then
        return '#Y因为你的生产作坊等级不足以炼化此装备，炼化失败。'
    end
    local yzxh = 50000

    if 保留 then
        yzxh = 200000
    end

    if self.银子 < yzxh then
        return '#Y你的银两不足'
    end
    local tlxh = 10
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end
    for i, v in ipairs { '', '内丹精华', '血玲珑', '九彩云龙珠', '九彩云龙珠', '九彩云龙珠' } do
        if v ~= '' and list[i].名称 ~= v then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
    end
    local 确定 = true
    if list[1].数据.炼化属性 and list[1].数据.炼化属性.重复 and not 保留 then
        确定 = self.rpc:确认窗口('检查当前属性较好，确定再次炼化么？')
    end
    if not 确定 then
        return
    end


    self:角色_扣除银子(yzxh, "装备炼化")
    self:角色_扣除体力(tlxh)

    list[2]:减少(1)
    list[3]:减少(1)
    list[4]:减少(1)
    list[5]:减少(1)
    list[6]:减少(1)
    if 秘籍 then
        秘籍:减少(1)
    end

    --如何计算材料剩余可炼化次数
    local 剩余次数 = 10
    local 价值 = 0
    for k, v in pairs(list) do
        if v.价值 then
            价值 = 价值 + v.价值
        end
    end



    local t, 重复 = self:取普通装备炼化属性(list[1].装备类别, 价值)
    if not list[1].数据.炼化属性 then
        保留 = false
    end
    if 保留 then
        self.临时炼化属性 = {}
        for k, v in pairs(t) do
            table.insert(self.临时炼化属性, { k, v })
        end
        self.临时炼化属性.nid = list[1].nid
        self.临时炼化属性.重复 = 重复
        zf.熟练度 = zf.熟练度 + 15
        t.重复 = 重复

        return "炼化", t, self.银子, self.体力, list[1].数据.炼化属性, zf.熟练度, 剩余次数, "#Y炼化成功！"
    else
        list[1].数据.炼化属性 = {}
        for k, v in pairs(t) do
            table.insert(list[1].数据.炼化属性, { k, v })
        end
        list[1].数据.炼化属性.重复 = 重复
    end
    zf.熟练度 = zf.熟练度 + 15
    return "炼化", t, self.银子, self.体力, nil, zf.熟练度, 剩余次数, "#Y炼化成功！"
end

function 角色:角色_装备炼化属性替换()
    if not self.临时炼化属性 then
        return
    end
    if not self.临时炼化属性.nid then
        return
    end
    local nid = self.临时炼化属性.nid

    if __物品[nid] and __物品[nid].rid == self.id then
        local item = __物品[nid]
        item.数据.炼化属性 = {}
        for i, v in ipairs(self.临时炼化属性) do
            table.insert(item.数据.炼化属性, { v[1], v[2] })
        end
        item.数据.炼化属性.重复 = self.临时炼化属性.重复
        self.临时炼化属性 = nil
        return item.数据.炼化属性
    end
end

function 角色:角色_炼器(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    local n, aa = #list, false
    for k, v in pairs(_炼器装备) do
        if v.需要数量 <= n then
            aa = true
            local r = { v.fun(list) }
            if type(r) == "table" then
                if r[1] then
                    return r
                end
            end
        end
    end
end

local _开光几率 = { 50, 25, 12, 7, 3 }
function 角色:角色_装备开光(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "九玄仙玉" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].是否装备 or list[1].级别 < 11 or list[1].佩饰 or list[1].装备类别 ~= "武器" then
        return '#Y只有武器才可以炼化属性。'
    end
    if list[1].数据.开光 and list[1].数据.开光 > 4 then
        return '#Y一件武器只能开光五次。'
    end

    local yzxh = 100000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    local tlxh = 10
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end
    self:角色_扣除银子(yzxh, "装备开光")
    self:角色_扣除体力(tlxh)
    list[2]:减少(1)
    if math.random(100) < _开光几率[(list[1].数据.开光 or 0) + 1] then
        if list[1].数据.开光 == nil then
            list[1].数据.开光 = 0
        end
        list[1].数据.开光 = list[1].数据.开光 + 1
        return { self.银子, self.体力, "#Y恭喜你，开光成功了！" }
    else
        return { self.银子, self.体力, "#Y很遗憾，开光失败了" }
    end
end

function 角色:角色_装备炼器(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "落魂砂" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].是否装备 or list[1].级别 < 11 or list[1].佩饰 or list[1].装备类别 ~= "武器" then
        return '#Y只有武器才可以炼化属性。'
    end
    if not list[1].数据.开光 then
        return '#Y开光过后的武器才可以进行炼器！'
    end


    local 神功笔录 = 0
    local 价值 = 0
    local 保留 = false

    for i, v in ipairs(list) do
        if v.价值 then
            价值 = 价值 + v.价值 * 3
        end
        if v.名称 == "神功笔录" then
            保留 = true
            神功笔录 = i
        elseif v.名称 == "落魂砂" then
            if v.数量 < 3 then
                return '#Y材料不足！'
            end
        end
    end
    if not list[1].数据.炼器属性 then
        保留 = false
    end
    local yzxh = 100000
    if 保留 then
        yzxh = 500000
    end
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end
    local tlxh = 10
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end

    local 确定 = true
    if list[1].数据.炼器属性 and list[1].数据.炼器属性.重复 and not 保留 then
        确定 = self.rpc:确认窗口('检查当前属性较好，确定再次炼器么？')
    end
    if not 确定 then
        return
    end




    self:角色_扣除银子(yzxh, "装备炼器")
    self:角色_扣除体力(tlxh)

    list[2]:减少(3)
    if list[神功笔录] and 保留 then
        list[神功笔录]:减少(1)
    end
    local t, 重复 = self:取普通装备炼器属性(价值, list[1].开光)
    if 保留 then
        self.临时炼器属性 = {}
        for k, v in pairs(t) do
            table.insert(self.临时炼器属性, { k, v })
        end
        self.临时炼器属性.nid = list[1].nid
        self.临时炼器属性.重复 = 重复
        t.重复 = 重复
        return "炼器", t, self.银子, self.体力, list[1].数据.炼器属性
    else
        list[1].数据.炼器属性 = {}
        for k, v in pairs(t) do
            table.insert(list[1].数据.炼器属性, { k, v })
        end
        list[1].数据.炼器属性.重复 = 重复
        return "炼器", t, self.银子, self.体力
    end
end

function 角色:角色_装备炼器属性替换()
    if not self.临时炼器属性 then
        return
    end
    if not self.临时炼器属性.nid then
        return
    end
    local nid = self.临时炼器属性.nid

    if __物品[nid] and __物品[nid].rid == self.id then
        local item = __物品[nid]
        item.数据.炼器属性 = {}
        for i, v in ipairs(self.临时炼器属性) do
            table.insert(item.数据.炼器属性, { v[1], v[2] })
        end
        item.数据.炼器属性.重复 = self.临时炼器属性.重复
        self.临时炼器属性 = nil
        return item.数据.炼器属性
    end
end

-- local _装备炼器重复控制 = {
--     {
--         { 触发 = false, 几率 = 1500 },
--         { 触发 = false, 几率 = 3000 },
--         { 触发 = false, 几率 = 6000 },
--         { 触发 = false, 几率 = 12000 },
--     },
--     {
--         { 触发 = false, 几率 = 1000 },
--         { 触发 = false, 几率 = 2000 },
--         { 触发 = false, 几率 = 4000 },
--         { 触发 = false, 几率 = 8000 },
--     },
--     {
--         { 触发 = false, 几率 = 600 },
--         { 触发 = false, 几率 = 1200 },
--         { 触发 = false, 几率 = 2400 },
--         { 触发 = false, 几率 = 4800 },
--     },
-- }
function 角色:取普通装备炼器属性(价值, n)
    local a = 1
    if 价值 >= 450 then
        a = 3
    elseif 价值 >= 375 then
        a = 2
    end
    local t = GGF.复制表(__脚本['scripts/make/炼器属性库.lua'])
    local r = {}
    n = math.random(n)
    local 重复 = false
    local cfjv = __脚本['scripts/make/几率控制.lua'].装备炼器重复控制


    local 可重复 = self:取重复几率(cfjv, a)
    local 重复数量 = self:取重复条数(可重复)
    if 重复数量 > n then --
        重复数量 = n
    end
    if 重复数量 > 1 then
        local cfsx = math.random(#t) -- 先随机取一条属性 进行重复
        table.insert(r, t[cfsx])
        n = n - 1
        for i = 1, 重复数量 - 1 do --开始重复
            table.insert(r, t[cfsx])
            n = n - 1
            重复 = true
        end
        table.remove(t, cfsx)
    end
    for i = 1, n do
        local s = math.random(#t)
        table.insert(r, t[s])
        table.remove(t, s)
    end

    local list = {}
    for k, v in pairs(r) do
        for a, b in pairs(r) do
            if v.名称 == b.名称 and k ~= a then
                重复 = true
            end
        end
        if list[v.名称] == nil then
            list[v.名称] = 0
        end
        if v.上限 < v.下限 then
            v.上限 = v.下限
            print(a .. "炼器属性库出错--" .. v.名称)
        end
        if _整数范围[v.名称] then
            list[v.名称] = list[v.名称] + math.random(v.下限, v.上限)
        else
            local sz = math.random(v.下限 * 10, v.上限 * 10) / 10
            list[v.名称] = list[v.名称] + sz
        end
    end
    return list, 重复
end

-- local _普通装备炼化重复控制 = {
--     {
--         { 触发 = false, 几率 = 1500 },
--         { 触发 = false, 几率 = 3000 },
--         { 触发 = false, 几率 = 6000 },
--         { 触发 = false, 几率 = 12000 },
--     },
--     {
--         { 触发 = false, 几率 = 1000 },
--         { 触发 = false, 几率 = 2000 },
--         { 触发 = false, 几率 = 4000 },
--         { 触发 = false, 几率 = 8000 },
--     },
--     {
--         { 触发 = false, 几率 = 600 },
--         { 触发 = false, 几率 = 1200 },
--         { 触发 = false, 几率 = 2400 },
--         { 触发 = false, 几率 = 4800 },
--     },
-- }

function 角色:取重复几率(t, a)
    local list = t[a]
    for i, v in ipairs(list) do
        v.触发 = false
    end
    return list
end

function 角色:取重复条数(可重复)
    for i = #可重复, 1, -1 do
        if math.random(可重复[i].几率) <= 1 then
            可重复[i].触发 = true
        end
    end

    local 重复条数 = 0
    for i = #可重复, 1, -1 do
        if 可重复[i].触发 then
            重复条数 = i
            break
        end
    end
    return 重复条数 + 1
end

function 角色:取普通装备炼化属性(类别, 价值)
    local a = 1
    if 价值 >= 495 then
        a = 3
    elseif 价值 >= 450 then
        a = 2
    end
    local 重复 = false
    local t = GGF.复制表(__脚本['scripts/make/普通装备炼化属性库.lua'][类别])
    local n = math.random(5) --
    local list = {}
    local r = {}
    local cfjv = __脚本['scripts/make/几率控制.lua'].普通装备炼化重复控制
    local 可重复 = self:取重复几率(cfjv, a)
    local 重复数量 = self:取重复条数(可重复)
    if 重复数量 > n then --
        重复数量 = n
    end
    if 重复数量 > 1 then
        local cfsx = math.random(#t) -- 先随机取一条属性 进行重复
        table.insert(r, t[cfsx])
        n = n - 1
        for i = 1, 重复数量 - 1 do --开始重复
            table.insert(r, t[cfsx])
            n = n - 1
            重复 = true
        end
        table.remove(t, cfsx)
    end
    for i = 1, n do --不存在重复
        local s = math.random(#t)
        table.insert(r, t[s])
        table.remove(t, s)
    end


    for k, v in pairs(r) do
        for a, b in pairs(r) do
            if v.名称 == b.名称 and k ~= a then
                重复 = true
            end
        end
        if list[v.名称] == nil then
            list[v.名称] = 0
        end
        if v.上限 < v.下限 then
            v.上限 = v.下限
            print(类别 .. a .. "普通装备炼化属性库出错--" .. v.名称)
        end
        if _整数范围[v.名称] then
            list[v.名称] = list[v.名称] + math.random(v.下限, v.上限)
        else
            local sz = math.random(v.下限 * 10, v.上限 * 10) / 10
            list[v.名称] = list[v.名称] + sz
        end
    end
    return list, 重复
end

--===============================================================================
function 角色:角色_佩饰重炼(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if not list[1].佩饰 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if #list == 3 and list[1].装备类别 == '护身符' then
        for i, v in ipairs { '', '六魂之玉', '内丹精华' } do
            if v ~= '' and list[i].名称 ~= v then
                return '#Y你提供的原料有问题，请重新执行一遍。'
            end
        end
    elseif #list == 6 then
        for i, v in ipairs { '', '六魂之玉', '血玲珑', '九彩云龙珠', '九彩云龙珠', '九彩云龙珠' } do
            if v ~= '' and list[i].名称 ~= v then
                return '#Y你提供的原料有问题，请重新执行一遍。'
            end
        end
    else
        return
    end


    if list[1].新手装备 then
        return '#Y新手装备无法操作！'
    end

    local yzxh = 1000000
    if self.银子 < yzxh then
        return '#Y银子不足，无法升级'
    end
    list[2]:减少(1)
    list[3]:减少(1)
    if list[4] then
        list[4]:减少(1)
    end
    if list[5] then
        list[5]:减少(1)
    end
    if list[6] then
        list[6]:减少(1)
    end
    self.银子 = self.银子 - yzxh
    local T
    if list[1].装备类别 == "披风" then
        T = require('数据库/装备属性_披风')
    elseif list[1].装备类别 == "面具" then
        T = require('数据库/装备属性_面具')
    elseif list[1].装备类别 == "挂件" then
        T = require('数据库/装备属性_挂件')
    elseif list[1].装备类别 == "腰带" then
        T = require('数据库/装备属性_腰带')
    elseif list[1].装备类别 == "戒指" then
        T = require('数据库/装备属性_戒指')
    elseif list[1].装备类别 == "护身符" then
        T = require('数据库/装备属性_护身符')
        if #list == 3 then
            list[1].数据.品质 = list[1].数据.品质 - math.random(1, 2)
            list[1].数据.基本属性 = T.取基础属性(list[1].数据.级别, list[1].数据.品质)
        elseif #list == 6 then
            list[1].数据.附加属性 = T.取附加抗性(list[1].数据.级别, list[1].数据.品质)
        end
        return { self.银子, "#Y重炼成功" }
    end

    list[1].数据.属性要求 = T.取佩饰属性需求(list[1].数据.级别)
    list[1].数据.基本属性 = T.取基础属性(list[1].数据.级别, list[1].数据.属性要求[1])
    list[1].数据.附加属性 = T.取附加抗性(list[1].数据.级别)
    local 百分比 = list[1].数据.默契值 / list[1].数据.默契值上限
    for i, v in ipairs(list[1].数据.附加属性) do
        if _整数范围[v[1]] then
            list[1].数据.附加属性[i][2] = math.ceil(list[1].数据.附加属性[i][3] * 百分比)
        else
            list[1].数据.附加属性[i][2] = math.ceil(list[1].数据.附加属性[i][3] * 百分比 * 10) * 0.1
        end
    end
    return { self.银子, "#Y重炼成功" }
end

function 角色:角色_佩饰升级(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "无量琉璃" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].佩饰 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].默契值 and list[1].默契值 < list[1].默契值上限 then
        return '#Y默契值没有达到上限！'
    end

    if list[1].级别 >= 7 then
        return '#Y已经达到等级上限'
    end
    if list[1].新手装备 then
        return '#Y新手装备无法操作！'
    end

    local yzxh = list[1].级别 * 400000
    if self.银子 < yzxh then
        return '#Y银子不足，无法升级'
    end
    list[2]:减少(1)
    self.银子 = self.银子 - yzxh

    if list[1].装备类别 == "披风" then
        local T = require('数据库/装备属性_披风')
        list[1].数据.级别 = list[1].数据.级别 + 1
        list[1].数据.默契值上限 = list[1].数据.级别 * 1000
        if list[1].数据.级别 > 3 then
            list[1].数据.默契值上限 = list[1].数据.默契值上限 + (list[1].数据.级别 - 2) * 1000
        end
        list[1].数据.默契值 = 1
        list[1].数据.名称 = T.取升级名称(list[1].数据.级别, list[1].数据.性别)
        list[1].数据.基本属性, list[1].数据.附加属性 = T.取升级属性(list[1].数据.基本属性,
            list[1].数据.附加属性, list[1].数据.级别, list[1].数据.属性要求[1])
        list[1].数据.等级需求 = T.取升级佩饰等级需求(list[1].数据.级别)
        list[1].数据.属性要求 = T.取升级佩饰属性需求(list[1].数据.级别, list[1].数据.属性要求[1
        ])

        return { self.银子, "#Y升级成功" }
    elseif list[1].装备类别 == "面具" then
        local T = require('数据库/装备属性_面具')
        list[1].数据.级别 = list[1].数据.级别 + 1
        list[1].数据.默契值上限 = list[1].数据.级别 * 1000
        if list[1].数据.级别 > 3 then
            list[1].数据.默契值上限 = list[1].数据.默契值上限 + (list[1].数据.级别 - 2) * 1000
        end
        list[1].数据.默契值 = 1
        list[1].数据.名称 = T.取升级名称(list[1].数据.级别, list[1].数据.性别)
        list[1].数据.基本属性, list[1].数据.附加属性 = T.取升级属性(list[1].数据.基本属性,
            list[1].数据.附加属性, list[1].数据.级别, list[1].数据.属性要求[1])
        list[1].数据.等级需求 = T.取升级佩饰等级需求(list[1].数据.级别)
        list[1].数据.属性要求 = T.取升级佩饰属性需求(list[1].数据.级别, list[1].数据.属性要求[1
        ])

        return { self.银子, "#Y升级成功" }
    elseif list[1].装备类别 == "挂件" then
        local T = require('数据库/装备属性_挂件')
        list[1].数据.级别 = list[1].数据.级别 + 1
        list[1].数据.默契值上限 = list[1].数据.级别 * 1000
        if list[1].数据.级别 > 3 then
            list[1].数据.默契值上限 = list[1].数据.默契值上限 + (list[1].数据.级别 - 2) * 1000
        end
        list[1].数据.默契值 = 1
        list[1].数据.名称 = T.取升级名称(list[1].数据.级别, list[1].数据.性别)
        list[1].数据.基本属性, list[1].数据.附加属性 = T.取升级属性(list[1].数据.基本属性,
            list[1].数据.附加属性, list[1].数据.级别, list[1].数据.属性要求[1])
        list[1].数据.等级需求 = T.取升级佩饰等级需求(list[1].数据.级别)
        list[1].数据.属性要求 = T.取升级佩饰属性需求(list[1].数据.级别, list[1].数据.属性要求[1
        ])

        return { self.银子, "#Y升级成功" }
    elseif list[1].装备类别 == "腰带" then
        local T = require('数据库/装备属性_腰带')
        list[1].数据.级别 = list[1].数据.级别 + 1
        list[1].数据.默契值上限 = list[1].数据.级别 * 1000
        if list[1].数据.级别 > 3 then
            list[1].数据.默契值上限 = list[1].数据.默契值上限 + (list[1].数据.级别 - 2) * 1000
        end
        list[1].数据.默契值 = 1
        list[1].数据.名称 = T.取升级名称(list[1].数据.级别, list[1].数据.性别)
        list[1].数据.基本属性, list[1].数据.附加属性 = T.取升级属性(list[1].数据.基本属性,
            list[1].数据.附加属性, list[1].数据.级别, list[1].数据.属性要求[1])
        list[1].数据.等级需求 = T.取升级佩饰等级需求(list[1].数据.级别)
        list[1].数据.属性要求 = T.取升级佩饰属性需求(list[1].数据.级别, list[1].数据.属性要求[1
        ])

        return { self.银子, "#Y升级成功" }
    elseif list[1].装备类别 == "戒指" then
        local T = require('数据库/装备属性_戒指')
        list[1].数据.级别 = list[1].数据.级别 + 1
        list[1].数据.默契值上限 = list[1].数据.级别 * 1000
        if list[1].数据.级别 > 3 then
            list[1].数据.默契值上限 = list[1].数据.默契值上限 + (list[1].数据.级别 - 2) * 1000
        end
        list[1].数据.默契值 = 1
        list[1].数据.名称 = T.取升级名称(list[1].数据.级别, list[1].数据.性别)

        if list[1].数据.部位 == 7 then
            list[1].数据.名称 = list[1].数据.名称 .. "#右"
        else
            list[1].数据.名称 = list[1].数据.名称 .. "#左"
        end

        list[1].数据.基本属性, list[1].数据.附加属性 = T.取升级属性(list[1].数据.基本属性,
            list[1].数据.附加属性, list[1].数据.级别, list[1].数据.属性要求[1])
        list[1].数据.等级需求 = T.取升级佩饰等级需求(list[1].数据.级别)
        list[1].数据.属性要求 = T.取升级佩饰属性需求(list[1].数据.级别, list[1].数据.属性要求[1
        ])

        return { self.银子, "#Y升级成功" }
    elseif list[1].装备类别 == "护身符" then
        local T = require('数据库/装备属性_护身符')
        list[1].数据.级别 = list[1].数据.级别 + 1
        list[1].数据.名称 = T.取升级名称(list[1].数据.级别)
        list[1].数据.等级需求 = T.取佩饰等级需求(list[1].数据.级别)
        list[1].数据.基本属性, list[1].数据.附加属性 = T.取升级属性(list[1].数据.级别, list[1].数据.品质, list[1].数据.基本属性, list[1].数据.附加属性)

        return { self.银子, "#Y升级成功" }
    end
end

function 角色:角色_佩饰培养(list, 次数)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if list[1].默契值 and list[2].名称 ~= "佩饰精华" and not list[2].佩饰 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].品质 and list[2].佩饰 and list[2].装备类别 ~= '护身符' then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].佩饰 then
        return '#Y只有佩饰才可以培养。'
    end
    if list[1].默契值 and list[1].默契值 >= list[1].默契值上限 then
        return '#Y默契值已经达到上限！'
    end

    if list[1].品质 and list[1].品质 >= 1000 then
        return '#Y品质已经达到上限！'
    end
    if list[1].新手装备 then
        return '#Y新手装备无法操作！'
    end
    次数 = list[2].数量 >= 次数 and 次数 or list[2].数量
    local yzxh = list[1].级别 * 20000
    if self.银子 < yzxh then
        return '#Y银子不足，无法培养'
    end
    local 增加量 = 20
    local 使用量 = 0

    if list[1].默契值 and 增加量 > 0 then
        local ts
        local 当前默契 = list[1].默契值
        local 默契值上限 = list[1].默契值上限
        for i = 1, 次数, 1 do
            if self.银子 < yzxh then
                ts = '#Y银子不足，无法培养'
                break
            end
            self.银子 = self.银子 - yzxh
            增加量 = 增加量 + 20
            使用量 = 使用量 + 1
            if 增加量 + 当前默契 >= 默契值上限 then
                break
            end
        end
        list[1].数据.默契值 = list[1].数据.默契值 + 增加量
        if list[1].数据.默契值 > list[1].数据.默契值上限 then
            list[1].数据.默契值 = list[1].数据.默契值上限
        end
        list[2]:减少(使用量)
        local 百分比 = list[1].数据.默契值 / list[1].数据.默契值上限
        for i, v in ipairs(list[1].数据.附加属性) do
            if _整数范围[v[1]] then
                list[1].数据.附加属性[i][2] = math.ceil(list[1].数据.附加属性[i][3] * 百分比)
            else
                list[1].数据.附加属性[i][2] = math.ceil(list[1].数据.附加属性[i][3] * 百分比 * 10) * 0.1
            end
        end
        return { self.银子, "#Y培养成功" }
    end

    if list[1].品质 and 增加量 > 0 then
        local ts
        local 当前品质 = list[1].品质
        local 品质上限 = 1000
        list[1].数据.品质 = list[1].数据.品质 + 增加量
        if list[1].数据.品质 > 1000 then
            list[1].数据.品质 = 1000
        end
        list[2]:减少(1)
        for i, v in ipairs(list[1].数据.附加属性) do
            if _整数范围[v[1]] then
                local n = math.floor(list[1].数据.附加属性[i][3] * list[1].数据.级别 * list[1].数据.品质 / 1000)
                list[1].数据.附加属性[i][2] = n
            else
                local n = math.floor(list[1].数据.附加属性[i][3] * list[1].数据.级别 * list[1].数据.品质 / 100) * 0.1
                if n * 10 < 1 then
                    n = 0.1
                end
                list[1].数据.附加属性[i][2] = n
            end
        end
        return { self.银子, "#Y培养成功" }
    end
end

function 角色:角色_打造佩饰提交材料(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    local n, aa = #list, false
    if n == 6 then
        local r
        if list[2].名称 == "六魂之玉" and list[3].名称 == "血玲珑" and list[4].名称 == "九彩云龙珠" and list[5].名称 == "九彩云龙珠" and list[6].名称 == "九彩云龙珠" then
            r = { _炼化佩饰.重炼.fun(list) }
        end
        if type(r) == "table" then
            if r[1] then
                return r
            end
        end
    elseif n == 2 then
        local r
        if list[2].名称 == "无量琉璃" then
            r = { _炼化佩饰.升级.fun(list) }
        elseif list[2].佩饰 and list[2].装备类别 == '护身符' then
            r = { _炼化佩饰.培养护身符.fun(list) }
        else
            r = { _炼化佩饰.培养.fun(list) }
        end
        if type(r) == "table" then
            if r[1] then
                return r
            end
        end
    elseif n == 3 then
        local r
        if list[2].名称 == "无量琉璃" and list[3].名称 == "血玲珑" then
            r = { _炼化佩饰.升级护身符.fun(list) }
        elseif list[2].名称 == "六魂之玉" and list[3].名称 == "内丹精华" then
            r = { _炼化佩饰.重炼护身符.fun(list) }
        end
        if type(r) == "table" then
            if r[1] then
                return r
            end
        end
    end
end

--===============================================================================
--===============================================================================
function 角色:角色_八荒遗风(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if list[1] and list[1].名称 == "八荒遗风" and list[2] and list[2].仙器 then
        local xh = { 800000, 2000000, 4800000, 8000000, 9600000 }
        local js = list[2].阶数
        return { xh[js] }
    end
    return '#Y你提供的原料有问题，请重新执行一遍。'
end

function 角色:角色_灌输灵气(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    local 上限 = { 8, 8, 6, 5, 3 }
    if list[1] and list[1].名称 == "八荒遗风" and list[2] and list[2].仙器 then
        if list[2].阶数 > 5 then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
        if list[1].灵气 then
            if list[1].阶数 ~= 0 and list[1].阶数 ~= list[2].阶数 then
                return '#Y你提供的原料有问题，请重新执行一遍。'
            elseif list[1].阶数 ~= 0 and list[1].灵气 >= 上限[list[1].阶数] then
                return '#Y灵气已满！'
            end
        end
        local js = list[2].阶数
        local xh = { 800000, 2000000, 4800000, 8000000, 9600000 }
        local yzxh = xh[js]
        if self.银子 < yzxh then
            return '#Y你没有那么多银子！'
        end
        self:角色_扣除银子(yzxh, "高级打造")
        if list[1].灵气 then
            list[1]:添加灵气()
        else
            list[1]:添加灵气(list[2].阶数, list[2].编号)
        end
        list[2]:减少(1)
        return { self.银子, "#Y灵气提升1点！" }
    end
end

local _仙器升级材料 = { "千年寒铁", "天外飞石", "盘古精铁", "补天神石", "六魂之玉", "无量琉璃" }
function 角色:角色_提交仙器升级材料(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].灵气 then
        return
    end
    if list[1].名称 ~= "八荒遗风" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local 上限 = { 8, 8, 6, 5, 3 }
    if list[1].灵气 < 上限[list[1].阶数] then
        return "#Y灵气未满"
    end
    if list[2].名称 ~= _仙器升级材料[list[1].阶数] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local xh = { 1500000, 2800000, 6000000, 12000000, 24000000 }
    --消耗
    return { xh[list[1].阶数 or 1] }
end

function 角色:角色_仙器升级(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].灵气 then
        return
    end
    if list[1].名称 ~= "八荒遗风" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local 上限 = { 8, 8, 6, 5, 3 }
    if list[1].灵气 < 上限[list[1].阶数] then
        return "#Y灵气未满"
    end
    if list[2].名称 ~= _仙器升级材料[list[1].阶数] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    local xh = { 1500000, 2800000, 6000000, 12000000, 24000000 }
    local yzxh = xh[list[1].阶数 or 1]
    if self.银子 < yzxh then
        return "#Y你没有那么多银子！"
    end

    self:角色_扣除银子(yzxh, "仙器升级")
    local 阶 = list[1].阶数 + 1
    local 名称 = _装备信息库.仙器名称表[math.random(#_装备信息库.仙器名称表)]
    list[1]:减少(1)
    list[2]:减少(1)
    self:物品_添加 {

        __沙盒.生成装备 { 名称 = 名称, 等级 = 阶 }

    }

    return { self.银子, string.format("#Y你获得了#R%s", 名称) }
end

function 角色:角色_提交仙器炼化材料(list, 保留)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].仙器 then
        return
    end
    if list[2].名称 ~= "仙器精华" and not list[2].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].仙器 and list[2].阶数 > 1 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 100000
    if 保留 then
        yzxh = 1000000
    end
    return { yzxh }
end

function 角色:角色_仙器炼化(list, 保留)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if not list[1].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "仙器精华" and not list[2].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].仙器 and list[2].阶数 > 1 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    local yzxh = 100000
    if 保留 then
        yzxh = 1000000
    end
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    self:角色_扣除银子(yzxh, "仙器炼化")


    list[2]:减少(1)
    --如何计算材料剩余可炼化次数
    local 剩余次数 = 0

    local t = GGF.复制表(__脚本['scripts/make/神兵精炼属性.lua'])[list[1].装备类别]
    local sx = t[math.random(#t)]
    local list2 = {}
    list2[sx.名称] = 0
    if _整数范围[sx.名称] then
        list2[sx.名称] = list2[sx.名称] + math.random(sx.下限, sx.上限)
    else
        local sz = math.random(sx.下限 * 10, sx.上限 * 10) / 10
        list2[sx.名称] = list2[sx.名称] + sz
    end

    if not list[1].数据.炼化属性 then
        保留 = false
    end
    if 保留 then
        self.临时仙器炼化属性 = {}
        for k, v in pairs(list2) do
            table.insert(self.临时仙器炼化属性, { k, v })
        end
        self.临时仙器炼化属性.nid = list[1].nid
        return "仙器炼化", list2, self.银子, list[1].数据.炼化属性
    else
        list[1].数据.炼化属性 = {}
        for k, v in pairs(list2) do
            table.insert(list[1].数据.炼化属性, { k, v })
        end
    end
    return "仙器炼化", list2, self.银子
end

function 角色:角色_仙器炼化属性替换()
    if not self.临时仙器炼化属性 then
        return
    end
    if not self.临时仙器炼化属性.nid then
        return
    end
    local nid = self.临时仙器炼化属性.nid

    if __物品[nid] and __物品[nid].rid == self.id then
        local item = __物品[nid]
        item.数据.炼化属性 = {}
        for i, v in ipairs(self.临时仙器炼化属性) do
            table.insert(item.数据.炼化属性, { v[1], v[2] })
        end
        self.临时仙器炼化属性 = nil
        return item.数据.炼化属性
    end
end

function 角色:角色_提交仙器重铸材料(list)
    if not _检查物品(self, list) then
        return
    end

    if #list < 2 then
        return
    end
    if not list[1].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "悔梦石" and list[2].名称 ~= "高级悔梦石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 2000000

    return { yzxh }
end

function 角色:角色_仙器重铸(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "悔梦石" and list[2].名称 ~= "高级悔梦石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local 阶数 = list[1].阶数
    if list[2].名称 == "高级悔梦石" and list[2].参数 < 阶数 then
        return '#Y请时候对应仙器阶数的高级悔梦石。'
    end

    local yzxh = 2000000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end
    self:角色_扣除银子(yzxh, "仙器重组")

    local 名称 = list[1].原名
    if list[2].名称 ~= "高级悔梦石" then
        名称 = _装备信息库.仙器名称表[math.random(#_装备信息库.仙器名称表)]
    end
    list[1]:减少(1)
    list[2]:减少(1)

    self:物品_添加 {

        __沙盒.生成装备 { 名称 = 名称, 等级 = 阶数 }

    }

    return { self.银子 }
end

local _普通打造材料 = { "乌金", "金刚石", "寒铁", "百炼精铁", "龙之鳞", "千年寒铁", "天外飞石",
    "盘古精铁", "补天神石" }
function 角色:角色_提交装备打造材料(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if type(list) ~= 'table' then
        return
    end
    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].佩饰 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    elseif list[1].级别 > 9 then
        return '#Y大于10的装备需要再作坊中生产。'
    end
    if list[2].名称 ~= _普通打造材料[list[1].级别] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 5000 * list[1].级别

    return { yzxh }
end

function 角色:角色_装备打造(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if type(list) ~= 'table' then
        return
    end

    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].佩饰 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    elseif list[1].级别 > 9 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= _普通打造材料[list[1].级别] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].宝石属性 or list[1].高级宝石属性 then
        return '#Y镶嵌过的装备无法打造。'
    end

    if list[1].数据.炼化属性 then
        return '#Y炼化过的装备不可生产。'
    end
    if list[1].级别 > 9 then
        return '#Y只有高级装备才可以在此生成'
    end

    local yzxh = 5000 * list[1].级别

    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end

    self:角色_扣除银子(yzxh, "装备打造")
    local 武器类别 = list[1].装备类别
    local 名称 = ""

    if 武器类别 == "武器" then
        名称 = _装备信息库.武器名称表[list[1].装备类型][list[1].级别 + 1]
    elseif 武器类别 == "衣服" or 武器类别 == "帽子" then
        名称 = _装备信息库[武器类别 .. "名称表"][list[1].性别][list[1].级别 + 1]
    elseif 武器类别 == "项链" or 武器类别 == "鞋子" then
        名称 = _装备信息库[武器类别 .. "名称表"][list[1].级别 + 1]
    end
    list[1]:减少(1)
    list[2]:减少(1)
    self:物品_添加 {
        __沙盒.生成装备 { 名称 = 名称 },
    }
    return { self.银子, string.format("#Y你获得了#R%s", 名称) }
end

--===============================================================================
--===============================================================================

function 角色:角色_提交神兵升级材料(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].等级 == 6 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if list[2].名称 ~= _仙器升级材料[list[1].数据.等级] and list[2].名称 ~= "高级神兵石" then --and not list[2].神兵
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 100000
    if list[1].等级 > 1 then
        yzxh = 1 * 2 ^ (list[1].等级 - 1) * 100000
    end
    if list[2].名称 == "高级神兵石" then
        yzxh = 50000000
    end
    return { yzxh }
end

local _神兵升级广播 = {
    "#G%s#Y眼疾手快的夺回了何大雷刚想贪污的#R%s，#Y，定眼一看原来四级了，乐的屁颠屁颠的。",
    "#Y刹那间，天空忽然传来#G%s#Y的一声长啸“有此五级#R%s#Y，今世别无所求”",
    "#Y神器问世，谁与争锋！何大雷双手将六级的#R%s#Y奉上，叹道：“只有风流如#G%s#Y才配的上这绝世神兵",
}
local _高级消耗 = {
    10000000,
    20000000,
    30000000,
    40000000,
    50000000,
}
function 角色:角色_神兵升级(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local dj = list[1].数据.等级
    if dj >= 6 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if list[2].名称 ~= _仙器升级材料[list[1].数据.等级] and list[2].名称 ~= "高级神兵石" then --and not list[2].神兵
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local 保留主 = false
    if list[2].名称 == "高级神兵石" then
        if list[2].参数 < dj then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
    end
    -- if self.体力<10 then
    --     return '#Y升级神兵需要10点体力。'
    -- end



    local yzxh = 100000
    if list[1].等级 > 1 then
        yzxh = 1 * 2 ^ (list[1].等级 - 1) * 100000
    end
    if list[2].名称 == "高级神兵石" then
        yzxh = _高级消耗[dj]
        保留主 = true
    end

    if self.银子 < yzxh then
        return "#Y你没有那么多银子！"
    end


    -- self:角色_扣除体力(10)
    self:角色_扣除银子(yzxh, "神兵升级")
    list[2]:减少(1)
    local 成功 = false
    if 保留主 then
        local t = __脚本['scripts/make/几率控制.lua'].高级神兵石
        local jl = t[dj]
        if jl then
            成功 = math.random(jl[1]) < jl[2]
        end
    else
        local 成功几率 = __脚本['scripts/make/几率控制.lua'].神兵升级
        成功 = math.random(100) < 成功几率[dj]
    end






    if 成功 then
        if list[1].数据.属性要求 then
            local sz = list[1].数据.属性要求[2] / dj
            sz = sz * (dj + 1)
            list[1].数据.属性要求[2] = math.floor(sz)
        end

        local 锁死属性 = "忽视防御程度"
        if list[1].数据.装备类型 == "爪" or list[1].数据.装备类型 == "刀" or list[1].数据.装备类型 == "斧" or list[1].数据.装备类型 == "棒" then
            锁死属性 = "忽视防御几率"
        end
        for k, v in pairs(list[1].数据.基本属性) do
            if v[1] ~= 锁死属性 then
                local r = v[2] / dj
                v[2] = r * (dj + 1)
            end
        end
        list[1].数据.等级 = list[1].数据.等级 + 1
        if list[1].装备类别 == "帽子" or list[1].装备类别 == "衣服" then
            list[1].名称 = list[1].原名 .. "#" .. list[1].数据.等级 .. "_" .. list[1].条数
        end

        if list[1].数据.等级 == 4 then
            __世界:发送系统(string.format(_神兵升级广播[1], self.名称, list[1].原名))
        elseif list[1].数据.等级 == 5 then
            __世界:发送系统(string.format(_神兵升级广播[2], self.名称, list[1].原名))
        elseif list[1].数据.等级 == 6 then
            __世界:发送系统(string.format(_神兵升级广播[3], list[1].原名, self.名称))
        end

        return { self.银子, string.format("#W好的，你的#Y%s#W已经升到了%s级。", list[1].原名,
            list[1].数据.等级) }
    else
        if 保留主 then
            return { self.银子, "很遗憾，神兵升级失败，请取走你的神兵。" }
        else
            list[1]:减少(1)
            return { self.银子, "很遗憾，神兵升级失败了！" }
        end
    end
end

function 角色:角色_提交神兵炼化材料(list)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "神兵石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 150000



    return { yzxh }
end

function 角色:角色_神兵炼化(list, 保留)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if type(list) ~= 'table' then
        return
    end
    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "神兵石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    -- if  list[1].数据.炼化属性  then
    --     return '#Y该装备已经上了神兵石了'
    -- end
    保留 = false
    -- if not list[1].数据.炼化属性 then
    --     保留 = false
    -- end
    local yzxh = 150000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end
    if self.体力 < 10 then
        return '#Y神兵炼化需要10点体力！'
    end
    self:角色_扣除体力(10)
    self:角色_扣除银子(yzxh, "神兵炼化")
    list[2]:减少(1)
    local k
    if list[1].装备类别 == "武器" then
        k = __脚本['scripts/make/神兵神兵石属性_橙.lua'][list[1].种族] --require("数据库/神兵炼化属性库")[list[1].种族]
    else
        k = __脚本['scripts/make/神兵神兵石属性_橙.lua'][list[1].原名] --require("数据库/神兵炼化属性库")[list[1].原名]
    end
    local sx = k[math.random(#k)]
    local r = {}
    for _, v in ipairs(sx) do
        r[v[1]] = v[2]
    end

    if 保留 then
        self.临时神兵炼化属性 = {}
        for _, v in pairs(sx) do
            table.insert(self.临时神兵炼化属性, { v[1], v[2] })
        end
        self.临时神兵炼化属性.nid = list[1].nid
        return "神兵炼化", r, self.银子, list[1].数据.炼化属性
    else
        list[1].数据.炼化属性 = {}
        for _, v in pairs(sx) do
            table.insert(list[1].数据.炼化属性, { v[1], v[2] })
        end
    end
    return "神兵炼化", r, self.银子
end

--玩家:神兵精炼窗口()
-- 玩家:神兵炼化窗口()
--[[ 完成后 检测刷新  剩余次数  提醒  广播 提醒   佩戴属性  佩戴角色 神兵 仙器描述 ]]

function 角色:角色_提交神兵精炼材料(list)
    if type(list) ~= 'table' then
        return
    end
    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "神兵石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 150000



    return { yzxh }
end

function 角色:角色_神兵精炼(list, 保留)
    if self.交易锁 then
        return "#Y请先解除安全锁！"
    end
    if type(list) ~= 'table' then
        return
    end
    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "神兵石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].数据.精炼属性 then
        保留 = false
    end
    local yzxh = 150000
    if 保留 then
        yzxh = 1500000
    end
    if self.体力 < 10 then
        return '#Y神兵精炼需要10点体力。'
    end


    if self.银子 < yzxh then --
        return '#Y你没有那么多银子！'
    end


    self:角色_扣除体力(10)
    self:角色_扣除银子(yzxh, "神兵精炼")
    list[2]:减少(1)


    local t, 重复 = self:取神兵精炼属性(list[1].装备类别)
    if not list[1].数据.精炼属性 then
        保留 = false
    end
    if 保留 then
        self.临时神兵精炼属性 = {}
        for k, v in pairs(t) do
            table.insert(self.临时神兵精炼属性, { k, v })
        end
        self.临时神兵精炼属性.nid = list[1].nid
        self.临时神兵精炼属性.重复 = 重复

        t.重复 = 重复

        return "神兵精炼", t, self.银子, list[1].数据.精炼属性
    else
        list[1].数据.精炼属性 = {}
        for k, v in pairs(t) do
            table.insert(list[1].数据.精炼属性, { k, v })
        end
        list[1].数据.精炼属性.重复 = 重复
    end
    return "神兵精炼", t, self.银子




    -- local t = __脚本['scripts/make/神兵精炼属性.lua'][list[1].装备类别] --require("数据库/仙器炼化属性库")[list[1].装备类别]
    -- local sx = t[math.random(#t)]--
    -- local list2 = {}
    -- list2[sx.名称] = 0


    -- local 负数 = false
    -- local s, x = sx.下限, sx.上限
    -- if sx.下限 < 0 then
    --     负数 = true
    --     s, x = math.abs(sx.下限), math.abs(sx.上限)
    -- end
    -- if _整数范围[sx.名称] then --todo 负数报错
    --     if 负数 then

    --         list2[sx.名称] = list2[sx.名称] + 0 - math.random(s, x)
    --     else
    --         list2[sx.名称] = list2[sx.名称] + math.random(s, x)
    --     end

    -- else
    --     local sz = math.random(s * 10, x * 10) / 10
    --     list2[sx.名称] = list2[sx.名称] + sz
    -- end


    -- if 保留 then
    --     self.临时神兵精炼属性 = {}
    --     for k, v in pairs(list2) do
    --         table.insert(self.临时神兵精炼属性, { k, v })
    --     end
    --     self.临时神兵精炼属性.nid = list[1].nid
    --     return "神兵精炼", list2, self.银子, list[1].数据.精炼属性
    -- else
    --     list[1].数据.精炼属性 = {}
    --     for k, v in pairs(list2) do

    --         table.insert(list[1].数据.精炼属性, { k, v })
    --     end
    -- end
    -- return "神兵精炼", list2, self.银子
end

function 角色:取神兵精炼属性(类别)
    local a = 1
    local 重复 = false

    local t = GGF.复制表(__脚本['scripts/make/神兵精炼属性.lua'][类别])
    local n = math.random(5) --
    local list = {}
    local r = {}
    local cfjv = __脚本['scripts/make/几率控制.lua'].神兵精炼重复控制
    local 可重复 = self:取重复几率(cfjv, a)
    local 重复数量 = self:取重复条数(可重复)
    if 重复数量 > n then --
        重复数量 = n
    end
    if 重复数量 > 1 then
        local cfsx = math.random(#t) -- 先随机取一条属性 进行重复
        table.insert(r, t[cfsx])
        n = n - 1
        for i = 1, 重复数量 - 1 do --开始重复
            table.insert(r, t[cfsx])
            n = n - 1
            重复 = true
        end
        table.remove(t, cfsx)
    end
    for i = 1, n do --不存在重复
        local s = math.random(#t)
        table.insert(r, t[s])
        table.remove(t, s)
    end


    for k, v in pairs(r) do
        for a, b in pairs(r) do
            if v.名称 == b.名称 and k ~= a then
                重复 = true
            end
        end
        if list[v.名称] == nil then
            list[v.名称] = 0
        end
        if v.上限 < v.下限 then
            v.上限 = v.下限
            print(类别 .. a .. "神兵精炼属性库出错--" .. v.名称)
        end
        if _整数范围[v.名称] then
            list[v.名称] = list[v.名称] + math.random(v.下限, v.上限)
        else
            local sz = math.random(v.下限 * 10, v.上限 * 10) / 10
            list[v.名称] = list[v.名称] + sz
        end
    end
    return list, 重复
end

function 角色:角色_神兵精炼属性替换()
    if not self.临时神兵精炼属性 then
        return
    end
    if not self.临时神兵精炼属性.nid then
        return
    end
    local nid = self.临时神兵精炼属性.nid

    if __物品[nid] and __物品[nid].rid == self.id then
        local item = __物品[nid]
        item.数据.精炼属性 = {}
        for i, v in ipairs(self.临时神兵精炼属性) do
            table.insert(item.数据.精炼属性, { v[1], v[2] })
        end
        self.临时神兵精炼属性 = nil
        return item.数据.精炼属性
    end
end

function 角色:角色_提交神兵强化材料(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[2].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 100000
    if list[1].等级 > 1 then
        yzxh = 1 * 2 ^ (list[1].等级 - 1) * 100000
    end

    return { yzxh }
end

function 角色:角色_神兵强化(list)
    if self.交易锁 then
        return "#Y请前往长安钱庄老板处解除交易锁！"
    end
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 or list[1].等级 < 4 then
        return '#Y只有4级或者4级以上神兵才可以使用精炼升级。'
    end
    if not list[2].神兵 or list[2].等级 < 1 or list[2].等级 > 3 then
        return '#Y你提供的原料有问题，必须是1级到3级的神兵，请重新执行一遍。'
    end
    if list[1].等级 >= 6 then
        return '#Y神兵等级已达上限。'
    end
    local yzxh = 100000
    if list[1].等级 > 1 then
        yzxh = 1 * 2 ^ (list[1].等级 - 1) * 100000
    end
    if self.银子 < yzxh then
        return "#Y你没有那么多银子！"
    end

    self:角色_扣除银子(yzxh)
    list[2]:减少(1)
    local dj = list[1].等级
    local 成功几率 = __脚本['scripts/make/几率控制.lua'].神兵强化
    if math.random(1000) < 成功几率[dj] then
        if list[1].数据.属性要求 then
            local sz = list[1].数据.属性要求[2] / dj
            sz = sz * (dj + 1)
            list[1].数据.属性要求[2] = math.floor(sz)
        end

        local 锁死属性 = "忽视防御程度"
        if list[1].数据.装备类型 == "爪" or list[1].数据.装备类型 == "刀" or list[1].数据.装备类型 == "斧" or list[1].数据.装备类型 == "棒" then
            锁死属性 = "忽视防御几率"
        end
        for k, v in pairs(list[1].数据.基本属性) do
            if v[1] ~= 锁死属性 then
                local r = v[2] / dj
                v[2] = r * (dj + 1)
            end
        end
        list[1].数据.等级 = list[1].数据.等级 + 1
        if list[1].装备类别 == "帽子" or list[1].装备类别 == "衣服" then
            list[1].名称 = list[1].原名 .. "#" .. list[1].数据.等级 .. "_" .. list[1].条数
        end

        if list[1].数据.等级 == 4 then
            __世界:发送系统(string.format(_神兵升级广播[1], self.名称, list[1].原名))
        elseif list[1].数据.等级 == 5 then
            __世界:发送系统(string.format(_神兵升级广播[2], self.名称, list[1].原名))
        elseif list[1].数据.等级 == 6 then
            __世界:发送系统(string.format(_神兵升级广播[3], list[1].原名, self.名称))
        end

        return { self.银子, string.format("#W好的，你的#Y%s#W已经升到了%s级。", list[1].原名, list[1].数据.等级) }
    else
        local r = __沙盒.生成物品 { 名称 = '神兵碎片', 数量 = math.random(1, 3) }
        self:物品_添加({ r })
        return { self.银子, "强化失败!!!!" }
    end
end

--===============================================================================
--===============================================================================
function 角色:角色_打开作坊总管窗口()
    return self:角色_取作坊列表()
end

function 角色:提升作坊熟练(r, n)
    if r then
        if r.熟练度 < 100000 then
            r.熟练度 = r.熟练度 + math.floor(n)
            if r.熟练度 > 100000 then
                r.熟练度 = 100000
            end
            return r
        end
    end
end

function 角色:角色_提升作坊熟练(n, 次数)
    if not 次数 then
        次数 = 1
    end
    local tlxh = 次数 * 20
    local yzxh = 次数 * 100000
    if self.体力 < tlxh then
        return "#Y你的体力不足！"
    end
    if self.银子 < yzxh then
        return "#Y你的银两不足！"
    end
    local r = self.作坊[n]
    if r then
        if r.熟练度 < 100000 then
            local tj = 0
            for i = 1, 次数 do
                tj = tj + math.random(15, 25)
            end
            r.熟练度 = r.熟练度 + tj
            if r.熟练度 > 100000 then
                r.熟练度 = 100000
            end
            self:角色_扣除银子(yzxh, "提升作坊")
            self:角色_扣除体力(tlxh)
            return r, self.体力, string.format("#Y%s获得%s点熟练度", r.名称, tj)
        else
            return "#Y熟练度达到上限！"
        end
    end
end

function 角色:角色_提升作坊等级(n)
    local r = self.作坊[n]
    if r then
        local slxh = (r.等级 + 1) * 2
        local yzxh = (r.等级 + 1) * 250
        if r.熟练度 < slxh then
            return "#Y你的熟练度不足！"
        end
        if self.银子 < yzxh then
            return "#Y你的银两不足！"
        end
        if r.等级 < 126 then
            r.等级 = r.等级 + 1
            self:角色_扣除银子(yzxh, "提升作坊2")
            r.熟练度 = r.熟练度 - slxh
            return r, string.format("#Y%s提升至%s级", r.名称, r.等级)
        else
            return "#Y等级度达到上限！"
        end
    end
end

local _等级需求 = { 8, 24, 40, 56, 72, 88, 104, 999 }
function 角色:角色_提升作坊段位(n)
    local r = self.作坊[n]
    if r and r.段位 then
        local djxh = _等级需求[r.段位 + 1]
        local yzxh = _等级需求[r.段位 + 1] * 250000
        if r.等级 < djxh then
            return "#Y你的等级不够！"
        end
        if self.银子 < yzxh then
            return "#Y你的银两不足！"
        end
        if r.段位 < 7 then
            r.段位 = r.段位 + 1
            self:角色_扣除银子(yzxh, "提升作坊3")
            return r, string.format("#Y%s提升至%s段", r.名称, r.段位)
        else
            return "#Y等级度达到上限！"
        end
    end
end

function 角色:角色_提交香火材料(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end

    if not list[1].是否装备  then
        return '#Y只有装备才可以炼化属性。'
    elseif list[1].数据.特技 then
        return '#Y该装备已经有特技了。'
    end
    if list[2].名称 ~= "低级祈神香" and list[2].名称 ~= "中级祈神香" and list[2].名称 ~= "高级祈神香" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    return { 1000000 }
end

local 特技库=require('数据库/特技库')
function 角色:角色_装备香火(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end

    if not list[1].是否装备  then
        return '#Y只有装备才可以炼化属性。'
    elseif list[1].数据.特技 then
        return '#Y该装备已经有特技了。'
    end
    if list[2].名称 ~= "低级祈神香" and list[2].名称 ~= "中级祈神香" and list[2].名称 ~= "高级祈神香" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local 增加 = 100 
    if list[2].名称 == "中级祈神香" then
        增加 = 300
    elseif list[2].名称 == "高级祈神香" then
        增加 = 1500
    end
    self:角色_扣除银子(1000000, "祈神")
    list[2]:减少(1)
    list[1].数据.祈福值 = (list[1].数据.祈福值 or 0) + 增加
    if list[1].祈福值 >= 1500 then
        local sj = math.random(1,#特技库)
        list[1].数据.特技 = 特技库[sj].名称--'亢龙有悔' 特技库[sj].名称
        list[1].数据.祈福值 = 0
        return { self.银子, string.format("#Y你的诚心感动了上天，该装备获得了特技%s", 特技库[sj].名称) }
    else
        return { self.银子, string.format("#Y你的祈福上天已经收到了") }
    end
end

function 角色:角色_提交还愿材料(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end

    if not list[1].是否装备  then
        return '#Y只有装备才可以还愿。'
    elseif not list[1].数据.特技 then
        return '#Y该装备没有特技。'
    end
    if list[2].名称 ~= "还愿香" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    return { 1000000 }
end

function 角色:角色_装备还愿(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end

    if not list[1].是否装备  then
        return '#Y只有装备才可以还愿。'
    elseif not list[1].数据.特技 then
        return '#Y该装备没有特技。'
    end
    if list[2].名称 ~= "还愿香" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    self:角色_扣除银子(1000000, "祈神")
    list[2]:减少(1)
    list[1].数据.特技 = nil
    return { self.银子, string.format("#Y你的愿望上天已经收到了", 名称) }
end

function 角色:角色_检查合成材料(list)
    if type(list) == "table" then
        if #list == 0 then
            return true
        end
        local item1 = list[1]
        local item2 = list[2]
        if (item1 and __物品[item1] and __物品[item1].rid == self.id and __物品[item1].是否装备) then
            return true
        end
    end
    return false
end
