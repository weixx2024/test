local 角色 = require('角色')
local _可合成 = {
    沧海珠 = true,
    蓝田玉 = true,
    烈焰砂 = true,
    灵犀角 = true,
    五溪散 = true,
    武帝袍 = true,
    霄汉鼎 = true,
    雪蟾蜍 = true,
    云罗帐 = true,
    盘古石 = true,
}
local _随机炼妖石 = {
    "沧海珠",
    "蓝田玉",
    "烈焰砂",
    "灵犀角",
    "五溪散",
    "武帝袍",
    "霄汉鼎",
    "雪蟾蜍",
    "云罗帐",
    "盘古石",
}
local _炼妖合成消耗 = {
    5000,     --9
    10000,    --10
    20000,    --11
    40000,    --11
    80000,    --11
    160000,   --11
    320000,   --11
    640000,   --11
    1280000,  --11
    2560000,  --11
    5120000,  --11
    10240000, --11

}
function 角色:角色_提交合成炼妖石(list)
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
    if not _可合成[list[1].名称] or not _可合成[list[2].名称] then
        return '#Y只有炼妖石材可以合成。'
    end
    if list[1].数据.参数 >= 13 then
        return '#Y该炼妖石已经达到最高数值,无法继续合成。'
    end
    if list[1].参数 ~= list[2].参数 then
        return '#Y需要两个相同数值的炼妖石材可以合成。'
    end

    if list[1].名称 == "盘古石" and list[2].名称 ~= "盘古石" then
        return '#Y盘古石不可与其它类型炼妖石合成。'
    end

    local 消耗 = _炼妖合成消耗[list[1].参数]
    -- if list[1].名称 == "盘古石" then
    --     消耗 = math.floor((list[1].参数 * 0.5) * (list[1].参数 * 0.5) * 500)
    -- end
    -- if list[1].参数 >= 9 then
    --     消耗 = _高级消耗[list[1].参数 - 8]
    -- end


    return { 消耗 }
end

function 角色:角色_合成炼妖石(list)
    if type(list) ~= 'table' then
        return
    end
    local 消耗 = 0
    local r = self:角色_提交合成炼妖石(list)
    if type(r) == "string" then
        return r
    elseif type(r) == "table" then
        消耗 = r[1]
    end
    if list[1].参数 >= 13 then
        return '#Y该炼妖石已经达到最高数值,无法继续合成。'
    end
    if self.银子 < 消耗 then
        return '#Y你没有那么多银子。'
    end
    local 随机 = list[1].名称 ~= list[2].名称
    local 成败 = false
    local name = list[1].名称
    local 参数 = list[1].参数
    local jlkz = __脚本['scripts/make/几率控制.lua'].炼妖石合成几率
    local jz = jlkz[list[1].参数]
    if math.random(100) <= (jz or 10) then
        成败 = true
    end
    if not 成败 then
        list[2]:减少(1)
        return { self.银子, "对不起,你的炼妖石我合成的时候不小心打坏了一个。" }
    else
        list[1]:减少(1)
        list[2]:减少(1)
    end


    self:角色_扣除银子(消耗)
    if 随机 then
        name = _随机炼妖石[math.random(10)]
    end

    self:物品_添加 {
        __沙盒.生成物品 { 名称 = name, 参数 = 参数 + 1 },
    }

    return { self.银子, "好的,我帮你打造出了一个更好的炼妖石。" }
end

local _宝石可合成 = {
    绿宝石 = true,
    神秘石 = true,
    符咒石 = true,
    智慧石 = true,
    月亮石 = true,
    太阳石 = true,
    黑宝石 = true,
    蓝宝石 = true,
    黄宝石 = true,
    红宝石 = true,
    光芒石 = true,
    赤焰石 = true,
    紫烟石 = true,
    孔雀石 = true,
    落星石 = true,
    沐阳石 = true,
    芙蓉石 = true,
    琉璃石 = true,
    寒山石 = true,
}

local _高级宝石 = {
    赤焰石 = true,
    紫烟石 = true,
    孔雀石 = true,
    落星石 = true,
    沐阳石 = true,
    芙蓉石 = true,
    琉璃石 = true,
    寒山石 = true,
}

local _宝石合成消耗 = {
    10000,
    20000,
    50000,
    100000,
    200000,
    400000,
    800000,
    2000000,
    5000000,

}
function 角色:角色_提交宝石合成(list)
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
    if not _宝石可合成[list[1].名称] or not _宝石可合成[list[2].名称] then
        return '#Y只有宝石才可以合成。'
    end
    if list[1].数据.等级 >= 10 and not _高级宝石[list[1].名称] then
        return '#Y该宝石已经达到最高等级,无法继续合成。'
    end
    if list[1].数据.等级 ~= list[2].数据.等级 then
        return '#Y需要两个相同等级的宝石才可以合成。'
    end
   
    if (_高级宝石[list[1].名称] and not _高级宝石[list[2].名称]) or (_高级宝石[list[2].名称] and not _高级宝石[list[1].名称]) then
        return '#Y高级宝石只可以与高级宝石进行合成。'
    end
    local 消耗 = _宝石合成消耗[list[1].数据.等级]
    if _高级宝石[list[1].名称] then
        消耗 = list[1].数据.等级*100000   --银子消耗 
    end
    return { 消耗 }
end


function 角色:角色_提交宝石鉴定(list)
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
    if list[1].名称 ~= '奇异石'  then
        return '#Y请将要鉴定的奇异石放在1号位置，否则无法鉴定'
    elseif not list[2].是否高级宝石 then
        return '#Y鉴定奇异石需要奇异石等级-3的高级宝石作为材料'
    end
    if list[2].数据.等级 ~= list[1].数据.等级 - 3 then
        return '#Y鉴定奇异石需要奇异石等级-3的高级宝石作为材料。'
    end
    local 消耗 = list[1].数据.等级*10000   --银子消耗 
    return { 消耗 }
end

function 角色:角色_提交宝石重铸(list)
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
    if not _宝石可合成[list[1].名称] or not _宝石可合成[list[2].名称] then
        return '#Y只有宝石才可以合成。'
    end
    if not list[1].是否高级宝石 or not list[2].是否高级宝石 then
        return '#Y宝石重铸需要使用5级以上高级宝石+ 主宝石-4级辅助高级宝石'
    end
    if list[1].数据.等级 < 5 then
        return '#Y只有5级以上宝石才能重铸'
    end
    if list[2].数据.等级 ~= list[1].数据.等级 - 4 then
        return '#Y宝石重铸需要使用5级以上高级宝石+ 主宝石-4级辅助高级宝石'
    end
    local 消耗 = list[1].数据.等级*10000   --银子消耗 
    return { 消耗 }
end

--local _宝石合成几率 = { 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 }

local _随机宝石 = {
    "绿宝石",
    "神秘石",
    "符咒石",
    "智慧石",
    "月亮石",
    "太阳石",
    "黑宝石",
    "蓝宝石",
    "黄宝石",
    "红宝石",
    "光芒石",
}

function 角色:角色_合成宝石(list)
    if type(list) ~= 'table' then
        return
    end
    local 消耗 = 0
    local r = self:角色_提交宝石合成(list)
    if type(r) == "string" then
        return r
    elseif type(r) == "table" then
        消耗 = r[1]
    end
    if self.银子 < 消耗 then
        return '#Y你没有那么多银子。'
    end
    if _高级宝石[list[1].名称] then
        local 名称 = list[1].名称 ~= list[2].名称 and _高级宝石[math.random(#_高级宝石)] or list[1].名称
        local 等级 = list[1].等级
        local 成败 = false
        local jlkz = __脚本['scripts/make/几率控制.lua'].高级宝石合成几率
        local jz = jlkz[等级]
        if math.random(100) <= jz then
            成败 = true
        end
        local 禁止交易
        if list[1].禁止交易 or list[2].禁止交易 then
            禁止交易 = self.rpc:确认窗口('本次合成包含禁止交易的物品，继续合成会到这合成后的宝石为绑定状态！')
            if not 禁止交易 then
                return
            end
        end
        if not 成败 then --失败
            list[math.random(2)]:减少(1)
            return { self.银子, "对不起,你的宝石我合成的时候不小心打坏了一个。" }
        else --成功
            list[1]:减少(1)
            list[2]:减少(1)
        end
        self:角色_扣除银子(消耗)
        if math.random(100) <= 10 and 等级 >= 4 then --合成的时候概率奇异石10% 嗯
            self:物品_添加({
                __沙盒.生成物品 { 名称 = "奇异石" ,等级 = 等级 + 1 ,禁止交易 = 禁止交易},
            })
        else
            if 等级>= 10 then
                if list[1].宝石属性 ~= list[2].宝石属性 then
                    local bs = self.接口:随机新宝石(等级)
                    self:物品_添加({
                        __沙盒.生成物品 { 名称 = bs.名称, 等级 = bs.等级, 品质 = bs.品质, 宝石属性 = bs.类型, 宝石数值 = bs.数值 ,禁止交易=禁止交易},
                    })
                    
                else
                    local bs = self.接口:指定新宝石(list[1].名称,list[1].宝石属性,等级)
                    self:物品_添加({
                        __沙盒.生成物品 { 名称 = bs.名称, 等级 = bs.等级, 品质 = bs.品质, 宝石属性 = bs.类型, 宝石数值 = bs.数值 ,禁止交易=禁止交易},
                    })
                end
            else
                if list[1].宝石属性 ~= list[2].宝石属性 then
                    local bs = self.接口:随机新宝石(等级+1)
                    self:物品_添加({
                        __沙盒.生成物品 { 名称 = bs.名称, 等级 = bs.等级, 品质 = bs.品质, 宝石属性 = bs.类型, 宝石数值 = bs.数值 ,禁止交易=禁止交易},
                    })
                    
                else
                    local bs = self.接口:指定新宝石(list[1].名称,list[1].宝石属性,等级+1)
                    self:物品_添加({
                        __沙盒.生成物品 { 名称 = bs.名称, 等级 = bs.等级, 品质 = bs.品质, 宝石属性 = bs.类型, 宝石数值 = bs.数值 ,禁止交易=禁止交易},
                    })
                end
            end
        end
    else
        local 名称 = list[1].名称 ~= list[2].名称 and _随机宝石[math.random(#_随机宝石)] or list[1].名称
        local 属性 = list[1].宝石属性 == list[2].宝石属性 and list[1].宝石属性
        -- local 名称 = list[1].名称 ~= list[2].名称 and _随机新宝石[math.random(#_随机新宝石)] or list[1].名称
        -- local 属性 = list[1].新宝石属性 == list[2].新宝石属性 and list[1].新宝石属性
        if 属性 then
            名称 = math.random(10) < 5 and list[1].名称 or list[2].名称
        end
        local 成败 = false
        local 等级 = list[1].等级
        local jlkz = __脚本['scripts/make/几率控制.lua'].宝石合成几率
        local jz = jlkz[等级] or 0
        if math.random(100) <= jz then
            成败 = true
        end
        if not 成败 then --失败
            list[math.random(2)]:减少(1)
            return { self.银子, "对不起,你的宝石我合成的时候不小心打坏了一个。" }
        else --成功
            list[1]:减少(1)
            list[2]:减少(1)
        end
        self:角色_扣除银子(消耗)
        local bs = __沙盒.生成物品 { 名称 = 名称, 等级 = 等级 + 1, 宝石属性 = 属性 }
        self:物品_添加 {
            bs
        }
    end
    return { self.银子, "好的,我帮你打造出了一个更好的宝石。" }
end


function 角色:角色_鉴定宝石(list)
    if type(list) ~= 'table' then
        return
    end
    local 消耗 = 0
    local r = self:角色_提交宝石鉴定(list)
    if type(r) == "string" then
        return r
    elseif type(r) == "table" then
        消耗 = r[1]
    end
    if self.银子 < 消耗 then
        return '#Y你没有那么多银子。'
    end
    local 等级 = list[1].等级
    local 禁止交易
    if list[1].禁止交易 or list[2].禁止交易 then
        禁止交易 = self.rpc:确认窗口('本次鉴定包含禁止交易的物品，继续鉴定得到的宝石为绑定状态！')
        if not 禁止交易 then
            return
        end
    end
    list[1]:减少(1)
    list[2]:减少(1)
    self:角色_扣除银子(消耗)
    local bs = self.接口:随机新宝石(等级,"鉴定")
    self:物品_添加({
        __沙盒.生成物品 { 名称 = bs.名称, 等级 = bs.等级, 品质 = bs.品质, 宝石属性 = bs.类型, 宝石数值 = bs.数值 ,禁止交易=禁止交易},
    })
    return { self.银子, "好的,我帮你鉴定出了一颗"..bs.名称.."宝石。" }
end

function 角色:角色_重铸宝石(list)
    if type(list) ~= 'table' then
        return
    end
    local 消耗 = 0
    local r = self:角色_提交宝石重铸(list)
    if type(r) == "string" then
        return r
    elseif type(r) == "table" then
        消耗 = r[1]
    end
    if self.银子 < 消耗 then
        return '#Y你没有那么多银子。'
    end
    local 等级 = list[1].等级
    local 禁止交易
    if list[1].禁止交易 or list[2].禁止交易 then
        禁止交易 = self.rpc:确认窗口('本次重铸包含禁止交易的物品，继续重铸得到的宝石为绑定状态！')
        if not 禁止交易 then
            return
        end
    end
    local str = "请选择你要重铸成什么宝石！\nmenu\n"
    for i,v in pairs(_高级宝石) do
        str = str ..string.format("%s|%s\n",i,i)
    end
    local i = self.接口:选择窗口(str)
    if not i then
        return false
    end
    if not _高级宝石[i] then
        return '#Y你选择的高级宝石不存在。'
    end
    list[1]:减少(1)
    list[2]:减少(1)
    self:角色_扣除银子(消耗)
    local bs = self.接口:指定新宝石(i,nil,等级)
    self:物品_添加({
        __沙盒.生成物品 { 名称 = bs.名称, 等级 = bs.等级, 品质 = bs.品质, 宝石属性 = bs.类型, 宝石数值 = bs.数值 ,禁止交易=禁止交易},
    })
    return { self.银子, "好的,我帮你重铸了这颗宝石。" }
end