-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-09-28 18:34:50
-- @Last Modified time  : 2024-10-26 14:01:43
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '昆山玉碎',
    是否被动 = true,
}

local BUFF

function 法术:法术施放后(攻击方, 挨打方)
    if 挨打方 then
        for i,v in ipairs(挨打方) do
            local 几率 = self:取几率(攻击方, v)
            if 几率 > math.random(100) then
                local bl = math.random(1,3)
                local 伤害  = math.floor(攻击方.伤害*bl)
                local 额外目标组 = v:取附近目标(v.位置)
                if math.random(100) <= 67 and #额外目标组 > 0 then
                    伤害 = math.floor(伤害/(#额外目标组+1))
                    v:减少气血(伤害)
                    攻击方.当前数据:群体目标添加特效(1306,v.位置)
                    for n,_ in ipairs(额外目标组) do
                        _:减少气血(伤害)
                        攻击方.当前数据:群体目标添加特效(1306,_.位置)
                    end
                else
                    v:减少气血(伤害)
                    攻击方.当前数据:群体目标添加特效(1306,v.位置)
                end    
            end
        end
        return true
    end
end

function 法术:取几率(攻击方, 挨打方)
    local 亲密度 = 攻击方.亲密 or 0
    local 几率 = 10 + math.floor(亲密度 ^ 0.17)
    return 几率
end

function 法术:法术取描述(P)
    return string.format("使用仙法时有几率对目标造成音势伤害（PVE战斗音势伤害在100%%~300%%随机）且目标距离1以内其他敌方单位67%%几率均摊此伤害")
end

return 法术
