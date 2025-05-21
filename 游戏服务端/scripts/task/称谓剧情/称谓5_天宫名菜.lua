local 任务 = {
    名称 = '称谓5_天宫名菜',
    别名 = '(五称)天宫名菜',
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
    '前往#Y魔王寨#W找#G#u#[1173|603|208|$雷鸟#]#u#W聊一聊！',
    '去天宫找#G#u#[1111|16|37|$仙女#]#u#W要天宫的名菜。#R（对话结束后进入战斗）',
    '将天宫的名菜交给#G#u#[1173|603|208|$雷鸟#]#u#W。#Y(请将天宫名菜ALT+G给子雷鸟）'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 2023, 台词 = '大王的婚事在即，如果能有#R“天宫的名菜”#W锦上添花的话，大王一定会非常高兴的！' },
    --0
    [2] = { 头像 = 3061, 结束 = false, 台词 = '天宫的名菜是嫦娥姐姐亲手烹调的菜式，是三界最美味的，怎么可能轻易给你呢？别痴心妄想了，回去吧。' },
    [3] = { 头像 = 0, 结束 = false, 台词 = '受人之托，忠人之事，不拿到我是不会走的。' },
    [4] = { 头像 = 3061, 结束 = false, 台词 = '……什么？你还不走？真是不到黄河心不死…好吧，我就给你一次机会，如果你能打赢嫦娥姐姐的玉兔的话，我就把“天宫的名菜”给你！' },
    [5] = { 头像 = 0, 台词 = '打就打，谁怕谁啊！' },
    --1
    [6] = { 头像 = 2023, 台词 = '哇，是天宫名菜也！你真的做到了！太厉害了！' },
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
    if not 玩家:剧情称谓是否存在(4) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '雷鸟' then
        if self.进度 == 0 then
            self.对话进度 = 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            self.进度 = 1
        end
    elseif NPC.名称 == '仙女' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 5 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if not 玩家:剧情称谓是否存在(4) then
        return
    end
end

function 任务:击杀仙女(玩家)
    if 玩家:添加物品({ 生成物品 { 名称 = '天宫的名菜', 数量 = 1, 禁止交易 = true } }) then
        self.进度 = 2
    end
end

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 5, '名菜')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    NPC.队伍给予 = true
    if NPC.名称 == '雷鸟' then
        if self.进度 == 2 then
            if items[1] and items[1].名称 == '天宫的名菜' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.对话进度 = 6
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                    self:完成(玩家)
                end
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '仙女' then
        if self.进度 == 1 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓5_天宫名菜.lua')
        end
    end
end

local _怪物 = {
    {
        名称 = "玉兔",
        外形 = 2001,
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
                local r = v.对象.接口:取任务("称谓5_天宫名菜")
                if r and r.进度 == 1 then
                    r:击杀仙女(v.对象.接口)
                end
            end
        end
    end
end

return 任务
