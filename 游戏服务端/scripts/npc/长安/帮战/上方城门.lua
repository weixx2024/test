local NPC = {}
local 对话 = [[
我是威武无敌的龙神大炮,只要给我20秒钟时间点燃引线,我能帮你轰掉对方城门180点体力。
menu
燃烧吧龙神大炮
我来参观的
]]
--
function NPC:NPC对话(玩家, i)
    local 耐久 = self.帮派.帮战信息.显示信息.耐久
    if 耐久 <= 0 then
        return
    end
    if 玩家.是否组队 then
        for _, v in 玩家:遍历队伍() do
            if v.复活标记 and v.复活标记 - os.time() <= 0 then
                v.复活标记 = nil
            end
            if v.复活标记 then
                local 剩余时间 = v.复活标记 - os.time()
                玩家:常规提示('#G' .. v.名称 .. '#Y刚刚复活,还需要#R' .. 剩余时间 .. '#Y秒才可以出城')
                return
            end
        end
    else
        if 玩家.复活标记 and 玩家.复活标记 - os.time() <= 0 then
            玩家.复活标记 = nil
        end
        if 玩家.复活标记 then
            local 剩余时间 = 玩家.复活标记 - os.time()
            玩家:常规提示('#Y你刚刚复活,还需要#R' .. 剩余时间 .. '#Y秒才可以出城')
            return
        end
    end

    if 玩家.帮派 == self.帮派.名称 then
        if self.攻击者 and self.攻击者.名称 then
            return '' .. self.攻击者.名称 .. '正在进攻城门,你要攻击他吗？\nmenu\n为了帮派冲呀\n我去干点别的'
        else
            return '城门剩余耐久' .. 耐久 .. ''
        end
    else
        if self.攻击者 and self.攻击者.nid then
            if self.攻击者.nid == 玩家.nid then
                return '城门剩余' .. 耐久 .. '耐久\nmenu\n我去破坏点别的\n我去干点别的'
            elseif self.攻击者.名称 then
                return '' .. self.攻击者.名称 .. '正在进攻城门'
            end
        else
            return '城门剩余耐久' .. 耐久 .. ',你要攻击它吗？\nmenu\n必须打它\n我去干点别的'
        end
    end
end

function NPC:NPC菜单(玩家, i)
    if i == '为了帮派冲呀' then
        玩家:帮战间接战斗(self.攻击者.nid)
        玩家:设置取消攻击城门(self.攻击者.nid)
        self.攻击者 = {}
    elseif i == '我去破坏点别的' then
        玩家:设置取消攻击城门(self.攻击者.nid)
        self.攻击者 = {}
    elseif i == '必须打它' then
        self.攻击者 = { 名称 = 玩家.名称, nid = 玩家.nid }
        玩家:设置攻击城门(self.攻击者.nid, self.nid)
    elseif i == '4' then
    end
end

return NPC
