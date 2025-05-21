local 物品 = {
    名称 = '测试#test',
    叠加 = 999,
    类别 = 1,
    类型 = 1,
    对象 = 12,
    条件 = 63,
    绑定 = false,
    排序 = 200,
    测试常量 = 111
}
function 物品:初始化()
    self.测试变量 = 222
    self.图标 = 37
    self.描述 = '自定义描述'
    print('物品:初始化')
end

function 物品:测试函数(对象)

end

local 测试函数 = 物品.测试函数
function 物品:使用(对象)
    assert(self.测试常量==111, '测试常量错误')
    assert(self.测试变量==222, '测试变量错误')
    assert(self.测试函数==测试函数, '测试函数错误')
    print('测试通过')
end

function 物品:取描述(对象)
    -- print('物品:取描述')
    return '#Y黄色描述#r#G绿色描述'
end
return 物品