local NPC = {}
local 对话 = [[
我是威武无敌的龙神大炮,只要给我20秒钟时间点燃引线,我能帮你轰掉对方城门180点体力。
menu
燃烧吧龙神大炮
我来参观的
]]

function NPC:NPC对话(玩家, i)
    if not 玩家.是否组队 or not 玩家.是否队长 then
        return "请组队且由队长进行操控"
    elseif 玩家:取队伍人数() < 3 then
        return "最少三人组队才可以操控大炮"
    end
    if self._数据.操控者 and self._数据.操控者 ~= '' then
        return 玩家:操控提示(self._数据.操控者)
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if not 玩家.是否组队 or not 玩家.是否队长 then
        return "请组队且由队长进行操控"
    elseif 玩家:取队伍人数() < 3 then
        return "最少三人组队才可以操控大炮"
    end
    if i == '燃烧吧龙神大炮' then
        if self._数据.操控者 and self._数据.操控者 ~= '' then
            return 玩家:操控提示(self._数据.操控者)
        end
        玩家:操控龙神大炮(self.nid)
        self._数据.操控者 = 玩家.nid
    elseif i == '掐灭它(进入战斗)' then
        玩家:还原龙神大炮(self.nid , self._数据.操控者)
        玩家:帮战间接战斗(self._数据.操控者)
        self._数据.操控者 = ''
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC