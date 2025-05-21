local 取孩子技能几率 = require('数据库/孩子信息库').取孩子技能几率
local 多目标技能 = require('数据库/孩子信息库').多目标技能

local 战斗对象 = class('战斗对象')
gge.require('战斗/对象/事件')
local _属性BUFF = {
    每回合HP = true,
    每回合MP = true,
}

local _释放法术 = {
    被攻击时释放魔神附身 = true,
    被攻击时释放乾坤借速 = true,
    被攻击时释放含情脉脉 = true,
}

local _附法技能 = {
    附水攻击 = true,
    附火攻击 = true,
    附风攻击 = true,
    附雷攻击 = true,
    附混乱攻击 = true,
    附加震慑攻击 = true,
    附加毒攻击几率 = true,
}


local _法反列表 = {
    水法反击 = true,
    雷法反击 = true,
    火法反击 = true,
    风法反击 = true,
}

local _符文 = {
    分裂攻击 = true,
}

function 战斗对象:初始化(位置, 对象, 战场)
    self.指令 = '物理'
    self.战场 = 战场
    self.位置 = 位置
    self.对象 = 对象
    self.怨气 = 149
    self.最大怨气 = 500
    self.增加亲密 = 0

    local tp = ggetype(对象)
    self.是否玩家 = tp == '角色'
    self.是否召唤 = tp == '召唤'
    self.是否怪物 = tp == '怪物'
    self.是否孩子 = tp == '孩子'

    self:事件_初始化()

    self.回合数据 = {} --发给客户端的
    self.BUFF列表 = {}
    self.法术列表 = {}
    self.召唤列表 = {}
    self.内丹列表 = {}
    self.附法列表 = {}
    self.主动技能 = {} --怪物随机用
    self.被动技能 = {}
    self.法反列表 = {}
    self.孩子增益 = {}

    self.气血 = 对象.气血
    self.魔法 = 对象.魔法
    self.攻击 = 对象.攻击
    self.速度 = 对象.速度

    self.对象数据 = {
        攻击 = 对象.攻击 or 0,
        速度 = 对象.速度 or 0,
        忽视躲闪率 = 0, --废弃
        抗致命几率 = 0, --废弃
        抗连击率 = 0, --废弃
        忽视反击率 = 0, --废弃
    }

    self.队伍 = self.位置 >= 10 and 2 or 1

    if self.是否孩子 then
        local 主人 = self.战场:取对象(self.位置 - 10)
        self.速度 = 主人.速度 + 1
    end

    if self.是否玩家 then
        self:玩家初始化(对象)
    end

    if not self.是否孩子 then
        if not self.是否玩家 then
            self:非玩家初始化(对象)
        end
        self:公共初始化(对象, 战场)
    end
end

function 战斗对象:玩家初始化(对象)
    for _, v in 对象:遍历召唤() do
        v.战斗已上场 = v.是否参战 --or false
        table.insert(self.召唤列表, v)
    end
    table.sort(
        self.召唤列表,
        function(a, b)
            return a.顺序 < b.顺序
        end
    )

    for _, v in 对象:遍历技能() do
        if v.战斗可用 then --战斗
            self.法术列表[v.nid] = v
        end
    end

    for _, v in 对象:遍历特技() do
        if v.战斗可用 then --战斗
            self.法术列表[v.nid] = v
        end
    end

    for _, v in 对象:遍历佩戴法宝() do
        local r = require('对象/法术/技能')({ 名称 = v.名称, 等级 = v.等级, 类别 = '法宝' })
        self.法术列表[r.nid] = r
    end
end

function 战斗对象:非玩家初始化(对象)
    self.是否消失 = self.是否消失 == nil
    self.装备属性 = __容错表()

    for k, v in 对象:遍历内丹() do
        if v.元气 > 0 then
            if v.战斗可用 then
                self.法术列表[v.nid] = v
            end
            table.insert(self.内丹列表, v)
        end
    end
    for _, v in 对象:遍历技能() do
        if v.战斗可用 then --战斗
            self.法术列表[v.nid] = v
        end
    end
end

function 战斗对象:公共初始化(对象, 战场)
    -- 初始化属性抗性
    for _, k in pairs(require('数据库/抗性库')) do
        if self.是否玩家 then
            -- print(k,对象.抗性[k])
        end
        self.对象数据[k] = 对象.抗性[k]
    end

    for k, v in self:遍历法术() do
        if v.是否主动 then
            table.insert(self.主动技能, v)
        elseif v.是否被动 then
            table.insert(self.被动技能, v)
        end
    end

    for k, v in pairs(_附法技能) do
        if self[k] ~= 0 then
            local r = require('对象/法术/技能')({ 名称 = k, 类别 = '属性' })
            self.附法列表[r.nid] = r
        end
    end

    for k, v in pairs(_属性BUFF) do
        if self[k] ~= 0 then
            local r = require('对象/法术/技能')({ 名称 = k, 类别 = '属性' })
            self.法术列表[r.nid] = r
        end
    end

    for k, v in pairs(_释放法术) do
        if self[k] ~= 0 then
            local r = require('对象/法术/技能')({ 名称 = k, 类别 = '属性' })
            self.法术列表[r.nid] = r
        end
    end

    for k, v in pairs(_法反列表) do
        if self[k] ~= 0 then
            local r = require('对象/法术/技能')({ 名称 = k, 类别 = '属性' })
            self.法反列表[r.nid] = r
        end
    end

    for k, v in pairs(_符文) do
        if self[k] ~= 0 then
            local r = require('对象/法术/技能')({ 名称 = k, 类别 = '符文' })
            self.法术列表[r.nid] = r
        end
    end
end

function 战斗对象:__index(k)
    local t = rawget(self, '对象数据')
    if t and t[k] ~= nil then
        return t[k]
    end
    local t = rawget(self, '对象')
    if t and t[k] ~= nil then
        return t[k]
    end
end

function 战斗对象:取主人()
    if self.对象.主人 then
        for i, v in self:遍历我方玩家() do
            if v.nid == self.对象.主人.nid then
                return v
            end
        end
    end
    return
end

function 战斗对象:当前喊话(s, time)
    for i, v in self.战场:遍历玩家() do
        v.rpc:战斗喊话(self.位置, s, time)
    end
end

function 战斗对象:队伍喊话(s, time)
    for i, v in self:遍历我方玩家() do
        v.rpc:战斗喊话(self.位置, s, time)
    end
end

--===============================================================================
function 战斗对象:战斗开始()
    if self.对象.战斗_开始 then
        self.对象:战斗_开始(self)
    end
end

function 战斗对象:战斗结束()
    if self.对象.战斗_结束 then
        self.对象:战斗_结束()
    end
end

function 战斗对象:战斗结束触发领悟()
    if self.对象.战斗_结束 then
        self.对象:战斗结束触发领悟()
    end
end

function 战斗对象:进入战斗()
    self.当前数据.位置 = self.位置
    self.ev:进入战斗(self)
    if self.内丹列表[1] then
        self.内丹列表[1]:切换内丹BUFF(self)
    end
end

function 战斗对象:取数据() --客户端
    local wx = self.外形
    if self.是否玩家 then
        wx = self:角色_取战斗模型()
    end
    local r = {
        nid = self.nid,
        名称 = self.名称,
        名称颜色 = self.名称颜色,
        外形 = wx,
        染色 = self.染色,
        位置 = self.位置,
        气血 = self.气血,
        最大气血 = self.最大气血,
        魔法 = self.魔法,
        最大魔法 = self.最大魔法,
        是否死亡 = self.是否死亡,
        是否机器人 = self.是否机器人,
        是否孩子 = self.是否孩子,
        隐身 = self.是否隐身
    }

    r.buf = {}
    for _, v in pairs(self.BUFF列表) do
        table.insert(r.buf, v.id)
    end
    return r
end

--===============================================================================
local 天资映射表 = {
    ['清心咒'] = '混乱',
    ['莲台心法'] = '混乱',
    ['破冰术'] = '封印',
    ['飞龙在天'] = '封印',
    ['解毒术'] = '中毒',
    ['丹青妙手'] = '中毒'
}

function 战斗对象:孩子喊话()
    if not self.是否孩子 then
        return
    end

    local 主人 = self.战场:取对象(self.位置 - 10)
    local 数据 = require('战斗/回合数据')(self.位置)
    local 是否喊话 = false

    -- 把上回合的属性增益减掉
    if self.孩子增益.龙腾 or self.孩子增益.先发制人 then
        self.速度 = self.速度 - 200
        主人.速度 = 主人.速度 - 200
    end

    self.孩子增益 = {}
    self.孩子法术增强喊话 = false
    主人.孩子增益 = {}

    for i = 1, #self.天资 do
        local 几率 = 取孩子技能几率(self.评价, self.亲密, self.孝心, self.天资[i])

        -- 法术 伤害吸收类 被攻击时触发
        if self.天资[i] == '水系吸收' or self.天资[i] == '玄冰甲' or self.天资[i] == '火系吸收' or self.天资[i] == '烈火甲' or self.天资[i] == '雷系吸收' or self.天资[i] == '天雷甲' or self.天资[i] == '风系吸收' or self.天资[i] == '狂风甲' or self.天资[i] == '鬼火吸收' or self.天资[i] == '冥火甲' then
            if math.random(1, 100) <= 40 then
                self.孩子增益[self.天资[i]] = 几率
            end

            goto continue
        end

        if math.random(1, 100) <= 几率 then
            if self.天资[i] == '龙腾' or self.天资[i] == '先发制人' then -- 加速 回合开始时触发
                self.孩子增益[self.天资[i]] = 200

                self.速度 = self.速度 + 200
                主人.速度 = 主人.速度 + 200

                数据:孩子喊话('看我的#G' .. self.天资[i] .. '#46')
                数据.时长 = 1
                是否喊话 = true
            elseif self.天资[i] == '破甲' or self.天资[i] == '嗜血狂攻' then
                self.孩子增益[self.天资[i]] = 1

                数据:孩子喊话('看我的#G' .. self.天资[i] .. '#46')
                数据.时长 = 1
                是否喊话 = true
            elseif self.天资[i] == '金刚护体' then -- 回合开始前先计算 但不触发 -- 物理 伤害吸收类 被攻击时触发
                self.孩子增益[self.天资[i]] = 2
            elseif self.天资[i] == '铁布衫' then -- 回合开始前先计算 但不触发 -- 物理 伤害吸收类 被攻击时触发
                self.孩子增益[self.天资[i]] = 1
            elseif 天资映射表[self.天资[i]] ~= nil and 主人:取BUFF(天资映射表[self.天资[i]]) then -- 脱困 回合开始时触发
                self.孩子增益[self.天资[i]] = 1

                主人.当前数据.位置 = 主人.位置
                主人:删除BUFF(天资映射表[self.天资[i]])

                数据:孩子喊话('看我的#G' .. self.天资[i] .. '#46')
                数据.时长 = 1
                是否喊话 = true
            else -- 加强法术类 在出手时触发
                self.孩子增益[self.天资[i]] = 几率
                self.孩子法术增强喊话 = true
            end
        end

        ::continue::
    end

    主人.孩子增益 = self.孩子增益

    if 是否喊话 then
        数据:孩子技能()
    end

    return 数据
end

function 战斗对象:触发孩子喊话(str)
    local 孩子 = self.战场:取对象(self.位置 + 10)
    孩子.当前数据:孩子喊话(str)
end

function 战斗对象:回合开始()
    if not self.当前数据 then
        return
    end

    self.当前数据.位置 = self.位置
    self.已保护 = false --注每回合只可触发
    self.ev:回合开始(self)
    self.ev:BUFF回合开始(self)

    local 敌方可用 = false

    if self.是否怪物 then
        self.魔法 = self.最大魔法
        if #self.主动技能 > 0 and math.random(100) <= (self.施法几率 or 50) then
            self.指令 = '法术'
            local i = math.random(#self.主动技能)
            self.选择 = self.主动技能[i].nid
            敌方可用 = self.主动技能[i].敌方可用
        else
            self.指令 = '物理'
        end

        if self.指令 == "法术" then
            if self.选择 and 敌方可用 then
                self.目标 = self:随机敌方存活目标()
            else
                self.目标 = self:随机我方存活目标()
            end
        elseif self.指令 == "物理" then
            self.目标 = self:随机敌方存活目标()
        end

        self.战场:脚本战斗回合开始(self)
    end

    -- 机器人每回合满蓝色
    if self.是否机器人 then
        self.魔法 = self.最大魔法
    end
end

function 战斗对象:回合结束(数据)
    self.当前数据.位置 = self.位置
    if self.内丹列表[2] then
        local i = math.random(#self.内丹列表)
        self.内丹列表[i]:切换内丹BUFF(self)
    end
    self.ev:BUFF回合结束(self)
    self.ev:法术回合结束(self)
    if self.是否怪物 then
        self.战场:脚本战斗回合结束(self)
    end
end

--===============================================================================
local _人物指令校验 = {
    物理 = true,
    法术 = true,
    道具 = true,
    防御 = true,
    保护 = true,
    召唤 = true,
    召还 = true,
    捕捉 = true,
    逃跑 = true,
}

local _召唤指令校验 = {
    物理 = true,
    法术 = true,
    道具 = true,
    防御 = true,
    保护 = true,
}

function 战斗对象:机器人指令()
    if not self.是否机器人 then
        return
    end
    local sum = self.战场:取对象(self.位置 + 5)
    local 功能 = self.机器人功能
    local 战斗人物选择
    if 功能.战斗人物法术 then
        for _, v in pairs(self.法术列表) do
            if v.名称 == 功能.战斗人物法术 then
                战斗人物选择 = v.nid
            end
        end
    end
    self:置指令(功能.战斗人物指令, 功能.战斗人物目标, 战斗人物选择)
    if sum then
        local 战斗召唤选择
        if 功能.战斗召唤法术 then
            for _, v in pairs(self.法术列表) do
                if v.名称 == 功能.战斗召唤法术 then
                    战斗人物选择 = v.nid
                end
            end
        end
        sum:置指令(功能.战斗召唤指令, 功能.战斗召唤目标, 战斗召唤选择)
    end
end

function 战斗对象:战斗菜单回传(nid)
    self._定时:删除()
end

function 战斗对象:打开战斗菜单()
    self._定时 = __世界:定时(
        3000,
        function(ms)
            self:打开菜单()
            return ms
        end
    )
    self:打开菜单()
end

function 战斗对象:打开菜单()
    self.保护 = nil
    if self.是否机器人 then
        self:机器人指令()
        return
    end
    if self.是否孩子 then
        return
    end
    local sum = self.战场:取对象(self.位置 + 5)
    if not self.完成指令 then
        local 数据验证 = self.rpc:人物菜单(self.战场.等待时长, sum == nil, self.nid, self.怨气) --
        if not 数据验证 then

        end
        return
    end
    if sum and not sum.完成指令 then
        local 数据验证 = self.rpc:召唤菜单(sum.nid, self.nid)
        if not 数据验证 then

        end
        return
    end
    if self.是否队长 then
        local 助战 = self.战场:取助战对象(self.位置)
        for i, v in pairs(助战) do
            local sum = self.战场:取对象(v.位置 + 5)
            if not v.完成指令 then
                local 数据验证 = self.rpc:人物菜单(nil, sum == nil, v.nid, v.怨气)
                if not 数据验证 then

                end
                return
            end
            if sum and not sum.完成指令 then
                local 数据验证 = self.rpc:召唤菜单(sum.nid, v.nid)
                if not 数据验证 then

                end
                return
            end
        end
    end
    self._定时:删除()
    for _, P in self:遍历我方玩家() do
        P.rpc:战斗操作(self.位置)
    end
    return true
end

function 战斗对象:菜单返回(人物, 召唤)
    local nid = (人物 or 召唤).nid
    if self.nid == nid then
        self.完成指令 = true
        local 人物指令, 人物目标, 人物选择 = 人物.指令, 人物.目标, 人物.选择
        if 人物指令 then
            if _人物指令校验[人物指令] then
                self.菜单指令 = 人物指令
                self.菜单目标 = 人物目标
                self.菜单选择 = 人物选择

                self.对象.战斗指令 = self.菜单指令
                self.对象.战斗目标 = self.菜单目标
                self.对象.战斗选择 = self.菜单选择
                self:置指令(self.菜单指令, self.菜单目标, self.菜单选择)
            end
        end
    end
    local sum = self.战场:取对象(self.位置 + 5)
    if sum and sum.nid == nid then
        local 召唤指令, 召唤目标, 召唤选择 = 召唤.指令, 召唤.目标, 召唤.选择
        if 召唤指令 then
            sum.完成指令 = true
            if _召唤指令校验[召唤指令] then
                sum.菜单指令 = 召唤指令
                sum.菜单目标 = 召唤目标
                sum.菜单选择 = 召唤选择

                self.对象.战斗召唤指令 = sum.菜单指令
                self.对象.战斗召唤目标 = sum.菜单目标
                self.对象.战斗召唤选择 = sum.菜单选择
                sum:置指令(sum.菜单指令, sum.菜单目标, sum.菜单选择)
            end
        end
    end
    if self.是否队长 then
        local 助战 = self.战场:取助战对象(self.位置)
        for i, v in pairs(助战) do
            local sum = self.战场:取对象(v.位置 + 5)
            if v.nid == nid then
                local 人物指令, 人物目标, 人物选择 = 人物.指令, 人物.目标, 人物.选择
                if 人物指令 then
                    if 人物指令 == "物理" and 人物目标 == nil then
                        人物目标 = self:随机敌方存活目标()
                    end
                    v.完成指令 = true
                    if _人物指令校验[人物指令] then
                        v.菜单指令 = 人物指令
                        v.菜单目标 = 人物目标
                        v.菜单选择 = 人物选择
                        v.对象.战斗指令 = 人物指令
                        v.对象.战斗目标 = 人物目标
                        v.对象.战斗选择 = 人物选择
                        v:置指令(v.菜单指令, v.菜单目标, v.菜单选择)
                    end
                end
            end
            if sum and sum.nid == nid then
                local 召唤指令, 召唤目标, 召唤选择 = 召唤.指令, 召唤.目标, 召唤.选择
                if 召唤指令 == "物理" and 召唤目标 == nil then
                    召唤目标 = self:随机敌方存活目标()
                end
                sum.完成指令 = true
                if _召唤指令校验[召唤指令] then
                    sum.菜单指令 = 召唤指令
                    sum.菜单目标 = 召唤目标
                    sum.菜单选择 = 召唤选择

                    v.对象.战斗召唤指令 = 召唤指令
                    v.对象.战斗召唤目标 = 召唤目标
                    v.对象.战斗召唤选择 = 召唤选择
                    sum:置指令(sum.菜单指令, sum.菜单目标, sum.菜单选择)
                end
            end
        end
    end
    self._定时 = __世界:定时(
        3000,
        function(ms)
            self:打开菜单()
            return ms
        end
    )
    return self:打开菜单()
end

function 战斗对象:执行自动(v) -- 人物自动或者超时强制自动
    if self.自动 or v then
        self.完成指令 = true
        self.自动 = '∞'
        self.对象.战斗自动 = self.自动
        self.指令 = self.菜单指令 or self.存档指令[1]
        self.目标 = self.菜单目标 or self.存档指令[2]
        self.选择 = self.菜单选择 or self.存档指令[3]
        if not self.指令 then
            __世界:WARN('执行自动物理 > 目标没有指令' .. (self.对象.战斗指令 or "无"))
            self.指令 = '物理'
            self.目标 = 101
        else
            self.对象:置存档命令(self.指令, self.目标, self.选择)
        end
        local sum = self.战场:取对象(self.位置 + 5)
        if sum then
            sum.指令 = sum.菜单指令 or sum.存档指令[1]
            sum.目标 = sum.菜单目标 or sum.存档指令[2]
            sum.选择 = sum.菜单选择 or sum.存档指令[3]
            if not sum.指令 then
                __世界:WARN('执行自动物理 > 目标没有指令' .. sum.名称)
                sum.指令 = '物理'
                sum.目标 = 101
            else
                sum.对象:置存档命令(sum.指令, sum.目标, sum.选择)
            end
        end
        if self.是否队长 then
            local 助战 = self.战场:取助战对象(self.位置)
            for i, v in pairs(助战) do
                v.完成指令 = true
                v.自动 = self.自动
                v.对象.战斗自动 = self.自动
                v.指令 = v.菜单指令 or v.存档指令[1]
                v.目标 = v.菜单目标 or v.存档指令[2]
                v.选择 = v.菜单选择 or v.存档指令[3]
                if not v.指令 then
                    __世界:WARN('执行自动物理 > 目标没有指令' .. (v.对象.战斗指令 or "无"))
                    v.指令 = '物理'
                    v.目标 = 101
                else
                    v.对象:置存档命令(v.指令, v.目标, v.选择)
                end
                local sum = self.战场:取对象(v.位置 + 5)
                if sum then
                    sum.指令 = sum.菜单指令 or sum.存档指令[1]
                    sum.目标 = sum.菜单目标 or sum.存档指令[2]
                    sum.选择 = sum.菜单选择 or sum.存档指令[3]
                    if not sum.指令 then
                        __世界:WARN('执行自动物理 > 目标没有指令' .. sum.名称)
                        sum.指令 = '物理'
                        sum.目标 = 101
                    else
                        sum.对象:置存档命令(sum.指令, sum.目标, sum.选择)
                    end
                end
            end
        end


        local 人物指令 = self.指令
        if not 人物指令 then
            人物指令 = '物理'
        end
        local 召唤指令 = (sum or {}).指令 or "物理"
        if not 召唤指令 then
            召唤指令 = '物理'
        end
        self.rpc:战斗自动(self.自动, 人物指令, 召唤指令)
        for _, P in self:遍历我方玩家() do
            P.rpc:战斗操作(self.位置)
        end
        return true
    end
end

function 战斗对象:自动战斗(s) -- 客户端发送自动或者取消按钮
    if s then
        self.自动 = '∞'
    else
        self.自动 = nil
    end
    self.对象.战斗自动 = self.自动
    if not self.菜单指令 then
        self.菜单指令 = self.对象.存档指令[1] or '物理'
        self.菜单目标 = self.对象.存档指令[2] or self:随机敌方存活目标()
        self.对象.战斗指令 = self.对象.存档指令[1] or '物理'
        self.对象.战斗目标 = self.对象.存档指令[2] or self:随机敌方存活目标()
    end
    local sum = self.战场:取对象(self.位置 + 5)
    if sum and not sum.菜单指令 then
        sum.菜单指令 = sum.对象.存档指令[1] or '物理'
        sum.菜单目标 = sum.对象.存档指令[2] or sum:随机敌方存活目标()
        sum.主人.战斗召唤指令 = sum.对象.存档指令[1] or '物理'
        sum.主人.战斗召唤目标 = sum.对象.存档指令[2] or sum:随机敌方存活目标()
    end
    if self.是否队长 then
        local 助战 = self.战场:取助战对象(self.位置)
        for i, v in pairs(助战) do
            if v then
                v.自动 = '∞'
            else
                v.自动 = nil
            end
            v.对象.战斗自动 = self.自动
            if not v.菜单指令 then
                v.菜单指令 = v.对象.存档指令[1] or '物理'
                v.菜单目标 = v.对象.存档指令[2] or v:随机敌方存活目标()
                v.对象.战斗指令 = v.对象.存档指令[1] or '物理'
                v.对象.战斗目标 = v.对象.存档指令[2] or v:随机敌方存活目标()
            end
            local sum = self.战场:取对象(v.位置 + 5)
            if sum and not sum.菜单指令 then
                sum.菜单指令 = sum.对象.存档指令[1] or '物理'
                sum.菜单目标 = sum.对象.存档指令[2] or sum:随机敌方存活目标()
                sum.主人.战斗召唤指令 = sum.对象.存档指令[1] or '物理'
                sum.主人.战斗召唤目标 = sum.对象.存档指令[2] or sum:随机敌方存活目标()
            end
        end
    end
    return self.自动, self.菜单指令, sum and sum.菜单指令
end

function 战斗对象:置指令(i, n, m) --菜单，或者脚本
    self.指令 = i
    self.目标 = n or self.目标
    self.选择 = m or self.选择
    if i == '物理' then
        if n == self.位置 then --不能自己
            self.目标 = 0
        end
    elseif i == '法术' then
        if not self.法术列表[m] then
            self.选择 = 0
        end
    elseif i == '保护' then
        if n ~= self.位置 then --不能自己
            self.保护 = self.目标
        end
    end
end

--===============================================================================
function 战斗对象:回合演算()
    local 数据 = require('战斗/回合数据')(self.位置)
    local 是否行动 = false

    if self.是否孩子 then
        local 主人 = self.战场:取对象(self.位置 - 10)
        -- 释放多目标门派技能, 并且孩子增强法术, 则喊话
        if 主人 and self.孩子法术增强喊话 and 主人.指令 == '法术' then
            local 法术名称 = 主人.法术列表[主人.选择].名称
            for k, _ in pairs(self.孩子增益) do
                if 多目标技能[k] then
                    for _k, v in pairs(多目标技能[k]) do
                        if v == 法术名称 then
                            数据:孩子喊话('看我的厉害#46')
                        end
                    end
                end
            end
        end
        是否行动 = true
        return 数据, 是否行动
    end

    if self.指令 ~= '召还' then
        if self.是否死亡 or self.ev:BUFF指令开始(self) == false then
            return 数据, 是否行动
        end
    end
    self:战斗指令开始(数据)
    self.ev:战斗指令开始(self, 数据)

    if self.指令 == "暗影离魂" then
        self:指令_暗影离魂攻击(数据)
        是否行动 = true
    elseif self.指令 == '防御' then -- 防御
        是否行动 = true
    elseif self.指令 == '物理' then --物理
        self:指令_物理攻击(数据)
        是否行动 = true
    elseif self.指令 == '法术' then --法术
        self:指令_使用法术(数据)
        是否行动 = true
    elseif self.指令 == '道具' then --道具
        self:指令_使用道具(数据)
        是否行动 = true
    elseif self.指令 == '召唤' then --召唤
        self:指令_召唤(数据)
        是否行动 = true
    elseif self.指令 == 'AI召唤' then --召唤
        self:指令_AI召唤(数据, self.召唤对象)
        是否行动 = true
    elseif self.指令 == '召还' then --召还
        self:指令_召还(数据)
        是否行动 = true
    elseif self.指令 == '捕捉' then --捕捉
        self:指令_捕捉(数据)
        是否行动 = true
    elseif self.指令 == '逃跑' then --逃跑
        self:指令_逃跑(数据)
        是否行动 = true
    end
    self.ev:战斗指令结束后(self, 数据)
    return 数据, 是否行动
end

function 战斗对象:战斗指令开始(数据)
    if self.指令 == '法术' then
        -- if self:是否PK() then
        local dst = self:所满足对象(
            function(v)
                if not v.是否死亡 and not self:是否我方(v) and (v:取BUFF("悬刃BUFF") or v:取BUFF("强化悬刃BUFF")) then
                    return true
                end
            end
        )
        if #dst > 0 then
            local 目标数据 = self.战场:指令开始()
            local BUFF = dst[1]:取BUFF("强化悬刃BUFF") and dst[1]:取BUFF("强化悬刃BUFF") or dst[1]:取BUFF("悬刃BUFF")
            local qx = BUFF:BUFF取效果(dst[1], self)
            dst[1]:删除BUFF("悬刃BUFF")
            dst[1]:删除BUFF("强化悬刃BUFF")
            self:减少气血(qx)
            数据:法术后(目标数据)
            self.战场:指令结束()
            for i, v in ipairs(dst) do
                v:删除BUFF("悬刃BUFF")
                v:删除BUFF("强化悬刃BUFF")
            end
        end

        local dst = self:所满足对象(
            function(v)
                if not v.是否死亡 and not self:是否我方(v) and (v:取BUFF("遗患BUFF") or v:取BUFF("强化遗患BUFF")) then
                    return true
                end
            end
        )
        if #dst > 0 then
            local 目标数据 = self.战场:指令开始()
            local BUFF = dst[1]:取BUFF("强化遗患BUFF") and dst[1]:取BUFF("强化遗患BUFF") or dst[1]:取BUFF("遗患BUFF")
            local qx = BUFF:BUFF取效果(dst[1], self)
            dst[1]:删除BUFF("遗患BUFF")
            dst[1]:删除BUFF("强化遗患BUFF")
            self:减少魔法(qx)
            数据:法术后(目标数据)
            self.战场:指令结束()
            for i, v in ipairs(dst) do
                v:删除BUFF("遗患BUFF")
                v:删除BUFF("强化遗患BUFF")
            end
        end
        -- end
        local dst = self:所满足对象(
            function(v)
                if not v.是否死亡 and not self:是否我方(v) and v:取BUFF("报复") and not v:取BUFF("封印") then
                    return true
                end
            end
        )
        if #dst > 0 then
            local BUFF = dst[1]:取BUFF("报复")
            local qx = BUFF:BUFF取效果(dst[1], self)
            if qx then
                local 目标数据 = self.战场:指令开始()
                self:减少气血(qx)
                数据:法术后(目标数据)
                dst[1]:删除BUFF(BUFF)
                self.战场:指令结束()
            end
        end

        local dst = self:所满足对象(
            function(v)
                if not v.是否死亡 and self:是否我方(v) and v:取BUFF("回源") and not v:取BUFF("封印") then
                    return true
                end
            end
        )
        if #dst > 0 then
            local BUFF = dst[1]:取BUFF("回源")
            if BUFF:BUFF取效果(dst[1], self) then
                local 目标数据 = self.战场:指令开始()
                local mf = math.floor(self.最大魔法 * 0.5)
                self:可视增加魔法(mf, 1)
                数据:魔法(mf, 2)
                self.当前数据.位置 = self.位置
                self.战场:指令结束()
            end
        end
    end
end

function 战斗对象:被驱逐(特效, 数据)
    self.是否逃跑 = true
    self.战场:退出(self.位置, true)
    数据:驱逐(特效, self.位置)
end

function 战斗对象:是否触发分裂(src, dst)
    if self.分裂触发 then
        return false
    elseif self.触发分裂 then
        return true
    elseif self.ev:BUFF分裂攻击(src, dst) then
        return true
    elseif self.抗性.分裂攻击 and math.random(100) <= self.抗性.分裂攻击 then
        return true
    end
    return false
end

function 战斗对象:删除隐身()
    local t = self:取BUFF("隐身")
    if t then
        self:删除BUFF(t)
        self.当前数据.位置 = self.位置
        self.是否隐身 = false
    end
end

--===============================================================================
function 战斗对象:指令_物理攻击(数据)
    self.分裂触发 = nil
    local 追加次数 = 0
    local 目标 = self:取物理目标()
    ::分裂攻击::
    ::追加普攻::
    if 目标 then
        local src = self:物理_生成对象('物理', 目标)
        数据.时长 = 数据.时长 + src.连击次数
        local dst = 目标
        local 水中探月
        if self.ev:水中探月计算(src, dst) then
            水中探月 = true
        end
        ::loop::
        local 天降流火
        if self.ev:天降流火计算(src, dst) then
            天降流火 = 1
        end
        local 目标数据 = self.战场:指令开始()
        self.ev:物理攻击前(src, dst)
        if self.ev:BUFF物理攻击前(src, dst, 数据) == false then
            return
        end
        self:删除隐身()
        if 水中探月 then
            self.ev:水中探月附加(src, dst)
            数据:水中探月法术("水中探月", 目标数据, dst.位置)
        else
            目标:被物理攻击(src, dst, 天降流火)
        end
        self.ev:物理攻击(src, dst)
        if 天降流火 == 1 then --目标.是否死亡 and
            天降流火 = 2
            self.ev:天降流火附加(src, dst)
        end
        if not 水中探月 then
            数据:物理攻击(目标.位置, 目标数据, 追加次数 ~= 0 and 1, 天降流火)
        end
        self.ev:物理攻击后(src, dst, 数据, src.伤害)
        self.战场:指令结束()
        -- 1打对面的，不管是否被混，都有附法
        -- 2打自己的，被混以后才附法
        if not src.躲避 then --附法
            if (self.ev:BUFF队友伤害(src, dst) ~= true and self:是否敌方(dst)) or (self.ev:BUFF队友伤害(src, dst) == true and self:是否我方(dst)) then
                local list = {}
                for k, v in pairs(self.法术列表) do
                    if v.是否特殊物理法术 then
                        table.insert(list, v)
                    end
                end
                if #list > 0 then
                    local 法术 = list[math.random(#list)]
                    local 目标数据 = self.战场:指令开始()
                    if 法术:特殊物理法术(src, dst) then
                        法术:特殊物理法术附加(src, dst)
                        数据:特殊物理法术(法术.名称, 目标数据, dst.位置)
                    end
                    self.战场:指令结束()
                end

                if not 目标.是否死亡 then
                    if self.ev:临风剑意计算(src, dst) then
                        local 目标数据 = self.战场:指令开始()
                        self.ev:临风剑意附加(src, dst)
                        数据:无特效物理法术(目标数据)
                        self.战场:指令结束()
                    end
                end

                local list = {}
                for k, v in pairs(self.附法列表) do --属性
                    if v:是否触发(src) then
                        table.insert(list, v)
                    end
                end
                for k, v in pairs(self.法术列表) do --内丹
                    if v.是否物理法术 then
                        table.insert(list, v)
                    end
                end
                if #list > 0 then
                    local 法术 = list[math.random(#list)]
                    local 目标数据2 = self.战场:指令开始()
                    if 法术:物理法术(src, dst) then
                        if 法术.物理法术附加 then
                            法术:物理法术附加(src, dst, 数据)
                        end
                        数据:物理法术(法术.id, 目标数据2)
                    end
                    self.战场:指令结束()
                end
            end
        end
        local 最大连击 = self:最大连击次数()
        if 最大连击 and src.连击次数 > 最大连击 then
            src.连击次数 = 最大连击
        end
        if not self.是否死亡 and not 目标.是否死亡 and not 目标:取BUFF("封印") and not src.防止连击 and src.连击次数 > 0 then
            if self.ev:连击开始前(src, dst) then
                self.目标 = self:随机敌方存活目标()
                目标 = self:取物理目标()
                dst = 目标
                local 连击 = src.连击次数
                src = self:物理_生成对象('物理', dst)
                src.连击次数 = 连击
            end

            self.触发连击 = true
            src:物理_计算连击(dst)
            goto loop
        end
        目标.涅槃重生 = nil
        self.触发连击 = nil
        if not src.躲避 and not 目标.是否死亡 and self.ev:物理攻击结束(src, dst) and (not self:是否我方(dst) or self.ev:BUFF队友伤害(src, dst)) then
            local 目标数据 = self.战场:指令开始()
            local 名称 = self.ev:物理攻击结束附加(src, dst)
            数据:特殊物理法术(名称, 目标数据, dst.位置)
            self.战场:指令结束()
        end
        if not src.躲避 and self.ev:物理攻击追加(src, dst) and 追加次数 < 3 and (not self:是否我方(dst) or self.ev:BUFF队友伤害(src, dst)) then
            local mb = self:敌方属性排列(
                1,
                function(v)
                    if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') and (not dst or dst ~= v) then
                        return true
                    end
                end,
                function(a, b)
                    return a.气血 < b.气血
                end
            )

            if mb[1] then
                self.目标 = mb[1]
                目标 = self:取物理目标()
                追加次数 = 追加次数 + 1
                goto 追加普攻
            end
        end
    end

    if not self.是否死亡 and self:是否触发分裂(src, dst) and self:取敌方存活数() then
        目标 = self:随机取物理目标()
        local t = {}
        t[self.位置] = { 位置 = self.位置 }
        self.分裂触发 = true
        数据:特效(2643, t)
        goto 分裂攻击
    end
end

function 战斗对象:取技能对象()
    for k, v in pairs(self.法术列表) do
        if v.名称 == "暗影离魂" or v.名称 == "大圣神通" then
            return v
        end
    end
end

function 战斗对象:指令_暗影离魂攻击(数据) --就是暗影离魂
    print("暗影离魂攻击")
    self.分裂触发 = nil
    local 禁止连击
    local src = setmetatable({
        伤害类型 = "",
    }, { __index = self, __newindex = self })
    ::分裂攻击::
    local 法术 = self:取技能对象()
    local 目标数 = 法术:法术取目标数(self)
    local dst = self:取群体物理目标(目标数)
    if #dst > 0 then
        local 目标数据 = self.战场:指令开始()
        local list = {}
        for i, v in ipairs(dst) do
            v.被连击次数 = 0
            if math.random(80) <= (src.连击率 - v.抗连击率) then
                v.被连击次数 = src.连击次数
            end
            v.被连击次数 = math.random(1, 7)
            list[i] = { 连击次数 = 0, 位置 = v.位置 }
        end
        数据:暗影离魂攻击(list, 目标数据)
        for i, v in ipairs(dst) do
            ::loop::
            if self.ev:BUFF物理攻击前(src, v, 数据) == false then
                return
            end
            self:暗影离魂_计算伤害(src, v)
            self.ev:物理攻击(src, v, 数据, i)
            v:被物理攻击(src)
            if i == 1 then
                self.ev:物理攻击后(src, v, 数据, src.伤害)
            end
            if not src.躲避 and ((self:是否敌方(v) and not self.ev:BUFF队友伤害(src, v)) or (self.ev:BUFF队友伤害(src, v) == true and self:是否我方(v))) then --附法
                local list = {}

                for k, x in pairs(self.法术列表) do
                    if x.是否物理法术 then
                        table.insert(list, x)
                    end
                end
                for k, x in pairs(self.附法列表) do -- 属性
                    if x:是否触发(src) then
                        table.insert(list, x)
                    end
                end

                if #list > 0 then
                    local 法术 = list[math.random(#list)]
                    local 目标数据2 = self.战场:指令开始()

                    if 法术:物理法术(src, v) then
                        if 法术.物理法术附加 then
                            法术:物理法术附加(src, v, 数据)
                        end
                        数据:群体理法术(法术.id, 目标数据2)
                    end


                    self.战场:指令结束()
                end
            end
            if not self.是否死亡 and not v.是否死亡 and not v:取BUFF("封印") and not src.防止连击 and v.被连击次数 and v.被连击次数 > 0 and not 禁止连击 and not v.涅槃重生 then
                v.被连击次数 = v.被连击次数 - 1
                list[i].连击次数 = list[i].连击次数 + 1
                goto loop
            end
            v.涅槃重生 = nil
            v.被连击次数 = nil
        end
        self.战场:指令结束()
    end
    if not self.是否死亡 and self:是否触发分裂(src, dst) and self:取敌方存活数() then
        目标 = self:随机取物理目标()
        local t = {}
        t[self.位置] = { 位置 = self.位置 }
        self.分裂触发 = true
        数据:特效(2643, t)
        goto 分裂攻击
    end
    if self.是否隐身 then
        local 目标数据 = self.战场:指令开始()
        self:删除隐身()
        self.战场:指令结束()
        数据:法术后(目标数据)
    end
end

function 战斗对象:暗影离魂_计算伤害(src, dst)
    local 伤害, 狂暴, 致命 = 0, false, false
    伤害 = (src.攻击 - src.装备属性.附加攻击) * (1 + src.加成攻击 * 0.01) + src.装备属性.附加攻击
    伤害 = 伤害 - dst.装备属性.防御值 - (dst.抗性.防御值 or 0)
    local 忽视物理吸收 = self.ev:BUFF取忽视物理吸收(self, dst) or 0
    if math.random(100) <= src.忽视防御几率 then
        伤害 = 伤害 * (1 - (dst.物理吸收 - 忽视物理吸收 - src.忽视防御程度) * 0.01)
    else
        伤害 = 伤害 * (1 - (dst.物理吸收 - 忽视物理吸收) * 0.01)
    end
    src.初始伤害 = 伤害
    伤害, 狂暴, 致命 = src:物理_计算狂暴致命(dst, src.初始伤害)
    if dst.指令 == '防御' then
        伤害 = 伤害 * 0.5
    end
    伤害 = self.ev:BUFF伤害最终计算(self, dst, 伤害) or 伤害
    src.伤害 = math.floor(伤害)
    if src.伤害 < 1 then src.伤害 = 1 end
    src.狂暴 = 狂暴
    src.致命 = 致命
    return t
end

function 战斗对象:置重复操作()
    if self.战场.新增对象 == nil then
        self.战场.新增对象 = {}
    end
    self.战场.新增对象[#self.战场.新增对象 + 1] = self
end

function 战斗对象:指令_使用法术(数据)
    local 法术 = self.法术列表[self.选择]
    if type(法术) == 'table' and 法术.是否主动 then
        self.当前法术 = 法术
        local dst = self:取法术目标()
        local src = self:法术_生成对象('法术', dst)
        数据.时长 = 数据.时长 + src.连击次数
        ::loop::
        if self.ev:BUFF法术施放前(src, dst, 法术, 数据) == false then
            return
        end
        if self.ev:法术施放前(src, dst, 法术, 数据) == false then
            return
        end

        -- 背水一战 物理攻击法术
        if type(法术) == 'table' and 法术.物攻法术 then
            self:指令_物理攻击(数据)
            self.战场:指令结束()
            local 目标数据2 = self.战场:指令开始()
            self.ev:法术施放后(src, dst, 法术, self)
            ---
            数据:法术后(目标数据2)
            return
        end
        if dst[1] and dst[1].是否死亡 and not 法术.死活可用 then
            return
        elseif dst[1] and (dst[1].是否隐身 and not self.ev:无视隐身()) and #dst == 1 then
            return
        elseif #dst == 0 then
            return
        end
        local 目标数据 = self.战场:指令开始()
        self:删除隐身()
        local r = 法术:法术施放(src, dst)
        self.战场:指令结束()
        local 禁止连击
        if r ~= false then
            数据:法术(法术.id, 目标数据)
            if src.法术类型 ~= '连击' then
                local 目标数据2 = self.战场:指令开始()
                self.ev:法术施放后(src, dst, 法术, self)
                数据:法术后(目标数据2)
                -- self.ev:法术施放后(src, dst)
                self.战场:指令结束()
            end
        else
            数据:法术后(目标数据)
            禁止连击 = true
        end
        if self.ev:蜃光流星计算(src, dst[1]) then
            local 目标数据 = self.战场:指令开始()
            local 目标排序 = {}
            local 首个位置 = {}
            for i = 1, #dst do
                if self.ev:蜃光流星计算(src, dst[i], i) then
                    local 名称, s = self.ev:蜃光流星计附加(src, dst[i])
                    if #s > 0 then
                        目标排序[i] = s
                        首个位置[i] = dst[i].位置
                    end
                end
            end
            数据:蜃光流星法术(名称, 目标数据, 目标排序, 首个位置)
            self.战场:指令结束()
        end
        if not self.是否死亡 and self:取敌方存活数() > 0 and src.连击次数 > 0 and not 禁止连击 then
            --src:物理_计算连击(dst)
            src.伤害衰减 = src.伤害衰减 + 1
            src.法术类型 = '连击'
            src.连击次数 = src.连击次数 - 1
            goto loop
        end
    end
end

function 战斗对象:指令_使用道具(数据)
    local 道具
    local 主人 = false
    if self.是否玩家 then
        道具 = self.对象.物品[self.选择]
    elseif self.是否召唤 then
        道具 = self.对象.主人.物品[self.选择]
    end
    local 目标 = self.战场:取对象(self.目标)
    if type(道具) == 'table' and 目标 then
        if 目标.主人 == self.对象 then
            主人 = true
        end
        if not 道具.战斗是否可用 then
            return
        end
        if 目标.是否玩家 and not 道具.人物是否可用 then
            return
        end
        if 目标.是否召唤 and not 道具.召唤是否可用 then
            return
        end
        self.当前物品 = 道具
        if self.ev:BUFF物品使用前(self, 目标) == false then
            return
        end

        local 目标数据 = self.战场:指令开始()
        self:删除隐身()
        目标:被使用道具(self, 道具, 主人)
        --self.ev:使用道具后(数据,self,目标)
        数据:道具(目标数据)
        self.战场:指令结束()
    end
end

function 战斗对象:指令_AI召唤(数据, 召唤)
    for i, v in ipairs(召唤) do
        if v.召唤位置 then
            local 野怪 = self.战场:加入(v.召唤位置, v)
            野怪:战斗开始()
            数据:召唤(野怪:取数据(1))
        end
    end
end

function 战斗对象:添加内丹BUFF(数据)
    if self.内丹列表[1] then
        数据:添加BUFF(1307, self.位置)
    end
end

function 战斗对象:指令_召唤(数据)
    local v = self.召唤列表[self.目标]
    if v and v:取是否可参战() and not v.战斗已上场 then
        self.目标 = nil
        v.战斗已上场 = true

        if self.战场:取对象(self.位置 + 5) then
            self.战场:退出(self.位置 + 5)
        end

        local 召唤 = self.战场:加入(self.位置 + 5, v)
        召唤:战斗开始()
        数据:召唤(召唤:取数据())
        召唤.ev:召唤进入战斗(self, 数据, 召唤)
        self.对象.参战召唤 = v
        召唤:添加内丹BUFF(数据)
        self.ev:BUFF召唤结束后(self, 召唤, 数据)
    end
end

function 战斗对象:指令_召还(数据)
    self.对象.参战召唤 = nil
    local 召唤 = self.战场:退出(self.位置 + 5)
    数据:召还(self.位置 + 5)
end

function 战斗对象:指令_捕捉(数据)
    local 目标 = self.战场:取对象(self.目标)
    if 目标 and not 目标.是否死亡 and 目标.是否怪物 and 目标.可以捕捉 then
        local src = self
        src.成功率 = 30
        if gge.isdebug then
            src.成功率 = 100
        end
        --self.ev:捕捉事件(数据, src, 目标)
        local 结果 = math.random(100) <= src.成功率
        if 结果 then
            local 召唤 = __沙盒.生成召唤 { 名称 = 目标.原名, 等级 = 目标.等级, 宝宝 = 目标.宝宝, 捕捉 = true }
            if 召唤 then
                if self.对象:剧情称谓是否存在(召唤.携带) then
                    self.对象:召唤_添加(召唤)
                    self.战场:退出(目标.位置)
                else
                    结果 = false
                    self.对象.rpc:常规提示("#Y该召唤兽需要" .. 召唤.携带 .. "才可以捕捉！")
                end
            end
        end
        数据:捕捉(目标.位置, 结果)
    else
        数据:捕捉(false)
    end
end

function 战斗对象:指令_逃跑(数据)
    local src = self
    src.成功率 = 50
    if gge.isdebug then
        src.成功率 = 100
    end
    -- --特效迷踪
    -- self.ev:逃跑事件(数据, src)
    self.是否逃跑 = math.random(100) <= src.成功率
    if self.是否逃跑 then
        self.战场:退出(self.位置)

        if self.是否玩家 then
            self.战场:退出(self.位置 + 5) -- 召唤兽
            self.战场:退出(self.位置 + 10) -- 孩子
        end
    end
    数据:逃跑(self.是否逃跑)
end

function 战斗对象:置接收数据(data)
    if data then
        table.insert(self.回合数据, 1, data)
    else
        table.remove(self.回合数据, 1)
    end
    self.当前数据 = self.回合数据[1]
end

function 战斗对象:物理_计算连击(dst)
    assert(self.伤害类型, '错误')
    self.连击次数 = self.连击次数 - 1
    self.初始伤害 = math.floor(self.初始伤害 * 0.75)
    local 伤害, 狂暴, 致命 = self:物理_计算狂暴致命(dst, self.初始伤害)
    if dst.指令 == '防御' then
        伤害 = 伤害 * 0.5
    end
    self.伤害 = math.floor(伤害)
    self.狂暴 = 狂暴
    self.致命 = 致命
end

function 战斗对象:物理_生成对象(类型, dst)
    local t = setmetatable({
        伤害类型 = 类型,
        初始伤害 = 0,
        伤害 = 0,
        魔法伤害 = 0,
        伤害衰减 = 0,
        躲避 = false,
        致命 = false,
        狂暴 = false,
        连击次数 = 0,
        反击次数 = 0
    }, { __index = self, __newindex = self })

    if 类型 == '反震' then
        -- 我自岿然-护身符特技之一  特技效果：物理和师门法术造成的反震效果减半
        t.伤害 = math.floor(dst.伤害 * self.反震程度 * 0.01 - dst.抗反震)
        return t
    end
    local src = self
    if 类型 ~= '反击' and not src.孩子增益.破甲 and not src.孩子增益.嗜血狂攻 and math.random(100) <= dst.躲闪率 - src.忽视躲闪率 - src.命中率 then
        t.躲避 = true
        return t
    end

    local 伤害, 狂暴, 致命 = 0, false, false
    伤害 = (src.攻击 - src.装备属性.附加攻击) * (1 + src.加成攻击 * 0.01) + src.装备属性.附加攻击
    伤害 = 伤害 - dst.装备属性.防御值 - (dst.抗性.防御值 or 0)
    -- 如果src存在buff 大势锤 无视dst物理吸收
    local 忽视物理吸收 = self.ev:BUFF取忽视物理吸收(self, dst) or 0
    if math.random(100) <= src.忽视防御几率 then
        伤害 = 伤害 * (1 - (dst.物理吸收 - 忽视物理吸收 - src.忽视防御程度) * 0.01)
    else
        伤害 = 伤害 * (1 - (dst.物理吸收 - 忽视物理吸收) * 0.01)
    end
    t.初始伤害 = 伤害
    伤害, 狂暴, 致命 = t:物理_计算狂暴致命(dst, t.初始伤害)
    if dst.指令 == '防御' then
        伤害 = 伤害 * 0.5
    end
    if math.random(80) <= (src.连击率 - dst.抗连击率) then
        t.连击次数 = src.连击次数
        -- 牵制(高级技能) 技能效果：具有此技能的召唤兽在场时，敌方所有人物的连击次数不超过3次(不计算第一次攻击，仅限玩家之间PK时使用)。注意事项：召唤兽被封印，技能仍生效。
    end
    if 类型 == "物理" and t.连击次数 == 0 then
        t.连击次数 = self.ev:取是否连击() or 0
    end
    local 最大连击 = self:最大连击次数()
    if 最大连击 and t.连击次数 > 最大连击 then
        t.连击次数 = 最大连击
    end

    if 类型 ~= '反击' then
        if math.random(80) <= (dst.反击率 - src.忽视反击率) then
            t.反击次数 = math.random(dst.反击次数)
        end
        -- if dst.反击率 - src.忽视反击率 >= 100 then
        --     t.反击次数 = math.random(dst.反击次数)
        -- else
        --     for i = 1, dst.反击次数 do
        --         if math.random(100) <= (dst.反击率 - src.忽视反击率) then
        --             t.反击次数 = t.反击次数 + 1
        --         end
        --     end
        -- end
    end

    伤害 = self.ev:BUFF伤害最终计算(self, dst, 伤害) or 伤害
    t.伤害 = math.floor(伤害)
    t.狂暴 = 狂暴
    t.致命 = 致命
    return t
end

function 战斗对象:法术_生成对象(类型, dst)
    local t = setmetatable(
        {
            法术类型 = 类型 or '',
            连击次数 = 0,
            伤害衰减 = 0,
            伤害 = 0,
            魔法伤害 = 0,
            初始伤害 = 0,
            狂暴 = false
        },
        { __index = self, __newindex = self }
    )
    if self.法术连击几率 and self.法术连击次数 and self.法术连击几率 >= math.random(100) then
        local cs = math.floor(self.法术连击几率 / 100 * self.法术连击次数)
        t.连击次数 = cs
    end
    if t.连击次数 == 0 then
        t.连击次数 = self.ev:取是否三连击() or 0
    end
    if t.连击次数 == 0 then
        t.连击次数 = self.ev:取是否连击() or 0
    end

    return t
end

function 战斗对象:播放特效(id, 位置)
    local 数据 = self.当前数据
    数据:特效(id, 位置)
end

function 战斗对象:最大连击次数()
    if self:是否PK() then
        local dst = self:所满足对象(
            function(v)
                if not v.是否死亡 and not self:是否我方(v) and v:取BUFF("牵制") then
                    return true
                end
            end
        )
        if #dst > 0 then
            return 3
        end
    end
end

--=========================================================================
function 战斗对象:物理_计算BUFF(dst, 伤害)
    assert(self.伤害类型, '错误')
    --如果挨打方存在BUFF 千松扫尾 伤害=伤害*1.2
end

function 战斗对象:物理_计算狂暴致命(dst, 伤害)
    assert(self.伤害类型, '错误')
    local 狂暴, 致命 = false, false
    狂暴 = math.random(80) <= self.狂暴几率
    致命 = math.random(80) <= (self.致命几率 - dst.抗致命几率)
    if 狂暴 and 致命 then
        if math.random(2) == 1 then
            伤害 = 伤害 * 1.5 + dst.装备属性.防御值
            致命 = false
        else
            伤害 = 伤害 * 1.5 + dst.气血 * 0.1
            狂暴 = false
        end
    elseif 狂暴 then
        伤害 = 伤害 * 1.5 + dst.装备属性.防御值
    elseif 致命 then
        伤害 = 伤害 * 1.5 + dst.气血 * 0.1
    end
    return 伤害, 狂暴, 致命
end

function 战斗对象:物理_生成保护()
    assert(self.伤害类型, '错误')
    local t = {}
    for k, v in pairs(self) do
        t[k] = v
    end
    t.伤害类型 = '保护'
    t.躲避 = false
    t.伤害 = t.伤害 // 2 --伤害平分两个人
    self.伤害 = t.伤害
    setmetatable(t, getmetatable(self))
    return t
end

--=========================================================================
local _怨气类别 = {
    门派 = true,
}

function 战斗对象:被物理攻击(src, dst, 天降流火)
    local 数据 = self.当前数据
    local 怨气
    数据.位置 = self.位置
    if self.是否死亡 or self.是否无敌 or self.ev:BUFF被物理攻击前(src, self) == false then
        return 数据
    end
    self.ev:受到伤害前(src, self, 数据)
    self.ev:BUFF受到伤害前(src, dst, 数据)
    if self.ev:物理免疫(src, dst, 数据) then
        return 数据
    end
    -- self.ev:被物理攻击前(src, dst)
    if src.伤害类型 == '物理' and self:是否敌方(src) then
        for _, v in self:遍历我方存活() do
            if not v.已保护 and v.保护 == self.位置 and not src.禁保护 and not src.ev:禁止保护(src) then
                if v:能否保护() then
                    v.已保护 = true
                    local 保护数据 = self.战场:指令开始()
                    local src2 = src:物理_生成保护()
                    v:被物理攻击(src2)
                    数据.保护 = 保护数据[v.位置]
                    v.保护 = nil
                    self.战场:指令结束()
                    break
                end
            end
        end
    end
    local 实际伤害 = self.ev:BUFF气血伤害(src, self) or src.伤害
    if src.伤害类型 == "反震" then
        self.ev:反震前(dst or self, src, 实际伤害)
    end
    local 魔法伤害 = self.ev:BUFF魔法伤害(src, self) or src.魔法伤害
    if self.ev:BUFF队友伤害(src, dst) ~= true and self:是否我方(src) then
        实际伤害 = 1
    end

    -- 先判断孩子 金刚护体 or 铁布衫 如果存在则不计算躲避,直接返回
    if self.孩子增益.金刚护体 then
        if self.孩子增益.金刚护体 >= 1 then
            实际伤害 = 0
            self.孩子增益.金刚护体 = self.孩子增益.金刚护体 - 1
            self:触发孩子喊话('看我的#G金刚护体#46')

            return 数据
        end
    elseif self.孩子增益.铁布衫 then
        if self.孩子增益.铁布衫 >= 1 then
            实际伤害 = 0
            self.孩子增益.铁布衫 = self.孩子增益.铁布衫 - 1
            self:触发孩子喊话('看我的#G铁布衫#46')

            return 数据
        end
    end
    local 物伤转增加 = false
    if not src.躲避 then
        怨气 = 25
        if self.ev:物伤转增加(self, src) then
            if 魔法伤害 and 魔法伤害 > 0 then
                self:可视增加魔法(魔法伤害)
            end
            if 实际伤害 > 0 then
                if 实际伤害 > self.气血 then
                    实际伤害 = self.气血
                end
                self.气血 = self.气血 + 实际伤害
                if self.气血 > self.最大气血 then
                    self.气血 = self.最大气血
                end
            else
                实际伤害 = 1
                self.气血 = self.气血 + 实际伤害
                if self.气血 > self.最大气血 then
                    self.气血 = self.最大气血
                end
            end
            物伤转增加 = true
        else
            if 魔法伤害 and 魔法伤害 > 0 then
                self:可视减少魔法(魔法伤害)
            end
            if 实际伤害 > 0 then
                if 实际伤害 > self.气血 then
                    实际伤害 = self.气血
                end
                self.气血 = self.气血 - 实际伤害
            else
                实际伤害 = 1
                self.气血 = self.气血 - 实际伤害
            end
        end
    end

    -- self.ev:被物理攻击后(src, dst)
    self.ev:BUFF被物理攻击后(src, dst)
    local 反击数据, 反震数据, 法反数据 --有保护的情况下不会触发反震、反击
    if not 数据.保护 and not src.禁反震 and not src.躲避 and src.伤害类型 == '物理' and math.random(100) <= self.反震率 then
        反震数据 = self.战场:指令开始()
        local src2 = self:物理_生成对象('反震', src)
        src:被物理攻击(src2)
        self.战场:指令结束()
    end

    if self.气血 > 0 then
        if not 数据.保护 and src.伤害类型 == '物理' and not src.禁反击 then
            if src.反击次数 > 0 then
                反击数据 = self.战场:指令开始()
                local src2 = self:物理_生成对象('反击', src)
                src:被物理攻击(src2)
                src.反击次数 = src.反击次数 - 1
                self.战场:指令结束()
            end
            local list = {}
            for k, v in pairs(self.法反列表) do --属性
                if v:是否触发(src, dst) then
                    table.insert(list, v)
                end
            end
            if #list > 0 and not self.是否死亡 then
                local 法术 = list[math.random(#list)]
                法反数据 = self.战场:指令开始()
                local src2 = self:法术_生成对象('反击', dst)
                if src2 then
                    法术:法术反击(src2, src)
                    src:被法术攻击(src2, 法术)
                end
                self.战场:指令结束()
            end
        end
    else
        self.气血 = 0
        self.是否死亡 = true --要计回合数，所以0
    end
    if 怨气 then
        self:增加怨气(怨气)
    end
    src.ev:攻击添加BUFF(src, self)
    if self.是否死亡 then
        if self.ev:BUFF死亡处理(src, dst) then
            local 目标数据 = self.战场:指令开始()
            self.ev:BUFF死亡处理结果(src, dst)
            self.战场:指令结束()
            数据:法术后(目标数据)
        end
    end

    local d = 数据:物理伤害(实际伤害, self.指令 == '防御', self.是否死亡, self.是否消失, nil, 天降流火)
    if src.躲避 then
        d.躲避 = true
    elseif src.致命 then
        d.类型 = '致命'
    elseif src.狂暴 then
        d.类型 = '狂暴'
    end
    d.物伤转增加 = 物伤转增加
    if 反震数据 then
        d.反震 = 反震数据[src.位置]
    end

    if 反击数据 then
        数据:物理反击(反击数据[src.位置])
    end
    if 法反数据 then
        数据:法术反击(法反数据[src.位置])
    end
    --没这技能- -  这个肯定无所谓 复制过来了
    if self.是否死亡 and self.是否消失 then
        if self.是否召唤 then
            self.对象:死亡处理()
            self:召唤兽死亡处理()
        end
        self.战场:退出(self.位置)
        self.ev:召唤离场(self, 数据, src)
        local r = self:取主人()
        if r and r.是否玩家 then
            if next(r.支援列表) then
                for i, n in ipairs(r.支援列表) do
                    local v = r:取指定召唤兽(n)
                    if v and not v.战斗已上场 and self:取是否闪现(v) then
                        local bb = r:取召唤信息(r.位置 + 5)
                        if bb then
                            bb.指令 = nil
                        end
                        r.目标 = nil
                        v.战斗已上场 = true
                        local 召唤 = r.战场:加入(r.位置 + 5, v)
                        召唤:战斗开始("召唤")
                        数据:召唤(召唤:取数据())
                        召唤.ev:召唤进入战斗(r, 数据, 召唤, "闪现")
                        数据:目标添加特效(2151, r.位置 + 5)
                        r.对象.参战召唤 = v
                        self.ev:BUFF召唤结束后(self, 召唤, 数据)
                        break
                    end
                end
            else
                for _, v in pairs(r.召唤列表) do
                    if not v.战斗已上场 and self:取是否闪现(v) then
                        local bb = r:取召唤信息(r.位置 + 5)
                        if bb then
                            bb.指令 = nil
                        end
                        r.目标 = nil
                        v.战斗已上场 = true
                        local 召唤 = r.战场:加入(r.位置 + 5, v)
                        召唤:战斗开始("召唤")
                        数据:召唤(召唤:取数据())
                        召唤.ev:召唤进入战斗(r, 数据, 召唤, "闪现")
                        数据:目标添加特效(2151, r.位置 + 5)
                        r.对象.参战召唤 = v
                        self.ev:BUFF召唤结束后(self, 召唤, 数据)
                        break
                    end
                end
            end
        end
    end
    src.禁反震 = nil
    src.禁反击 = nil
    src.禁保护 = nil

    return 数据
end

function 战斗对象:召唤兽死亡处理()
    for i, v in self:遍历我方召唤() do
        v.ev:添加属性(v)
    end
end

function 战斗对象:取是否闪现(v)
    local 闪现几率 = 0 + (v.抗性.闪现几率 or 0)
    if v:取技能是否存在("闪现") or v:取技能是否存在("大隐于朝") or v:取技能是否存在("鬼神莫测") or v:取技能是否存在("神出鬼没")
        or v:取技能是否存在("义之金叶神") or v:取技能是否存在("仁之木叶神") or v:取技能是否存在("信之土叶神") or v:取技能是否存在("智之水叶神") or v:取技能是否存在("礼之火叶神")
    then
        闪现几率 = 闪现几率 + 30
    end
    if math.random(100) <= 闪现几率 then
        return true
    end
end

function 战斗对象:被法术攻击(src, 技能)
    local 数据 = self.当前数据
    local 怨气
    数据.位置 = self.位置
    if src.法术类型 == "反击" and 技能 then
        数据.id = 技能.id
    end
    if self.是否死亡 or self.是否无敌 or self.ev:BUFF被法术攻击前(src, self) == false then
        return
    end
    self.ev:受到伤害前(src, self, 数据)
    self.ev:BUFF受到伤害前(src, dst, 数据)
    self.ev:被法术攻击前(src, self)
    if (技能.是否仙法 or 技能.是否鬼法) and self.ev:法术免疫(src, dst, 数据) then
        return 数据
    end
    local 实际伤害 = self.ev:BUFF气血伤害(src, self) or src.伤害
    local 魔法伤害 = self.ev:BUFF魔法伤害(src, self) or src.魔法伤害
    -- self.ev:BUFF血伤转法伤(src, self, 实际伤害, 魔法伤害)
    -- self.ev:BUFF法伤转血伤(src, self, 魔法伤害, 实际伤害)
    local 实际伤害 = 实际伤害
    if 实际伤害 then
        实际伤害 = math.floor(实际伤害)
    end
    local 魔法伤害 = 魔法伤害
    if 魔法伤害 then
        魔法伤害 = math.floor(魔法伤害)
    end
    -- 孩子技能 伤害吸收 触发
    if 技能.是否仙法 then
        if 实际伤害 == 0 then
            return 数据
        end
    end
    local 法伤转增加
    if self.ev:法伤转增加(self, src) then
        self.气血 = self.气血 + 实际伤害
        if self.气血 > self.最大气血 then
            self.气血 = self.最大气血
        end
        法伤转增加 = true
        if 魔法伤害 and 魔法伤害 > 0 then
            -- 孩子技能 定心咒 龙神心法
            if self.孩子增益.定心咒 then
                self:触发孩子喊话('看我的#G定心咒#46')
            elseif self.孩子增益.龙神心法 then
                self:触发孩子喊话('看我的#G龙神心法#46')
            else
                self:可视增加魔法(魔法伤害)
            end
        end
    else
        self.气血 = self.气血 - 实际伤害
        if 魔法伤害 and 魔法伤害 > 0 then
            -- 孩子技能 定心咒 龙神心法
            if self.孩子增益.定心咒 then
                self:触发孩子喊话('看我的#G定心咒#46')
            elseif self.孩子增益.龙神心法 then
                self:触发孩子喊话('看我的#G龙神心法#46')
            else
                self:可视减少魔法(魔法伤害)
            end
        end
    end
    self.ev:BUFF被法术攻击后(src, self)
    if self.气血 > 0 then

    else
        self.气血 = 0
        self.是否死亡 = true
    end
    local 反震数据 --有保护的情况下不会触发反震、反击
    if 技能 and 技能.是否仙法 and math.random(100) <= self.反震率 then
        反震数据 = self.战场:指令开始()
        local src2 = self:物理_生成对象('反震', src)
        src:被物理攻击(src2)
        self.战场:指令结束()
    end
    if 技能 and _怨气类别[技能.类别] then
        怨气 = 25
        self:增加怨气(怨气)
    end
    if self.是否死亡 then
        if self.ev:BUFF死亡处理(src, self) then
            local 目标数据 = self.战场:指令开始()
            self.ev:BUFF死亡处理结果(src, self)
            self.战场:指令结束()
            数据:法术后(目标数据)
        end
    end
    local d = 数据:法术伤害(实际伤害, self.是否死亡, self.是否消失, self.狂暴, self.怨气)
    if 反震数据 then
        d.反震 = 反震数据[src.位置]
    end
    d.法伤转增加 = 法伤转增加
    if self.是否死亡 then
        if self.是否消失 then
            if self.是否召唤 then
                self.对象:死亡处理()
                self:召唤兽死亡处理()
            end
            self.战场:退出(self.位置)
            self.ev:召唤离场(self, 数据, src)
            local r = self:取主人()
            if r and r.是否玩家 then
                if next(r.支援列表) then
                    for i, n in ipairs(r.支援列表) do
                        local v = r:取指定召唤兽(n)
                        if v and not v.战斗已上场 and self:取是否闪现(v) then
                            local bb = r:取召唤信息(r.位置 + 5)
                            if bb then
                                bb.指令 = nil
                            end
                            r.目标 = nil
                            v.战斗已上场 = true
                            local 召唤 = r.战场:加入(r.位置 + 5, v)
                            召唤:战斗开始("召唤")
                            数据:召唤(召唤:取数据())
                            召唤.ev:召唤进入战斗(r, 数据, 召唤, "闪现")
                            数据:目标添加特效(2151, r.位置 + 5)
                            r.对象.参战召唤 = v
                            self.ev:BUFF召唤结束后(self, 召唤, 数据)
                            break
                        end
                    end
                else
                    for _, v in pairs(r.召唤列表) do
                        if not v.战斗已上场 and self:取是否闪现(v) then
                            local bb = r:取召唤信息(r.位置 + 5)
                            if bb then
                                bb.指令 = nil
                            end
                            r.目标 = nil
                            v.战斗已上场 = true
                            local 召唤 = r.战场:加入(r.位置 + 5, v)
                            召唤:战斗开始("召唤")
                            数据:召唤(召唤:取数据())
                            召唤.ev:召唤进入战斗(r, 数据, 召唤, "闪现")
                            数据:目标添加特效(2151, r.位置 + 5)
                            r.对象.参战召唤 = v
                            self.ev:BUFF召唤结束后(self, 召唤, 数据)
                            break
                        end
                    end
                end
            end
        end
    end
    src.ev:攻击添加BUFF(src, self)
end

function 战斗对象:被使用法术(src, 技能)
    local 数据 = self.当前数据
    local 怨气 = 25
    数据.位置 = self.位置
    if 技能 and _怨气类别[技能.类别] then
        self:增加怨气(怨气)
        数据.怨气 = self.怨气
    end
end

function 战斗对象:被物理法术(src, 法术)
    local 数据 = self.当前数据
    数据.位置 = self.位置
end

function 战斗对象:被使用道具(来源, 道具, 主人)
    local 数据 = self.当前数据
    数据.位置 = self.位置
    self.ev:被使用道具前(self, 数据, 来源)
    local 之前气血 = self.气血 + 0
    道具:使用(self, 来源)
    if self.气血 > 0 then
        self.是否死亡 = false
    end
    if 主人 and self.气血 > 之前气血 then
        self.增加亲密 = self.增加亲密 + 1
    end
    self.ev:被使用道具后(self, 数据, 来源)
    return 数据
end

function 战斗对象:逃跑()
    local 数据 = self.当前数据
    self.战场:退出(self.位置)
    数据:逃跑(true)
end

--=====================================
return 战斗对象
