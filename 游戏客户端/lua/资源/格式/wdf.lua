

local GGF = require('GGE.函数')
local _HASH = require('gxy2.hash')

local _WDFS = {}

local function _loadwdf(name, file)
    local wdf = require('gxy2.wdf')(file)
    if wdf then
        if _WDFS[name] then
            wdf:GetList(_WDFS[name])
        elseif wdf then
            _WDFS[name] = wdf:GetList()
        end
        return true
    end
end

local wdf = class('wdf')

function wdf:初始化(path)
    local list = {}
    for file in GGF.遍历文件(path) do
        if file:sub(-3, -2) == 'wd' then
            local name = GGF.取文件名(file, true)
            if not list[name] then
                list[name] = {}
            end
            table.insert(list[name], file)
        end
    end

    for k, v in pairs(list) do
        table.sort(
            v,
            function(a, b)
                local a = a:sub(-1)
                local b = b:sub(-1)
                if a == 'f' then
                    a = '0'
                end
                if b == 'f' then
                    b = '0'
                end
                return a:byte() > b:byte()
            end
        )

        for _, v in ipairs(v) do
            if not _loadwdf(k, v) then
            end
        end
    end
end

function wdf:取数据(path)
    local r = path
    if type(path) == 'string' then
        r = self:是否存在(path)
    end
    if type(r) == 'table' and r.wdf then
        return r.wdf:GetData(r.id)
    end
end

function wdf:是否存在(path)
    local name, hash = gge.utf8togbk(path):match('(%w+)/(.+)')
    if name and _WDFS[name] and hash then
        if hash:sub(1, 2) == '0x' then --shape/0x00000000.tcp
            hash = tonumber(hash:match('(.+)%.%a%a%a'))
        else
            hash = _HASH(hash)
        end
        return _WDFS[name][hash]
    end
end

return wdf
