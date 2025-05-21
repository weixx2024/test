

local function _角度算方向(g, a, i)
    if g == 4 then
        local r
        if a then
            if (a >= 0 and a <= 90) then
                r = 1
            elseif (a > 90 and a <= 180) then
                r = 2
            elseif (a > 180 and a <= 270) then
                r = 3
            elseif (a > 270) then
                r = 4
            end
        elseif i == 1 or i == 5  then --(i+4) %4
            return 1
        elseif i == 2 or i == 6  then
            return 2
        elseif i == 3 or i == 7  then
            return 3
        elseif i == 4 or i == 8  then
            return 4
        end
        return r
    else
        local r
        if a then
            if (a >= 300 or a <= 120) then
                r = 1
            elseif a > 120 then
                r = 2
            end
        elseif i == 1 or i == 5 or i == 4 or i == 8 then
            return 1
        else
            return 2
        end
        return r
    end
end
--控制各方向的动画
local 动画类 = class('动画类')

function 动画类:动画类(tcp)
    self._tcp = tcp
    self.宽度 = tcp.width
    self.高度 = tcp.y
    self.方向数 = tcp.group
    self.x = tcp.x
    self.y = tcp.y
    self._ani = {}
    for i = 1, tcp.group do
        self._ani[i] = tcp:取动画(i):播放()
    end
    self:置方向(1)
end

function 动画类:更新(dt)
    self._cur:更新(dt)
end

function 动画类:显示(x, y)
    self._cur:显示(x, y)
end

function 动画类:调色(pp, p)
    self._tcp:调色(pp, p)
    for i = 1, self.方向数 do
        self._ani[i]:清空()
        self._ani[i].资源.p = p
    end
end

function 动画类:置方向(i, a)
    if i > self.方向数 then
        i = _角度算方向(self.方向数, a, i)
    end
    if self._ani[i] then
        --self.方向 = i
        self._cur = self._ani[i]
    end
    return self
end

function 动画类:取精灵()
    return self._cur:取精灵()
end

function 动画类:取当前帧()
    return self._cur.当前帧
end

function 动画类:取帧数()
    return self._cur.帧数
end

function 动画类:检查点(x, y)
    return self._cur:检查点(x, y)
end

function 动画类:检查透明(x, y)
    return self._cur:检查透明(x, y)
end

function 动画类:停止()
    self._cur:停止()
    return self
end

function 动画类:播放()
    self._cur:播放()
    return self
end

function 动画类:暂停()
    self._cur:暂停()
    return self
end

function 动画类:置首帧()
    for i, v in ipairs(self._ani) do
        v:置首帧()
    end
    return self
end

function 动画类:置尾帧()
    for i, v in ipairs(self._ani) do
        v:置尾帧()
    end
    return self
end

function 动画类:置往返(...)
    for i, v in ipairs(self._ani) do
        v:置往返(...)
    end
    return self
end

function 动画类:置循环(...)
    for i, v in ipairs(self._ani) do
        v:置循环(...)
    end
    return self
end

function 动画类:置循环次数(cs)
    for i, v in ipairs(self._ani) do
        v:置循环次数(cs)
    end
    return self
end

function 动画类:置帧率(...)
    for i, v in ipairs(self._ani) do
        v:置帧率(...)
    end
    return self
end

function 动画类:置帧事件(...)
    for i, v in ipairs(self._ani) do
        v.帧事件 = ...
    end
    return self
end

function 动画类:置停止事件(...)
    for i, v in ipairs(self._ani) do
        v.停止事件 = ...
    end
    return self
end

function 动画类:置高亮(...)
    for i, v in ipairs(self._ani) do
        v:置高亮(...)
    end
    return self
end

function 动画类:置颜色(...)
    for i, v in ipairs(self._ani) do
        v:置颜色(...)
    end
    return self
end
return 动画类
