-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2022-06-13 09:28:35


local NPC = {}
local 对话 = [[你是大侠，飞过去要收2400两路费，你想飞那个？
menu
盘丝洞 领取种族任务
地府 我什么都不想做
魔王寨
狮驼岭 
]]
--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end

local _对话2 = [[
老大果然没有看错你们那就拿出咱们的绝活，秒也好，砍也好，总之端了那伙菜鸟，现在就去么？
menu
1|没问题，我们这就去
2|好远啊，不去不去
]]
function NPC:NPC菜单(玩家,i)
    if i=='盘丝洞' then
        玩家:切换地图(1144, 7, 9)
    elseif i=='地府' then
        玩家:切换地图(1124, 19, 12)
    elseif i=='魔王寨' then
        玩家:切换地图(1145, 16, 9)
    elseif i=='狮驼岭' then
        玩家:切换地图(1134, 7, 4)
    elseif i == '领取种族任务' then
        local r = 玩家:选择窗口(_对话2)
        if r and r == "1" then
            return self:领取种族任务(玩家)
        end
    end
end

function NPC:领取种族任务(玩家)
    if 玩家.种族 ~= 2 then
        return "#24 本使者只给人族发布任务！"
    elseif 玩家:取队伍人数() < 3 then
        return "'#Y需要3个人以上的组队来帮我！'"
    end
    local t = {}

    for _, p in 玩家:遍历队伍() do
        if p.转生 < 1 and p.等级 < 70 then
            table.insert(t,p.名称)
        end
    end
    if #t > 0 then
        return table.concat(t, ", " ).. "等级1转70级无法参加此活动"
    end
    for _, p in 玩家:遍历队伍() do
        if p.种族 ~= 2 then
            table.insert(t,p.名称)
        end
    end
    if #t > 0 then
        return table.concat(t, ", " ).. "不是本种族成员"
    end

    local r = 生成任务({ 名称 = "日常_种族任务" })
    if r and r:生成怪物(玩家) then
        local ff = string.format('老大果然没有看错你。速去#Y%s#W端掉#G#u%s#W#u。', r.位置, r.怪名)
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队伍() do
                v:最后对话(ff, self.外形)
            end
            return ff
        end
    end
end



return NPC