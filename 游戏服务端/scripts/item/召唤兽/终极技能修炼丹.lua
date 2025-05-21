-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-08-28 20:28:58
-- @Last Modified time  : 2024-08-28 20:45:44
local 物品 = {
    名称 = '终极技能修炼丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:是否有问号技能() then    
        if math.random(100) <= 50  then    
            if 对象:处理问号技能() then
                  self.数量 = self.数量 - 1
                  对象:提示窗口('#Y 开启终极技能成功！')
             else  
                对象:提示窗口('#Y 终极技能开启失败！')
                self.数量 = self.数量 - 1
             end
         else      
            对象:提示窗口('#Y 终极技能开启失败！')
            self.数量 = self.数量 - 1
        end          
     else        
        return '#Y 你没有？技能！'
    end
end


return 物品
