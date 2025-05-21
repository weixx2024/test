local NPC = {}
local 对话 = [[
我是专门为别人升级神兵的，我也可以帮你补充神兵灵气，你需要我帮忙吗？
menu
1|升级神兵
6|升级神兵（精炼）
2|神兵精炼
3|我要打造神兵石
4|我已经搜集够了50片神兵碎片，快帮我打造吧
5|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:神兵升级窗口()
    elseif i == '6' then
        玩家:神兵强化窗口()
    elseif i == '2' then
        玩家:神兵精炼窗口()
    elseif i == '3' then
        玩家:神兵炼化窗口()
    elseif i == '4' then
        local r = 玩家:取物品是否存在("神兵碎片")
        if r and r.数量 >= 50 then
            if 玩家.银子 >= 5000000 then
                if self:添加神兵(玩家) then
                    r:减少(50)
                    玩家:扣除银子(5000000)
                end
            else
                return "你没有那么银子"
            end
        else
            return "你没有那么碎片"
        end

    end
end

local _武器 = { "金箍棒", "宣花斧", "盘古锤", "枯骨刀", "乾坤无定", "芭蕉扇", "八景灯", "多情环",
    "赤炼鬼爪", "毁天灭地", "搜魂钩", "混天绫", "索魂幡", "震天戟", "缚龙索", "斩妖剑", }
local _衣服 = { "锁子黄金甲", "五彩宝莲衣" }
local _帽子 = { "凤翅瑶仙簪", "紫金七星冠" }
local _项链 = { "混元盘金锁" }
local _鞋子 = { "藕丝步云履", "步定乾坤履" }

function NPC:添加神兵(对象)
    local 名称 = "魅影"
    local 几率 = math.random(12)
    if 几率 <= 5 then
        名称 = _武器[math.random(#_武器)]
    elseif 几率 <= 7 then
        名称 = _衣服[math.random(#_衣服)]
    elseif 几率 <= 9 then
        名称 = _帽子[math.random(#_帽子)]
    elseif 几率 <= 10 then
        名称 = _项链[math.random(#_项链)]
    else
        名称 = _鞋子[math.random(#_鞋子)]
    end


    local r = 生成装备 { 名称 = 名称, 等级 = 1 }
    if r then
        if 对象:添加物品({ r }) then
            return true
        end
    end
end

return NPC
