local 任务 = {
    名称 = '坐骑2_惩恶扬善',
    别名 = '(坐骑二)惩恶扬善',
    类型 = '坐骑剧情',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
    self.御马小仙 = { 甲 = 0, 乙 = 0, 丙 = 0, 丁 = 0, 戊 = 0 }
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(sec)
end

local _详情 = {
    '前往#Y灵兽村#W找#G青龙长老#W聊一聊！',
    '去#Y傲来#W揭穿#G灵兽大仙#W的真面目。',
    '继续和#G灵兽大仙#W交谈。',
    '找#G灵兽仙#W问问降服#G灵兽大仙#W的方法。',
    '#G羊脂玉净瓶#W被#Y狮驼岭#W的#G蛤蟆精#W得到了，打败拿那回来吧。',
    '拿到羊脂玉净瓶了，去收服灵兽大仙吧。',
    '羊脂玉净瓶不灵验，找灵兽仙理论去。',
    '找御马监#G小马仙#W要糊涂虫。',
    '帮小马仙找五个御马小仙。',
    '五个御马小仙都找到了，去找#G小马仙#W要糊涂虫吧。',
    '拿到糊涂虫了，去收服#G灵兽大仙#W吧。#Y（ALT+G对灵兽大仙使用糊涂虫）',
    '收服了灵兽大仙，去找青龙长老复命吧。#Y（ALT+G把羊脂玉净瓶交给青龙长老）',
}

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1] or ''
end

local _台词 = {
    [1] = { 头像 = 3054, 结束 = false, 台词 = '师门不辛啊……唉……真是造孽……' },
    [2] = { 头像 = 0, 结束 = false, 台词 = '为何唉声叹气？不知在下能否帮上一些小忙，略进微薄之力。' },
    [3] = { 头像 = 3054, 结束 = false, 台词 = '唉阁下有所不知，老夫有一名劣徒不甘忍受寂寞，逃到傲来国化身成灵兽大仙，纠集了若干小妖为祸一方，我正为此烦恼不已。' },
    [4] = { 头像 = 0, 结束 = false, 台词 = '可是要效仿白虎护卫，来个大义灭亲？？（好好的一座灵兽村，为何会有那么多村民叛逃到人间，成为祸害一方的妖怪，这可真是奇怪了！）' },
    [5] = { 头像 = 3054, 结束 = false, 台词 = '一则此去路途遥远，我身担长老重任，不便轻易出村。二则就是……唉……' },
    [6] = { 头像 = 0, 结束 = false, 台词 = '二则可是长老于心不忍？？' },
    [7] = { 头像 = 3054, 结束 = false, 台词 = '说来可羞煞老夫，这劣徒自幼跟随于我，实在是不忍心……' },
    [8] = { 头像 = 0, 结束 = false, 台词 = '长老不必难过，不如在下前往一试，看能否规劝您那徒弟，长老认为如何？' },
    [9] = { 头像 = 3054, 台词 = '如此甚好，那就拜托啦！自己千万要小心……切勿伤了他的性命……' },
    --0

    [10] = { 头像 = 3043, 结束 = false, 台词 = '来者何人？见到本大仙还不下跪！' },
    [11] = { 头像 = 0, 结束 = false, 台词 = '好你个灵兽仙大仙，以为穿上道袍就不认得你了？你再这里作威作福，可有曾想过辛苦养育你的师傅！' },
    [12] = { 头像 = 3043, 结束 = false, 台词 = '哼！你一个外人拼什么管别人的家事？还有为何你怎会知道我与师傅之事？' },
    [13] = { 头像 = 0, 结束 = false, 台词 = '你师傅青龙已经将事情原委告知于我，若你还有良知此番就给我回灵兽村见你师傅。' },
    [14] = { 头像 = 3043, 结束 = false, 台词 = '灵兽村寂寞清苦，有什么好回的。你不见我在此多么逍遥快活，等我安定下来去把师傅也接来共享富贵。' },
    [15] = { 头像 = 0, 结束 = false, 台词 = '真是顽冥不化，别说你师傅，我都快被你气死了。我这就替你师傅教训教训你！' },
    [16] = { 头像 = 3043, 台词 = '哼有能耐在我手下逃命再说吧！' },
    --1

    [17] = { 头像 = 0, 结束 = false, 台词 = '看在你师傅的份上，这次就薄惩于你，快快和我回去像你师傅谢罪。' },
    [18] = { 头像 = 3043, 结束 = false, 台词 = '你还是杀了我吧，我死也不会再回到那个寂寞清苦的灵兽村！' },
    [19] = { 头像 = 0, 台词 = '（看来青龙长老这位劣徒本性还不坏，可就是不愿意回灵兽村，这可怎么是好？对了他也是灵兽，我何不去问问灵兽仙老儿有何高招。）' },
    --2

    [20] = { 头像 = 0, 结束 = false, 台词 = '灵兽老儿，灵兽老儿。' },
    [21] = { 头像 = 3062, 结束 = false, 台词 = '哈哈，什么风把你吹来了，可是又遇到什么麻烦事情了？' },
    [22] = { 头像 = 0, 结束 = false, 台词 = '麻烦事倒是有，不过不是我的。' },
    [23] = { 头像 = 3062, 结束 = false, 台词 = '不是你的……难道是我的不成！' },
    [24] = { 头像 = 0, 结束 = false, 台词 = '不错，正是你的。' },
    [25] = { 头像 = 3062, 结束 = false, 台词 = '这话怎讲？' },
    [26] = { 头像 = 0, 结束 = false, 台词 = '哼，傲来国有位灵兽大仙，在那作威作福，为祸一方，你可知罪？' },
    [27] = { 头像 = 3062, 结束 = false, 台词 = '这个……灵兽大仙和小老儿可没有关系，何罪之有啊？？' },
    [28] = { 头像 = 0, 结束 = false, 台词 = '（这老头倒也好骗，看来被我蒙住了，再糊弄糊弄他，到时候害怕他不帮我？）一个是灵兽仙，一个是灵兽大仙，他们非亲既故，恐怕是你的儿孙辈吧？就算和你没瓜葛，用你的名字为祸，也要治你个疏于职守的罪名。' },
    [29] = { 头像 = 3062, 结束 = false, 台词 = '玩笑可乱开不得啊……这可如何是好，还请您设法帮帮小老儿。' },
    [30] = { 头像 = 0, 结束 = false, 台词 = '哈哈……就我们俩的交情，当然会帮了。不过……为了替你澄清，总要抓他个活口。打死他不难，可是要生擒就……' },
    [31] = { 头像 = 3062, 结束 = false, 台词 = '要生擒他？这也不难。小老儿有一直羊脂玉净瓶，秩序拿它对准那灵兽大仙高呼其名，只要他一答应，就会被装入瓶中。' },
    [32] = { 头像 = 0, 结束 = false, 台词 = '（没想到这老头还有这么件宝贝，这下就简单啦）有什么羊脂玉净瓶就快拿来，我这就把灵兽大仙给抓了去。' },
    [33] = { 头像 = 3062, 台词 = '前些日小老儿到狮驼岭收妖，不慎讲羊脂玉净瓶失落在了狮驼岭，听说现在被蛤蟆精得到了。碰巧这几天没空去拿，还请你再跑一趟吧。' },
    --3

    [34] = { 头像 = 2022, 结束 = false, 台词 = '有了这个羊脂玉净瓶，在狮驼岭我就不用再低声下气啦，呱呱呱……' },
    [35] = { 头像 = 0, 结束 = false, 台词 = '蛤蟆精，这个羊脂玉净瓶听说是灵兽仙的宝贝，怎么落到你手上？' },
    [36] = { 头像 = 2022, 结束 = false, 台词 = '东西掉在地上，我捡到的就是我的，你想干嘛？' },
    [37] = { 头像 = 0, 结束 = false, 台词 = '没有没有，我是说，有一个小孩子离家出走了，我要把这个小孩子带回去。可小孩子怎么不愿意回家，这个羊脂玉净瓶呢……' },
    [38] = { 头像 = 2022, 结束 = false, 台词 = '我的！' },
    [39] = { 头像 = 0, 结束 = false, 台词 = '我知道！不过其实是这个瓶子的主任答应把它借给我，然后他不小心将瓶子丢在狮驼岭了，再然后呢瓶子就被你捡了，再再然后呢我就来找你要这个瓶子……明白了吗？' },
    [40] = { 头像 = 2022, 结束 = false, 台词 = '明白了，你是神经病，而且是一个想骗我瓶子的神经病！' },
    [41] = { 头像 = 0, 结束 = false, 台词 = '（看来要想说服蛤蟆精要比对牛弹琴难的多了。迫于无奈只好……）既然你不肯交出来，那我唯有用抢的了。' },
    [42] = { 头像 = 2022, 台词 = '不给你就用抢的，你不去当强盗确实有失天分，呱呱呱……' },
    --4

    [43] = { 头像 = 0, 结束 = false, 台词 = '灵兽大仙！！' },
    [44] = { 头像 = 3043, 结束 = false, 台词 = '…… …… …… …… ……' },
    [45] = { 头像 = 0, 结束 = false, 台词 = '灵兽大仙！！' },
    [46] = { 头像 = 3043, 结束 = false, 台词 = '你当我是傻瓜啊，羊脂玉净瓶的功用谁人不是知，要杀就杀，不要来啰嗦。' },
    [47] = { 头像 = 0, 台词 = '（破烂东西，灵兽老儿你可把我坑苦了）' },
    --5

    [48] = { 头像 = 0, 结束 = false, 台词 = '灵兽老儿你给我出来！！' },
    [49] = { 头像 = 3062, 结束 = false, 台词 = '可是把那假冒的灵兽大仙逮到了来报喜的？' },
    [50] = { 头像 = 0, 结束 = false, 台词 = '报你个头，你的破宝贝压根就不灵。' },
    [51] = { 头像 = 3062, 结束 = false, 台词 = '这绝不可能，小老儿的宝贝是从太上老君手上得来，可是百试不爽。当年要不是金角大王和银角大王太笨，险些连齐天大圣都被它拿住。' },
    [52] = { 头像 = 0, 结束 = false, 台词 = '坏就坏在它百试不爽，大家都知道它的功效，我怎么叫那灵兽大仙都不答应，再灵又有什么用处。' },
    [53] = { 头像 = 3062, 台词 = '阁下暂且息怒，听说小马仙有一种糊涂虫，可使人神志不清，你去要一只来给那灵兽大仙用上，再叫他名字不就行了。' },
    --6

    [54] = { 头像 = 46, 结束 = false, 台词 = '糊涂虫呀，这儿可多了……可使我正和小仙们一起抓迷藏呢。这样子吧，我去帮你抓糊涂虫，你去帮我找小朋友好不好？要在十分钟内找齐五个小朋友哦。' },
    [55] = { 头像 = 0, 结束 = false, 台词 = '哥哥帮你找就是，但你可得把糊涂虫抓到哦。' },
    [56] = { 头像 = 46, 台词 = '哥哥放心，等你找到小仙们就抓到了。' },
    --7

    [57] = { 头像 = 46, 台词 = '真厉害，这都让你找到了。' },
    [58] = { 头像 = 46, 台词 = '你已经找过我了' },
    --8

    [59] = { 头像 = 46, 台词 = '嘻，大哥哥抓迷藏好厉害哦，这就是糊涂虫了，拿好了呀。 ' },
    --9

    [60] = { 头像 = 3043, 结束 = false, 台词 = '头怎么突然好晕？' },
    [61] = { 头像 = 0, 结束 = false, 台词 = '灵兽大仙！！' },
    [62] = { 头像 = 3043, 结束 = false, 台词 = '哎，我在这呢！！#Y（光华一现，只见灵兽大仙身影一闪，已被装入羊脂玉净瓶中。）' },
    [63] = { 头像 = 0, 台词 = '（总不辱使命，赶紧带他回去见青龙长老吧！）' },
    --10

    [64] = { 头像 = 3054, 结束 = false, 台词 = '这次仰仗阁下帮忙，劣徒才没酿成大错。' },
    [65] = { 头像 = 0, 结束 = false, 台词 = '长老您不必客气，他现在想明白了？' },
    [66] = { 头像 = 3054, 结束 = false, 台词 = '劣徒就是劣徒，虽然明白了，与妖怪为伍鱼肉百姓是不对的，可是怎么都不愿意长期呆在这灵兽村，待我再调教时日让其回心转意。阁下为人善良，无私帮助他人，实乃道德高尚。' },
    [67] = { 头像 = 0, 结束 = false, 台词 = '长老过奖了，助人为乐乃快乐之本，何以有高尚之说？' },
    [68] = { 头像 = 3054, 台词 = '哈哈……老夫此处有灵兽蛋一颗，借此赠与阁下了表谢意。' },
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
    if NPC.名称 == '青龙长老' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 9 then
                self.进度 = 1
            end
        elseif self.进度 == 12 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 68 then
                self:完成(玩家)
            end
        end
    elseif NPC.名称 == '灵兽大仙' then
        if self.进度 == 1 then
            if self.对话进度 >= 16 then
                self.对话进度 = 9
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 16 then
                self:任务攻击事件(玩家, NPC)
            end
        elseif self.进度 == 2 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 19 then
                self.进度 = 3
            end
        elseif self.进度 == 5 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 47 then
                self.进度 = 6
            end
        elseif self.进度 == 11 then
            if self.对话进度 >= 63 then
                return
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        end
    elseif NPC.名称 == '灵兽仙' then
        if self.进度 == 3 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 33 then
                self.进度 = 4
            end
        elseif self.进度 == 6 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 53 then
                self.进度 = 7
            end
        end
    elseif NPC.名称 == '蛤蟆精' then
        if self.进度 == 4 then
            if self.对话进度 >= 42 then
                self.对话进度 = 33
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 42 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    elseif NPC.名称 == '小马仙' then
        if self.进度 == 7 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 56 then
                self.进度 = 8
            end
        elseif self.进度 == 9 then
            local 添加物品 = 玩家:添加物品({ 生成物品 { 名称 = '糊涂虫', 数量 = 1, 禁止交易 = true } })
            if 添加物品 then
                self.对话进度 = 59
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                self.进度 = 10
            else
                玩家:提示窗口('#Y你的背包满了，无法获得任务物品！')
            end
        end
    elseif NPC.名称 == '御马小仙甲' then
        if self.进度 == 8 then
            if self.御马小仙.甲 == 0 then
                self.御马小仙.甲 = 1
                self.对话进度 = 57
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                self:检查NPC进度()
            else
                self.对话进度 = 58
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            end
        end
    elseif NPC.名称 == '御马小仙乙' then
        if self.进度 == 8 then
            if self.御马小仙.乙 == 0 then
                self.御马小仙.乙 = 1
                self.对话进度 = 57
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                self:检查NPC进度()
            else
                self.对话进度 = 58
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            end
        end
    elseif NPC.名称 == '御马小仙丙' then
        if self.进度 == 8 then
            if self.御马小仙.丙 == 0 then
                self.御马小仙.丙 = 1
                self.对话进度 = 57
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                self:检查NPC进度()
            else
                self.对话进度 = 58
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            end
        end
    elseif NPC.名称 == '御马小仙丁' then
        if self.进度 == 8 then
            if self.御马小仙.丁 == 0 then
                self.御马小仙.丁 = 1
                self.对话进度 = 57
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                self:检查NPC进度()
            else
                self.对话进度 = 58
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            end
        end
    elseif NPC.名称 == '御马小仙戊' then
        if self.进度 == 8 then
            if self.御马小仙.戊 == 0 then
                self.御马小仙.戊 = 1
                self.对话进度 = 57
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                self:检查NPC进度()
            else
                self.对话进度 = 58
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            end
        end
    end
end

function 任务:检查NPC进度()
    if self.进度 == 8 then
        for k, v in pairs(self.御马小仙) do
            if v == 0 then
                return
            end
        end
    end
    self.进度 = 9
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    if 玩家:添加物品({ 生成物品 { 名称 = "灵兽蛋", 数量 = 1, 参数 = 2, 种族 = 玩家.种族 } }) then
        self:删除()
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if NPC.名称 == '灵兽大仙' then
        if self.进度 == 10 then
            if items[1] then
                if items[1].名称 == '糊涂虫' then
                    if items[1].数量 >= 1 then
                        items[1]:接受(1)
                        self.进度 = 11
                        self.对话进度 = 60
                        NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                    end
                end
            end
        end
    elseif NPC.名称 == '青龙长老' then
        if self.进度 == 11 then
            if items[1] then
                if items[1].名称 == '羊脂玉净瓶' then
                    if items[1].数量 >= 1 then
                        items[1]:接受(1)
                        self.进度 = 12
                        self.对话进度 = 64
                        NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                    end
                end
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '灵兽大仙' then
        if self.进度 == 1 and self.对话进度 == 16 then
            local r = 玩家:进入战斗('scripts/war/坐骑剧情/坐骑2_灵兽大仙.lua', NPC)
            if r then
                self.进度 = 2
                self.对话进度 = 17
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                玩家:最后对话(NPC.台词, NPC.头像)
            end
        end
    elseif NPC.名称 == '蛤蟆精' then
        if self.进度 == 4 and self.对话进度 == 42 then
            local r = 玩家:进入战斗('scripts/war/坐骑剧情/坐骑2_蛤蟆精.lua', NPC)
            if r then
                local 添加物品 = 玩家:添加物品({ 生成物品 { 名称 = '羊脂玉净瓶', 数量 = 1, 禁止交易 = true } })
                if 添加物品 then
                    self.进度 = 5
                    玩家:添加经验(171000)
                    玩家:添加银子(100000)
                end
            end
        end
    end
end

return 任务
