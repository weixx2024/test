local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '以牙还牙',
    是否被动 = true,
}

function 法术:进入战斗(攻击方)

end

function 法术:召唤进入战斗(攻击方,数据,召唤)
    local dst = 攻击方:所满足对象(
        function(v)
            if not v.是否死亡 and not 攻击方:是否我方(v) and not v.是否玩家 and v:取是否有终极技能() then -- 
                return true
            end
        end
    )
    local 成功
    if #dst > 0 then
        local sj = math.random(1,#dst)
        local 目标 = dst[sj]
        local 终极技能表 = 目标:取终极技能表()
        if #终极技能表 > 0 then
            sj = math.random(1,#终极技能表)
            召唤:添加临时技能(终极技能表[sj].名称)
            成功 = 终极技能表[sj].名称
        end
    end
    local 目标数据 = 攻击方.战场:指令开始()
    if 成功 then
        local r = 召唤:取主人()
        if r then
            r.rpc:提示窗口('#R你复制了'..成功.."技能")
        end
    end
    攻击方.战场:指令结束()
    数据:全屏特效(2316, 目标数据)
end

function 法术:战斗指令结束后(攻击方,数据)

end

function 法术:法术取描述(P)
    return string.format("进场后，若对方参战召唤兽有终极技能，则模拟得到其中某个终极技能相同的效果。整场战斗只触发一次(仅限玩家之间PK时使用)")
end

return 法术
