local 任务 = {
    名称 = '称谓5_天宫玉酒',
    别名 = '(五称)天宫玉酒',
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
    '前往#Y魔王寨#W找#G#u#[1173|602|212|$牛妖#]#u#W聊一聊！',
    '去找#G#u#[1112|79|48|$王母娘娘#]#u#W要瓶玉酒过来。#R（对话结束后进入战斗）',
    '将玉酒交给#G#u#[1145|24|14|$牛魔王#]#u#W。#Y(请将玉酒ALT+G牛魔王）'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 2066, 结束 = false, 台词 = '伤脑筋，真伤脑筋……大王马上就要和紫霞成婚了，可到现在还没拿的出手的喜酒，要是到了婚礼上还这样的话，我们一定会被大王用三昧真火烧死的。' },
    [2] = { 头像 = 0, 结束 = false, 台词 = '牛魔王要结婚了？而且是和紫霞仙子？（那不是鲜花插在牛身上啊！）' },
    [3] = { 头像 = 2066, 结束 = false, 台词 = '那是当然，你也是来祝贺的吧？告诉你，世界上所有的酒里，天宫用蟠桃酿造的玉酒才是最让人销魂的……大王和盘丝大仙的结婚典礼上，也只有那样的酒才相配。' },
    [4] = { 头像 = 0, 结束 = false, 台词 = '哦，你们妖怪也挺会享受的嘛！' },
    [5] = { 头像 = 2066, 台词 = '可惜，我们是下界小妖，没有上天庭的能力。不过，我看你很强的样子，想来有上天入地的本领，你能帮忙我吗？' },
    --0
    [6] = { 头像 = 3065, 结束 = false, 台词 = '想要玉酒可没那么容易，最少，得看看我的宠物同不同意，哦呵呵呵！！' },
    [7] = { 头像 = 0, 台词 = '什么？还要打仗……？' },
    --1
    [8] = { 头像 = 2081, 结束 = false, 台词 = '多谢你为我找到了玉酒……但婚事出了点问题。' },
    [9] = { 头像 = 0, 结束 = false, 台词 = '哦？有什么问题吗？' },
    [10] = { 头像 = 2081, 结束 = false, 台词 = '唉，都怪孙悟空那个勾引二嫂的臭猴子，一万多年前我还帮助他一起去解救小白呢，他也不感恩，现在居然要去动我老牛的人！气死我了，要是让我抓到那只臭猴子，我非剥了他的皮不可！' },
    [11] = { 头像 = 0, 结束 = false, 台词 = '孙悟空勾引你的老婆，你有什么证据吗？' },
    [12] = { 头像 = 2081, 台词 = '证据就是暂时还没有，不过现在紫霞生气了，说是什么紫青宝剑不见了，死活也不愿意跟我成亲，这可怎么办那！' },
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
    if not 玩家:剧情称谓是否存在(4) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '牛妖' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 5 then
                self.进度 = 1
            end
        end
    elseif NPC.名称 == '王母娘娘' then
        if self.进度 == 1 then
            if self.对话进度 >= 7 then
                self.对话进度 = 5
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 7 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    elseif NPC.名称 == '牛魔王' then
        if self.进度 == 3 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 12 then
                self:完成(玩家)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:击杀王母(玩家)
    if 玩家:添加物品({ 生成物品 { 名称 = '天宫的玉酒', 数量 = 1, 禁止交易 = true } }) then
        self.进度 = 2
    end
end

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 5, '玉酒')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    NPC.队伍给予 = true
    if NPC.名称 == '牛魔王' then
        if self.进度 == 2 then
            if items[1] and items[1].名称 == '天宫的玉酒' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.进度 = 3
                    self.对话进度 = 8
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                    self:完成(玩家)
                end
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '王母娘娘' then
        if self.进度 == 1 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓5_天宫玉酒.lua')
        end
    end
end

local _怪物 = {
    {
        名称 = "王母",
        外形 = 2071,
        气血 = 66000,
        魔法 = 50000,
        攻击 = 3600,
        速度 = 55,
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
                local r = v.对象.接口:取任务("称谓5_天宫玉酒")
                if r and r.进度 == 1 then
                    r:击杀王母(v.对象.接口)
                end
            end
        end
    end
end

return 任务
