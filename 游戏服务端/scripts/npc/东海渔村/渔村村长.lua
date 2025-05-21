-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:39
-- @Last Modified time  : 2022-07-29 08:53:55
local NPC = {}
local 对话 = [[
我们村长人少，需要不少的人手，不会亏了你的好处的。
menu
]]
local 任务 = [[
1|帮忙找个人,100两银子
2|打海盗，120两银子
3|我还有其他事情，就不帮忙了
]]
--最近发现珊瑚海岛上有海盗出没，请到渔村外帮我把#R/NPC名称#W/找回来。
function NPC:NPC对话(玩家, i)
    return 对话 .. 任务
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取海盗寻人任务(玩家)
    elseif i == '2' then
        return self:领取打海盗任务(玩家)

    end
end

function NPC:领取海盗寻人任务(玩家)
    if 玩家.是否组队 then
        local t = {}
        for _, v in 玩家:遍历队伍() do
            if v:取任务('海岛寻人') then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            return '#R' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取'
        end
    else
        if 玩家:取任务('海岛寻人') then
            return '你已经有任务了'
        end
    end

    local r = 生成任务 {名称 = '海岛寻人'}

    if r and r:生成怪物(玩家) then
        local ff = string.format('最近发现#G%s#W有海盗出没，请到渔村外帮我把#G#u%s#W#u找回来。', r.位置, r.怪名)
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队友() do
                v:最后对话(ff, self.外形)
            end
            return ff
        else
            return ff
        end
    end
end
function NPC:领取打海盗任务(玩家)
    if 玩家.是否组队 then
        local t = {}
        for _, v in 玩家:遍历队伍() do
            if v:取任务('打海盗') then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            return '#R' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取'
        end
    else
        if 玩家:取任务('打海盗') then
            return '你已经有任务了'
        end
    end

    local r = 生成任务 {名称 = '打海盗'}

    if r and r:生成怪物(玩家) then
        local ff =string.format('最近发现#G%s#W有海盗出没，请到渔村外击退#G#u%s#W#u。', r.位置, r.怪名)
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队友() do
                v:最后对话(ff, self.外形)
            end
            return ff
        else
            return ff
        end
    end
end


function NPC:NPC给予(玩家, 银两, 物品)
    -- local str = '银两:' .. 银两 .. '#r'
    -- if 物品[1] then
    --     str = str .. '物品:' .. 物品[1].名称 .. '*' .. 物品[1].数量
    --     if 物品[1].数量 >= 2 then
    --         物品[1]:接受(2)
    --     end
    -- end
    -- return str
end
return NPC
