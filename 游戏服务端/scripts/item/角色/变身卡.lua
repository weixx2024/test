local 物品 = {
    名称 = '变身卡',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}


local 对话 = [[
menu
1|我要使用变身卡
2|我要放入变身卡册
99|什么都不想做
]]

--卡集存放



function 物品:使用(对象)

    local r = 对象:选择窗口(对话)
    if r == "1" or r == "2" then
        if r == "1" then
            local rw = 生成任务 { 名称 = '变身卡' }
            rw:添加任务2(对象, self)
            self.数量 = self.数量 - 1
        elseif r == "2" then
            if 对象:放入卡册 { name = self.name, key = self.key, 属性类型 = self.属性类型, 属性id = self.属性id } then
                self.数量 = self.数量 - 1
            end
        end

    end



end

function 物品:生成介绍()
end

function 物品:取描述(对象)
    if self.介绍 then
        return '#C' .. self.介绍
    end
    return '#C未知介绍'
end

return 物品
