local NPC = {}
local 对话 = [[
我就是所有帮派的总管，你找我有什么事吗?
menu
1|我要建立帮派
2|我来响应帮派
3|我要加入帮派
99|我什么都不想做
]]
function NPC:NPC对话(玩家, i)
    return 对话
end

local _创建费用 = 30000000
function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local 名称, 宗旨 = 玩家:创建帮派窗口()
        if 名称 then

            local wp = 玩家:取物品是否存在("三界召集令")
            if not wp then
                return "创建帮派需要一块三界召唤令"
            end
            local r = 玩家:帮派创建(名称, 宗旨)
            if r == true then
                wp:减少(1)
                return "你开始申请创立帮派，等待他人响应。"
            else
                return r
            end
        end

    elseif i == "2" then
        local list = {}
        for k, v in 遍历帮派() do
            if not v.响应成功 then
                table.insert(list, { 名称 = v.名称, 响应 = v.响应, 创始人 = v.帮主, 宗旨 = v.宗旨 })
            end
        end
        local 名称 = 玩家:响应帮派窗口(list)
        if 名称 then
            local r = 玩家:响应帮派(名称)
            if r == true then
                return "响应成功"
            else
                return r
            end
        end
    elseif i == "3" then
        local list = {}
        for k, v in 遍历帮派() do
            if v.响应成功 then
                local n = v:取成员人数()
                table.insert(list, { 名称 = v.名称, 等级 = v.等级, 人数 = n, 帮主 = v.帮主, 宗旨 = v.宗旨 })
            end
        end
        玩家:申请帮派窗口(list)

    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
