local 物品 = {
    名称 = '奇异石',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 1,
    条件 = 0,
    绑定 = false,
}
function 物品:初始化()
   
end

function 物品:使用(对象)

end

function 物品:取描述(对象)
    return string.format("#Y等级 %s", self.等级)
end


function 物品:取回收价格(对象)
    if self.等级 == 6 then
        return 150000
    elseif self.等级 == 7 then
        return 250000
    elseif self.等级 == 8 then
        return 450000
    end
end
return 物品
