local 物品 = {
    名称 = '八称免过符',
    叠加 = 1,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()

end

function 物品:使用(对象)
    local r = 对象:取任务('引导_称谓剧情')
    if r then
        if r:剧情称谓直接完成(对象, 8) then
            local r = 对象:取任务('称谓8_妙法莲华经')
            if r then
                r:删除()
            end
            local r = 对象:取任务('称谓8_一万三千年之前')
            if r then
                r:删除()
            end
        
           
         
            对象:提示窗口('#Y 你可以直接去领取称谓了！')
            self.数量 = self.数量 - 1
        else
            对象:提示窗口('#Y 你已经过了这个称谓（或者尚未完成上个称谓）')
        end
    end
    
end

function 物品:取描述()

end

return 物品
