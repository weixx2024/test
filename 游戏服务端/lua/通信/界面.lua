function REG:取物品描述(id, nid)
    if __物品[nid] then
        return __物品[nid]:取描述()
    end
end

function REG:取法宝描述(id, nid)
    if __法宝[nid] then
        return __法宝[nid]:取描述()
    end
end

local function 聊天信息处理(内容)
    for i = 64, 73 do
        内容 = 内容:gsub('#' .. i, '##' .. i)
    end
    内容 = 内容:gsub('#100', '##100')
    for i = 114, 116 do
        内容 = 内容:gsub('#' .. i, '##' .. i)
    end
    for i = 154, 158 do
        内容 = 内容:gsub('#' .. i, '##' .. i)
    end
    内容 = 内容:gsub('#212', '##212')
    return 内容
end

function REG:界面聊天(id, 内容, 频道)
    local P = _角色[id]
    if P and type(内容) == 'string' then
        内容 = 聊天信息处理(内容)
        if 频道 == 1 then --当前
            P:聊天_发送周围(内容)
        elseif 频道 == 2 then --队伍
            P:聊天_发送队伍(内容)
        elseif 频道 == 3 then --帮派
            P:聊天_发送帮派(内容)
            -- elseif 频道 == 4 then --私聊
            --     P:聊天_发送私聊(内容)
        elseif 频道 == 4 then --世界
            P:聊天_发送世界(内容)
        elseif 频道 == 5 then --GM
            P:聊天_发送GM(内容)
        elseif 频道 == 6 then --传音

        end
    end
end
