

local 宠物领养 = 窗口层:创建我的窗口('宠物领养', 0, 0, 495, 394)
local _选中 = 1

local _介绍 = {
    '生肖鼠\n十二生肖里最精明能干的动物，知识丰富充满智慧，既有魅力又充满侵略性。',
    '生肖牛\n稳重.辛勤.诚恳.沉默寡言，是最嘉的完成者和执行者，强大而持久的耐力是牛的优点，但也不可掩饰牛也略微显得缓慢和极端固执。',
    '生肖虎\n威猛而充满创造力，特立独行不拘于常规，特别拥有自我意识，老虎似乎天生就有赚钱的运气和本能。',
    '生肖兔\n优雅而高贵.对艺术.音乐.历史和文学都有强烈的兴趣。他们喜欢和平安静。但这并不意味兔子是一种软弱可欺的动物。',
    '生肖龙\n具有权威性.对任何事物都充满热情.而且似乎永不之疲倦，他们的身上有散发着健康的气息和无穷的精力。',
    '生肖蛇\n美丽的生物，他们都比较孤芳自赏。当然,蛇也确实漂亮和聪明。它们多半控制欲比较强。 ',
    '生肖马\n追求自由的动物，可能会有点独断专行。马的学习能力也非常强。不过这也导致马有时候可能三心二意。',
    '生肖羊\n最具有创造力。不过他们通常都需要有人催逼才能成功。在天赋之下羊又可以承担巨大的工作量，即使是枯燥而漫长的工作也能完成。',
    '生肖猴\n稳定而且正直，又有点女子气。总是受人喜爱。而最令人欣赏的是猴解决问题的能力。他们多半对什么都很有兴趣。',
    '生肖鸡\n比较夸张.喜欢追随时尚和流行。热爱修饰。虽然看起来比较另类，其实鸡是很保守的。它们喜欢尝试各种东西。',
    '生肖狗\n是正义的代名词，他们考虑周详。聪明有信心.诚实.忠心.勇于献身。对于主人有着最忠诚的个性。狗最擅长契而不舍的完成一件事',
    '生肖猪\n强壮而温和.吸引人而诚实。不善言辞，但很喜欢舒适的生活。但猪总是相当精明。而且它们也确实有令人羡慕的好运气。'
}

function 宠物领养:初始化()
    self:置精灵(__res:getspr('gires/0x34CD2F86.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.选中框 = self:取拉伸精灵_宽高('gires3/button/lyxzk.tcp', 68, 100)
    self.选中框:置中心(-30, -48)
    local h = 1
    local l = 0
    self.emote = {}
    for i = 1, 12, 1 do
        l = l + 1
        if l > 4 then
            l = 1
            h = h + 1
        end
        local tcp = __res:get('shape/char/%04d/stand.tcp', 4000 + i)
        local ani = tcp:取动画(1)
        self.emote[i] = ani:播放(true)
        self.emote[i].xx = -30 + l * 79 - 79
        self.emote[i].yy = -48 + h * 109 - 109
        -- ani:置中心(- 30 + l * 79 - 79, -48 + h * 109 - 109, 68, 100)
    end



end

-- self.emote = {}
-- --self.fonts = {默认 = __res.F14, 宋体 = __res.F14}
-- for id = 0, 211 do
--     local tca = __res:get('gires/emote/%02d.tca', id)
--     if tca then --and tca.frame > 1
--         local ani = tca:取动画(1)
--         self.emote[id] = ani:播放(true)
--         -- ani:置中心(-ani.资源.x, -ani.资源.y + ani.高度)
--     end
-- end
function 宠物领养:更新(dt)

    for i = 1, 12 do
        self.emote[i]:更新(dt)
    end

end

function 宠物领养:显示(x, y)
    local h = 1
    local l = 0
    for i = 1, 12 do
        l = l + 1
        if l > 4 then
            l = 1
            h = h + 1
        end
        self.emote[i]:显示(x + 70 + l * 79 - 79, y + 10 + h * 109)
    end
end

function 宠物领养:前显示(x, y)
    if _选中 ~= 0 then
        self.选中框:显示(x, y)
    end
end

宠物领养:创建关闭按钮(0, 1)

function 宠物领养:左键弹起(x, y, a, b)
    for i = 1, 12 do
        if self.emote[i] and self.emote[i]:检查点(a, b) then
            self:置选中(i)
            return
        end
    end

end

宠物领养:创建文本('介绍文本', 350, 50, 130, 240):置文本('十二生肖里最精明能干的动物，知识丰富充满智慧，既有魅力又充满侵略性。')

function 宠物领养:置选中(i)
    _选中 = i
    self.介绍文本:置文本(_介绍[i])
    self.选中框:置中心(-self.emote[i].xx - 60, -self.emote[i].yy - 96)
end

local 领养按钮 = 宠物领养:创建中按钮('领养按钮', 369, 340, '领  养', 85)

function 领养按钮:左键弹起()
    coroutine.resume(宠物领养.co, _选中)
    宠物领养.co = nil
    宠物领养:置可见(false)
end

function 窗口层:打开宠物领养()
    宠物领养:置可见(not 宠物领养.是否可见)
    if not 宠物领养.是否可见 then
        return
    end
    宠物领养:置选中(1)
    宠物领养.co = coroutine.running()
    return coroutine.yield()
end

--窗口层:打开宠物领养()
function RPC:打开宠物领养()
    return 窗口层:打开宠物领养()
end

return 宠物领养
