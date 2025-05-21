local 任务 = {
    名称 = '称谓3_羊脂仙露',
    别名 = '(三称)羊脂仙露',
    类型 = '称谓剧情',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '前往#Y斧头帮#W找#G#u#[1203|59|69|$三当家#]#u#W聊一聊！',
    '给他羊脂仙露救他们帮主。#R（将羊脂仙露ALT+G给予三当家）',
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 2044, 结束 = false, 台词 = '前些天，一个外号桃花杀手的女人路过我们帮，说是要找什么转世孙悟空，我们这里明明是斧头帮嘛，哪有什么转世孙悟空，可那个女人就是不明白这个道理，还硬要看我们的脚底板，我们这些帮众的脚底板看了也就看啦，我们尊贵的帮主的脚底板怎么能随便看呢？一言不合，两人就打起来啦，我们帮主因为恰好处在生理上的低潮期，所以功夫嘛，就比平时低了那么一点点，结果，就中了那个女人的八~~~伤~~~~~~~~~拳！' },
    [2] = { 头像 = 0, 台词 = '（这个疯子~乱七糟说的一堆废话）中了这个伤以后会怎么样？' },
    --0
    [3] = { 头像 = 2044, 台词 = '太好了，你居然可以把这个药找到了！看来帮主的伤一定有救了！！为了感谢和报答你，我决定把我昨天买酒剩下的钱给你。' },
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
    if not 玩家:剧情称谓是否存在(2) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '三当家' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 2 then
                self.进度 = 1
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    玩家:添加声望(60)
    玩家:添加师贡(200)
    玩家:提示窗口('#Y因为你的热心助人，你在这个世界的声望得到提升，获得60点声望，200两银子。')
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 3, '仙露')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    NPC.队伍给予 = true
    if NPC.名称 == '三当家' then
        if self.进度 == 1 then
            if items[1] and items[1].名称 == "羊脂仙露" then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.对话进度 = 3
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                    self:完成(玩家)
                end
            end
        end
    end
end

return 任务
