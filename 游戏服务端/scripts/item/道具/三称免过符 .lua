-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-10-30 18:20:43
-- @Last Modified time  : 2024-11-04 08:35:53

local 物品 = {
    名称 = '三称免过符',
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
        if r:剧情称谓直接完成(对象, 3) then
            local r = 对象:取任务('称谓3_春三十娘')
            if r then
                r:删除()
            end
            local r = 对象:取任务('称谓3_山贼之灵')
            if r then
                r:删除()
            end
            local r = 对象:取任务('称谓3_羊脂仙露')
            if r then
                r:删除()
            end
            local r = 对象:取任务('称谓3_夜光珠')
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
