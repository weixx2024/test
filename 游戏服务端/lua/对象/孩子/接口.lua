--可以访问的属性
local 接口 = {
    名称 = true,
    外形 = true,
    职业 = true,
    阶段 = true,
    气质 = true,
    悟性 = true,
    智力 = true,
    耐力 = true,
    内力 = true,
    亲密 = true,
    孝心 = true,
    温饱 = true,
    疲劳 = true,
    评价 = true,
    性别 = true,
}
--可以访问的方法

local 亲孝上限 = 400
-- do zdz 由于修炼次数降低,需要放大属性增长倍数
local 修炼加点数 = 20 -- 官方值1
local 高级修炼加点数 = 30 -- 官方值3
local 阶段1引导次数 = 16 -- 官方值16
local 阶段2引导次数 = 60 -- 官方值60
local 阶段3修炼次数 = 84 -- 官方值84
local 阶段4修炼次数 = 168 -- 官方值168

-- 年龄：0-6岁用12本引导;6-18岁操作432次(共12年，每年12个月，每个月操作3次，12*12*3=432次);

local _引导道具 = require('数据库/孩子信息库').引导道具
local _属性范围 = require('数据库/孩子信息库').属性范围
local _随机天资 = require('数据库/孩子信息库').随机天资
local _随机低级天资 = require('数据库/孩子信息库').随机低级天资
local _随机高级天资 = require('数据库/孩子信息库').随机高级天资

function 接口:提示窗口(...)
    self.主人.rpc:提示窗口(...)
end

function 接口:常规提示(...)
    self.主人.rpc:常规提示(...)
end

function 接口:添加物品(t)
    return self.主人.接口:添加物品(t)
end

function 接口:使用引导物品(道具名称, 高级)
    if not _引导道具[道具名称] then
        return false
    end

    if self.阶段 > 2 then
        self.接口:常规提示("#Y超过儿童期无法再使用引导物品")
        return false
    end

    if self.阶段 == 2 and self.物品.引导 >= 阶段2引导次数 then
        self.接口:常规提示("#Y超过儿童期无法再使用引导物品")
        return false
    end

    if 高级 == nil then
        if self.主人.接口:取活动限制次数('孩子引导') >= 20 then
            self.接口:常规提示("#Y今日引导次数已用完")
            return false
        end
    end

    local 额外几率 = 5
    if 高级 ~= nil then
        额外几率 = 20
    end

    for key, value in pairs(_引导道具[道具名称]) do
        if self[key] == nil then
            self[key] = 0
        end
        self[key] = self[key] + value
    end

    if 高级 == nil then
        self.主人.接口:增加活动限制次数('孩子引导')
    end

    self.物品.引导 = self.物品.引导 + 1
    self.接口:常规提示('#Y使用成功，宝宝的属性发生了些许的变化')

    if self.阶段 == 1 then
        self.接口:常规提示('#Y当前阶段还可以引导%s次', 阶段1引导次数 - self.物品.引导)
    elseif self.阶段 == 2 then
        self.接口:常规提示('#Y当前阶段还可以引导%s次', 阶段2引导次数 - self.物品.引导)
    end

    if self.阶段 == 1 and self.物品.引导 >= 阶段1引导次数 then
        self.阶段 = 2
        self.物品.引导 = 0
        self.接口:常规提示('#Y恭喜，你的宝宝已经进入了儿童期')
    end
    if self.阶段 == 2 and self.物品.引导 >= 阶段2引导次数 then
        self.阶段 = 3
        self.物品.引导 = 0
        self.物品.修炼 = 0
        self.接口:常规提示('#Y恭喜，你的宝宝已经进入了青年期')
    end

    if math.random(100) <= 额外几率 then
        local list = { "亲密", "疲劳", "孝心" }
        local 属性 = list[math.random(#list)]
        local 点数 = math.random(#list)
        if 高级 ~= nil then
            点数 = math.random(3)
        end

        self[属性] = self[属性] + 点数

        if self.亲密 > 亲孝上限 then
            self.亲密 = 亲孝上限
        end
        if self.孝心 > 亲孝上限 then
            self.孝心 = 亲孝上限
        end

        self.接口:常规提示('#Y宝宝获得%s+%s', 属性, 点数)
    end

    self:刷新评价()
    return true
end

function 接口:拜师(职业)
    if self.阶段 == 1 or self.阶段 == 2 then
        return '青年期再来吧'
    end

    if self.性别 == 1 and 职业 == '剑舞' then
        return '该职业只有女孩才能学习'
    end

    if self.性别 == 2 and 职业 == '兵法' then
        return '该职业只有男孩才能学习'
    end

    if self.职业 ~= '' then
        return '该宝宝已经拜师了'
    end

    self.职业 = 职业
    self.接口:常规提示("#Y拜师成功")
    self:刷新评价()
end

function 接口:职业检查(职业)
    if self.职业 == '' then
        return "请先带宝宝加入一种职业"
    end

    if self.职业 ~= 职业 then
        return "我不是你宝宝得老师哦"
    end
end

function 接口:修炼(属性序号, 消耗物品, 高级)
    local 属性
    if type(属性序号) == "number" then
        属性 = _属性范围[属性序号]
    end

    if self.职业 == '' then
        self.接口:常规提示("#Y请先带宝宝加入一种职业")
        return false
    end

    if self.阶段 == 1 or self.阶段 == 2 then
        self.接口:常规提示('#Y青年期再来吧')
        return false
    elseif self.阶段 == 3 and self.物品.修炼 >= 阶段3修炼次数 then
        self.接口:常规提示('#Y已经达到修炼次数上限！')
        return false
    elseif self.阶段 == 4 and self.物品.修炼 >= 阶段4修炼次数 then
        self.接口:常规提示('#Y你的宝宝已经出师了！')
        return false
    end

    if 高级 == nil then
        if self.主人.接口:取活动限制次数('孩子修炼') >= 50 then
            self.接口:常规提示("#Y今日修炼次数已用完")
            return false
        end
    end

    local 全属性满值 = self:取属性点上限(属性, self.职业, true)

    if self:取属性点上限(属性, self.职业) and 全属性满值 < 5 then
        self.接口:常规提示("#Y该属性已经满！请修炼其它属性！")
        return false
    end

    local 额外几率 = 5
    if 高级 ~= nil then
        额外几率 = 20
    end

    local 物品 = self.主人.接口:取物品是否存在(消耗物品)
    if 物品 then
        物品:减少(1)
        local 点数 = 5

        if 全属性满值 < 5 then
            self[属性] = self[属性] + 点数
            self.接口:常规提示("#Y你的%s经过修炼%s提升了%s点", self.名称, 属性, 点数)
        end

        if self.阶段 == 3 then
            self.接口:常规提示('#Y当前阶段还可以修炼%s次', 阶段3修炼次数 - self.物品.修炼)
        elseif self.阶段 == 4 then
            self.接口:常规提示('#Y当前阶段还可以修炼%s次', 阶段4修炼次数 - self.物品.修炼)
        end

        if math.random(100) <= 额外几率 or 全属性满值 >= 5 then
            local list = { "亲密", "疲劳", "孝心" }
            local 属性 = list[math.random(#list)]
            if 高级 ~= nil then
                点数 = math.random(3)
            end

            self[属性] = self[属性] + 点数

            if self.亲密 > 亲孝上限 then
                self.亲密 = 亲孝上限
            end
            if self.孝心 > 亲孝上限 then
                self.孝心 = 亲孝上限
            end

            if 全属性满值 >= 5 then
                self.接口:常规提示('#Y由于宝宝所有属性已满，获得%s+%s', 属性, 点数)
            else
                self.接口:常规提示('#Y宝宝获得%s+%s', 属性, 点数)
            end
        end

        if 高级 == nil then
            self.主人.接口:增加活动限制次数('孩子修炼')
        end
        self.物品.修炼 = self.物品.修炼 + 1

        if self.阶段 == 3 and self.物品.修炼 >= 阶段3修炼次数 then
            self.阶段 = 4
            self.物品.引导 = 0
            self.物品.修炼 = 0
            self.接口:常规提示('#Y恭喜，你的宝宝已经进入了成年期')
        end

        if self.阶段 == 4 and self.物品.修炼 >= 阶段4修炼次数 then
            self.接口:常规提示('#Y恭喜，你的宝宝已经出师了')
        end
        self:刷新评价()
    else
        self.接口:常规提示("#Y你包裹里已经没有%s", 消耗物品)
    end
end

function 接口:消除疲劳()
    if self.疲劳 <= 0 then
        self.接口:常规提示("#Y该宝宝没有疲劳度可清除")
        return false
    end

    local i = self.主人.接口:选择窗口('请选择要转化的属性！\nmenu\n1|气质\n\n2|悟性\n\n3|智力\n\n4|内力\n\n5|耐力')
    if not i then
        return false
    end

    local 洗点属性 = 5
    if self.疲劳 < 5 then
        洗点属性 = self.疲劳
    end

    self.疲劳 = self.疲劳 - 5
    self[_属性范围[tonumber(i)]] = self[_属性范围[tonumber(i)]] + 洗点属性
    self.接口:常规提示("#Y宝宝清除了%s点疲劳，新增%s点%s", 洗点属性, 洗点属性,
        _属性范围[tonumber(i)])
    if self.疲劳 < 0 then
        self.疲劳 = 0
    end

    self:刷新评价()
    return true
end

function 接口:添加亲密孝心(名称)
    if self.亲密 >= 亲孝上限 and self.孝心 >= 亲孝上限 then
        self.接口:常规提示("#Y亲密孝心已经达到上限")
        return false
    end

    local 数值 = 1
    if 名称 == "仙童果" then
        数值 = 5
    end

    if math.random(100) <= 50 then
        if self.亲密 < 亲孝上限 then
            self.亲密 = self.亲密 + 数值
            self.接口:常规提示("#Y宝宝增加了" .. 数值 .. "亲密")
        else
            self.孝心 = self.孝心 + 数值
            self.接口:常规提示("#Y宝宝增加了" .. 数值 .. "孝心")
        end
    else
        if self.孝心 < 亲孝上限 then
            self.孝心 = self.孝心 + 数值
            self.接口:常规提示("#Y宝宝增加了" .. 数值 .. "孝心")
        else
            self.亲密 = self.亲密 + 数值
            self.接口:常规提示("#Y宝宝增加了" .. 数值 .. "亲密")
        end
    end
    if self.亲密 > 亲孝上限 then
        self.亲密 = 亲孝上限
    end
    if self.孝心 > 亲孝上限 then
        self.孝心 = 亲孝上限
    end

    self:刷新评价()
    return true
end

function 接口:修改天资(名称)
    local 天资
    if 名称 == '琼浆玉液' then
        天资 = self:排除已有天资(_随机低级天资)[math.random(1, #_随机低级天资)]
    elseif 名称 == '金丹' then
        天资 = self:排除已有天资(_随机高级天资)[math.random(1, #_随机高级天资)]
    else
        天资 = self:排除已有天资(_随机天资)[math.random(1, #_随机天资)]
    end

    if 天资 then
        local 文本 = '请选择一项你想要覆盖的天资\nmenu\n1|' .. self.天资[1] .. '\n2|' .. self.天资[2] .. '\n3|' .. self.天资[3] .. '\n4|什么也不做'
        local i = self.主人.接口:选择窗口(文本)
        if i then
            if i ~= '4' then
                self.天资[tonumber(i)] = 天资
                self.接口:常规提示('#Y你的%s获得了新的天资#G%s', self.名称, 天资)
                self.刷新的属性.天资 = true
                return true
            end
        end
    end
end

--===============================================================================
if not package.loaded.孩子接口_private then
    package.loaded.孩子接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('孩子接口_private')

local 孩子接口 = class('孩子接口')

function 孩子接口:初始化(P)
    _pri[self] = P
    self.是否孩子 = true
end

function 孩子接口:__index(k)
    if k == 0x4253 then
        return _pri[self]
    end
    local r = 接口[k]
    local P = _pri[self]
    if r == true then
        return P[k]
    elseif r then
        return function(_, ...)
            return r(P, ...)
        end
    end
end

return 孩子接口
