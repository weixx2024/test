local 物品 = {
    名称 = '鎏金自选卡',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}

function 物品:初始化()

end


local _鎏金宝宝范围 = {'龙马','北冥龙君','画皮娘子','孔雀明王','水月镜花','龙兔','妙音鸾女'}  --,'孟极'  ,'惜红衣'
local _对话 = [[
请选择你想要的召唤兽！ 
menu
1|龙马
2|北冥龙君
3|妙音鸾女
4|画皮娘子
5|孔雀明王
6|水月镜花
7|龙兔
19|我在想想
-- 3|孟极  （暂无）
-- 8|惜红衣   （暂无）
]]





function 物品:使用(对象)
    local r = 对象:选择窗口(_对话)
    if r then
        for i, v in ipairs(_鎏金宝宝范围) do
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