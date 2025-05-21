local 角色 = require('角色')
local _可镶嵌 = {
    项链 = {},
    帽子 = {
        物理吸收 = true,
        抗风 = true,
        抗雷 = true,
        抗水 = true,
        抗火 = true,
        抗中毒 = true,
        抗混乱 = true,
        抗昏睡 = true,
        抗封印 = true,
        附加气血 = true,
        附加魔法 = true,

    },
    衣服 = {
        抗风 = true,
        抗雷 = true,
        抗水 = true,
        抗火 = true,
        抗中毒 = true,
        抗混乱 = true,
        抗昏睡 = true,
        抗封印 = true,
        附加气血 = true,
        附加魔法 = true,
        反震程度 = true,
        反震率 = true,
        反击次数 = true, --太阳石
        反击率 = true, --太阳石



    },

    鞋子 = {
        敏捷 = true,
        躲闪率 = true,
    },

    武器 = {
        致命几率 = true,
        抗致命几率 = true,
        连击次数 = true,
        狂暴几率 = true,
        命中率 = true,
        连击率 = true,
        反击次数 = true,
        反击率 = true,

    },

}

function 角色:角色_提交宝石摘除材料(list)
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
    if not list[1].数据.高级宝石属性 or #list[1].数据.高级宝石属性 == 0 then
        return '#Y该装备还没有镶嵌高级宝石'
    end
    if list[2].名称 ~= "宝石精华" then
        return '#Y材料不符！'
    end
    local yzxh = 50000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end
    return { yzxh }
end

function 角色:角色_宝石摘除(list)
    if type(list) ~= 'table' then
        return
    end
    local 消耗 = 0
    local r = self:角色_提交宝石摘除材料(list)
    if type(r) == "string" then
        return r
    elseif type(r) == "table" then
        消耗 = r[1]
    end
    
    if self.银子 < 消耗 then
        return '#Y你没有那么多银子！'
    end
    local str = "请选择要摘除的宝石！\nmenu\n"
    for i,v in ipairs(list[1].数据.高级宝石属性) do
        str = str ..string.format("%s|%s(%s级)\n",i,v[3],v[4])
    end
    local i = self.接口:选择窗口(str)
    if not i then
        return false
    end
    i = tonumber(i)
    if list[1].数据.高级宝石属性[i] then
        local 材料消耗 = list[1].数据.高级宝石属性[i][4]*3
        if list[2].数量 < 材料消耗 then
            return "#Y本次摘除需要消耗宝石精华*"..材料消耗
        end
        local 禁止交易 = list[2].禁止交易
        list[2]:减少(材料消耗)
        self:角色_扣除银子(消耗)
        local 临时宝石 = list[1].数据.高级宝石属性[i]
        self.接口:添加物品({
            __沙盒.生成物品 { 名称 = 临时宝石[3], 等级 = 临时宝石[4], 品质 = 临时宝石[5], 宝石属性 = 临时宝石[1], 宝石数值 = 临时宝石[2] ,禁止交易 = 禁止交易},
        })
        table.remove(list[1].数据.高级宝石属性,i)
        if #list[1].数据.高级宝石属性 == 0 then list[1].数据.高级宝石属性 = nil end
        return { self.银子, "拆除成功" }
    else
        return '#Y数据错误，没有这样的宝石！'
    end
    
end


function 角色:角色_提交装备高级镶嵌材料(list)
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
    if #list < 3 then
        return
    end

    if not __config.新宝石 then
        return
    end


    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    --  if list[1].炼化属性 then
    --      return '#Y炼化过的装备不可以再镶嵌宝石'
    --  end
    if not list[2].是否高级宝石 then
        return '#Y材料2应放入高级宝石！'
    end
    if type(list[2].宝石属性) ~= "string" then
        return '#Y材料2不符！'
    end
    if list[3].名称 ~= "宝石精华" then
        return '#Y材料3应放入宝石精华！'
    end

    if list[1].数据.高级宝石属性 and #list[1].数据.高级宝石属性 == 3 then
        return '#Y一件装备只可以镶嵌3颗宝石'
    end
    if list[1].数据.高级宝石属性 then
        for i,v in ipairs(list[1].数据.高级宝石属性) do
            if v[3] == list[2].名称 then
                return '#Y该装备已经打造过该宝石了'
            end
        end
    end
    local kx = list[2].名称
    local 装备类别 = list[1].装备类别
    if 装备类别 == "项链" then
        if kx ~= "沐阳石" and kx ~= "芙蓉石" then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    elseif 装备类别 == "武器" then
        if kx ~= "赤焰石" and kx ~= "紫烟石" and kx ~= "孔雀石" then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    elseif 装备类别 == "鞋子" then
        if kx ~= "琉璃石" and kx ~= "寒山石" then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    elseif 装备类别 == "衣服" then
        if kx ~= "落星石" and kx ~= "沐阳石" then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    elseif 装备类别 == "帽子" then
        if kx ~= "落星石" and kx ~= "芙蓉石" then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    end
    --镶嵌花多少钱
    local yzxh = 50000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end
    return { yzxh }
end

function 角色:角色_装备高级镶嵌(list)
    if type(list) ~= 'table' then
        return
    end
    local 消耗 = 0
    local r = self:角色_提交装备高级镶嵌材料(list)
    if type(r) == "string" then
        return r
    elseif type(r) == "table" then
        消耗 = r[1]
    end
    local 材料消耗 = list[2].等级*3
    if self.银子 < 消耗 then
        return '#Y你没有那么多银子！'
    elseif list[3].数量 < 材料消耗 then
        return "#Y本次打造需要消耗宝石精华*"..材料消耗
    end
    self:角色_扣除银子(消耗)
    --{抗性名称,数值,宝石名称,等级,价值}
    local t = {
        list[2].宝石属性,
        list[2].宝石数值,
        list[2].名称,
        list[2].等级,
        list[2].品质,
    }
    list[2]:减少(1)
    list[3]:减少(材料消耗)
    if not list[1].数据.高级宝石属性 then
        list[1].数据.高级宝石属性 = {}
    end

    table.insert(list[1].数据.高级宝石属性, t)
    return { self.银子, "镶嵌成功" }
end


function 角色:角色_提交装备镶嵌材料(list)
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
    if list[1].级别 > 10 then
        return '#Y只有普通装备才可以镶嵌宝石'
    end
    if list[1].炼化属性 then
        return '#Y炼化过的装备不可以再镶嵌宝石'
    end
    if not list[2].宝石属性 then
        return '#Y材料不符！'
    end

    if type(list[2].宝石属性) ~= "string" then
        return '#Y材料不符！'
    end

   
    if list[1].宝石属性 and #list[1].宝石属性 == 3 then
        return '#Y一件装备只可以镶嵌3颗宝石'
    end

    local kx = list[2].宝石属性
    local 装备类别 = list[1].装备类别 --这五件
    if 装备类别 == "项链" then
        if kx == "附加气血" then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    elseif 装备类别 == "武器" then
        if not _可镶嵌.武器[kx] then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    elseif 装备类别 == "鞋子" then
        if not _可镶嵌.鞋子[kx] then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    elseif 装备类别 == "衣服" then
        if not _可镶嵌.衣服[kx] then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    elseif 装备类别 == "帽子" then
        if not _可镶嵌.帽子[kx] then
            return '#Y这颗宝石不可以镶嵌在此部位'
        end
    end
    local yzxh = 50000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end

    return { yzxh }
end

function 角色:角色_装备镶嵌(list)
    if type(list) ~= 'table' then
        return
    end
    local 消耗 = 0
    local r = self:角色_提交装备镶嵌材料(list)
    if type(r) == "string" then
        return r
    elseif type(r) == "table" then
        消耗 = r[1]
    end
    if self.银子 < 消耗 then
        return '#Y你没有那么多银子！'
    end
    self:角色_扣除银子(消耗)
    --{抗性名称,数值,宝石名称,等级,价值}
    local t = {
        list[2].宝石属性,
        list[2].宝石数值,
        list[2].名称,
        list[2].等级,
        list[2].价值,
    }
    list[2]:减少(1)
    if not list[1].数据.宝石属性 then
        list[1].数据.宝石属性 = {}
    end

    table.insert(list[1].数据.宝石属性, t)
    return { self.银子, "镶嵌成功" }
end

function 角色:角色_获取神兵属性数量(name)
    if __脚本['scripts/make/神兵库.lua'][name] then
        return #__脚本['scripts/make/神兵库.lua'][name]
    else
        return 0
    end
end

function 角色:角色_获取神兵属性(name, n)
    local t = __脚本['scripts/make/神兵库.lua'][name]
    if t and t[n] then
        return t[n]
    end
end

local _兑换物品 = {
    [1] = "一级神兵自选卡",
    [2] = "二级神兵自选卡",
    [3] = "三级神兵自选卡",
    [4] = "四级神兵自选卡",
    [5] = "五级神兵自选卡",
    [6] = "六级神兵自选卡",
}
function 角色:角色_兑换神兵(name, n, leve)

    local t = __脚本['scripts/make/神兵库.lua'][name]
    if t and t[n] then
        local 物品 = _兑换物品[leve]
        if not 物品 then
            return "该等级暂未开启兑换"
        end
        if not self:物品_查找空位() then
            return "#Y最少预留一个包裹空位"
        end
        local r = self:物品_获取(物品)
        if not r then
            return "#Y你身上没有" .. 物品
        end
        r:减少(1)
        self:物品_添加 {
            __沙盒.生成装备 { 名称 = name, 等级 = leve, 序号 = n },
        }
        self.rpc:提示窗口("#Y你使用一个#G%s#Y兑换了一个#G%s#Y。",物品,name)
        return true
    else
        return "该神兵属性不存在"
    end
end
