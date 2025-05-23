﻿local 任务 = {
    名称 = '称谓12_四圣戏禅心',
    别名 = '(十二称)四圣戏禅心',
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
    '你可以完成第十二个称谓剧情任务了，任务领取人#Y白骨山(74,59)#G#u#[101300|75|57|$老妇人#]#u',
    '去问间#G#u#[101297|18|13|$三小姐#]#u#W为什么烦恼。',
    '去打跑#G#u#[101295|40|12|$山贼#]#u#W，解决三小姐的烦恼。#R(温馨提示:山贼杀不死，只要坚持10回合等他逃跑就可以了。）',
    '这山贼难道是个树妖，去问问傲来的铁匠#G#u#[1101|14|19|$黄哥#]#u#W。',
    '去找#G#u#[1174|138|140|$沙铁匠#]#u#W要金铭石对付树妖。',
    '去五指山解决#G#u#[1194|22|30|$老猴精#]#u#W。#Y（ALT+A攻击老猴精）',
    '有了金铭石，不会再怕#G#u#[101295|40|12|$山贼#]#u#W的妖法了。#R（对话后进入战斗！）',
    '打败了山贼，去告诉#G#u#[101297|18|13|$三小姐#]#u#W让她安心。',
    '去问问#G#u#[101298|22|15|$二小姐#]#u#W为什么烦恼。',
    '去洛阳帮二小姐找回手镯，听说现在#G#u#[1236|334|59|$满堂春#]#u#W处。',
    '给予#G#u#[1236|334|59|$满堂春#]#u#W天外飞石换回手镯。#R（请ALT+G直接给予满堂春天外飞石)',
    '拿到手镯，快去交给#G#u#[101298|22|15|$二小姐#]#u#W吧。#R（请ALT+G给予)',
    '去问问#G#u#[101295|28|196|$大小姐#]#u#W为什么烦恼。',
    '去做来国找#G#u#[1092|215|213|$守禅僧#]#u#W讨要九叶琼芝草给大小姐治病。',
    '这守禅僧如此难对付，怎么办呢??旁边的#G#u#[1092|218|205|$雷鸟怪#]#u#W问问他有什么办法... ...',
    '去魔王寨找#G#u#[1173|600|208|$雷鸟#]#u#W问问。',
    '拿到雷鸟的介绍信，去找#G#u#[1092|218|205|$雷鸟怪#]#u#W继续打听。',
    '得到佛谕，快找#G#u#[1092|215|213|$守禅僧#]#u#W僧进入圣殿。',
    '把九叶琼芝草给#G#u#[101295|28|196|$大小姐#]#u#W。#Y（ALT+G将九叶琼芝草给予大小姐)',
    '跟#G大小姐#W聊聊吧。',
    '三位小姐的烦恼都解除了 ，去和#G#u#[101296|25|10|$老夫人#]#u#W聊聊吧。'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3069, 结束 = false, 台词 = '你是西去灵山的修行之人？嗯，老身也是礼佛之人，今日便请在此歇息一宿，明日再行。' },
    [2] = { 头像 = 0, 结束 = false, 台词 = '多谢老夫人，看老夫人似乎心事重重，是否遇到什么为难之事？？不知可方便相告，也许我能尽些绵薄之力。' },
    [3] = { 头像 = 3069, 结束 = false, 台词 = '唉，这位小哥有所不知，老身夫君早逝，只留下三个女儿，老身含辛茹苦将他们抚养成人，如今三个女儿都出落得如花似玉，也算稍慰老身之心。可是最近几天不知怎么回事，三个女儿都愁眉不展，让老身忧心不已，唉。' },
    [4] = { 头像 = 0, 台词 = '哦，是这么回事，老夫人且不要忧愁，等我去问问三位小姐，看看他们究竟遇到了什么烦恼。' },
    --0
    [5] = { 头像 = 3050, 结束 = false, 台词 = '啊，你说什么？你可以帮我解决难题，真的吗？' },
    [6] = { 头像 = 0, 结束 = false, 台词 = '三小姐且先说说是什么疑难之事。' },
    [7] = { 头像 = 3050, 结束 = false, 台词 = '嗯，看你似乎也是有点修为之人，就告诉你吧，就是，就是，附近有个山贼，前几天找上门，居然说要纳我为妾。我不想答应，但是又怕那山贼难为我的家人。你…你能帮我吗？' },
    [8] = { 头像 = 0, 结束 = false, 台词 = '哼哼，我当什么事呢，原来就一个小小山贼，三小姐放心，我这就去帮你教训他，保管他再不敢来纠缠。' },
    [9] = { 头像 = 3050, 台词 = '…真的，太好了，你真是个大好人。' },
    --1
    [10] = { 头像 = 0, 结束 = false, 台词 = '喂，你就是那个要强娶四圣庄三小姐的山贼吗？' },
    [11] = { 头像 = 2045, 结束 = false, 台词 = '你这家伙是什么人？？敢来管我的事情。' },
    [12] = { 头像 = 0, 结束 = false, 台词 = '你别管我是什么人，识相的话，老老实实打消了这份念头，否则的话，可别怪我下手不留情。' },
    [13] = { 头像 = 2045, 结束 = false, 台词 = '就凭你，哼哼，胜得了我手中这口刀再说吧。' },
    [14] = { 头像 = 0, 结束 = false, 台词 = '啊…怎么突然…好重的妖气！！……这家伙不是一般人！！！' },
    --
    [15] = { 头像 = 0, 台词 = '可恶，这家伙竟然刀枪不入，怎么才能对付他呢。刚才的感觉，山林之气好重，难不成这家伙是个树妖山精？做来国似乎很多这类妖物，对，去找傲来的铁匠打听看看。' },
    --2
    [16] = { 头像 = 3113, 结束 = false, 台词 = '四圣庄？？你一定是遇到了那个千年老树精。' },
    [17] = { 头像 = 0, 结束 = false, 台词 = '千年树精？？' },
    [18] = { 头像 = 3113, 结束 = false, 台词 = '对，那是一棵千年古树，吸取日月精华，成了人形，他的树皮坚韧无比，寻常刀剑决不能伤。除非找北俱的沙铁匠，要到他那颗祖传的#R金铭石#W将你的兵器变成无上神兵，才有可能击败这个妖怪。' },
    [19] = { 头像 = 0, 台词 = '沙铁匠，嗯，上次帮他完成了观看玄天神鞭的心愿，借用一下金铭石，应该不是什么问题吧，我这就去找他。' },
    --3
    [20] = { 头像 = 3012, 结束 = false, 台词 = '金铭石，既然是恩人你要，当然没问题，只是…恩人你来晚了呀。' },
    [21] = { 头像 = 0, 结束 = false, 台词 = '来晚了？？怎么回事？？' },
    [22] = { 头像 = 3012, 结束 = false, 台词 = '金铭石…已经被五指山的老猴精抢走了……他说他要用金铭石打造无上神兵，我无力反抗，金铭石就被他抢走了。' },
    [23] = { 头像 = 0, 结束 = false, 台词 = '老猴精？这种小妖也敢放肆，你放心，我负责将金铭石给你夺回来。' },
    [24] = { 头像 = 3012, 台词 = '好，但金铭石在身，兵器将变为无上神兵，锐利无比，请恩人多加小心。' },
    --4
    [25] = { 头像 = 0, 台词 = '哼哼，有了这块金铭石，应该可以消灭那树妖了。' },
    --5
    [26] = { 头像 = 2045, 结束 = false, 台词 = '嗯？又是你，上此被教训得还不够吗？' },
    [27] = { 头像 = 0, 结束 = false, 台词 = '妖孽，你以为这次还能猖狂，看我破了你的妖术。' },
    [28] = { 头像 = 2045, 结束 = false, 台词 = '哈哈哈，我这千年树皮坚韧无比，你有什么办法可以对付我？？' },
    [29] = { 头像 = 0, 结束 = false, 台词 = '妖孽，你可知金铭石？' },
    [30] = { 头像 = 2045, 结束 = false, 台词 = '什么……你居然有金铭石，这…这下槽了…' },
    --6
    [31] = { 头像 = 3050, 结束 = false, 台词 = '啊！！你…你真的打败那个山贼了？？' },
    [32] = { 头像 = 0, 结束 = false, 台词 = '是，那其实不是普通山贼，而是得道的千年树妖，不过已经被我打败了，三小姐以后不必再为此烦恼了。' },
    [33] = { 头像 = 3050, 台词 = '…太好了，你真是我的大恩人。' },
    --7
    [34] = { 头像 = 0, 结束 = false, 台词 = '二小姐最近是否遇到什么烦心之事，可方便告之吗？' },
    [35] = { 头像 = 3050, 结束 = false, 台词 = '啊，你就是母亲款待的那个西行之人吗？是这样的，我有一件#R手镯#W，非常喜欢。但前段日子不小心将它失落了，后来听说在洛阳有人看到满堂春有这件手镯。我有心将它找回来，可是洛阳山高路远……' },
    [36] = { 头像 = 0, 台词 = '二小姐你放心，这事对我们修行之人来说不过是举手之劳，我去帮你找回来。' },
    --8
    [37] = { 头像 = 3082, 结束 = false, 台词 = '什么？你说这件手镯是四圣庄二小姐的？？哎呀，可…可这是我花一万两银子买来的呀，这么漂亮的手镯，难道就让我自接还回去吗？？这样吧，你拿一万两银子，我就把手镯转让给你，怎么样？？' },
    [38] = { 头像 = 0, 台词 = '……还真是不吃亏呀……' },
    --9
    [39] = { 头像 = 3050, 台词 = '啊，这就是我的手镯，你看你看，多漂亮啊。我还以为找不回来了呢，真是……太感谢你。' },
    --10
    [40] = { 头像 = 3050, 结束 = false, 台词 = '啊，你……你就是二妹，三妹说的那个修为高深之人？' },
    [41] = { 头像 = 0, 结束 = false, 台词 = '…大小姐的声音为什么……？？' },
    [42] = { 头像 = 3050, 结束 = false, 台词 = '唉，我也不知道为什么，前些日子得上这个怪病后，就一直如此了。上日梦到一位金甲神人对我说，我这病需得用傲来国圣殿内的#R九叶琼芝草#W才能治好。' },
    [43] = { 头像 = 0, 结束 = false, 台词 = '哦，傲来国呀，这容易，我片刻就能取来。' },
    [44] = { 头像 = 3050, 结束 = false, 台词 = '并不是那么容易，那位神人告知，要得这九叶琼芝草，需得经受两重考验。一者那圣殿被印所封，任你有通天彻地法力也无法打开，而且门口还有一位守禅僧长年守护，那守禅僧也是法力通天，难上加难。二者，这九叶琼芝草生长极为耗时，世人往往等不到成长为九叶之日……' },
    [45] = { 头像 = 0, 台词 = '这…大小姐放心，我既然答应了令堂，就一定帮你治好这病。' },
    --11
    [46] = { 头像 = 3047, 台词 = '阿弥陀佛，殿内保存看圣物，外人岂可轻易进入。' },
    --12
    [47] = { 头像 = 2023, 结束 = false, 台词 = '嘿嘿，我告诉你，我现在可是与天齐寿，与仙同级哟。' },
    [48] = { 头像 = 0, 结束 = false, 台词 = '嗯？这么得意，有什么好事吗？？' },
    [49] = { 头像 = 2023, 结束 = false, 台词 = '哼哼，你们凡夫俗子岂能知道傲来国九……啊哟，这种好事，不说！！不说！！！' },
    [50] = { 头像 = 0, 台词 = '看这家伙鬼鬼崇祟，一定有什么问题。咦，这人长得跟魔王寨的雷鸟精好象莫非…等等，我去问问看…' },
    --13
    [51] = { 头像 = 2023, 结束 = false, 台词 = '哎呀，竟然是无所不能的偶像啊，真……太荣幸了！！！' },
    [52] = { 头像 = 0, 结束 = false, 台词 = '这……（没有那么夸张吧）我来找你，是有事问你，那个…' },
    [53] = { 头像 = 2023, 结束 = false, 台词 = '傲来里的那家伙，啊哈，他是我的兄弟，既然老大有事找他，这事包在我身上。等我写书信一封，叫他尽力帮忙老大就是了。' },
    [54] = { 头像 = 0, 台词 = '呵呵，这样，那就多谢啦。' },
    --14
    [55] = { 头像 = 2023, 结束 = false, 台词 = '嗯，既然是我哥哥要我帮你，那就告诉你吧，前几日我从灵山偷出了一张如来佛谕，哈哈，想不到竟然可以靠那个东西进入做来的圣殿哟，喷啧，里面的九叶琼芝草可真不是吹的。听说那本是灵山圣物，但却需长在红尘之中，所以如来在傲来起圣殿一座供养此物，还用无上法力化成守禅信守护，想不到竟然被我享受到…真是太幸运了！！' },
    [56] = { 头像 = 0, 结束 = false, 台词 = '哈哈，这真是得未全不费工夫，那佛谕呢？' },
    [57] = { 头像 = 2023, 台词 = '既然你是我哥哥的崇拜对象，那就帮你一次，那，这就是佛谕，拿去吧。' },
    --15
    [58] = { 头像 = 3047, 台词 = '阿弥陀佛，既有如来佛谕，施主请进。' },
    [59] = { 头像 = 0, 台词 = '九叶琼芝草终于长出了九片叶子，快拿去给大小姐吧。' },
    --16
    [60] = { 头像 = 3050, 结束 = false, 台词 = '……这就是九叶琼芝草？？' },
    [61] = { 头像 = 0, 结束 = false, 台词 = '对，大小姐只要将它服下，就可以不药而愈。' },
    [62] = { 头像 = 3050, 结束 = false, 台词 = '这…这是真的吗？？啊，我…我的声音…真…真的好了，…恩人叫我怎么报答你呢？？' },
    [63] = { 头像 = 0, 台词 = '啊…那…那就不用啦。' },
    --17
    [64] = { 头像 = 3069, 结束 = false, 台词 = '真的吗？？老身的三个女儿真的都…恩人，叫老身怎么感谢你呢。这样吧老身愿将一女许与恩人为妻，将来恩人就继承老身这庄园田产，如何？？' },
    [65] = { 头像 = 0, 结束 = false, 台词 = '多谢老夫人美意，但我是修行之人，不敢受这些红尘之物，还望老夫人见谅。' },
    [66] = { 头像 = 3069, 结束 = false, 台词 = '呵呵，果然不错，看来老身没有看错你呀。' },
    [67] = { 头像 = 0, 结束 = false, 台词 = '嗯？？这是什么意思…啊，怎么突然如此仙气纵横，莫非…？？' },
    [68] = { 头像 = 3069, 结束 = false, 台词 = '不错，老身并非凡人，老身的三个女儿也皆是幻象，我等乃是黎山老母，观音姐姐，普贤菩萨，文殊菩萨，特来此四圣庄幻化人形，考验你西行修真之心。你果然不负我望，通过了考验，还望你多加磨砺，早成正果。' },
    [69] = { 头像 = 0, 台词 = '多谢菩萨，修真之心常世之中时有考验，不敢稍有懈怠。' },
    --18
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
    if not 玩家:剧情称谓是否存在(11) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '老妇人' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 4 then
                self.进度 = 1
            end
        end
    elseif NPC.名称 == '三小姐' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 9 then
                self.进度 = 2
            end
        elseif self.进度 == 7 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 33 then
                self.进度 = 8
            end
        end
    elseif NPC.名称 == '二小姐' then
        if self.进度 == 8 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 36 then
                self.进度 = 9
            end
        end
    elseif NPC.名称 == '大小姐' then
        if self.进度 == 12 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 45 then
                self.进度 = 13
            end
        elseif self.进度 == 19 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 63 then
                self.进度 = 20
            end
        end
    elseif NPC.名称 == '山贼' then
        if self.进度 == 2 then
            if self.对话进度 >= 14 then
                self.对话进度 = 10
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 14 then
                self:任务攻击事件(玩家, NPC)
            end
        elseif self.进度 == 6 then
            if self.对话进度 >= 30 then
                self.对话进度 = 26
            end
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 30 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    elseif NPC.名称 == '黄哥' then
        if self.进度 == 3 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 19 then
                self.进度 = 4
            end
        end
    elseif NPC.名称 == '沙铁匠' then
        if self.进度 == 4 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 24 then
                self.进度 = 5
            end
        end
    elseif NPC.名称 == '满堂春' then
        if self.进度 == 9 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 38 then
                self.进度 = 10
            end
        end
    elseif NPC.名称 == '守禅僧' then
        if self.进度 == 13 then
            self.进度 = 14
            self.对话进度 = 46
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        elseif self.进度 == 17 then
            self.对话进度 = 58
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            玩家:切换地图(1100, 31, 20)
        end
    elseif NPC.名称 == '雷鸟怪' then
        if self.进度 == 14 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 50 then
                self.进度 = 15
            end
        elseif self.进度 == 16 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 57 then
                local 添加物品 = 玩家:添加物品({ 生成物品 { 名称 = '佛谕', 数量 = 1, 禁止交易 = true } })
                if 添加物品 then
                    玩家:删除物品('雷鸟的书信', 1)
                    self.进度 = 17
                else
                    NPC.台词 = '你背包满了，清理一下再来找我'
                    self.对话进度 = self.对话进度 - 1
                end
            end
        end
    elseif NPC.名称 == '雷鸟' then
        if self.进度 == 15 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 54 then
                local 添加物品 = 玩家:添加物品({ 生成物品 { 名称 = '雷鸟的书信', 数量 = 1, 禁止交易 = true } })
                if 添加物品 then
                    self.进度 = 16
                else
                    NPC.台词 = '你背包满了，清理一下再来找我'
                    self.对话进度 = self.对话进度 - 1
                end
            end
        end
    elseif NPC.名称 == '琼芝草苗' then
        if self.进度 == 17 then
            local 添加物品 = 玩家:添加物品({ 生成物品 { 名称 = '九叶琼芝草', 数量 = 1, 禁止交易 = true } })
            if 添加物品 then
                玩家:删除物品('佛谕', 1)
                self.进度 = 18
                self.对话进度 = 59
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            end
        end
    elseif NPC.名称 == '老夫人' then
        if self.进度 == 20 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 69 then
                self:完成(玩家)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    玩家:添加声望(200)
    玩家:常规提示('#Y你完成取经任务又一关:四圣试禅心。你的望增加了200点。')
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 12, '老妇')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    NPC.队伍给予 = true
    if NPC.名称 == '满堂春' then
        if self.进度 == 10 then
            -- if cash and cash >= 10000 then --
            --     if 玩家:扣除银子(10000) then
            if items[1] and items[1].名称 == '天外飞石' then --你试试不还 没法试要做任务呢  那你有空在世吧e'b
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    local 添加物品 = 玩家:添加物品({ 生成物品 { 名称 = '手镯', 数量 = 1, 禁止交易 = true } })
                    if 添加物品 then
                        self.进度 = 11
                        NPC.台词 = '那好吧，给你手镯。'
                    else
                        NPC.台词 = '你背包满了，清理一下再来找我'
                    end
                end
            end
        end
    elseif NPC.名称 == '二小姐' then
        if self.进度 == 11 then
            if items[1] and items[1].名称 == '手镯' then
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.进度 = 12
                    self.对话进度 = 39
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                end
            end
        end
    elseif NPC.名称 == '大小姐' then
        if self.进度 == 18 then
            if items[1] and items[1].名称 == '九叶琼芝草' then
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.进度 = 19
                    self.对话进度 = 60
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                end
            end
        end
    end
end

function 任务:击杀山贼1(玩家)
    self.进度 = 3
    self.对话进度 = 15
end

function 任务:击杀老猴精(玩家)
    if 玩家:添加物品({ 生成物品 { 名称 = '金铭石', 数量 = 1, 禁止交易 = true } }) then
        self.进度 = 6
        self.对话进度 = 25
        玩家:添加经验(6300000)
        玩家:添加师贡(75000)
        玩家:常规提示('#Y你得到6300000点经验，75000两师贡和金铭石。')
    end
end

function 任务:击杀山贼2(玩家)
    self.进度 = 7
    玩家:添加经验(5073250)
    玩家:添加师贡(75000)
    玩家:删除物品('金铭石', 1)
    玩家:常规提示('#Y你得到5073250点经验，75000两师贡。')
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '山贼' then
        if self.进度 == 2 and self.对话进度 == 14 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓12_四圣戏禅心.lua', 1)
        elseif self.进度 == 6 and self.对话进度 == 30 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓12_四圣戏禅心.lua', 3)
        end
    elseif NPC.名称 == '老猴精' then
        if self.进度 == 5 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓12_四圣戏禅心.lua', 2)
        end
    end
end

local _怪物 = {
    {
        名称 = "山贼",
        等级 = 140,
        外形 = 2045,
        气血 = 90000000,
        魔法 = 12000,
        攻击 = 40000,
        速度 = 500,
        打算逃跑 = true, --杀不死
        是否消失 = false,
        抗性 = {
            物理吸收 = 1000,
            抗震慑 = 1000,
            抗雷 = 1000,
            抗火 = 1000,
            抗水 = 1000,
            抗风 = 1000,
            抗混乱 = 100,
            抗封印 = 80,
            抗昏睡 = 100,
        },
        技能 = {

        }
    },

    {
        名称 = "老猴精",
        等级 = 140,
        外形 = 2060,
        气血 = 1100000,
        魔法 = 12000,
        攻击 = 80000,
        速度 = 500,
        是否消失 = false,
        抗性 = {
            抗震慑 = 30,
            抗混乱 = 110,
            抗封印 = 80,
            抗昏睡 = 100,
            物理吸收 = 100,
            连击率 = 60,
            连击次数 = 3,
            反击率 = 60,
            反击次数 = 3,

        },
        技能 = {

        }
    },

    {
        名称 = "山贼",
        等级 = 140,
        外形 = 2045,
        气血 = 1000000,
        魔法 = 12000,
        攻击 = 40000,
        速度 = 500,
        是否消失 = false,
        抗性 = {
            抗震慑 = 30,
            抗混乱 = 100,
            抗封印 = 80,
            抗昏睡 = 100,
            物理吸收 = 50,


        },
        技能 = {

        }
    },
}
local _小怪 = {
    {
        名称 = "流氓",
        等级 = 140,
        外形 = 2046,
        气血 = 500000,
        魔法 = 12000,
        攻击 = 20000,
        速度 = 250,
        是否消失 = false,
        抗性 = {
            抗震慑 = 30,
            抗混乱 = 100,
            抗封印 = 80,
            抗昏睡 = 100,
            物理吸收 = 50,

        },
        技能 = {
            { 名称 = "雷神怒击", 熟练度 = 6000 },
            { 名称 = "谗言相加", 熟练度 = 6000 },

        }
    },
    {
        名称 = "女贼",
        等级 = 140,
        外形 = 2020,
        气血 = 500000,
        魔法 = 12000,
        攻击 = 20000,
        速度 = 250,
        是否消失 = false,
        抗性 = {
            抗震慑 = 30,
            抗混乱 = 100,
            抗封印 = 80,
            抗昏睡 = 100,
            物理吸收 = 50,

        },
        技能 = {

        }
    },

}

local _数量 = { 6, 0, 8 }

function 任务:战斗初始化(玩家, i)
    local r = 生成战斗怪物(_怪物[i])
    if r.打算逃跑 then
        r.打算逃跑回合 = 10
    end
    self:加入敌方(1, r)
    if i ~= 2 then
        for n = 1, _数量[i], 1 do
            r = 生成战斗怪物(_小怪[math.random(2)])
            self:加入敌方(n + 1, r)
        end
    end
end

function 任务:战斗回合开始(dt)
    local r = self:取对象(101)
    if r and r.打算逃跑 and r.打算逃跑回合 and self.回合数 > r.打算逃跑回合 then
        r:置指令('逃跑')
    end
end

function 任务:战斗结束(s)
    if s then
        local zg = self:取对象(101)
        for _, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("称谓12_四圣戏禅心")
                if r then
                    if zg then
                        if zg.名称 == "山贼" and r.进度 == 6 then
                            r:击杀山贼2(v.对象.接口)
                        elseif zg.名称 == "老猴精" and r.进度 == 5 then
                            r:击杀老猴精(v.对象.接口)
                        end
                    else
                        if r.进度 == 2 then
                            r:击杀山贼1(v.对象.接口)
                        end
                    end
                end
            end
        end
    end
end

return 任务
