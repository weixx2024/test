-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 00:49:34
local 物品 = {
    名称 = '惊天雷',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 48,
    条件 = 37,
    召唤禁止释放 = true,
    绑定 = false,
}

function 物品:使用(对象, 来源)
    if 对象.是否怪物 then
        if 对象:取战斗脚本() ~= 'scripts/event/活动7_年年有余_鲤鱼.lua' then
            return
        end
        local dst = 对象:取敌方后排加1目标(
            对象.位置,
            function(v)
                if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') then --and (not 对象 or 对象 ~= v)
                    return true
                end
            end
        )
        if dst[1] then
            for k, v in pairs(dst) do
                v:被驱逐()
                来源:提示("#Y糟糕，鲤鱼被吓跑了~~")
            end
            self.数量 = self.数量 - 1
        end
    end
end

return 物品
