local 物品 = {
    名称 = '随机一阶仙器礼盒',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()

end

local _武器 = { "情殇", "回梦", "苍暮", "问冥", "凌波", "暗夜", "陨星", "倾城", "河图", "裂风",
    "傲天", "幽游", "醉仙", "红尘", "惊魂", "晓霜", "幽昙" }
local _衣服 = { "轩辕", "舞雪" }
local _帽子 = { "邀月", "幻羽" }
local _项链 = { "化魄" }
local _鞋子 = { "魅影" }

function 物品:使用(对象)
    local 名称 = "魅影"
    local 几率 = math.random(12)
    if 几率 <= 5 then
        名称 = _武器[math.random(#_武器)]
    elseif 几率 <= 7 then
        名称 = _衣服[math.random(#_衣服)]
    elseif 几率 <= 9 then
        名称 = _帽子[math.random(#_帽子)]
    elseif 几率 <= 10 then
        名称 = "化魄"
    else
        名称 = "魅影"
    end

    local r = 生成装备 { 名称 = 名称, 等级 = 1 }

    if r then
        if 对象:添加物品({r}) then
            self.数量 = self.数量 - 1
        end
    end




end

function 物品:取描述()

end

return 物品
