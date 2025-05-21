local 法术 = {
    类别 = '法宝',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '番天印',
    id = 1507
}


function 法术:法术施放(攻击方, 目标)
    local 消耗怨气 = self:法术取消耗().消耗怨气
    if 攻击方:取怨气() < 消耗怨气 then
        攻击方:提示("#R怨气不足，无法释放！")
        return false
    end
    self.xh = 消耗怨气
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        v:删除BUFF('遗忘')
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少怨气(self.xh)
        self.xh = false
    end
end

function 法术:法术取消耗()
    return { 消耗怨气 = 1 }
end

function 法术:取目标数()
    return 3
end

function 法术:法术取回合()
    return 3
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    return string.format("解除对方的异常状态")
end

-- function 法术:进入战斗(自己)
--     local 成功 = true
--     if 成功 then
--         local b = 自己:进入战斗添加BUFF(BUFF)
--         if b then
--             b.回合 = self:法术取回合()
--         end
--     end
-- end



return 法术
