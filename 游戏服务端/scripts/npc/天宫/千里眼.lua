local NPC = {}
local 对话 = [[
我就是千里眼，天上凡间一草一木都逃不过我的法眼，要是你要找人找我就没错了。#2不过帮你没问题，给500000两辛苦费就行。找人可是很费神的。#17
menu
1|呀，你帮我找找
2|我只是路过看看
]]
local 对话2 = [[
我就是千里眼，天上凡间一草一木都逃不过我的法眼，要是你要找人找我就没错了。#2不过帮你没问题，给500000两辛苦费就行。找人可是很费神的。#17
menu
1|我知道玩家名称
2|我知道玩家ID
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:选择窗口(对话2)
        if r == "1" then

            local name = 玩家:输入窗口("", "请输入玩家名称！")
            if name then
                local t = 按名称查询nid(name)
                if not t then
                    return "名称错误，该玩家不存在！"
                end
                local P = 玩家:取玩家(t.nid)
                if not P then
                    return "该玩家不存线！"
                end


                if P.当前地图.是否副本 then
                    return "当前玩家在副本地图 无法传送！"
                end

                if 玩家:扣除师贡(500000) then
                    P.rpc:常规提示("#Y你身旁有一阵冷风吹过，感觉到一丝不好的气息")
                    return string.format("#G%s#W在#Y%s(%s,%s)", P.名称, P.当前地图.名称, P.X, P.Y)
                end


            end
        elseif r == "2" then

            local id = 玩家:输入窗口("", "请输入玩家ID！")
            if id then
                local 数字id = tonumber(id)
                if 数字id then
                    local t = 按ID查询nid(数字id - 10000)
                    if not t then
                        return "ID错误，该玩家不存在！"
                    end
                    local P = 玩家:取玩家(t.nid)
                    if not P then
                        return "该玩家不存线！"
                    end
                    if P.当前地图.是否副本 then
                        return "当前玩家在副本地图 无法传送！"
                    end
                    if 玩家:扣除师贡(500000) then
                        P.rpc:常规提示("#Y你身旁有一阵冷风吹过，感觉到一丝不好的气息")
                        return string.format("#G%s#W在#Y%s(%s,%s)", P.名称, P.当前地图.名称, P.X, P.Y)
                    end
                else
                    return "请输入正确ID"
                end
            end
        end
    end
end

return NPC
