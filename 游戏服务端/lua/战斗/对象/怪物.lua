local 怪物 = class('怪物', require('对象/召唤/召唤'))
local _附法技能 = {
    附水攻击 = true,
    附火攻击 = true,
    附风攻击 = true,
    附雷攻击 = true,
    附混乱攻击 = true,
    附加震慑攻击 = true,
    附加毒攻击几率 = true,
}
local _释放法术 = {
    被攻击时释放魔神附身 = true,
    被攻击时释放乾坤借速 = true,
    被攻击时释放含情脉脉 = true,
}
local _法反列表 = {
    水法反击 = true,
    雷法反击 = true,
    火法反击 = true,
    风法反击 = true,
}
function 怪物:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    self.最大魔法 = self.魔法
    self.最大气血 = self.气血
    self.抗性 = __容错表(self.抗性)
    if type(self.技能) == 'table' then
        local 技能 = {}
        for _, v in ipairs(self.技能) do
            if type(v) == 'string' then
                table.insert(技能, require('对象/法术/技能')({ 名称 = v, 类别 = '门派' }))
            elseif type(v) == 'table' and v.名称 then
                if not v.类别 then
                    v.类别 = '门派'
                end
                table.insert(技能, require('对象/法术/技能')(v))
            end
        end
        self.技能 = 技能
    else
        self.技能 = {}
    end

    if type(self.内丹) == 'table' then
        local 内丹 = {}
        for _, v in ipairs(self.内丹) do
            if type(v) == 'string' then
                table.insert(内丹, require('对象/法术/内丹')({ 技能 = v }))
            elseif type(v) == 'table' then
                table.insert(内丹, require('对象/法术/内丹')(v))
            end
        end
        self.内丹 = 内丹
    else
        self.内丹 = {}
    end



    self.附法技能 = {}
    for k, _ in pairs(_附法技能) do
        table.insert(self.附法技能, require('对象/法术/技能')({
            名称 = k,
            熟练度 = 1,
            类别 = '属性'
        }))
    end
end

function 怪物:属性计算()

end

function 怪物:更新(t)

end

function 怪物:战斗_开始()

end

function 怪物:战斗_结束(v)

end

return 怪物
