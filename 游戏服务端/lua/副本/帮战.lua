local 帮战 = class('帮战')
local function _get(name)
    local 脚本 = __脚本['scripts/copy/帮战.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
    return nil
end

local _报名时间 = {
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
}

function 帮战:初始化(t)
    self.脚本 = 'scripts/copy/帮战.lua'
    self.报名数据 = __redis:获取数据('帮战报名')
    self.匹配数据 = {}
    self.高手挑战 = {}
    self._定时 = nil
    self.分钟 = os.date("%M", os.time())
    self.小时 = os.date("%H", os.time())
    self.星期 = os.date('%w', os.time())
    if _报名时间[self.星期] then
        if self.星期 == "5" then
            if self.小时 + 0 <= 19 and self.分钟 + 0 < 30 then
                self:开启报名()
            end
        else
            self:开启报名()
        end
    end
end

function 帮战:存档()
    __redis:存档数据('帮战报名', self.报名数据)
end

function 帮战:__index(k)
    local 脚本 = rawget(self, '脚本')
    if 脚本 then
        local r = _get(k)
        if r ~= nil then
            return r
        end
    end
end

function 帮战:__newindex(k, v)
    rawset(self, k, v)
end

local _开启时间 = {
    ["1"] = false,
    ["2"] = false,
    ["3"] = false,
    ["4"] = false,
    ["5"] = false,
    ["6"] = false,
    ["0"] = false,
}

-- 19:30 开启进场、关闭报名、初始化匹配、禁止开打
-- 20:00 开启第一轮帮战、关闭进场、关闭报名、开始开打
-- 21:00 结束第一轮，开启进场、关闭报名、初始化匹配、禁止开打
-- 21:30 开启第二轮帮战、关闭进场、关闭报名、开始开打
-- 22.30 结束第二轮，关闭进场、开启报名

function 帮战:整分处理(sec)
    self.分钟 = os.date("%M", sec)
    if _开启时间[self.星期] then
        if self.分钟 == "30" then
            if self.小时 == "19" then
                self:开启进场()
            elseif self.小时 == "21" then
                self:开启帮战()
            elseif self.小时 == "22" then
                self:关闭帮战()
            end
        end
    end
end

function 帮战:整点处理(sec)
    self.小时 = os.date("%H", sec)
    if self.星期 ~= os.date('%w', sec) then
        self.星期 = os.date('%w', sec)
    end
    if _开启时间[self.星期] then
        if self.小时 == "00" then
            if self.星期 == "1" then
                self:清空报名数据()
                self:开启报名()
            end
        elseif self.小时 == "20" then
            self:开启帮战()
        elseif self.小时 == "21" then
            self:关闭帮战()
            self:开启进场()
        end
    end
end

function 帮战:初始化匹配()
    local list = {}
    for k, v in pairs(self.报名数据) do
        table.insert(list, { 名称 = k, })
    end

    if #list == 0 then
        __世界:发送系统('#R由于报名帮战数量不足2，本日帮战活动取消！')
        return
    end

    if #list == 1 then
        __世界:发送系统('#R由于报名帮战数量不足2，本日帮战活动取消！')
        self:结束活动()
        return
    end

    local 对战组 = {}
    local 对战双方 = {}
    for i, v in ipairs(list) do
        table.insert(对战双方, v.名称)
        if i % 2 == 0 then
            table.insert(对战组, 对战双方)
            对战双方 = {}
        end
    end
    self.匹配数据 = 对战组
    __世界:发送系统('#R本日对战帮派如下:')
    for i = 1, #self.匹配数据 do
        __世界:发送系统('#R' .. self.匹配数据[i][1] .. ' VS ' .. self.匹配数据[i][2] .. '')
    end
    for i = 1, #self.匹配数据 do
        local 帮战地图 = __沙盒.生成地图(101392)
        self:创建帮战NPC(帮战地图, __帮派[self.匹配数据[i][1]], __帮派[self.匹配数据[i][2]])
        local 临时帮派 = self.匹配数据[i]
        for n = 1, #临时帮派 do
            __帮派[临时帮派[n]].帮战信息 = {
                结束 = false,
                帮战地图 = 帮战地图,
                大本营 = n,
                显示信息 = {
                    名称 = 临时帮派[n],
                    耐久 = 6000,
                    帮派目前参战成员 = 0,
                    帮派成员胜利场次 = 0,
                    高手挑战胜利场次 = 0,
                    能量塔发动攻击数 = 0,
                    龙神大炮开炮次数 = 0,
                    本帮杀敌最高成员 = '',
                    本人杀敌 = 0,
                    胜场统计 = {},
                    连胜记录 = {},
                    个人杀敌 = {}
                }
            }
            if n == 1 then
                __帮派[临时帮派[n]].帮战信息.敌对帮派 = 临时帮派[2]
            else
                __帮派[临时帮派[n]].帮战信息.敌对帮派 = 临时帮派[1]
            end
        end
    end
end

function 帮战:创建帮战NPC(帮战地图, 帮派1, 帮派2)
    帮战地图.是否帮战 = true
    帮战地图.是否副本 = true
    --公共NPC
    帮战地图:添加NPC {
        名称 = "龙神大炮",
        外形 = 90002,
        脚本 = 'scripts/npc/长安/帮战/龙神大炮.lua',
        操控者 = '',
        X = 15,
        Y = 78
    }
    帮战地图:添加NPC { --下方营地外传送人
        名称 = "帮战传送人",
        外形 = 3038,
        脚本 = 'scripts/npc/长安/帮战/通用战场传送.lua',
        方向 = 0,
        X = 17,
        Y = 29
    }
    帮战地图:添加NPC { --上方营地外传送人
        名称 = "帮战传送人",
        外形 = 3038,
        脚本 = 'scripts/npc/长安/帮战/通用战场传送.lua',
        方向 = 2,
        X = 99,
        Y = 69
    }
    帮战地图:添加NPC { --挑战区传送人
        名称 = "帮战传送人",
        外形 = 3038,
        脚本 = 'scripts/npc/长安/帮战/通用战场传送.lua',
        方向 = 2,
        X = 109,
        Y = 14
    }


    --下方NPC
    帮战地图:添加NPC { --下方营地内传送人
        名称 = "帮战传送人",
        外形 = 3038,
        脚本 = 'scripts/npc/长安/帮战/下方大本营传送.lua',
        方向 = 1,
        X = 5,
        Y = 8,
        帮派 = 帮派1
    }
    帮战地图:添加NPC {
        名称 = "城门",
        外形 = 90004,
        脚本 = 'scripts/npc/长安/帮战/下方城门.lua',
        攻击者 = {},
        X = 17.5,
        Y = 16,
        帮派 = 帮派1
    }
    帮战地图:添加NPC {
        名称 = "烈火塔",
        外形 = 90003,
        脚本 = 'scripts/npc/长安/帮战/下方烈火塔1.lua',
        耐久 = 500,
        攻击者 = {},
        守护者 = {},
        X = 27.5,
        Y = 34.5,
        帮派 = 帮派1
    }
    帮战地图:添加NPC {
        名称 = "烈火塔",
        外形 = 90003,
        脚本 = 'scripts/npc/长安/帮战/下方烈火塔2.lua',
        耐久 = 500,
        攻击者 = {},
        守护者 = {},
        X = 44,
        Y = 24.5,
        帮派 = 帮派1
    }
    帮战地图:添加NPC {
        名称 = "玄冰塔",
        外形 = 90003,
        脚本 = 'scripts/npc/长安/帮战/下方玄冰塔1.lua',
        耐久 = 500,
        攻击者 = {},
        守护者 = {},
        X = 42,
        Y = 40,
        帮派 = 帮派1
    }
    帮战地图:添加NPC {
        名称 = "玄冰塔",
        外形 = 90003,
        脚本 = 'scripts/npc/长安/帮战/下方玄冰塔2.lua',
        耐久 = 500,
        攻击者 = {},
        守护者 = {},
        X = 56,
        Y = 31.5,
        帮派 = 帮派1
    }
    -- 帮战地图:添加NPC { --挑战区传送人
    --     名称 = "明鑫",
    --     称谓 = '挑战公证人'
    --     外形 = 3038,
    --     脚本 = 'scripts/npc/长安/帮战/挑战公证人.lua',
    --     方向 = 2,
    --     X = 119,
    --     Y = 8
    -- }

    --上方NPC
    帮战地图:添加NPC {
        名称 = "帮战传送人",
        外形 = 3038,
        脚本 = 'scripts/npc/长安/帮战/上方大本营传送.lua',
        方向 = 2,
        X = 110,
        Y = 77,
        帮派 = 帮派2
    }

    帮战地图:添加NPC {
        名称 = "城门",
        外形 = 90004,
        脚本 = 'scripts/npc/长安/帮战/上方城门.lua',
        攻击者 = {},
        X = 107.5,
        Y = 67,
        帮派 = 帮派2
    }
    帮战地图:添加NPC {
        名称 = "烈火塔",
        外形 = 90003,
        脚本 = 'scripts/npc/长安/帮战/上方烈火塔1.lua',
        耐久 = 500,
        攻击者 = {},
        守护者 = {},
        X = 85,
        Y = 63,
        帮派 = 帮派2
    }
    帮战地图:添加NPC {
        名称 = "烈火塔",
        外形 = 90003,
        脚本 = 'scripts/npc/长安/帮战/上方烈火塔2.lua',
        耐久 = 500,
        攻击者 = {},
        守护者 = {},
        X = 100,
        Y = 54.5,
        帮派 = 帮派2
    }
    帮战地图:添加NPC {
        名称 = "玄冰塔",
        外形 = 90003,
        脚本 = 'scripts/npc/长安/帮战/上方玄冰塔1.lua',
        耐久 = 500,
        攻击者 = {},
        守护者 = {},
        X = 73.5,
        Y = 56.5,
        帮派 = 帮派2
    }
    帮战地图:添加NPC {
        名称 = "玄冰塔",
        外形 = 90003,
        脚本 = 'scripts/npc/长安/帮战/上方玄冰塔2.lua',
        耐久 = 500,
        攻击者 = {},
        守护者 = {},
        X = 88,
        Y = 48,
        帮派 = 帮派2
    }
end

function 帮战:清空报名数据()
    self.报名数据 = {}
end

function 帮战:查看报名数据()

end

function 帮战:开启报名()
    self.报名开关 = true
    self.进场开关 = false
    self.战斗开关 = false
    __世界:发送系统("#Y帮战报名已经开启")
end

function 帮战:开启进场()
    self:初始化匹配()
    self.报名开关 = false
    self.进场开关 = true
    self.战斗开关 = false
    __世界:发送系统("#Y帮战进场已经开启")
end

function 帮战:开启帮战()
    self.报名开关 = false
    self.进场开关 = false
    self.战斗开关 = true
    self._定时 = __世界:定时(
        1000,
        function(ms)
            for i = 1, #self.匹配数据 do
                local 帮派1, 帮派2 = self.匹配数据[i][1], self.匹配数据[i][2]
                if self.高手挑战[帮派1] and self.高手挑战[帮派1][1] and self.高手挑战[帮派2] and self.高手挑战[帮派2][1] then
                    local nid = self.高手挑战[帮派1][1]
                    local 玩家1 = __玩家[nid]
                    if not 玩家1 then
                        table.remove(self.高手挑战[帮派1],1)
                    end

                    local dnid = self.高手挑战[帮派2][1]
                    local 玩家2 = __玩家[dnid]
                    if not 玩家2 then
                        table.remove(self.高手挑战[帮派2],1)
                    end
                    if 玩家1 and 玩家2 then
                        table.remove(self.高手挑战[帮派2],1)
                        table.remove(self.高手挑战[帮派1],1)
                        玩家1:帮战进入挑战(dnid)
                    end
                end
            end
            return ms
        end
    )
    __世界:发送系统("#Y帮战已经开启，各位玩家尽情的厮杀吧！")
end

function 帮战:关闭帮战()
    self.报名开关 = false
    self.进场开关 = false
    self.战斗开关 = false
    self:清空报名数据()
    self:结束活动()
end

function 帮战:结束活动()
    self.高手挑战 = {}
    if self._定时 then
        self._定时:删除()
    end
    for i = 1, #self.匹配数据 do
        local 帮派1, 帮派2 = self.匹配数据[i][1], self.匹配数据[i][2]
        if __帮派[帮派1].帮战信息.结束 == false then
            __帮派[帮派1].帮战信息.结束 = true
            __帮派[帮派2].帮战信息.结束 = true
            local 胜利, 失败 = 帮派1, 帮派2
            if __帮派[帮派1].帮战信息.显示信息.耐久 > __帮派[帮派2].帮战信息.显示信息.耐久 then
                胜利, 失败 = 帮派1, 帮派2
            elseif __帮派[帮派1].帮战信息.显示信息.耐久 < __帮派[帮派2].帮战信息.显示信息.耐久 then
                胜利, 失败 = 帮派2, 帮派1
            else --平局随机胜方
                local 胜利, 失败 = 帮派1, 帮派2
                if math.random(1, 100) <= 50 then
                    胜利, 失败 = 帮派2, 帮派1
                end
            end
            self:帮战结算(__帮派[胜利], __帮派[失败])
        end
    end
end

function 帮战:帮战结算(胜, 负) --且只有队长有积分目前 改成队员也有积分  这个没问题啊 他跟对战无关，他给的是 所有在线的帮众可以 你现在就是这样的
    if 负 then
        for k, v in pairs(负.成员列表) do --
            if __玩家[k] then
                __帮战:失败奖励(__玩家[k].接口)
                __玩家[k].接口:常规提示('#Y帮战已结束,你们输了')
                __玩家[k].接口:龙神帮战退场()
            end
        end
    end
    if 胜 then
        for k, v in pairs(胜.成员列表) do 
            if __玩家[k] then
                __帮战:胜利奖励(__玩家[k].接口)
                __玩家[k].接口:常规提示('#Y帮战已结束,你们赢了')
                __玩家[k].接口:龙神帮战退场()
            end
        end
    end
    __世界:发送系统('#R' .. 胜.名称 .. '战胜了' .. 负.名称 .. '')
    胜.帮战信息 = {}
    负.帮战信息 = {}
end

function 帮战:帮派报名(name)
    self.报名数据[name] = true
end

function 帮战:能否报名()
    return self.报名开关
end

function 帮战:是否已报名(name)
    return self.报名数据[name]
end

function 帮战:能否进场()
    return self.进场开关
end

function 帮战:能否PK()
    return self.战斗开关
end

function 帮战:胜利奖励(玩家)
    local func = _get('胜利奖励包')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, 玩家)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end
    end
end

function 帮战:失败奖励(玩家)
    local func = _get('失败奖励包')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, 玩家)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end
    end
end

return 帮战
