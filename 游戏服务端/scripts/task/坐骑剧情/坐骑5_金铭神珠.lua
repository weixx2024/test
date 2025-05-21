local 任务 = {
    名称 = '坐骑5_金铭神珠',
    别名 = '(坐骑五)金铭神珠',
    类型 = '坐骑剧情',
    是否隐藏 = true,
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(sec)
end

local _详情 = {
    '金铭神珠（提示：#G财神#W）',
    '找#G幽冥地鬼#W拿回金铭神珠。',
}

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _菜单 = [[
想好了没有，1000000两银子拿来，金铭神珠就是你的。
menu
1|其实，强盗这份很有前途的职业我也会做。打劫！
2|区区一百万两银子，拿去便是。
99|我再想想。
]]

local _台词 = {
    [1] = {头像 = 0, 结束 = false, 台词 = '财神大老爷！！'},
    [2] = {头像 = 3086, 结束 = false, 台词 = '（小混蛋又来了，赶紧躲起来）'},
    [3] = {头像 = 0, 结束 = false, 台词 = '别跑呀财神大老爷！'},
    [4] = {头像 = 0, 结束 = false, 台词 = '别这么说人家嘛，这次不要你的钱钱，只要接你的金铭神珠玩玩。'},
    [5] = {头像 = 0, 结束 = false, 台词 = '财神您可不是如此小气之人哦。'},
    [6] = {头像 = 3086, 结束 = false, 台词 = '实不相瞒，你来晚一步，金铭神珠已被幽冥地鬼老儿变身成小老头的模样，从看守的童子手中骗走了。'},
    [7] = {头像 = 0, 台词 = '岂有此理，我这就去找他要来。'},
    --0

    [8] = {头像 = 2075, 结束 = false, 台词 = '想要从我这里拿走金铭神珠，也不是不可以，给我1000000两银子这珠子就是你的了！'},
    [9] = {头像 = 0, 结束 = false, 台词 = '（破珠子这么贵，坑我呢？）……'},
    [10] = {头像 = 2075, 结束 = false, 台词 = _菜单},
    --1

    [11] = {头像 = 2075, 台词 = '算…算你厉害…我的金铭神珠啊……呜，来人啊，强盗抢劫啦！'},
    --战斗
    [12] = {头像 = 2075, 台词 = '谢谢这位爷，金铭神珠现在是你的了，哈哈哈！'},
    --给钱
}

function 任务:取对话(玩家)
    local r = _台词[self.对话进度]
    local 台词, 头像, 结束 = r.台词, r.头像, r.结束
    if 头像 == 0 then
        头像 = 玩家.原形
    end
    return 台词, 头像, 结束
end

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '财神' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 7 then
                self.进度 = 1
            end
        end
    elseif NPC.名称 == '幽冥地鬼' then
        if self.进度 == 1 then
            if self.对话进度 >= 10 then
                self.对话进度 = 9
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '幽冥地鬼' then
        if self.进度 == 1 then
            if i == '1' then
                self:任务攻击事件(玩家, NPC)
            elseif i == '2' then
                if 玩家:扣除银子(1000000) then
                    self.对话进度 = 12
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                    -- 最后完成
                    self:完成(玩家)
                else
                    NPC.台词 = '坑谁呢，你有这么多钱吗？'
                end
            end
        end
    end
end

function 任务:完成(玩家)
    local 添加物品 = 玩家:添加物品({生成物品 {名称 = '金铭神珠', 数量 = 1}})
    if 添加物品 then
        self:删除()
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)

end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '幽冥地鬼' then
        if self.进度 == 1 then
            local r = 玩家:进入战斗('scripts/war/坐骑剧情/坐骑5_幽冥地鬼.lua', NPC)
            if r then
                self.对话进度 = 11
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                玩家:最后对话(NPC.台词, NPC.头像)
                -- 最后完成
                self:完成(玩家)
            end
        end
    end
end

return 任务