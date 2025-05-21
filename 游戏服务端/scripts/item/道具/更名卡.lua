local 物品 = {
    名称 = '更名卡',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local r = 对象:输入窗口('', "名字代表你的身份，改名请慎重哦#2，请说说你想改成什么名字吧？")
    if r then
        if 检测名称(r) then
            return '#Y名称已存在'
        end
        if 对象:改名(r) then
            self.数量 = self.数量 - 1
        else
            return '#Y当前状态下无法进行此操作'
        end
    end



end

return 物品
