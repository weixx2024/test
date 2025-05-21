local 物品 = {
    名称 = '追杀令',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
local 对话2 = [[
请输入
menu
1|我知道玩家名称
2|我知道玩家ID
]]
function 物品:使用(对象)
    if 对象.是否玩家 then
        local r = 对象:选择窗口(对话2)
        if r == "1" then

            local name = 对象:输入窗口("", "请输入玩家名称！")
            if name then
                local t = 按名称查询nid(name)
                if not t then
                    return "名称错误，该玩家不存在！"
                end
                local P = 对象:取玩家(t.nid)
                if not P then
                    return "该玩家不存线！"
                end
                if P.当前地图.是否副本 then
                    return "当前玩家在副本地图 无法传送！"
                end
                对象:切换地图(P.地图, P.X, P.Y)
                self.数量 = self.数量 - 1
            end
        elseif r == "2" then
            local id = 对象:输入窗口("", "请输入玩家ID！")
            if id then
                local 数字id = tonumber(id)
                if 数字id then
                    local t = 按ID查询nid(数字id - 10000)
                    if not t then
                        return "ID错误，该玩家不存在！"
                    end
                    local P = 对象:取玩家(t.nid)
                    if not P then
                        return "该玩家不存线！"
                    end
                    if P.当前地图.是否副本 then
                        return "当前玩家在副本地图 无法传送！"
                    end
                    对象:切换地图(P.地图, P.X, P.Y)
                    self.数量 = self.数量 - 1
                else
                    return "请输入正确ID"
                end
            end
        end




    end


end

return 物品
