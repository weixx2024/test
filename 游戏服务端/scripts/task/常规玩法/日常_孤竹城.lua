-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2024-08-30 18:50:40

local 任务 = {
    名称 = '日常_孤竹城',
    别名 = '孤竹城',
    类型 = '副本任务'
}


function 任务:任务初始化()
    self.进度 = 1
end

local _描述 = {
    '#G#u#[101595|65|52|$生苦#]#u,#G#u#[101595|134|69|$老苦#]#u,#G#u#[101595|62|115|$病苦#]#u,#G#u#[101595|31|69|$死苦#]#u,#G#u#[101595|158|114|$求不得苦#]#u,#G#u#[101595|208|70|$爱离别苦#]#u,#G#u#[101595|138|28|$五阴炽盛苦#]#u,#G#u#[101595|188|21|$怨憎会苦#]#u,',
}


function 任务:任务取详情(玩家)
    if _描述[self.进度] then
        return string.format('孤竹城有八苦，画师将其封存于壁画。画中人生生世世，永堕这世间苦。请按顺序去挑战。#r#r%s#r#r#Y温馨提示：#r#W完成8轮挑战后可以前往%s#W领取最终奖励！', _描述[self.进度],"#G#u#[101595|105|58|$宝箱#]#u") --：#r#r%s#r#r#Y温馨提示：#r#W爱离别苦为特殊玩法官咖，可以消耗银两跳过：#r五阴炽盛苦与怨憎会苦关卡为可以选择高难度调整，奖励更加丰厚
    end
    return "无"
end

function 任务:任务取消(玩家)

end

function 任务:任务更新(sec, 玩家)
    if sec > self.时间 then
        local map = 玩家:取地图(self.MAP)
        if map then
            local NPC = map:取NPC(self.NPC)
            if NPC then
                NPC:删除()
            end
        end
        self:删除()
    end
end

function 任务:任务上线(玩家)


end

function 任务:任务下线(玩家)

end

function 任务:添加任务(玩家)
    if not 玩家.是否组队 then
        return '需要3个人以上的组队来帮我'
    end
    if 玩家:取队伍人数() < 3 then
        return '需要3个人以上的组队来帮我'
    end
    local t = {}
    for _, v in 玩家:遍历队伍() do
        if v:判断等级是否低于(69) then --or not v:剧情称谓是否存在(8)
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        return table.concat(t, '、 ') .. '#W低于70级,无法领取'
    end
    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_孤竹城') then
            table.insert(t, v.名称)
        end
    end

    if #t > 0 then
        return table.concat(t, '、 ') .. '已有此任务,无法重复领取'
    end

    for _, v in 玩家:遍历队伍() do
        if v:取活动限制次数('孤竹城') >= 2 then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        return table.concat(t, '、 ') .. '今日已经完成过2次这个任务了'
    end
    self.时间 = os.time() + 1800
    self.进度 = 1
    self.队伍 = {}
    self.评分 = {}
    for k, v in 玩家:遍历队伍() do
        v:添加任务(self)
        v:增加活动限制次数('孤竹城')
    end
    return true
end

function 任务:取评分(关卡)
    return self.评分[关卡] and "该关卡当前评分："..self.评分[关卡] or "你还未通关过该关卡"
end

function 任务:是否完成(玩家)
    -- for i=1,8 do
    --     if not self.评分[i] then
    --         return "你还未通关第"..i.."关卡"
    --     end
    -- end
    local nid = 玩家:取任务('日常_孤竹城').nid
    for _, v in 玩家:遍历队伍() do
        local r = v:取任务('日常_孤竹城')
        if  r and r.nid == nid then
            r:掉落包(v,"宝箱")
            r:删除()
        end
    end
    return true
end

function 任务:完成关卡(玩家,关卡,进入时间)
    if 玩家:取任务('日常_孤竹城') then
        if not self.评分[关卡] then
            for _, v in 玩家:遍历队伍() do
                if v:取任务('日常_孤竹城') and v:取任务('日常_孤竹城').nid == 玩家:取任务('日常_孤竹城').nid then
                    self:掉落包(v,关卡)
                end
            end
        end
        self.评分[关卡] = os.time() - 进入时间
    end
end

local _广播 = '#R%s#c00FFFF在孤竹城内表现优异,特获赠珍稀宝盒。打开一看,盒子里装的竟是#G#m(%s)[%s]#m#n#c00FFFF一个，发财啦!#93'

function 任务:掉落包(玩家,关卡)
    local 经验 = 661024
    玩家:添加经验(经验)
    玩家:添加参战召唤兽经验(经验 * 1.5)
    local 掉落包 = 取掉落包('活动', '孤竹城')
    if 掉落包 and 掉落包[关卡] then
        奖励掉落包物品(玩家, 掉落包[关卡], _广播)
    end
end

return 任务
