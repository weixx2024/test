local 物品 = {
    名称 = '天外飞石',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    绑定 = false,
}

function 物品:使用(对象)

end
function 物品:取回收价格(对象)
    return 200000
end
return 物品