local 孩子 = require('孩子')

function 孩子:孩子_物品使用(i)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    return self.主人:角色_孩子物品使用(i, self)
end

function 孩子:孩子_参战(v)
    local mast = self.主人

    if self.阶段 == 1 then
        return '#Y婴儿期无法参战'
    end

    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end

    --参战条件判断
    if mast.参战孩子 then
        mast.参战孩子.是否参战 = false
    end
    self.是否参战 = v == true
    if self.是否参战 then
        mast.参战孩子 = self
    else
        mast.参战孩子 = nil
    end
    return self.是否参战
end

function 孩子:孩子_更改乳名(name)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 or type(name) ~= 'string' then
        return '#Y当前状态下无法进行此操作'
    end
    self.名称 = name
    -- if self.是否观看 then
    --     mast.rpc:切换名称(self.nid, v)
    --     mast.rpn:切换名称(self.nid, v)
    -- end
    return true
end

function 孩子:孩子_脱下装备(i)
    local mast = self.主人
    if not mast.是否战斗 and not mast.是否摆摊 and not mast.是否交易 then
        if type(i) == 'number' and self.装备[i] then
            local n = mast:物品_查找空位()
            if n then
                self.装备[i]:脱下孩子装备(self)
                mast.物品[n] = self.装备[i]

                self.装备[i] = nil
                self:刷新属性()
                return true
            end
        end
    end
end
