-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-03-07 18:52:00
-- @Last Modified time  : 2022-06-18 13:10:12

local Astar = class('Astar')

function Astar:初始化(w, h, data)
    self._ud = require('gastar')(w, h, data)
    self._p = {}
    self.w = w
    self.h = h
end

function Astar:是否障碍(x, y)
    return not self._ud:CheckPoint(x, y)
end

function Astar:是否通行(x, y)
    return self._ud:CheckPoint(x, y)
end

function Astar:置障碍(x, y, v)
    self._ud:SetPoint(x, y, v or 1)
end

function Astar:取路径(x, y, x1, y1)
    return self._ud:GetPath(x, y, x1, y1)
end
return Astar
