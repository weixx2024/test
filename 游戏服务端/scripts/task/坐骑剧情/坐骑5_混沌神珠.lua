local 任务 = {
    名称 = '坐骑5_混沌神珠',
    别名 = '(坐骑五)混沌神珠',
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
    '混沌神珠（提示：#G马面#W）',
    '打败#G绝地魔#W，拿回混沌神珠。#Y（提示：需要战斗）#W',
}

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = {头像 = 2053, 结束 = false, 台词 = '哈，上仙来的正好，马面有一事，正想请您帮忙呢。'},
    [2] = {头像 = 0, 台词 = '何事？'},
    [3] = {头像 = 2053, 台词 = '我的混沌神珠被绝地魔偷走了，我又打不过他，你帮我去拿回来，顺便教训一下他。'},
    --0
    [4] = {头像 = 2072, 结束 = false, 台词 = '马面嚣张跋涉，本魔偷他神珠也是为了薄惩他一下而已，你为什么要帮马面与我作对？'},
    [5] = {头像 = 0, 结束 = false, 台词 = '马面怎么样我可不管，我要的是混沌神珠，给还是不给？？'},
    [6] = {头像 = 2072, 台词 = '搞半天原来是想黑吃黑！！虽然你神通广大，本魔可也不是好惹的，让你知道知道强出头的后果！'},
    --1
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
    if NPC.名称 == '马面' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 3 then
                self.进度 = 1
            end
        end
    elseif NPC.名称 == '绝地魔' then
        if self.进度 == 1 then
            if self.对话进度 >= 6 then
                self.对话进度 = 3
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 6 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    local 添加物品 = 玩家:添加物品({生成物品 {名称 = '混沌神珠', 数量 = 1}})
    if 添加物品 then
        self:删除()
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '绝地魔' then
        if self.进度 == 1 then
            local r = 玩家:进入战斗('scripts/war/坐骑剧情/坐骑5_绝地魔.lua', NPC)
            if r then
                self:完成(玩家)
            end
        end
    end
end

return 任务