local 任务 = {
    名称 = '坐骑5_烈焰神珠',
    别名 = '(坐骑五)烈焰神珠',
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
    '烈焰神珠（提示：#G黄火牛#W）',
    '给#G黄火牛#W100000两银子。',
    '去白骨山寻找烈焰神珠。#Y（提示：战胜含有赤焰妖的暗雷）#W',
}

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = {头像 = 0, 结束 = false, 台词 = '小小把戏，也敢出来卖弄！'},
    [2] = {头像 = 3092, 结束 = false, 台词 = '这位看官，可不要小瞧人，小的这三昧真火可是烈焰神珠所化，厉害无比，太上老君火炼孙悟空…想当年…'},
    [3] = {头像 = 0, 结束 = false, 台词 = '烈焰神珠…！你知道烈焰神珠？（一个地痞都能弄到烈焰神珠，想必十分好得，发达了）'},
    [4] = {头像 = 3092, 台词 = '想要知道我是如何得到这烈焰神珠的，你给我个补天神石，我就告诉你。'},
    --0
    [5] = {头像 = 3092, 台词 = '看在补天神石的份上，大爷就告诉你吧，修行得道的赤焰妖身上可能藏有烈焰神珠，我修炼所用的神珠就是我爷爷的爷爷的爷爷在杀赤焰妖无意中得到。'},
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
    if NPC.名称 == '黄火牛' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 4 then
                self.进度 = 1
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    local 添加物品 = 玩家:添加物品({生成物品 {名称 = '烈焰神珠', 数量 = 1}})
    if 添加物品 then
        self:删除()
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if NPC.名称 == '黄火牛' then
        if self.进度 == 1 then
            if items[1] and items[1].名称 == '补天神石' then --你试试不还 没法试要做任务呢  那你有空在世吧e'b
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.进度 = 2
                    self.对话进度 = 5
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                end
            end
        end
    end
end

function 任务:任务触发暗雷(玩家)
    if 玩家.地图 == 101300 then
        if math.random(100) <= 30 then
            玩家:提示窗口('#R这些赤焰妖体内似乎含有一种特殊的火焰！')
            local r = 玩家:进入战斗('scripts/war/坐骑剧情/坐骑5_赤焰妖.lua')
            if r then
                self:完成(玩家)
            end
            return true
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
end

return 任务