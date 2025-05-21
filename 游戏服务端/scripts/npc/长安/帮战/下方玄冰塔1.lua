local NPC = {}

function NPC:NPC对话(玩家, i)
    if self._数据.耐久 <= 0 then
        return
    end
    if 玩家.帮派 == self.帮派.名称 then
        if self.攻击者 and self.攻击者.名称 then
            return ''..self.攻击者.名称..'正在进攻这座塔,你要攻击他吗？\nmenu\n为了帮派冲呀\n我去干点别的'
        elseif self.守护者 and self.守护者.nid then
            if self.守护者.nid == 玩家.nid then
                return '这座塔目前还剩余'..self._数据.耐久..'耐久\nmenu\n我有事要离开一下\n继续点亮'
            elseif self.攻击者.名称 then
                return ''..self.攻击者.名称..'正在操作这座塔'
            end
        else
            return '这座塔剩余耐久'..self._数据.耐久..',你要点亮它吗？\nmenu\n是的没错\n我去干点别的'
        end
    else
        if self.守护者 and self.守护者.名称 then
            return ''..self.守护者.名称..'正在操作这座塔,你要打断他吗？\nmenu\n必须打断\n我去干点别的'
        elseif self.攻击者 and self.攻击者.nid then
            if self.攻击者.nid == 玩家.nid then
                return '这座塔目前还剩余'..self._数据.耐久..'耐久\nmenu\n我去破坏点别的\n我去干点别的'
            elseif self.攻击者.名称 then
                return ''..self.攻击者.名称..'正在进攻这座塔'
            end
        else
            return '这座塔剩余耐久'..self._数据.耐久..',你要攻击它吗？\nmenu\n必须打它\n我去干点别的'
        end
    end
end

function NPC:NPC菜单(玩家, i)
    if i == '为了帮派冲呀' then
        玩家:帮战间接战斗(self.攻击者.nid)
        玩家:设置取消攻击塔(self.攻击者.nid)
        self.攻击者 = {}
        self.守护者 = {}
    elseif i == '我有事要离开一下' then
        玩家:设置取消操作冰塔(self.守护者.nid)
        玩家:点亮冰塔(self.nid , false)
        self.守护者 = {}
    elseif i == '是的没错' then
        if 玩家:点亮冰塔(self.nid , true) then
            self.守护者 = {名称 = 玩家.名称 , nid = 玩家.nid}
            玩家:设置操作冰塔(self.守护者.nid)
        end
    elseif i == '必须打断' then
        玩家:帮战间接战斗(self.守护者.nid)
        玩家:设置取消操作冰塔(self.守护者.nid)
        self.攻击者 = {}
        self.守护者 = {}
        玩家:点亮冰塔(self.nid , false)
    elseif i == '我去破坏点别的' then
        玩家:设置取消攻击塔(self.攻击者.nid)
        self.攻击者 = {}
    elseif i == '必须打它' then
        self.攻击者 = {名称 = 玩家.名称 , nid = 玩家.nid}
        玩家:设置攻击塔(self.攻击者.nid, self.nid)
    end
end

function NPC:破坏(玩家)
    if self.守护者.nid then
        玩家:设置取消操作冰塔(self.守护者.nid)
    end
    if self.攻击者.nid then
        玩家:设置取消攻击塔(self.攻击者.nid)
    end
    self.攻击者 = {}
    self.守护者 = {}
end

return NPC