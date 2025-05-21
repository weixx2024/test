local 角色 = require('角色')

--================================================================

function 角色:机器人_更新(sec)
    if self.是否机器人 and not self.是否战斗 then
        -- 10分钟活跃时间，否则下线机器人
        if self.活跃时间 + 600 < sec then
            self:下线()
            return
        end
        if self.是否队长 then
            self:角色_解散队伍()
            return
        end
        if not self.是否组队 then
            self:下线()
            return
        end
    end
end

function 角色:添加机器人(功能, 种族)
    local 机器人 = __沙盒.生成机器人(功能, {
        种族 = 种族, 地图 = self.地图, x = self.x, y = self.y
    })
    self:队伍_添加机器人(机器人)
end

function 角色:招募机器人(功能, 种族)
    if not self.是否队长 then
        self.rpc:提示窗口('#Y你不是队长')
        return
    end
    if self.接口:取队伍人数() >= 5 then
        self.rpc:提示窗口('#Y你的队伍已经满了')
        return
    end
    if 功能 == '抓鬼' then
        self:添加机器人(功能, 种族)
    end
    if 功能 == '做天' then
        self:添加机器人(功能, 种族)
    end
    if 功能 == '鬼王' then
        self:添加机器人(功能, 种族)
    end
    if 功能 == '修罗' then
        self:添加机器人(功能, 种族)
    end
end

--================================================================
function 角色:添加机器人new(种族, 性别, 外形, 技能)
    local 机器人 = __沙盒.生成机器人new({
        转生 = self.转生,
        等级 = self.等级,
        种族 = 种族,
        性别 = 性别,
        外形 = 外形,
        技能 = 技能,
        地图 = self.地图,
        x = self.x,
        y = self.y
    })
    self:队伍_添加机器人(机器人)
end

function 角色:角色_招募机器人(种族, 性别, 外形, 技能)
    if not self.是否队长 then
        self.rpc:提示窗口('#Y你不是队长')
        return
    end
    if self.接口:取队伍人数() >= 5 then
        self.rpc:提示窗口('#Y你的队伍已经满了')
        return
    end
    local map = self.接口:取当前地图()
    if map and map.名称 == "龙神比武场" then
        self.rpc:提示窗口('#Y该地图无法召唤助战')
        return
    end

    self:添加机器人new(种族, 性别, 外形, 技能)
end

function 角色:角色_打开机器人窗口()
    local list = __脚本['scripts/robot/机器人.lua'].召唤机器人列表
    return list
end
