local 任务 = {
    名称 = '为爱逆天',
    别名 = '为爱逆天',
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
        return '你决定帮助奎木狼阻拦追兵，火速去往#Y五指山(495,17)#W阻拦#G#u#[1194|495|17|$水德星君#]#u#W！'
    elseif self.进度 == 2 then
        return "你决定帮助奎木狼阻拦追兵，火速去往#Y大唐境内(438,62)#W阻拦#G#u#[1110|438|62|$火德星君#]#u#W！"
    elseif self.进度 == 3 then
        return "你决定帮助奎木狼阻拦追兵，火速去往#Y洛阳(183,123)#W阻拦#G#u#[1236|183|123|$天王李靖#]#u#W！"
    end
    return '为爱您填'
end

function 任务:任务取消(玩家)
    self:删除()
end

local _广播 = '#C成王败寇！#50#C天庭头领被#R/%s##C击败后，丢下了#G#m(%s)[%s]#m#n#C落荒而逃。。#40'

function 任务:击杀奎木狼(玩家)
    if 玩家:取活动限制次数('奎木狼') >= 1 then
        return
    end

    玩家:增加活动限制次数('奎木狼')
    玩家:增加活动限制次数('为爱逆天')
    玩家:添加任务经验(4895454)
    玩家:添加法宝经验(500)


    local 掉落包 = 取掉落包('活动', '天元盛典')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包['奎木狼'], _广播)
    end

    玩家:添加任务(self)
end

function 任务:击杀水德星君(玩家)
    self.进度 = 2
    if 玩家:取活动限制次数('水德星君') >= 1 then
        return
    end
    玩家:增加活动限制次数('水德星君')

    玩家:添加任务经验(4895454)
    玩家:添加法宝经验(500)

    local 掉落包 = 取掉落包('活动', '天元盛典')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包['水德星君'], _广播)
    end
end

function 任务:击杀火德星君(玩家)
    self.进度 = 3
    if 玩家:取活动限制次数('火德星君') >= 1 then
        return
    end
    玩家:增加活动限制次数('火德星君')

    玩家:添加任务经验(4895454)
    玩家:添加法宝经验(500)

    local 掉落包 = 取掉落包('活动', '天元盛典')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包['火德星君'], _广播)
    end
end

function 任务:击杀天王李靖(玩家)
    if 玩家:取活动限制次数('天王李靖') >= 1 then
        return
    end

    玩家:增加活动限制次数('天王李靖')
    玩家:添加任务经验(4895454)
    玩家:添加法宝经验(500)

    local 掉落包 = 取掉落包('活动', '天元盛典')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包['天王李靖'], _广播)
    end

    self:删除()
end

function 任务:任务NPC对话(玩家, NPC)
    if self.进度 == 1 and NPC and NPC.名称 == "奎木狼" then
        if self.对话进度 == 0 then
            NPC.结束 = false
            self.对话进度 = 1
        elseif self.对话进度 == 1 then
            NPC.台词 = "我没说要抓你，正相反，我要助你一臂之力。#24"
            NPC.头像 = 玩家.原形
            NPC.结束 = false
            self.对话进度 = 2
        elseif self.对话进度 == 2 then
            NPC.台词 = "少侠为何如此高义？"
            NPC.结束 = false
            NPC.头像 = NPC.外形
            self.对话进度 = 3
        elseif self.对话进度 == 3 then
            NPC.台词 = "拳套大的不一定是道理，谈恋爱就算天王老子也管不到嘛！#28"
            NPC.头像 = 玩家.原形
            NPC.结束 = nil
            self.对话进度 = 99
        end
    end
end

return 任务
