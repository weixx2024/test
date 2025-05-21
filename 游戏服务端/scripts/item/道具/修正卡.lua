local 物品 = {
    名称 = '修正卡',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

local _对话 = [[
我要重新第%s世修正
menu
1|男人 2|女人
3|男魔 4|女魔
5|男仙 6|女仙
7|男鬼 8|女鬼
]]

local _种族 = {
    ["1"] = 1001,
    ["2"] = 1002,
    ["3"] = 2001,
    ["4"] = 2002,
    ["5"] = 3001,
    ["6"] = 3002,
    ["7"] = 4001,
    ["8"] = 4002,
}


function 物品:使用(对象)
    if 对象.转生 == 0 then
        对象:常规提示("#Y此道具达到1转后才可以使用")
        return
    end
    local 选择 = {}
    if 对象.转生 > 0 then
        local r = 对象:选择窗口(_对话, "1")
        if r then
            table.insert(选择, r)
        else
            return
        end
    end
    if 对象.转生 > 1 then
        local r = 对象:选择窗口(_对话, "2")
        if r then
            table.insert(选择, r)
        else
            return
        end
    end
    if 对象.转生 > 2 then
        local r = 对象:选择窗口(_对话, "3")
        if r then
            table.insert(选择, r)
        else
            return
        end
    end
    if 对象.飞升 == 1 then
        local r = 对象:选择窗口(_对话, "4")
        if r then
            table.insert(选择, r)
        else
            return
        end
    end
    local 修正 = {}
    for _, v in ipairs(选择) do
        if _种族[v] then
            table.insert(修正, _种族[v])
        end
    end
    对象:重选修正(修正)
    self.数量 = self.数量 - 1

end

return 物品
