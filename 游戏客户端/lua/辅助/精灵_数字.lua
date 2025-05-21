

local 数字精灵 = class('数字精灵')

function 数字精灵:数字精灵(path, num, mode)
    if path then
        for i = 0, 9 do
            self[tostring(i)] = __res:getspr(path, i) --:置中心(0, 0)
        end
    end
    self._m = mode
    self._n = {}
    self:置数字(num)
end

function 数字精灵:置数字(num)
    self._n = {}
    if num then
        local w = 0
        for v in string.gmatch(num, '%d') do
            if self[v] then
                w = w + self[v].宽度
                table.insert(self._n, self[v])
            end
        end
        self._x = w // 2
    end
end
function 数字精灵:置数字2(num)
    self._n = {}
    if num then
        self.h = num // 3600 < 10 and "0" .. num // 3600 or num // 3600
        num = num - self.h * 3600
        self.f = num // 60 < 10 and "0" .. num // 60 or num // 60
        num = num - self.f * 60
        num = num < 10 and "0" .. num or num
        local w = 0
        for v in string.gmatch(self.h, '%d') do
            if self[v] then
                w = w + self[v].宽度
                table.insert(self._n, self[v])
            end
        end
        for v in string.gmatch(self.f, '%d') do
            if self[v] then
                w = w + self[v].宽度
                table.insert(self._n, self[v])
            end
        end
        for v in string.gmatch(num, '%d') do
            if self[v] then
                w = w + self[v].宽度
                table.insert(self._n, self[v])
            end
        end

        self._x = w // 2
    end
end
function 数字精灵:显示(x, y)
    if self._m == 0 then --向左
        local i = #self._n
        local _x = 0
        repeat
            if self._n[i] then
                _x = _x + self._n[i].宽度
                self._n[i]:显示(x - _x, y)
            end
            i = i - 1
        until i == 0
    elseif self._m == 1 then --居中
        local _x = 0
        for i, v in ipairs(self._n) do
            v:显示((x + _x) - self._x, y)
            _x = _x + v.宽度
        end
    else --正常 向右
        local _x = 0
        for i, v in ipairs(self._n) do
            v:显示(x + _x, y)
            _x = _x + v.宽度
        end
    end
end

return 数字精灵
