local 任务 = {
    名称 = '坐骑5_巨木神珠',
    别名 = '(坐骑五)巨木神珠',
    类型 = '坐骑剧情',
    是否隐藏 = true,
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)

end

function 任务:任务上线(玩家)
end

local _花苗状态 = { '浇水', '施肥', '除虫' }

function 任务:任务更新(sec)
    if self.进度 == 3 then
        if self.花苗 then
            self.花苗.时间 = self.花苗.时间 + 1
            if self.花苗.时间 >= 60 then
                if self.花苗.状态 then
                    self.进度 = 4 -- 失败
                else
                    self.花苗.时间 = 0
                    self.花苗.状态 = _花苗状态[math.random(#_花苗状态)]
                end
            end
        end
    end
end

local _详情 = {
    '巨木神珠（提示：#G镇元大仙#W）',
    '找#G王母娘娘#W要巨木神珠。',
    '找#G桃花仙#W要巨木神珠。',
    '种出桃花，换取巨木神珠。',
    '#R由于你的没有很好的照顾花苗，花苗枯萎了。',
    '桃花种出来了，找#G桃花仙#W要巨木神珠吧。'
}

function 任务:任务取详情(玩家)
    local 详情 = _详情[self.进度 + 1]
    if self.进度 == 3 then
        if self.花苗.状态 then
            详情 = 详情 .. '#r' .. string.format('你的花苗需要#R%s#W，快去照顾一下。', self.花苗.状态)
        end
    end
    return 详情
end

local _台词 = {
    [1] = {头像 = 3062, 结束 = false, 台词 = '哈哈，近日可好，也不抽空看看哥哥我！'},
    [2] = {头像 = 0, 结束 = false, 台词 = '别提了，我最近正为巨木神珠上脑筋呢！'},
    [3] = {头像 = 3062, 结束 = false, 台词 = '巨木神珠！你要那宝物何用？'},
    [4] = {头像 = 0, 结束 = false, 台词 = '这个…（虽然有结拜之谊，可关于灵兽村的事情缺不能说给你听）刚才听哥哥的口气，好像知道巨木神珠？'},
    [5] = {头像 = 3062, 结束 = false, 台词 = '天下之大，哪个地方的灵树还能比的过蟠桃园！'},
    [6] = {头像 = 0, 结束 = false, 台词 = '怎么获得，哥哥先说来听听。'},
    [7] = {头像 = 3054, 台词 = '哈哈，哈哈哈，我可不知道，什么都不知道。'},
    --0
    [8] = {头像 = 0, 结束 = false, 台词 = '娘娘，您起色真好，快教教我怎么保养呀！'},
    [9] = {头像 = 3065, 结束 = false, 台词 = '呵，小滑头，休要胡言乱语。又有什么事情需要老身帮忙呀？'},
    [10] = {头像 = 0, 结束 = false, 台词 = '我确实有事找您，想借您的巨木神珠一用，用完马上会还给您的。'},
    [11] = {头像 = 3065, 台词 = '巨木神珠被桃花仙保管，你去找她拿吧。'},
    --1
    [12] = {头像 = 3061, 结束 = false, 台词 = '按王母娘娘的本意，姐姐我本该给你，但是…'},
    [13] = {头像 = 0, 结束 = false, 台词 = '那姐姐还不快把巨木神珠给我，难道你想违抗王母娘娘的旨意吗？'},
    [14] = {头像 = 3061, 结束 = false, 台词 = '我也没说不给你，一千年后再来拿吧，王母娘娘可没说几时给你呢。'},
    [15] = {头像 = 0, 结束 = false, 台词 = '好姐姐，您就别耍我了，快给了我吧。'},
    [16] = {头像 = 3061, 结束 = false, 台词 = '你帮我把照顾一下旁边的花苗，等种出了桃花再来找我换取珠子吧。你要是不答应的话，我可就把巨木神珠收起来了哦。'},
    [17] = {头像 = 0, 台词 = '（这么倒霉，遇到这么刁钻的女子）'},
    --2

    [18] = {头像 = 3061, 台词 = '好漂亮的桃花，谢谢你，巨木神珠拿去吧。'},
    --5
}

local _花苗菜单 = [[
你的花苗看起来不太健康，你要做什么？
menu
浇水
施肥
除虫
]]

function 任务:取对话(玩家)
    local r = _台词[self.对话进度]
    local 台词, 头像, 结束 = r.台词, r.头像, r.结束
    if 头像 == 0 then
        头像 = 玩家.原形
    end
    return 台词, 头像, 结束
end

function 任务:开始种花苗()
    self.进度 = 3
    if self.花苗 then
        self.花苗 = nil
    end
    self.花苗 = { 成长 = 0, 时间 = 0 }
end

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '镇元大仙' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 7 then
                self.进度 = 1
            end
        end
    elseif NPC.名称 == '王母娘娘' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 11 then
                self.进度 = 2
            end
        end
     elseif NPC.名称 == '桃花仙' then
        if self.进度 == 2 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 17 then
                self:开始种花苗()
            end
        elseif self.进度 == 4 then
            self.进度 = 2
            self.对话进度 = 12
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        elseif self.进度 == 5 then
            self.对话进度 = 18
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            self:完成(玩家)
        end
    elseif NPC.名称 == '花苗' then
        if self.进度 == 3 then
            if self.花苗 and self.花苗.状态 then
                NPC.台词 = _花苗菜单
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '花苗' then
        if self.进度 == 3 then
            if self.花苗 and self.花苗.状态 then
                if self.操作时间 and self.操作时间 + 10 > os.time() then
                    玩家:提示窗口('#Y你刚刚已经照顾过了，过一会儿再来。')
                    return
                end
                self.操作时间 = os.time()
                if i == self.花苗.状态 then
                    self.花苗.状态 = nil
                    self.花苗.时间 = 0
                    self.花苗.成长 = self.花苗.成长 + 1
                    if self.花苗.成长 == 6 then
                        self.进度 = 5
                        玩家:提示窗口('#Y终于经过你的精心照顾，你终于种成了桃花。')
                    else
                        玩家:提示窗口('#Y幼苗得到你的照顾，慢慢的成长着…')
                    end
                else
                    玩家:提示窗口('#Y你的花苗并不需要%s。', i)
                end
            end
        end
    end
end

function 任务:完成(玩家)
    local 添加物品 = 玩家:添加物品({生成物品 {名称 = '巨木神珠', 数量 = 1}})
    if 添加物品 then
        self:删除()
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)

end

function 任务:任务攻击事件(玩家, NPC)
end

return 任务