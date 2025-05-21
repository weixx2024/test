local 物品 = {
    名称 = '刮刮乐',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}

function 物品:初始化()
end

function 物品:使用(对象)
    if not 对象:取包裹空位() then
        对象:提示窗口('#Y 你的包裹已经满了1！')
        return
    end

    local 掉落包 = 取掉落包('物品', '刮刮乐')
    if 掉落包 then
        local r = 随机物品(掉落包)
        if r then
            local 物品 = 生成物品(r)
            if 物品 then
                if 对象:添加物品({ 物品 }) then
                    self.数量 = self.数量 - 1
                    if r.广播 then
                        对象:发送系统("#C%s在抽奖中获得一个#G#m(%s)[%s]#m#n#89", 对象.名称, r.nid, r.名称)
                    end
                end
            end
        else
            对象:提示窗口('#Y 你的包裹已经满了2！')
        end
    end
end

return 物品
