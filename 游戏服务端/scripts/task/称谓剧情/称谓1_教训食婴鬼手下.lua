local 任务 = {
    名称 = '称谓1_教训食婴鬼手下',
    别名 = '(一称)教训食婴鬼手下',
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
    '找#G#u#[1052|13|18|$程夫人#]#u#W聊一聊！',
    '前往#Y长安城东#W找到#G#u#[1193|172|215|$食婴鬼的手下#]#u#W并杀了他。#R（ALT+A食婴鬼的手下）',
    '回去告诉#G#u#[1052|13|18|$程夫人#]#u#W你打败坏蛋的消息'
}

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3020, 结束 = false, 台词 = '我的小宝昨晚上被#R食婴鬼的手下#W抢走了! 听说食婴鬼会吃掉他，你能救救我的孩子吗?我唯一的孩子啊！如果他死了，我也不要活了！' },
    [2] = { 头像 = 0, 结束 = false, 台词 = '可怜的母亲！你放心我一定会帮你伸张正义的！' },
    [3] = { 头像 = 3020, 结束 = false, 台词 = '那我就拜托你了，昨晚有人在长安城东看见了食婴鬼的手下！' },
    [4] = { 头像 = 0, 台词 = '好，我这就去杀了他们。' },
    --0
    [5] = { 头像 = 3020, 台词 = '谢谢你，你的大恩大德，奴冢永世不忘!这点奴家的心意就请收下吧。' },
    --2
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
    NPC.队伍对话 = true
    if NPC.名称 == '程夫人' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 4 then
                self.进度 = 1
            end
        elseif self.进度 == 2 then
            self.对话进度 = 5
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            self:完成(玩家)
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:击杀食婴鬼手下(玩家)
    self.进度 = 2
    玩家:常规提示('#R你成功击杀了食婴鬼的手下')
end

function 任务:完成(玩家)
    玩家:添加师贡(5000)
    玩家:添加声望(25)
    玩家:提示窗口('#Y由于你的英勇你在这个世界的名望得到了提升，获得25点声望值和5000两银子。')
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 1, '手下')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == '食婴鬼的手下' then
            玩家:进入战斗('scripts/task/称谓剧情/称谓1_教训食婴鬼手下.lua')
        end
    end
end

local _怪物 = {
    {
        名称 = "食婴鬼的手下",
        外形 = 2017,
        气血 = 1500,
        魔法 = 1800,
        攻击 = 500,
        速度 = 15,
        抗性 = {

        },
        技能 = {

        }
    },

}
function 任务:战斗初始化(玩家)
    local r = 生成战斗怪物(_怪物[1])
    self:加入敌方(1, r)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("称谓1_教训食婴鬼手下")
                if r and r.进度 == 1 then
                    r:击杀食婴鬼手下(v.对象.接口)
                end
            end
        end
    end
end

return 任务
