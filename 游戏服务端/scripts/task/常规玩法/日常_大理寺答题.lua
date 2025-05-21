local 任务 = {
    名称 = '日常_大理寺答题',
    别名 = '大理寺答题',
    类型 = '常规玩法'
}


function 任务:任务初始化()

end

function 任务:任务取详情(玩家)
    return string.format("你当前正在参加大理寺答题，请在#R%s#W分内完成本活动。逾期将自动失去本轮活动资格。当前已回答#R%s#W道题目，其中回答正确#R%s#W道,回答错误#R%s#W道"
    , (self.时间 - os.time()) // 60, self.总数, self.答对, self.答错)
end

function 任务:任务取消(玩家)
    self:删除()
end

function 任务:任务更新(sec)
    if os.time() > self.时间 then
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if os.time() > self.时间 then
        self:删除()
    end
end

function 任务:添加任务(玩家)
    self.时间 = os.time() + 30 * 60
    self.tz = self:生成台词()
    self.总数 = 0
    self.答对 = 0
    self.答错 = 0
    玩家:增加活动限制次数('大理寺答题')
    玩家:添加任务(self)
    return true
end

function 任务:生成台词()
    self.计时 = os.time() + 30
    self.tm = _大理寺题库[math.random(#_大理寺题库)]
    self.tz = self.tm.对话 .. "\nmenu"
    local 选项 = {}
    for _, v in pairs(self.tm.选项) do
        table.insert(选项, { 选项 = v, 序列 = math.random(1000) })
    end
    table.sort(选项, function(a, b) return a.序列 > b.序列 end)
    for k, v in ipairs(选项) do
        self.tz = self.tz .. "\n" .. k + 20 .. "|" .. v.选项
        if v.选项 == self.tm.选项[4] then
            self.答案 = k + 20
        end
    end
    return self.tz
end

local _广播 = '#C%s#c00FFFF在大理寺答题任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!'

function 任务:掉落包(玩家)
    local 掉落包 = 取掉落包('日常', '大理寺答题')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包, _广播)
    end
end

--===============================================
function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == "大理寺官员" then
        if self.总数 < 10 then
            return self.tz
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == "大理寺官员" then
        if i and i ~= "1" then
            -- local 银子 = 5000
            local 经验 = 150000
            if tostring(self.答案) == i then
                if self.计时 > os.time() then
                    玩家:常规提示("#Y回答正确！")
                    self.答对 = self.答对 + 1
                    玩家:添加任务经验(经验, "大理寺答题")
                else
                    玩家:常规提示("#Y答题超时！")
                    self.答错 = self.答错 + 1
                end
            else
                玩家:常规提示("#Y回答错误！")
                self.答错 = self.答错 + 1
            end

            local r = 玩家:取任务('引导_大理寺答题')
            if r then
                r:添加进度(玩家)
            end
            self.总数 = self.总数 + 1
            if self.总数 < 10 then
                NPC.结束 = false
                NPC.台词 = self:生成台词()
            else
                self:掉落包(玩家)
                self:删除()
            end
        end
    end
end

--===============================================


function 任务:战斗初始化(玩家, NPC)

end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
