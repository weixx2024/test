local 物品 = {
    名称 = '枯荣丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}
function 物品:初始化(t)



end

function 物品:使用(对象)
    local 主人 = 对象:取主人接口()
    if 主人 then
        local r = 主人:取任务("枯荣丹")
        if r then
            if r.对象id == 对象.nid then
                r:添加时长(60)
                self.数量 = self.数量 - 1

            else
                r:重置任务(主人, 对象)
                self.数量 = self.数量 - 1
            end
        else
            local rw = 生成任务 { 名称 = '枯荣丹' }
            if rw and rw:添加任务(主人, 对象) then
                self.数量 = self.数量 - 1
            end
        end
    end
end

return 物品
