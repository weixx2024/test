﻿local 任务 = {
    名称 = '称谓13_取经路上',
    别名 = '(十三称)取经路上',
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
    '你可以完成第十三个称谓剧情任务了，任务领取人#Y普陀山#G#u#[1141|22|12|$仙女姐姐#]#u',
    '去问问#G#u#[1173|255|323|$猪八戒#]#u#W怎么又不西行取经了。',
    '去找#G#u#[1255|11|7|$胜天籁#]#u#W，询问九齿钉耙的下落。',
    '去狮驼岭寻找九齿钉耙，九齿钉耙在#G#u#[1131|19|22|$多头神魔#]#u#W手上。#R（对话结束后进入战斗！）',
    '把九齿钉耙拿给#G#u#[1173|255|323|$猪八戒#]#u#W。#Y（ALT+G给予猪八戒九齿钉耙）',
    '去问问#G#u#[1173|132|221|$沙和尚#]#u#W怎么又不愿西行取经了。',
    '去找#G#u#[1112|80|48|$王母娘娘#]#u#W聊聊。',
    '带找玉帝诏书去找#G#u#[1173|132|221|$沙和尚#]#u#W。（ALT+G给予沙和尚）',
    '#G沙和尚#W已经入魔，看来只有先打败他的心魔了。',
    '找#G沙和尚#W聊聊吧。'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3061, 台词 = '你来得正好，日前菩萨为取经人寻访弟子，点化了高老庄天蓬元帅转世的猪八戒和流沙河卷帘大将转世的沙和尚，可是不知道为什么，他们又突然不愿去了，你如果有暇，可否帮我去问个究竟。' },
    --0
    [2] = { 头像 = 0, 结束 = false, 台词 = '喂，老猪，你搞什么啊，西行取经，是多好的修真机会，你居然不愿意去？' },
    [3] = { 头像 = 2091, 结束 = false, 台词 = '这个……那个…' },
    [4] = { 头像 = 0, 结束 = false, 台词 = '扭扭捏捏干什么啊，你不替自己想，也要替嫦娥仙子想想吧。你不修行成正果，难道让地就这么一直替你担心下去吗？' },
    [5] = { 头像 = 2091, 结束 = false, 台词 = '唉，谁说我不想去。可是，我的兵器前几天被人偷走了，怎么去西天啊。' },
    [6] = { 头像 = 0, 结束 = false, 台词 = '啊，竟然有这回事，你的九齿钉粑不见了啊，那你刚才怎么不说？？' },
    [7] = { 头像 = 2091, 结束 = false, 台词 = '这…随身兵器被偷，多没面子啊。' },
    [8] = { 头像 = 0, 结束 = false, 台词 = '真是受不了你，堂堂男子汉，居然还这么讲究面子，被谁偷去了？我去帮你找回来。' },
    [9] = { 头像 = 2091, 结束 = false, 台词 = '所以说很没面子嘛，我也不知道是谁偷去的，本来洛阳城的胜天籁可以感应宝气，但他是仙身，我是妖身，所以……' },
    [10] = { 头像 = 0, 结束 = false, 台词 = '胜天籁？？' },
    [11] = { 头像 = 2091, 结束 = false, 台词 = '没错，胜天籁其实是天宫兵库司的仙人，只不过在人间修行而已。他专管天下神兵，能感应出任何兵器的所在。' },
    [12] = { 头像 = 0, 台词 = '好吧，我帮你去问问他。' },
    --1

    [13] = { 头像 = 3007, 结束 = false, 台词 = '九齿钉耙？？这是炼自太上老君炉中的宝物，集九海精英而成，乃天地之无上神兵，功可……' },
    [14] = { 头像 = 0, 结束 = false, 台词 = '打住！打住！！我是问兵器的下落，不是问你它的出处。（这家伙还真是罗嗦）' },
    [15] = { 头像 = 3007, 结束 = false, 台词 = '嘿嘿，天下神兵，没有我感应不到的，让我看……嗯，这九齿钉粑，应该是在狮驼岭一带，不过那里妖气弥漫，具体就探不清了。' },
    [16] = { 头像 = 0, 台词 = '狮驼岭，好，就去那里走一趟。' },
    --2

    [17] = { 头像 = 2089, 结束 = false, 台词 = '嘿嘿，想不到居然天上的宝贝我也能搞到，献给三位大王，我就是三人之下万人之上了，哈哈哈。' },
    [18] = { 头像 = 0, 结束 = false, 台词 = '搞到了什么宝贝啊？' },
    [19] = { 头像 = 2089, 结束 = false, 台词 = '就是炼自天宫太上老君炉中的九齿钉杷啊，嘿嘿，听说是天蓬元帅的宝贝，想不到在高老庄被我拿到，真是得来全不费工夫啊。' },
    [20] = { 头像 = 0, 台词 = '说得对，我也是得来全不费工夫，偷宝贝的死妖怪，吃我一招！' },
    --3

    [21] = { 头像 = 2091, 台词 = '啊，果然是我的钉耙，谢谢你，这下我可以安心帮助取经人前往西天了。嫦娥，你等着，我一定修成正果回来。' },
    --4

    [22] = { 头像 = 0, 结束 = false, 台词 = '喂，沙和尚，你被贬下凡，不一直就求修成正果，重回天庭吗？怎么这么大好的机会还不愿意去啊？' },
    [23] = { 头像 = 2092, 结束 = false, 台词 = '……我……我是个带罪之身，怎么可以去西天取经。' },
    [24] = { 头像 = 0, 台词 = '（嗯，看来这家伙是心结未解。解铃还需系铃人，去天宫找王母娘娘问问看）' },
    --5

    [25] = { 头像 = 3065, 结束 = false, 台词 = '沙和尚？？我记起来了，他本是保管我琉璃盏的神将，因为被孙悟空打碎了琉璃盏，被判失职之罪，贬下了凡间。' },
    [26] = { 头像 = 0, 结束 = false, 台词 = '娘娘可知道，这沙和尚因为心中对此事不能释怀，竟然甘愿放弃去西天取经修成正果的机会。实在是可怜可叹。' },
    [27] = { 头像 = 3065, 结束 = false, 台词 = '什么……竟有这样的事情。唉，若是因我的关系，而让他不能修成正果，老身也不能心安啊。' },
    [28] = { 头像 = 0, 结束 = false, 台词 = '其实方法很简单，只要娘娘肯给我一样物品做个记认，去告知他天庭已不再追究此事，娘娘也原谅了他，我想他的心结就能解开。' },
    [29] = { 头像 = 3065, 台词 = '好，那老身就以玉帝诏书一封，正式赦免他的罪过，让他能安心保取经人前往西天，以成正果。' },
    --6
    [30] = { 头像 = 2092, 结束 = false, 台词 = '…这是真的，这是真的诏书，天庭终于赦免我了。' },
    [31] = { 头像 = 0, 结束 = false, 台词 = '没错，这下你还有什么顾虑呢，去西天吧。' },
    [32] = { 头像 = 2092, 结束 = false, 台词 = '心魔：哼哼，没那么容易，沙和尚，你以为一纸诏书就能免了你的罪过，做梦！！' },
    [33] = { 头像 = 0, 结束 = false, 台词 = '（这……这是沙和尚的心魔！！好厉害，竟能成形。）' },
    [34] = { 头像 = 2092, 结束 = false, 台词 = '我不会再上你的当了，今天我要把你彻底消灭，摆脱你的控制，前往西天，求取正果。' },
    [35] = { 头像 = 2092, 结束 = false, 台词 = '心魔:嘿嘿，你想得倒美，我即是你，你即是我，你想消灭我，没那么容易！' },
    [36] = { 头像 = 0, 台词 = '哼，妖精，凭他自己的力量，可能不行，但是还有我呢。你别想再蛊惑于他！！' },
    --8
    [37] = { 头像 = 0, 结束 = false, 台词 = '终于消灭这家伙了,还真难缠！！' },
    [38] = { 头像 = 2092, 台词 = '谢谢，你的大恩，我铭记在心。哪怕有千难万险，我也一定保护取经人去到西天。' }
    --9
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
    if not 玩家:剧情称谓是否存在(12) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '仙女姐姐' then
        if self.进度 == 0 then
            self.进度 = 1
            self.对话进度 = 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        end
    elseif NPC.名称 == '猪八戒' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 12 then
                self.进度 = 2
            end
        end
    elseif NPC.名称 == '胜天籁' then
        if self.进度 == 2 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 16 then
                self.进度 = 3
            end
        end
    elseif NPC.名称 == '多头神魔' then
        if self.进度 == 3 then
            if self.对话进度 >= 20 then
                self.对话进度 = 17
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 20 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    elseif NPC.名称 == '沙和尚' then
        if self.进度 == 5 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 24 then
                self.进度 = 6
            end
        elseif self.进度 == 8 then
            if self.对话进度 >= 36 then
                self.对话进度 = 30
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 36 then
                self:任务攻击事件(玩家, NPC)
            end
        elseif self.进度 == 9 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 38 then
                self:完成(玩家)
            end
        end
    elseif NPC.名称 == '王母娘娘' then
        if self.进度 == 6 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 29 then
                local 添加物品 = 玩家:添加物品({ 生成物品 { 名称 = '诏书', 数量 = 1, 禁止交易 = true } })
                if 添加物品 then
                    self.进度 = 7
                else
                    self.对话进度 = self.对话进度 - 1
                end
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    玩家:添加声望(100)
    玩家:常规提示('#Y你成功点化沙和尚，你得到了100点声望值。')
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 13, '路上')
    end
    self:删除()
end

function 任务:击杀多头神魔(玩家)
    if 玩家:添加物品({ 生成物品 { 名称 = '九齿钉耙', 数量 = 1, 禁止交易 = true } }) then
        self.进度 = 4
        玩家:添加经验(5200000)
        玩家:添加师贡(75000)
        玩家:常规提示('#Y你得到5200000点经验和75000两师贡和九齿钉耙。')
    end
end

function 任务:击杀沙和尚(玩家)
    self.进度 = 9
    self.对话进度 = 37
    玩家:添加经验(5200000)
    玩家:添加师贡(75000)
    玩家:常规提示('#Y你得到5200000点经验和75000两师贡。')
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    NPC.队伍给予 = true
    if NPC.名称 == '猪八戒' then
        if self.进度 == 4 then
            if items[1] and items[1].名称 == '九齿钉耙' then
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.进度 = 5
                    self.对话进度 = 21
                    玩家:添加声望(100)
                    玩家:常规提示('#Y你成功点化猪八戒，你得到了100点声望值。')
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                end
            end
        end
    elseif NPC.名称 == '沙和尚' then
        if self.进度 == 7 then
            if items[1] and items[1].名称 == '诏书' then
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.进度 = 8
                    self.对话进度 = 30
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                end
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '多头神魔' then
        if self.进度 == 3 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓13_取经路上.lua', 1)
        end
    elseif NPC.名称 == '沙和尚' then
        if self.进度 == 8 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓13_取经路上.lua', 2)
        end
    end
end

local _怪物 = {

    {
        名称 = "多头神魔",
        等级 = 140,
        外形 = 2089,
        气血 = 1200000,
        魔法 = 12000,
        攻击 = 50000,
        速度 = 550,
        是否消失 = false,
        抗性 = {
            抗混乱 = 100,
            抗封印 = 80,
            抗昏睡 = 100,

        },
        技能 = {

        }
    },

    {
        名称 = "沙和尚",
        等级 = 140,
        外形 = 2092,
        气血 = 1250000,
        魔法 = 12000,
        攻击 = 50000,
        速度 = 550,
        是否消失 = false,
        抗性 = {
            抗震慑 = 30,
            物理吸收 = 50,
            抗水 = 50,
            抗火 = 50,
            抗雷 = 50,
            抗风 = 50,

        },
        技能 = {
            { 名称 = "蛟龙出海", 熟练度 = 13000 },
            { 名称 = "九龙冰封", 熟练度 = 13000 },
        }
    },


}


local _小怪 = {

    {
        名称 = "鼠怪",
        等级 = 140,
        外形 = 2021,
        气血 = 400000,
        魔法 = 12000,
        攻击 = 50000,
        速度 = 550,
        是否消失 = false,
        抗性 = {
            抗震慑 = 30,
            物理吸收 = 50,
            抗水 = 50,
            抗火 = 50,
            抗雷 = 50,
            抗风 = 50,
        },
        技能 = {

        }
    },


    {
        名称 = "虾兵",
        等级 = 140,
        外形 = 2062,
        气血 = 400000,
        魔法 = 12000,
        攻击 = 50000,
        速度 = 550,
        是否消失 = false,
        抗性 = {
            抗混乱 = 100,
            抗封印 = 80,
            抗昏睡 = 100,

        },
        技能 = {

        }
    },








}



function 任务:战斗初始化(玩家, i)
    local r = 生成战斗怪物(_怪物[i])
    self:加入敌方(1, r)
    for n = 1, 6, 1 do
        r = 生成战斗怪物(_小怪[i])
        self:加入敌方(n + 1, r)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        local zg = self:取对象(101)
        if zg then
            for _, v in self:遍历我方() do
                if v.是否玩家 then
                    local r = v.对象.接口:取任务("称谓13_取经路上")
                    if r then
                        if r.进度 == 3 and zg.名称 == "多头神魔" then
                            r:击杀多头神魔(v.对象.接口)
                        elseif r.进度 == 8 and zg.名称 == "沙和尚" then
                            r:击杀沙和尚(v.对象.接口)
                        end
                    end
                end
            end
        end
    end
end

return 任务
