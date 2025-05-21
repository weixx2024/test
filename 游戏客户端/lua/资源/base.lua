
local base = class('base')

function base:初始化()
    self._time = os.time() + 300
end

function base:更新时间()
    self._time = os.time() + 300
end

function base:检查时间(time)
    return time > self._time
end

return base
