local 任务 = {
    名称 = '称谓4_滋扰高小姐的妖怪',
    别名 = '(四称)滋扰高小姐的妖怪',
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
    '前往#Y高老庄大厅#W找#G#u#[1170|26|25|$高老先生#]#u#W聊一聊！',
    '去找#G#u#[1171|18|6|$高小姐#]#u#W了解下情况。',
    '去#Y大唐边境（241.319）#W的山洞里，解决了那#u#[1173|255|322|$妖怪#]#u#W。',
    '打败了猪八戒，去告诉#G#u#[1170|26|25|$高老先生#]#u#W这个消息。'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3027, 结束 = false, 台词 = '糟了糟了，我的女儿被妖怪盯上了。那妖怪整天腾云驾雾，风里来，沙里去谁也降伏不了他。还说三天以后就要来迎娶我的女儿，这可怎么办啊！！哎，我可怜的女儿……！' },
    [2] = { 头像 = 0, 结束 = false, 台词 = '老丈你女儿被什么妖怪盯上了？' },
    [3] = { 头像 = 3027, 结束 = false, 台词 = '这个我女儿比我清楚，你可以去问她。我知道你是能人异士，求你救救我的女儿吧！' },
    [4] = { 头像 = 0, 台词 = '好的，我了解一下情况先~' },
    --0
    [5] = { 头像 = 3061, 结束 = false, 台词 = '那只妖怪整天变换形象，有时候是个猪脸，有时候又是个将军的样子…我也不知道他的正体是什么…不过听他自己说，他是天上的什么什么大将，被打落人间的，现在住在沙漠里的一个山洞里……他还说三天以后就要来娶我。我好怕啊…你能帮我吗？' },
    [6] = { 头像 = 0, 台词 = '我这就去解决那妖怪！' },
    --1
    [7] = { 头像 = 0, 结束 = false, 台词 = '毛头猪脸的妖怪，你长得这么丑，还敢强抢民女？' },
    [8] = { 头像 = 2091, 台词 = '混帐！我是天上的天蓬元帅下凡，虽然有人说我长的像只猪，那是他们不懂欣赏！你是什么地方的毛贼，敢来坏我的好事？先吃你猪爷爷一钉耙！！' },
    --2 进入战斗
    [9] = { 头像 = 2091, 台词 = '没想到你这么厉害…哎我因为调戏嫦娥被贬下凡尘，投胎的时候又错投了猪胎，才弄成今天这个样子……我只是想和平常人一样。算了，我不会再去骚扰高小姐了，你也放过我吧。' },
    --2 战斗结束
    [10] = { 头像 = 3027, 台词 = '太谢谢你了！我们高家终于不用招一个妖怪女娟…您的大恩大德，我高家无以为报，这5000两银子和一些药材，请您笑纳。' },
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
    if not 玩家:剧情称谓是否存在(3) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '高老先生' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 4 then
                self.进度 = 1
            end
        elseif self.进度 == 3 then
            self.对话进度 = 10
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            self:完成(玩家)
        end
    elseif NPC.名称 == '高小姐' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 6 then
                self.进度 = 2
            end
        end
    elseif NPC.名称 == '猪八戒' then
        if self.进度 == 2 then
            if self.对话进度 >= 8 then
                self.对话进度 = 6
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 8 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:击杀猪八戒(玩家)
    self.进度 = 3
    self.对话进度 = 9
    玩家:添加经验(454218)
    玩家:添加师贡(65214)
    玩家:常规提示('#R你打败了猪八戒，获得了454218经验和65214两师贡！！')
end

function 任务:完成(玩家)
    玩家:添加声望(150)
    玩家:添加师贡(5000)
    玩家:添加物品({ 生成物品 { 名称 = '清风白雪', 数量 = 1 } })
    玩家:提示窗口('#Y因为你的胆大心细，你在这个世界的声望得到提升。获得150点声望，5000两师贡和一个清风白雪。')

    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 4, '八戒')
    end
    self:删除()
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '猪八戒' then
        if self.进度 == 2 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓4_滋扰高小姐的妖怪.lua')
        end
    end
end

local _怪物 = {
    {
        名称 = "猪八戒",
        外形 = 2091,
        气血 = 60000,
        魔法 = 5000,
        攻击 = 3200,
        速度 = 40,
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
                local r = v.对象.接口:取任务("称谓4_滋扰高小姐的妖怪")
                if r and r.进度 == 2 then
                    r:击杀猪八戒(v.对象.接口)
                end
            end
        end
    end
end

return 任务
