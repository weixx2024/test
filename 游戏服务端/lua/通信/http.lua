-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-09-12 14:03:12
-- @Last Modified time  : 2022-09-12 15:14:27

local http = require('HPSocket.HttpClient')(true)

function http:下载()
    http:连接('', 8800)
    if coroutine.isyieldable() then
        return self:GET('ip.txt')
    end
    http:断开()
end

return http
