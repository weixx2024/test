local 水陆大会 = class('水陆大会')
local function _get(name)
    local 脚本 = __脚本['scripts/copy/水陆大会.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
    return nil
end

function 水陆大会:初始化(t)
    self.脚本 = 'scripts/copy/水陆大会.lua'
    self.报名数据 = {}
    self.进场数据 = {}
    self.准备数据 = {}
    self.未发放积分 = {}
    self.战斗数量 = 0
    self.分钟 = os.date("%M", os.time())
    self.小时 = os.date("%H", os.time())
    self.星期 = os.date('%w', os.time())
    self.地图 = __沙盒.生成地图(1197)
    self.地图:添加NPC {
        名称 = "比武场管理员",
        外形 = 3011,
        脚本 = 'scripts/npc/水陆比武场.lua',
        X = 78,
        Y = 53,
    }
    if self.星期 == "2" then
        if self.小时 + 0 > 7 then
            self:开启报名()
        end
    end
end

function 水陆大会:存档()

end

function 水陆大会:__index(k)
    local 脚本 = rawget(self, '脚本')
    if 脚本 then
        local r = _get(k)
        if r ~= nil then
            return r
        end
    end
end

function 水陆大会:__newindex(k, v)
    rawset(self, k, v)
end

local _开启周 = {
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = false,
    ["6"] = false,
    ["0"] = false,
}

function 水陆大会:整分处理(sec)
    self.分钟 = os.date("%M", sec)
    if _开启周[self.星期] then
        if self.分钟 == "30" then
            if self.小时 == "19" then
                self:开启进场()
            end
        end
    end
end

function 水陆大会:整点处理(sec)
    self.小时 = os.date("%H", sec)
    if self.星期 ~= os.date('%w', sec) then
        self.星期 = os.date('%w', sec)
    end
    if _开启周[self.星期] then
        if self.小时 == "08" then
            self:开启报名()
        elseif self.小时 == "20" then
            self:开启水陆()
        end
    end
end

function 水陆大会:清空报名数据()
    self.报名数据 = {}
end

function 水陆大会:开启报名()
    self.报名开关 = true
    self.进场开关 = false
    self.是否打开 = false
    __世界:发送系统("#Y唐王下令:水陆大会将在20:00开始，请参加的队伍速去皇宫魏征处报名。")
    __世界:发送系统("#Y水陆大会报名截止在19:30分截止报名，请参加的队伍及时报名。")
end

function 水陆大会:关闭报名()
    self.报名开关 = false
end

function 水陆大会:是否已报名(nid)
    return self.报名数据[nid]
end

function 水陆大会:是否可报名()
    return self.报名开关
end

function 水陆大会:玩家报名(队长)
    if self.报名开关 then
        for k, v in 队长:遍历队伍() do
            self.报名数据[v.nid] = {
                进场 = false,
                名称 = v.名称,
                nid = v.nid,
                外形 = v.外形,
                积分 = v.其它.水陆总积分,
                胜利 = 0,
                失败 = 0,
                总场次 = 0,
                队伍 = 队长.nid,
                -- 连胜 = 0,
                准备 = false
            }
        end
        return "你已成功报名水陆大会！"
    end
    return "现在不是报名时间"
end

function 水陆大会:开启进场()
    self.报名开关 = false
    self.进场开关 = true
    self.是否打开 = false
    __世界:发送系统("#Y唐王下令:水陆大会将在20:00开始，请报名参加的队伍速去皇宫魏征处进场。")
    --  __世界:发送系统("水陆大会进场已经开启")
end

function 水陆大会:是否可进场()
    return self.进场开关
end

function 水陆大会:关闭进场()
    self.进场开关 = false
end

function 水陆大会:玩家进场(nid)
    if self.进场开关 then
        if self.报名数据[nid] then
            self.报名数据[nid].进场 = true
            return true
        end
    end
end

function 水陆大会:进入地图(P)
    if self.地图 then
        P:移动_切换地图(self.地图, 1510, 1296)
    end
end

function 水陆大会:开启水陆()
    self.报名开关 = false
    self.进场开关 = false
    self.是否打开 = true
    __世界:发送系统("#Y唐王下令水陆大会现在开始：水陆大会内英雄豪杰齐聚一堂，唐王在此挑选三界中能人异士，放眼天下，谁是最强！尽在水陆大会!")
    self.匹配倒计时 = os.time()
    self.战斗数量 = 0
    __世界:发送系统("#R水陆大会在3分钟以后自动匹配队伍战斗")
end

function 水陆大会:更新(sec)
    if self.匹配倒计时 then
        if sec - self.匹配倒计时 > 180 then
            self.匹配倒计时 = nil
            self:匹配对手_积分()
        end
    end
end

function 水陆大会:关闭水陆()
    self.报名开关 = false
    self.进场开关 = false
    self.是否打开 = false
    self:结束水陆()
end

function 水陆大会:玩家准备(nid)
    if self.是否打开 and self.报名数据[nid] then
        if self.报名数据[nid].进场 then
            self.报名数据[nid].准备 = true
        end
    end
end

function 水陆大会:匹配对手_积分()
    if not self.是否打开 then
        return
    end
    local 未匹配 = {}
    -----------------所有可进入战斗nid-------------------------
    for k, v in pairs(self.报名数据) do
        if v.失败 < 1 and v.进场 then
            if __玩家[k] and __玩家[k]:可否水陆匹配(self.地图.id) then --是否在线
                local n = __玩家[k]:取队伍水陆积分()
                table.insert(未匹配, { nid = k, 积分 = n })
            end
        end
    end
    table.sort(未匹配, function(a, b)
        return a.积分 > b.积分
    end)
    if #未匹配 <= 1 then --那就应该是只有1个人 就结束活动 重新来开
        self:结束活动()
        return
    end
    local 匹配 = {}
    local a
    local b
    repeat
        local t = {}
        a = math.random(#未匹配)
        t[1] = 未匹配[a].nid
        table.remove(未匹配, a)
        if next(未匹配) then
            b = math.random(#未匹配)
            t[2] = 未匹配[b].nid
            table.remove(未匹配, b)
        end
        table.insert(匹配, t)
    until not next(未匹配)

    if #匹配 == 1 then
        if 匹配[1] and not 匹配[1][2] then
            self:结束活动()
            return
        end
    end

    for i, v in ipairs(匹配) do
        if not v[1] or not v[2] then --轮空
            if v[1] then
                local P = __玩家[v[1]]
                if P then
                    for k, pp in P.接口:遍历队伍() do
                        self:战斗结束(pp, true)
                    end
                end
            end
            if v[2] then
                local P = __玩家[v[2]]
                if P then
                    for k, pp in P.接口:遍历队伍() do
                        self:战斗结束(pp, true)
                    end
                end
            end
        else
            if __玩家[v[1]] and __玩家[v[2]] then
                coroutine.xpcall(
                    function()
                        __玩家[v[1]]:进入PK战斗(__玩家[v[2]], 4)
                    end

                )
                self.战斗数量 = self.战斗数量 + 2
            end
        end
    end
end

function 水陆大会:匹配对手_随机()
    if not self.是否打开 then
        return
    end
    local 未匹配 = {}
    -----------------所有可进入战斗nid-------------------------
    for k, v in pairs(self.报名数据) do
        if v.失败 < 1 then
            if __玩家[k] and __玩家[k]:可否水陆匹配() then --是否在线
                table.insert(未匹配, k)
            end
        end
    end
    ---------------------------------  按队伍平均积分
    local 匹配 = {}
    local a
    local b
    repeat
        local t = {}
        a = math.random(#未匹配)
        t[1] = 未匹配[a]
        table.remove(未匹配, a)
        if next(未匹配) then
            b = math.random(#未匹配)
            t[2] = 未匹配[b]
            table.remove(未匹配, b)
        end
        table.insert(匹配, t)
    until not next(未匹配)

    for i, v in ipairs(匹配) do
        if not v[1] then --轮空

        else
            --todo 进入战斗(v[1]，v[2])
        end
    end
end

function 水陆大会:战斗结束(玩家, 胜负)
    if 玩家.是否队长 then
        self.战斗数量 = self.战斗数量 - 1
    end

    if self.战斗数量 <= 0 then
        if not self.匹配倒计时 then
            self.匹配倒计时 = os.time()
            __世界:发送系统("#R水陆大会在3分钟以后自动匹配队伍战斗")
        end
    end

    if not 玩家 or not self.报名数据[玩家.nid] then
        return
    end
    if 胜负 then
        self:胜利奖励(玩家)
        self.报名数据[玩家.nid].积分 = (self.报名数据[玩家.nid].积分 or 0) + 60
        self.报名数据[玩家.nid].胜利 = self.报名数据[玩家.nid].胜利 + 1
        玩家:常规提示("#Y你获得了胜利奖励")
    else
        if self.报名数据[玩家.nid] then
            self.报名数据[玩家.nid].失败 = self.报名数据[玩家.nid].失败 + 1
        end
        self:失败奖励(玩家)
        self.报名数据[玩家.nid].积分 = self.报名数据[玩家.nid].积分 + 30
        玩家:常规提示("#Y你获得了失败奖励")
    end
end

function 水陆大会:胜利奖励(玩家)
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

function 水陆大会:失败奖励(玩家)
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

local __啥 = {
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 127, y = 57, 方向 = 2 },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 123, y = 59, 方向 = 2 },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 119, y = 62, 方向 = 2 },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 115, y = 63, 方向 = 2 },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 111, y = 66, 方向 = 2 },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
    { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
}


function 水陆大会:结束活动()
    local list = {}
    for k, v in pairs(self.报名数据) do
        if v.进场 then
            table.insert(list, { 名称 = v.名称, 外形 = v.外形, 玩家nid = v.nid, 胜利 = v.胜利 })
        end
        if __玩家[v.nid] and __玩家[v.nid].是否战斗 then
            __玩家[v.nid].战斗.战场:强制退出战斗()
        end
    end
    table.sort(list, function(a, b)
        return a.胜利 > b.胜利
    end)
    __水陆排行帮 = {}
    local 胜场
    local 称谓 = "水陆冠军"
    for i = 1, 15, 1 do
        if list[i] then
            local t = __啥[i]
            if t then
                __水陆排行帮[i] = {
                    名称 = list[i].名称,
                    外形 = list[i].外形,
                    玩家nid = list[i].玩家nid,
                    称谓 = t.称谓,
                    mid = t.mid,
                    x = t.x,
                    y = t.y,
                    方向 = t.方向,
                    脚本 = 'scripts/npc/默认.lua'
                }
                local 积分 = 0
                if i > 10 then
                    积分 = 200
                elseif i > 5 then
                    积分 = 300
                else
                    积分 = 500
                end
                if 胜场 and 胜场 > list[i].胜场 then
                    if 称谓 == "水陆冠军" then
                        称谓 = "水陆亚军"
                    elseif 称谓 == "水陆亚军" then
                        称谓 = "水陆季军"
                    elseif 称谓 == "水陆季军" then
                        称谓 = nil
                    end
                end
                胜场 = list[i].胜场
                if __玩家[list[i].玩家nid] then
                    __玩家[list[i].玩家nid]:添加水陆积分(积分)
                    if 称谓 then
                        __玩家[list[i].玩家nid]:添加称谓(称谓)
                    end
                else
                    self.未发放积分[list[i].玩家nid] = 积分
                end
            end
        end
    end
    __地图[1003]:加载水陆NPC()
    self.报名数据 = {}
    self._匹配定时 = nil
    self.地图:清空玩家(1003, 116, 47)
    __世界:发送系统("水陆已结束")
end

return 水陆大会
