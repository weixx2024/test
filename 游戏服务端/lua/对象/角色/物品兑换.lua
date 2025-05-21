local 角色 = require('角色')
function 角色:角色_物品兑换()
    local 商品列表 = __脚本['scripts/shop/物品兑换.lua']
    return 商品列表
end

function 角色:角色_兑换物品(t)
    local 商品列表 = __脚本['scripts/shop/物品兑换.lua']
    local 物品 = GGF.复制表(商品列表[t])
    if 物品 then
        local 确认兑换 = self.rpc:确认窗口('你确认要兑换'..物品.名称..'吗？')
        if not 确认兑换 then
            return
        end
        for i,v in ipairs(物品.要求) do
            local wp = self:指定物品_获取(v.名称,v.数量)
            if not wp then
                return "兑换该道具需要"..v.名称.."*"..v.数量
            end
        end
        if 物品.要求.银子 then
            if self.银子 < 物品.要求.银子 then
                return "#Y 你没有那么多银子"
            end
            self.银子 = self.银子 - 物品.要求.银子
        end
        for i,v in ipairs(物品.要求) do
            local wp = self:指定物品_获取(v.名称,v.数量)
            if not wp then
                return "兑换该道具需要"..v.名称.."*"..v.数量
            end
            wp:减少(v.数量)
        end
        物品.要求=nil
        local 物品表 = {}
        table.insert(物品表, __沙盒.生成物品(物品))
        if not self:物品_检查添加(物品表) then
            return "#Y包裹没有空余的道具栏"
        end
        if self:物品_添加(物品表) then
            return "#Y你兑换了" .. 物品.名称
        end
    end   
end

