local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '春风拂面',
}

function 法术:召唤进入战斗(攻击方,数据,目标)
    if 数据 then
        local dst = 攻击方:我方属性排序(
            1,
            function(v)
                if not v.是否死亡 and (not 目标 or 目标 ~= v )  then --and not v:取BUFF('封印') --and v.是否召唤 
                    return true
                end
            end,
            function(a, b)
                return a.速度  > b.速度 
            end
        )
        if dst[1] then
            local 位置 = {}
            for i=1,2 do 
                local P = dst[i]
                if P then
                    位置[#位置+1] = P.位置
                end
            end
            if next(位置) then
                数据:群体添加特效(2151,位置)
            end
            local 目标数据 = 攻击方.战场:指令开始()
            for i=1,2 do 
                local P = dst[i]
                if P then
                    P:删除BUFF('混乱')
                    P:删除BUFF('封印')
                    P:删除BUFF('昏睡')
                    P:删除BUFF('中毒')
                    P:删除BUFF('遗忘')
                end
            end
            数据:法术后(目标数据)
            攻击方.战场:指令结束()
        end
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "进场时解除己方一只召唤兽的异常状态！"
end


return 法术
