local 任务 = {
    名称 = '坐骑3_义薄云天',
    别名 = '(坐骑三)义薄云天',
    类型 = '坐骑剧情',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(sec)
end

local _详情 = {
    '前往#Y灵兽村#W找#G嬷嬷#W聊一聊！',
    '找#G白虎长老#W询问小白虎的情况。',
    '找#G青龙长老#W询问小白虎的情况。',
    '去#Y大唐边境#W，铲除#G#G#u#[001173|52|330|$千年巨鳄#]#u#W#W。#Y（ALT+A攻击千年巨鳄）',
    '告诉#G白虎长老#W，千年巨鳄已经铲除的好消息。',
    '深入凤巢，打败#G#u#[001192|20|40|$无名小妖#]#u#W，救出小白虎的魂魄。',
    '将小白虎的魂魄带回去交给#G白虎长老#W。',
    '把找回小白虎魂魄的好消息告诉#G嬷嬷#W。',
}

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1] or ''
end

local _台词 = {
    [1] = { 头像 = 2288, 结束 = false, 台词 = '呜，呜呜，小白虎他……他……' },
    [2] = { 头像 = 0, 台词 = '嬷嬷，小白虎怎么了！！他怎么既不会动，也不会说话了？？' },
    --0
    [3] = { 头像 = 0, 结束 = false, 台词 = '长老，长老，白虎护卫的徒弟小白虎失魂了，你知道吗？' },
    [4] = { 头像 = 2038, 结束 = false, 台词 = '…… …… ……' },
    [5] = { 头像 = 0, 台词 = '（白虎长老支支吾吾的不肯说话，找青龙长老去问问。）' },
    --1

    [6] = { 头像 = 0, 结束 = false, 台词 = '长老，长老，白虎护卫的徒弟小白虎失魂了，你知道吗？' },
    [7] = { 头像 = 3054, 结束 = false, 台词 = '这个嘛……' },
    [8] = { 头像 = 0, 结束 = false, 台词 = '事关小白虎的性命，您不会也不告诉我吧？' },
    [9] = { 头像 = 3054, 结束 = false, 台词 = '具体怎么回事，还的问白虎长老才好啊。' },
    [10] = { 头像 = 0, 结束 = false, 台词 = '可是他支支吾吾的不肯多说。' },
    [11] = { 头像 = 3054, 结束 = false, 台词 = '那是由于他对你了解不深，不相信你的为人和能力吧。灵兽村长期不和外界接触，大家脾气多少有些固执……' },
    [12] = { 头像 = 0, 结束 = false, 台词 = '您就帮忙想个法子，让白虎长老他……' },
    [13] = { 头像 = 3054, 结束 = false, 台词 = '白虎老儿门下的事情，我也不好多管。' },
    [14] = { 头像 = 0, 结束 = false, 台词 = '您不会让我坐视小白虎失魂，袖手旁观吧？' },
    [15] = { 头像 = 3054, 结束 = false, 台词 = '让我想想……北俱芦洲和大唐边境交界的地方有一只恶兽，一直是白虎长老的心头大患，你如此如此……还是不行的话，你去找以为名叫高飞的村民, 这般这般……' },
    [16] = { 头像 = 0, 台词 = '就知道青龙长老最好了，我知道该怎么做啦。' },
    --2

    [17] = { 头像 = 2038, 结束 = false, 台词 = '是谁告诉你千年巨鳄盘踞所在的？小小年纪,怎么敢去惹他！' },
    [18] = { 头像 = 0, 结束 = false, 台词 = '既然知道有这么一头恶兽存在，在下自当竭力将其降伏，不能让他继续为祸地方。' },
    [19] = { 头像 = 2038, 结束 = false, 台词 = '真是年轻人，不知道天高地厚，它的厉害你可晓得，伤到没有？？平安回来就好，平安回来就好。' },
    [20] = { 头像 = 0, 结束 = false, 台词 = '托长老洪福，在下侥幸已经将它降伏。' },
    [21] = { 头像 = 2038, 结束 = false, 台词 = '英雄出少年啊，好孩子，了不起啊！！我那徒孙小白虎长大了要是能有你一半出席，老夫就心满意足了。唉，可惜……' },
    [22] = { 头像 = 0, 结束 = false, 台词 = '没错，在下已经好好的教训了他，想必它再也不敢为恶了。' },
    [23] = { 头像 = 2038, 结束 = false, 台词 = '哎这都是命呀。告诉你也没什么用……徒增伤心而已。' },
    [24] = { 头像 = 0, 结束 = false, 台词 = '如何，发现小白虎的魂魄没？' },
    [25] = { 头像 = 3054, 台词 = '事情是这样的…前些天小白虎犊子玩耍的时候被妖怪将魂魄摄掳走，藏玉凤巢之中，就变成现在这般模样了。我们虽然也去找过数次，奈何凤巢道路过于复杂，只能作罢。可怜的小白虎……不提也罢。' },
    --4

    [26] = { 头像 = 0, 结束 = false, 台词 = '大胆小妖，可让我逮到你了，快将小白虎的魂魄交出来，还可绕你一死！' },
    [27] = { 头像 = 2004, 台词 = '嘿，嘿嘿。要拿回他的魂魄容易，打过我再说。' },
    --5

    [28] = { 头像 = 0, 结束 = false, 台词 = '在下辛不辱使命，已经找到小白虎的魂魄并将其带回来了。' },
    [29] = { 头像 = 3054, 台词 = '真是英雄少年啊，小侠端的好手段，你这可是灵兽村的大恩人，我马上就帮这孩子施法换魂，麻烦你先去告诉嬷嬷一声，免得她继续伤心。' },
    --6

    [30] = { 头像 = 0, 结束 = false, 台词 = '嬷嬷,别伤心啦，小白虎的魂魄我已经找回来了，白虎长老正在为他施法还魂呢，等一会您就能见到活蹦乱跳的小白虎了。' },
    [31] = { 头像 = 2288, 台词 = '啊！！！真的？？？这实在是太感谢你了，没有了他，我都不知道怎么活哇！恩人，这有一颗“灵兽蛋”，是老太婆的一点心意，请收下吧，千万不要嫌弃呀！' },
    --7
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
    if NPC.名称 == '嬷嬷' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 2 then
                self.进度 = 1
            end
        elseif self.进度 == 7 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 31 then
                self:完成(玩家)
            end
        end
    elseif NPC.名称 == '白虎长老' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 5 then
                self.进度 = 2
            end
        elseif self.进度 == 4 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 25 then
                self.进度 = 5
            end
        elseif self.进度 == 6 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 29 then
                self.进度 = 7
            end
        end
    elseif NPC.名称 == '青龙长老' then
        if self.进度 == 2 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 16 then
                self.进度 = 3
            end
        end
    elseif NPC.名称 == '无名小妖' then
        if self.进度 == 5 then
            if self.对话进度 >= 27 then
                self.对话进度 = 25
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 27 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    if 玩家:添加物品({ 生成物品 { 名称 = "灵兽蛋", 数量 = 1, 参数 = 3, 种族 = 玩家.种族 } }) then
        self:删除()
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)

end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '千年巨鳄' then
        if self.进度 == 3 then
            local r = 玩家:进入战斗('scripts/war/坐骑剧情/坐骑3_千年巨鳄.lua', NPC)
            if r then
                self.进度 = 4
                玩家:添加经验(256000)
                玩家:添加银子(50000)
            end
        end
    elseif NPC.名称 == '无名小妖' then
        if self.进度 == 5 and self.对话进度 == 27 then
            local r = 玩家:进入战斗('scripts/war/坐骑剧情/坐骑3_无名小妖.lua', NPC)
            if r then
                self.进度 = 6
            end
        end
    end
end

return 任务
