local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '将死',
    id = 304,

}

function 法术:召唤离场(攻击方,数据)
    local dst = 攻击方:我方属性排序(
        1,
        function(v)
            if not v.是否死亡 and (not 目标 or 目标 ~= v ) and not v:取BUFF('封印') and v.是否召唤  then --
                return true
            end
        end,
        function(a, b)
            return a.速度  > b.速度 
        end
    )
    if dst[1] then
        for i=1,5 do 
            local P = dst[i]
            if P then
                数据:目标添加特效(2151,P.位置)
                P:删除BUFF('混乱')
                P:删除BUFF('封印')
                P:删除BUFF('昏睡')
                P:删除BUFF('中毒')
                P:删除BUFF('遗忘')
            end
        end
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "场时解除己方所有召唤兽的异常状态！"
end

return 法术
