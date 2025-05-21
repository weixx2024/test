local 物品 = {
    名称 = '珍惜神兽自选卡',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}

function 物品:初始化()

end


local _珍惜神兽范围 = {'画中仙','白泽','年'}
local _对话 = [[
请选择你想要的召唤兽！ 
menu
1|画中仙 
2|白泽
3|年
19|我在想想
]]





function 物品:使用(对象)
    local r = 对象:选择窗口(_对话)
    if r then
        for i, v in ipairs(_珍惜神兽范围) do
            if r==tostring(i) then
                if 对象:添加召唤(生成召唤 { 名称 =v }) then
                    self.数量 = self.数量 - 1
                    break
                end
            end
        end
    end
end



return 物品