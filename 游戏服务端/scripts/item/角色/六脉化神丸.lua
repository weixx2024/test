local 物品 = {
    名称 = '六脉化神丸',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.是否玩家 then
        local yy = 对象:取任务('玉枢返虚丸')
        local lm = 对象:取任务('六脉化神丸')
        local yl = 对象:取任务('疏筋理气丸')
        if lm or yy or yl then
            local r = 对象:确认窗口('#Y当前已经使用相似道具，若继续使用会覆盖原道具效果。')
            if r then
                if lm then
                    lm:删除()
                end
                if yy then
                    yy:删除()
                end
                if yl then
                    yl:删除()
                end
                local rw = 生成任务 { 名称 = '六脉化神丸' }
                if rw:添加任务(对象) then
                    self.数量 = self.数量 - 1
                    对象:常规提示("#Y你使用了六脉化神丸")
                end
            end
        else
            local rw = 生成任务 { 名称 = '六脉化神丸' }
            if rw:添加任务(对象) then
                self.数量 = self.数量 - 1
                对象:常规提示("#Y你使用了六脉化神丸")
            end
        end
    end

end











return 物品