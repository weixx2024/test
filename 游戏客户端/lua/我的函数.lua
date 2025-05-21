table.print = function(t)
    print(require('lua.serpent').block(t))
end

function pblock(t)
    print(require('lua.serpent').block(t))
end

function __生成ID()
    return require('nanoid').generate()
end

function 取两点距离(x, y, x1, y1)
    return math.sqrt(math.pow(x - x1, 2) + math.pow(y - y1, 2))
end

table.copy = function(ori_tab)
    if (type(ori_tab) ~= "table") then
        error("非table,不能复制.")
    end
    local new_tab = {};
    for i, v in pairs(ori_tab) do
        local vtyp = type(v);
        if (vtyp == "table") then
            new_tab[i] = table.copy(v);
        elseif (vtyp == "thread") then
            error("复制失败,非法类型.")
        elseif (vtyp == "userdata") then
            --error("复制失败,非法类型.")
        else
            new_tab[i] = v;
        end
    end
    return new_tab;
end

-- 获取字符串长度
string.length = function(str)
    local length = 0
    local bytes = { str:byte(1, #str) }
    local i = 1
    while i <= #bytes do
        local byte = bytes[i]
        if byte < 128 then
            length = length + 1
            i = i + 1
        elseif byte >= 192 and byte < 224 then
            length = length + 1
            i = i + 2
        elseif byte >= 224 and byte < 240 then
            length = length + 1
            i = i + 3
        elseif byte >= 240 and byte < 248 then
            length = length + 1
            i = i + 4
        else
            -- Invalid byte, skip
            i = i + 1
        end
    end
    return length
end

function 查找路线(startMap, endMap)
    local pathTable = __jump
    local find = {}
    local paths = {}

    local function pushPath(map, path)
        for _, v in pairs(map) do
            if pathTable[v.tid] and not find[v.tid] then
                table.insert(path, v)
                find[v.tid] = true
                table.insert(paths, { path = { table.unpack(path) } })
                table.remove(path)
            end
        end
    end

    -- 将起始点作为初始路径加入队列
    pushPath(pathTable[startMap] or {}, {})
    local shortestPath = nil
    while #paths > 0 do
        local current = table.remove(paths, 1)

        pushPath(pathTable[current.path[#current.path].tid], current.path)

        if current.path[#current.path].tid == endMap then
            -- 如果找到了终点，更新最短路径
            if shortestPath == nil or #current.path < #shortestPath then
                shortestPath = current.path
            end
        end
    end

    return shortestPath
end
