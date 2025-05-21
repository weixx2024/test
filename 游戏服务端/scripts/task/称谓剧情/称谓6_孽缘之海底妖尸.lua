local 任务 = {
    名称 = '称谓6_孽缘之海底妖尸',
    别名 = '(六称)孽缘之海底妖尸',
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
    '前往#Y方寸山#W找#G#u#[1135|27|34|$游方术土#]#u#W谈谈。',
    '问去#Y海底迷宫三层#W解决#G千年妖尸#W拿回剃刀。#R（对千年妖尸进行ALT+A攻击）',
    '把剃刀还给#G#u#[1135|27|34|$游方术土#]#u#W。#G（ALT+G给予）',
    '剃刀已经还回去了，跟#G#u#[1135|27|34|$游方术土#]#u#W聊聊。',
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3045, 结束 = false, 台词 = '唉……唉……唉……' },
    [2] = { 头像 = 0, 结束 = false, 台词 = '这位老兄，你干嘛唉声叹气？' },
    [3] = { 头像 = 3045, 结束 = false, 台词 = '我不知道该不该告诉你这桩事，但这个麻烦如果不解决的话，我的修行将无法继续下去。' },
    [4] = { 头像 = 0, 结束 = false, 台词 = '那你就告诉我吧，也许我就是上天安排来帮助你解决问题的。' },
    [5] = { 头像 = 3045, 结束 = false, 台词 = '看你是热心人，我就告诉你吧。每个术士在修炼的过程中身上都会带着那把剃度的剃刀，这把刀凝结了术士的功力，就像他的生命一样和术士共同成长。而我的刀被来自#R海底迷宫三层#W的一只修炼千年以上的#R妖尸#W夺走了，假以时日，妖尸会吸去刀上的全部功力，那时候我多年的修行就全完了。' },
    [6] = { 头像 = 0, 台词 = '看你这么可怜，我是要去帮你拿回来了。' },
    --0
    [7] = { 头像 = 3045, 结束 = false, 台词 = '啊，这正是我的剃刀！这下我多年的修行可保住了…多谢你!这是我平时炼制的一些丹药，也许你在战斗中会用的着。日后你有什么需要我帮忙的话我也会尽力而为！' },
    [8] = { 头像 = 0, 台词 = '呵呵，好说好说啦。' },
    --3
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
    if not 玩家:剧情称谓是否存在(5) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '游方术士' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 6 then
                self.进度 = 1
            end
        elseif self.进度 == 3 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 8 then
                self:完成(玩家)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:击杀海底妖尸(玩家)
    if 玩家:添加物品({ 生成物品 { 名称 = '剃刀', 数量 = 1, 禁止交易 = true } }) then
        self.进度 = 2
    end
end

function 任务:完成(玩家)
    玩家:添加经验(1320000)
    玩家:常规提示('#Y你打败了战神女娲，获得了1320000经验。')
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 6, '妖尸')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    NPC.队伍给予 = true
    if NPC.名称 == "游方术士" then
        if self.进度 == 2 then
            if items[1] then --
                if items[1].数量 >= 1 and items[1].名称 == '剃刀' then
                    items[1]:接受(1)
                    self.进度 = 3
                    self.对话进度 = 7
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                end
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '千年妖尸' then
        if self.进度 == 1 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓6_孽缘之海底妖尸.lua')
        end
    end
end

local _怪物 = {
    {
        名称 = "千年老妖",
        等级 = 70,
        外形 = 2017,
        气血 = 180000,
        魔法 = 100000,
        攻击 = 4700,
        速度 = 80,
        抗性 = {
            抗混乱 = 60,
            抗封印 = 40,
            抗昏睡 = 50,
        },
        技能 = {
            { 名称 = "雷霆霹雳", 熟练度 = 6000 },
            { 名称 = "日照光华", 熟练度 = 6000 },
            { 名称 = "雷神怒击", 熟练度 = 6000 },
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
                local r = v.对象.接口:取任务("称谓6_孽缘之海底妖尸")
                if r and r.进度 == 1 then
                    r:击杀海底妖尸(v.对象.接口)
                end
            end
        end
    end
end

return 任务
