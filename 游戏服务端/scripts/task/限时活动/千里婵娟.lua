local 任务 = {
    名称 = '千里婵娟',
    别名 = '千里婵娟',
    类型 = '限时活动'
}

function 任务:任务初始化(玩家, ...)
    self.进度 = 1
    self.对话进度 = 0
end

function 任务:任务更新(玩家, sec)
end

function 任务:任务取详情(玩家)
    if self.进度 == 1 then
        return '去#Y大唐境内(231,115)#W找#G#u#[1110|233|134|$红拂女#]#u#W。'
    elseif self.进度 == 2 then
        return '去#Y长安城东(79,86)#W找#G#u#[1193|79|86|$狐美人#]#u#W。'
    elseif self.进度 == 3 then
        return '去#Y五指山(371,75)#W找#G#u#[1194|371|75|$虎头怪#]#u#W。'
    elseif self.进度 == 4 then
        return '去#Y大唐边境(594,51)#W找#G#u#[1173|594|51|$龙战将#]#u#W。'
    elseif self.进度 == 5 then
        return '去#Y斧头帮(40,86)#W找#G#u#[1203|40|86|$燕山雪#]#u#W。'
    elseif self.进度 == 6 then
        return '去#Y傲来国(163,114)#W找#G#u#[1092|163|114|$剑侠客#]#u#W。'
    end
    return '千里婵娟'
end

function 任务:任务取消(玩家)
    self:删除()
end

function 任务:添加任务(玩家)
    for k, v in 玩家:遍历队伍() do
        v:增加活动限制次数('千里婵娟领取')
        v:添加任务(self)
    end

    return true
end

function 任务:地图刷新事件(玩家, map)
    if not self.遇敌时间 then
        self.遇敌时间 = 0
    end
    if 玩家.是否队长 then
        self.遇敌时间 = self.遇敌时间 + math.random(1, 3)
        if self.遇敌时间 > 180 then
            self.遇敌时间 = 0
            local r = 玩家:进入战斗("scripts/war/限时活动/千里婵娟.lua")
        end
    end
end

local _npcname = {
    "红拂女",
    "狐美人",
    "虎头怪",
    "龙战将",
    "燕山雪",
    "剑侠客",
}


function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == _npcname[self.进度] then
        NPC.台词 = NPC.台词 .. "menu\n1|有人托我来探望你\n2|路过看看"
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if i == "1" then
        if NPC.名称 == _npcname[self.进度] then
            self.进度 = self.进度 + 1
            local r = 玩家:取任务("千里婵娟")
            if r then
                for _, v in 玩家:遍历队伍() do
                    local rr = v:取任务("千里婵娟")
                    if rr and rr.nid == r.nid then
                        rr:掉落包(v)
                    end
                end
            end
            if self.进度 == 7 then
                self:删除()
            end
        end
    end
end

local _广播 = '#C寄语婵娟，愿逐月华，流照远人。#R%s#C不辞辛苦的完成了婵娟使的重托，婵娟使感动之余，将#G#m(%s)[%s]#m#n#C相赠。'
function 任务:掉落包(玩家)
    if 玩家:取活动限制次数('千里婵娟') > 5 then
        return
    end
    玩家:增加活动限制次数('千里婵娟')

    玩家:添加任务经验(318620)
    玩家:添加法宝经验(500)

    local 掉落包 = 取掉落包('活动', '千里婵娟')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包)
    end
end

return 任务
