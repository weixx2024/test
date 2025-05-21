local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '扶伤',
    id = 304,
}

function 法术:回合开始(攻击方)
    local zr = 攻击方:取主人() 
    local mb
    if zr.是否死亡 then
        mb = zr
    else
        local tab = 攻击方:取我方死亡()
        if next(tab) then
            mb = tab[math.random(1,#tab)]
        end
    end
    -- for i,v in pairs(tab) do
        if mb and math.random(100) < 5 then
            local 气血 = math.floor(mb.最大气血 * 0.5)
            mb:增加气血(气血)
            if mb.气血 > 0 then
                mb.是否死亡 = false
            end
        end 
    -- end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "灵犀一指，妙手回春，令死者返生。#r【消耗MP】0#r#G回合开始时有5%几率为死亡单位恢复50%气血"
end

return 法术
