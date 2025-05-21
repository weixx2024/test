local 角色 = require('角色')
function 角色:角色_自动任务_进入战斗(任务)
    local r = self:任务_获取(任务)
    if r then
        if 任务 == "日常_天庭任务" then
            r:任务NPC菜单(self.接口, r.自动, "1")
        else
            local P = self.周围[r.NPC]
            if P and ggetype(P) == '地图NPC' then
                r.接口:任务攻击事件(self.接口, P)
            end
        end
    end
end

function 角色:角色_自动任务_天庭自动(x, y)
    local r = self:任务_获取("日常_天庭任务")
    if r then
        local 名称
        if x == 180 and y == 10 then
            名称 = "万年熊王"
        elseif x == 10 and y == 100 then
            名称 = "三头妖王"
        elseif x == 180 and y == 100 then
            名称 = "蓝色妖王"
        elseif x == 150 and y == 150 then
            名称 = "黑山妖王"
        end
        if r[名称] and r[名称] ~= 1 then
            r.自动 = { 名称 = 名称 }
        end
    end
end

function 角色:角色_自动任务_添加任务(任务)
    if 任务 == "日常_抓鬼任务" then
        self:自动任务_小鬼(self.接口)
    elseif 任务 == "日常_天庭任务" then
        self:自动任务_天庭(self.接口)
    elseif 任务 == "日常_鬼王任务" then
        self:自动任务_鬼王(self.接口)
    elseif 任务 == "日常_修罗任务" then
        self:自动任务_修罗(self.接口)
    elseif 任务 == "日常_降魔任务" then
        self:自动任务_降魔(self.接口)    
    end
end

function 角色:自动任务_小鬼(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end

    -- if 玩家:取队伍人数() < 3 then
    --     玩家:常规提示('#Y需要3个人以上的组队来帮我！')
    --     return
    -- end
    local t = {}
    -- for _, v in 玩家:遍历队伍() do
    --     if v:判断等级是否低于(30) then
    --         table.insert(t, v.名称)
    --     end
    -- end
    -- if #t > 0 then
    --     玩家.接口:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于30级,无法领取')
    --     return
    -- end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_抓鬼任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家.接口:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end

    local r = __沙盒.生成任务 { 名称 = '日常_抓鬼任务' }

    if r and r:生成怪物(玩家) then
        local ff = string.format('各位且去#Y%s#W找到#G#u%s#W#u,降服超度它吧。', r.位置, r.怪名)
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, 3039)
        end
        return ff
    end
end

function 角色:自动任务_天庭(玩家)
    local r = __沙盒.生成任务 { 名称 = '日常_天庭任务' }
    if r and r:添加任务(玩家) then
        local ff = '快去御马监降服妖魔吧'
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, 2294)
        end
    end
end


local _任务对话 = {
    [1] = "三藏一行前往宝象，途径黑松林，却见南方一座宝塔，金光闪烁，彩气腾腾。三藏破门而入，却是误闯了黄袍怪老巢，正是“蛇头上苍蝇，自来的衣食”。走起~我宝象义士速去营救！",
    [2] = "宝象国真个好去处，看不尽那国中景致！唐僧师徒三众特去面驾，倒换文牒。八戒于殿前表演了大神通之法，更扬言往平顶山捉妖去也！我宝象国义士，还不前往助一臂之力？！",
    [3] = "失踪一十三年的公主？化作斑斓猛虎的高僧？凭空而降的驸马爷？银安殿宫娥失头案？……宝象国迷情重重，委实蹊跷，还望义士前往探听究竟。",
    [4] = "听说那孙大圣三打白骨精后遭师父驱逐，索性按落云头重回了傲来国，正是“重修花果山，复整水帘洞”。眼下三藏一行危机重重，他却哪里管得？义士速去告知大圣爷详情，邀其前来宝象，除妖伏魔！",
    [5] = "那黄袍怪神通广大，万不可轻敌。且听从大圣妙计，环环紧扣，各个击破，方能挫敌。",
    [6] = "那黄袍怪穷途现形，原是天庭奎木狼，与披香殿侍香玉女思凡下界，方有此间种种。决战在睫，义士们，请速去打败奎木狼！",
}
function 角色:自动任务_降魔(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    if 玩家:取队伍人数() < 1 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end

    local t = {}
    -- for _, v in 玩家:遍历队伍() do
    --     if v:判断等级是否低于(143, 3) then
    --         table.insert(t, v.名称)
    --     end
    -- end
    -- if #t > 0 then
    --     玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于3转143级,无法领取')
    --     return
    -- end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_降魔任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end

    local 分类 = math.random(6)

    local r = __沙盒.生成任务 { 名称 = '日常_降魔任务', 分类 = 分类, 进度 = 1 }
    if r and r:生成怪物(玩家) then
        local ff = _任务对话[分类]
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, 6552)
        end
    end
end

function 角色:自动任务_鬼王(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    if 玩家:取队伍人数() < 3 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end

    local t = {}

    for _, v in 玩家:遍历队伍() do
        if v:判断等级是否低于(90) then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于90级,无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        if not v:剧情称谓是否存在(10) then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '没有完成十称，无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_鬼王任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end

    local r = __沙盒.生成任务 { 名称 = '日常_鬼王任务' }

    if r and r:生成怪物(玩家) then
        local ff = string.format(
            '从地府逃出去的#G#u%s#W#u由于长时间没有被超度，现今在#Y%s#W吸取阴气化为鬼王，为免其危害人间，我已下令招募三界有志之士前往捉拿，成功者重重有赏！这事情就有劳阁下了！'
            , r.怪名:gsub('王', ''), r.位置)
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, 2075)
        end
        return ff
    end
end

function 角色:自动任务_修罗(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    if 玩家:取队伍人数() < 3 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end

    local t = {}
    for _, v in 玩家:遍历队伍() do
        if v:判断等级是否低于(110) then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于110级,无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_修罗任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end

    local r = __沙盒.生成任务 { 名称 = '日常_修罗任务' }

    if r and r:生成怪物(玩家) then
        local ff = string.format('请速去#Y%s#W#处消灭#G#u%s#u#W，阻止他为非作歹。！', r.位置, r.怪名)
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, 2023)
        end
    end
end

function 角色:角色_自动任务_地图跳转(mid, x, y, 任务)
    self.接口:切换地图(mid, x, y)
    if 任务 then
        local t = self:物品_获取(任务)
        if t then
            t:删除()
        end
    end
end
