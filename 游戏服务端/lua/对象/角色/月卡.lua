local 角色 = require('角色')

function 角色:角色_打开月卡()
    local 商品列表 = __脚本['scripts/shop/月卡.lua']
    return 商品列表, self.月卡
end



function 角色:角色_月卡领取(a, b, n)
    if self.月卡.时效 == nil or os.time() > self.月卡.时效 then
        return "#Y你还没有月卡或者已经到期！"
    end
    if self.月卡.领取 == os.date("%Y-%m-%d", os.time()) then
        return "#Y你今天已经领取过该奖励了"
    end
    local 商品列表 = __脚本['scripts/shop/月卡.lua']
    local 物品表 = {}
    for i,v in ipairs(商品列表) do
        local t = GGF.复制表(v)
        t.类别 = nil
        t.价格 = nil
        t.热卖 = nil
        t.属性 = nil
        t.结束时间 = nil
        t.限量 = nil
        t.限时 = nil
        local 数量 = tonumber(t.数量) or 1
        t.数量 = nil
        local 奖励 = __沙盒.生成物品(t)
        if 奖励.是否叠加 then
            奖励.数量 = 数量
            table.insert(物品表, 奖励)
        else
            for i = 1, 数量 do
                table.insert(物品表, __沙盒.生成物品(t))
            end
        end
    end
    if self:物品_添加(物品表) then
        self.月卡.领取 = os.date("%Y-%m-%d", os.time())
        self:日志_仙玉记录('你领取了月卡奖励 %s。', self.月卡.领取)
        return "#Y你领取了今日的月卡奖励"
    else
        return '#Y空间不足'
    end
end
