local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '忠不避危',
    id = 304,

}

function 法术:进入战斗(攻击方)

end

function 法术:回合开始(攻击方)
    if 攻击方.是否召唤 then
        if 20 > math.random(100) then
            local r = 攻击方:取主人()
            if r then
                if 攻击方.位置 > 5 and 攻击方.位置 < 11 then
                    攻击方.保护 = 攻击方.位置 - 5
                -- elseif 攻击方.位置 > 10 and 攻击方.位置 < 21 then
                --     攻击方.保护 = 攻击方.位置 - 5
                end
            end
        end

    end
end

function 法术:法术取描述(P)
   
    return "战斗中每回合有几率保护主人一次。（被动）"
end

return 法术
