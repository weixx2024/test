local 物品 = {
    名称 = '一级神兵自选卡',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()

end

function 物品:使用(对象)
    对象:打开窗口(("神兵兑换"))
end

function 物品:取描述()

end

return 物品
