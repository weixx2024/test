local ggf = require('GGE.函数')
local SDL = require 'SDL'
local en64 = require('base64').encode
local de64 = require('base64').decode
local unpk = require('cmsgpack').unpack
local pack = require('cmsgpack').pack

local s_format = string.format
local s_unpack = string.unpack
local t_insert = table.insert
local t_remove = table.remove
local ipairs = ipairs
local pairs = pairs
local assert = assert
local tonumber = tonumber
local toutf8 = gge.gbktoutf8
local togbk = gge.utf8togbk

local 配置 = class('资源配置')

function 配置:初始化()
    self.配置 = {}
end

function 配置:读取配置()
    local data = SDL.LoadFile('./config.ini')
    --   print(data)
    local cfg = {}
    if data then
        cfg = ggf.ini(data, #data)
    end
    self.配置.记住账号 = cfg.记住账号 == true
    self.配置.记住密码 = cfg.记住密码 == true
    self.配置.音乐音量 = tonumber(cfg.音乐音量) or 100
    self.配置.音效音量 = tonumber(cfg.音效音量) or 100
    self.配置.账号 = cfg.账号 and tostring(cfg.账号) or ''
    self.配置.密码 = cfg.密码 and tostring(cfg.密码) or ''
    local 账号列表 = cfg.账号列表 and de64(cfg.账号列表)
    self.配置.账号列表 = 账号列表 and unpk(账号列表) or {}
    self.配置.默认选区 = cfg.默认选区
end

function 配置:保存配置()
    local t = {}

    for _, k in ipairs {
        '账号',
        '密码',
        '账号列表',
        '记住账号',
        '记住密码',
        '音乐音量',
        '音效音量',
        '默认选区',
    } do
        local v = self.配置[k]
        if k == '账号列表' then
            v = en64(pack(v))
        end
        table.insert(t, string.format('%s = %s', k, v))
    end
    local t = table.concat(t, '\r\n')
    --   if gge.platform == 'Windows' then
    SDL.WriteFile('./config.ini', t)
    --  end
end

local function _split(str, mark)
    local t = {}
    local N = 1
    for line in str:gmatch('([^' .. mark .. ']+)') do
        if tonumber(line) then
            t[N] = tonumber(line)
        else
            t[N] = line
        end
        N = N + 1
    end
    return t
end

--动画染色板
--https://blog.csdn.net/leexuany/article/details/2504913
--shape/char/0001/00.pp
function 配置:depp(str)
    if not str then
        return
    end
    str = toutf8(str)

    local line = _split(str, '\r\n')
    local h = _split(line[1], ' ')
    local n = 1
    local ret = {}
    local num = t_remove(h, 1)
    if num > 1000 then           --新的
        for i = 1, num - 1000 do --分段数
            ret[i] = { a = h[i], b = h[i + 1] }
            n = n + 1
            for j = 1, line[n] do --方案数
                ret[i][j] = {}
                local N = 1
                for c = 1, 3 do --4未知
                    for _, v in ipairs(_split(line[n + c], ' ')) do
                        ret[i][j][N] = v
                        N = N + 1
                    end
                end
                n = n + 4
            end
        end
    else
        for i = 1, num do --分段数(部位)
            ret[i] = { a = h[i], b = h[i + 1] }
            n = n + 1
            for j = 1, line[n] do --方案数
                ret[i][j] = {}
                local N = 1
                for c = 1, 3 do
                    for _, v in ipairs(_split(line[n + c], ' ')) do
                        ret[i][j][N] = v
                        N = N + 1
                    end
                end
                n = n + 3
            end
        end
    end
    --分段数，方案数，RGB
    return ret
end

function 配置:getshapeid(id)
    -- if not self:是否存在('shape/char/%04d/stand.tcp', id) then
    --     if gge.isdebug then
    --         require('out').导出怪物(id)
    --     end
    -- end
    if not self:check('shape/char/%04d/stand.tcp', id) then
        return 37
    end
    return id
end

--处理召唤ID
function 配置:getsumid(id)
    -- if not id then
    --     return 0
    -- end
    -- if id > 100000 then
    --     id = id - 100000
    -- end
    -- if id > 2500 and id <= 3000 then
    --     id = id - 500
    -- end
    -- if not self:check('wzife/photo/sum/%d.tcp', id) then
    --     return 0
    -- end
    return id
end

--处理角色ID
function 配置:getheroid(id)
    -- if not id then
    --     return 0
    -- end
    -- if id > 12 then
    --     id = id - 12
    -- end
    -- if not self:check('wzife/photo/facesmall/%04d.tcp', id) then
    --     return 0
    -- end
    return id
end

return 配置
