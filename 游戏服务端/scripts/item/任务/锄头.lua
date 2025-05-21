local 物品 = {
    名称 = '锄头',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    禁止交易 = true,
}

function 物品:使用(对象)
    local r = 对象:取任务("日常_帮派任务")
    if r and r.分类 == 2 then
        local c = r:开始除草(对象)
        self.坐标=r.位置
        if c == true then
            self.数量 = self.数量 - 1
        else
            对象:常规提示(c)
        end
    end

end
function 物品:取描述()
    if self.坐标 then
        return string.format( "#Y到#G%s#Y附近除草",self.坐标 )
     
    end

end


return 物品
