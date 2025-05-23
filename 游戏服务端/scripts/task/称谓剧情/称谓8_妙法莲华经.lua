local 任务 = {
    名称 = '称谓8_妙法莲华经',
    别名 = '(八称)妙法莲华经',
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
    '前往#Y傲来国(311,35)#W找#G#u#[1092|315|33|$紫霞#]#u#W谈谈。',
    '去金山寺#G#u#[1153|19|16|$法明方丈#]#u#W找“妙法莲华经”',
    '去龙窟六层，杀死#G#u#[1182|37|61|$断情蛛#]#u#W，夺回妙法莲华经#W。#G（ALT+A攻击断情蛛）',
    '把妙法莲华经交紿#G#u#[1092|315|33|$紫霞#]#u#W。#Y(请将妙法莲华经ALT+G给予紫霞）',
    '找#G#u#[1092|315|33|$紫霞#]#u#W聊聊一万三千年前的一些事情。',
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 2015, 结束 = false, 台词 = '我想，你一定很奇怪我，孙悟空，小白，我们三个人之间的关系。' },
    [2] = { 头像 = 0, 结束 = false, 台词 = '对。到底是怎么回事？' },
    [3] = { 头像 = 2015, 结束 = false, 台词 = '我本是佛祖前的一颗灯芯，一万三千年前我遇到了那个叫做孙悟空的男人，曾经是灯芯的我，拥有窥视人心的能力，我隐约能够看到孙悟空黑暗的过去，当时他的内心被禁咒封锁，忘记了一切。' },
    [4] = { 头像 = 0, 结束 = false, 台词 = '你是说他有一段时间丧失了记忆？' },
    [5] = { 头像 = 2015, 结束 = false, 台词 = '没错。' },
    [6] = { 头像 = 0, 结束 = false, 台词 = '为什么？' },
    [7] = { 头像 = 2015, 结束 = false, 台词 = '因为那场考验，九生九死的考验……他忘记了过去的一切，而这也正是那时候为什么他会和我在一起的原因。很快，小白成为真正的纯阴女妖升天而来，当者披靡，她杀了几乎所有的神，最终在我和悟空面前停步。空洞血红的尸魔的眼睛里，居然流露出动人心魄的哀伤与温柔。小白住手了，从怀里缓缓掏出一样东西，是孙悟空当时送给她作为承诺的盒子。而这时候，佛祖也如期而至，将小白收服……' },
    [8] = { 头像 = 0, 结束 = false, 台词 = '原来如此！这以后的事情我差不多都知道了，其后一万年孙悟空就一直在试图营救小白？' },
    [9] = { 头像 = 2015, 结束 = false, 台词 = '恩，孙悟空终于没有爱上我，经过一万三千年他对小白的感情依然没有变。我对红尘已经厌倦了，也许我还是应当回到佛祖的身边当一个株灯芯……请你帮我去金山寺取回一本叫做妙法莲华经的佛经，只要有那本经书，我就可以摆脱这些尘世的烦恼。重新做回一根无知无识的灯芯。' },
    [10] = { 头像 = 0, 台词 = '好吧……' },
    --0
    [11] = { 头像 = 3047, 结束 = false, 台词 = '妙法莲华经被#R龙窟六层的断情蛛#W偷走了，那是只夺天地造化的可怕巨大蜘蛛，我劝你还是算了吧！' },
    [12] = { 头像 = 0, 台词 = '开什么玩笑，一只蜘蛛也敢跟我叫板。' },
    --1
    [13] = { 头像 = 2015, 结束 = false, 台词 = '谢谢你为我取来经书，我终于可以解脱了。既然悟空并不爱我，那我也不会再留恋这凡尘俗世了……作为报答，我会告诉你一万三千年前的一些事情，如果你想知道的话。' },
    [14] = { 头像 = 0, 结束 = false, 台词 = '当然想知道啊！' },
    [15] = { 头像 = 2015, 结束 = false, 台词 = '我已经跟你提过，孙悟空曾经送给小白一只盒子，那盒子里装着一颗悟空从石里出生的时候迸飞而带出的石头。' },
    [16] = { 头像 = 0, 结束 = false, 台词 = '而小白一直把这个盒子放在身上？' },
    [17] = { 头像 = 2015, 结束 = false, 台词 = '对，直到小白屠神之日。那天，悟空看着那盒子和小白的眼神，回想起了一切，佛祖在盒子上写下了禁咒“般若波罗密”。盒子和孙悟空一起出生的石头也在佛祖的点化下成为三样宝物，金箍，金箍棒，还有我的紫青宝剑。' },
    [18] = { 头像 = 0, 结束 = false, 台词 = '三样宝物原来是这么来的。' },
    [19] = { 头像 = 2015, 结束 = false, 台词 = '因为佛祖的力量，盒子在月光下会有神奇的力量，能够跨越时空，它象征人力不能挽回的哀伤，命运和悔恨，金箍棒代表着孙悟空被禁锢的无穷力量，金箍则代表被封存的记忆，而紫青宝剑则象征了温柔和约定。' },
    [20] = { 头像 = 0, 结束 = false, 台词 = '是这样……' },
    [21] = { 头像 = 2015, 台词 = '孙悟空将紫青宝剑送给了我，而在一万年里挣扎在回忆和痛苦之中。他已经不是纯粹的天仙，他的力量被分成三分，只有同时获得金箍与金箍棒才能恢复完整的力量。而一旦带上金箍，他就注定不能再和情欲有所牵连，这可以说是佛祖的牵制，也可以说是佛祖的圈套。而这一切，却如佛祖说的：都是为了三界的和平。' },
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
    if not 玩家:剧情称谓是否存在(7) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '紫霞' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 10 then
                self.进度 = 1
            end
        elseif self.进度 == 4 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 21 then
                self:完成(玩家)
            end
        end
    elseif NPC.名称 == '法明方丈' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 12 then
                self.进度 = 2
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成进度2(玩家)
    if 玩家:添加物品({ 生成物品 { 名称 = '妙法莲华经', 数量 = 1, 禁止交易 = true } }) then
        self.进度 = 3
        玩家:添加经验(2038000)
        玩家:添加师贡(51066)
        玩家:常规提示('#Y你得到#G938000#Y点经验和#G51066#Y两师贡和妙法莲华经。')
    end
end

function 任务:完成(玩家)
    玩家:添加声望(7000)
    玩家:常规提示('#Y你帮助紫霞仙子归位，你在这个世界的声望提升了，你获得了7000的声望。')
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 8, '妙法')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    NPC.队伍给予 = true
    if NPC.名称 == '紫霞' then
        if self.进度 == 3 then
            if items[1] and items[1].名称 == '妙法莲华经' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.进度 = 4
                    self.对话进度 = 13
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                end
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '断情蛛' then
        if self.进度 == 2 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓8_妙法莲华经.lua')
        end
    end
end

local _怪物 = {
    {
        名称 = "断情蛛",
        等级 = 110,
        外形 = 2065,
        气血 = 600000,
        魔法 = 120000,
        攻击 = 8000,
        速度 = 180,
        是否消失 = false,
        抗性 = {
            抗混乱 = 80,
            抗封印 = 80,
            抗昏睡 = 70,
            物理吸收 = 50,

        },
        技能 = {
            { 名称 = "飞砂走石", 熟练度 = 8000 },
            { 名称 = "乘风破浪", 熟练度 = 8000 },
            { 名称 = "太乙生风", 熟练度 = 8000 },
            { 名称 = "风雷涌动", 熟练度 = 8000 },
        }
    },

    {
        名称 = "地狱战神",
        等级 = 100,
        外形 = 2074,
        气血 = 300000,
        魔法 = 100001,
        攻击 = 4000,
        速度 = 90,
        是否消失 = false,
        抗性 = {
            抗混乱 = 100,
            抗封印 = 80,
            抗昏睡 = 100,
            物理吸收 = 30,

        },
        技能 = {
            -- { 名称 = "雷霆霹雳", 熟练度 = 8000 },
            -- { 名称 = "日照光华", 熟练度 = 8000 },
            -- { 名称 = "雷神怒击", 熟练度 = 8000 },
            -- { 名称 = "电闪雷鸣", 熟练度 = 8000 },
        }
    }
}







function 任务:战斗初始化(玩家)
    local r = 生成战斗怪物(_怪物[1])
    self:加入敌方(1, r)
    local n = math.random(2, 8)
    for k = 1, n, 1 do
        r = 生成战斗怪物(_怪物[2])
        self:加入敌方(k + 1, r)
    end
end

function 任务:战斗回合开始(dt)

end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("称谓8_妙法莲华经")
                if r and r.进度 == 2 then
                    r:完成进度2(v.对象.接口)
                end
            end
        end
    end
end

return 任务
