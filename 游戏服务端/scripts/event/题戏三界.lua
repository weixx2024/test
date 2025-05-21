local 事件 = {
    名称 = '题戏三界',
    是否打开 = true,
    开始时间 = os.time { year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00 },
    结束时间 = os.time { year = 2025, month = 7, day = 30, hour = 0, min = 0, sec = 00 }
}
local _开启日 = { --true开启--false
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["0"] = true,
}
function 事件:事件初始化()
    -- 在这里修改参加活动 等级限制 
    -- 活动早上10.30点开始 晚上22点结束
    self.等级 = 80
    self.转生 = 1
    self.结束时 = 22
    self.结束分 = 00
end

function 事件:更新()
end

function 事件:是否在开启()
    local t = os.date("*t", os.time())
    if (t.hour == 10 and t.min > 30) or (t.hour == self.结束时 and t.min < self.结束分) or
        (t.hour < self.结束时 and t.hour > 10) then
        return true
    end
end

function 事件:事件开始()
    if self:是否在开启() then
        self:刷出题目()
    end
end

function 事件:事件结束()
    self.是否结束 = true
end

function 事件:刷出题目()
    self.答对数据 = {}
    self.幸运参与奖 = {}
    self.头奖 = nil
    self.接收答题 = true
    local t = 取文曲题目()
    self.答案 = t[2]
    local txt = string.format('#G文曲星君题戏三界：' .. "%s", t[1])
    self:发送系统(txt)
    if self:是否在开启() then
        self:定时(20, self.结束答题)
    end
end

function 事件:结束答题()
    self.接收答题 = nil
    self.下一题时间 = math.random(130, 150) * 60
    if self:是否在开启() then
        self:定时(self.下一题时间, self.刷出题目)
    end
    self:发放经验奖励()
end

function 事件:玩家答题(玩家, str, nid)
    if str == self.答案 then
        if 玩家.转生 >= self.转生 and 玩家.等级 >= self.等级 then
            if not self.答对数据[nid] then
                if not self.头奖 then
                    self.头奖 = nid
                    self.答对数据[nid] = { nid = nid, 头奖 = true }
                    -- table.insert(self.答对数据, nid)
                else
                    self.答对数据[nid] = { nid = nid }
                end
            end
        end
    end
end

function 事件:发放经验奖励()
    local P
    local t = {}
    for nid, v in ipairs(self.答对数据) do
        P = self:取玩家接口(nid)
        if P then
            local xs = math.random(10) + 210543
            local 经验 = P.转生 * xs + P.等级 * 1203
            P:添加任务经验(经验)
            if math.random(100) < 10 then
                table.insert(self.幸运参与奖, P.nid)
                table.insert(t, P.名称)
            end
        end
    end
    if #t > 0 then
        local txt = '文曲星君非常非常欣赏#G' .. table.concat(t, ', ') .. '#W恭喜他们获得了本次答题活动中的幸运参与奖。'
        self:发送系统(txt)
    end
    self:发放物资奖励()
end

local _广播 = '#C天道酬勤，厚积薄发，恭喜#R%s#C在答题活动中，才思敏捷，获得了星君之厚赏#G#m(%s)[%s]#m#n'

function 事件:发放物资奖励()
    local P
    if self.头奖 then
        P = self:取玩家接口(self.头奖)
        if P then
            table.insert(self.幸运参与奖, 1, P.nid)
            self:发送系统('#Y' .. P.名称 .. '#G智冠三界，快人快语，第一个解答了文曲星君的谜题，恭喜他获得了本次答题活动中的头奖。')
        end
    end


    for i, nid in ipairs(self.幸运参与奖) do
        P = self:取玩家接口(nid)
        if P then
            local 掉落包 = 取掉落包('活动', '题戏三界')
            if 掉落包 then
                奖励掉落包物品(P, 掉落包, _广播)
            end
        end
    end
end

function 事件:整分处理(分钟, 小时, 星期)
    if _开启日[星期] then
        if 小时 == "10" and 分钟 == "30" then
            self:刷出题目()
        end
    end
end

return 事件
