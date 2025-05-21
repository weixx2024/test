-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-02 21:21:56
-- @Last Modified time  : 2024-08-23 14:00:07
local 数据 = {}
local 技能库 = require('数据/技能库')
function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    self.目标 = t.位置 and 战场层:取对象(t.位置) or 自己
    if 技能库[t.id] then
        self.动画 = __res:getani('magic/%04d.tca', t.id)
        if self.动画 == nil then
            self.动画 = __res:getani('magic/%04d.tcp', t.id)
        end
    end
    if not self.动画 then
        return
    end
    战场层:添加技能(self)
    self.动画:播放():置帧率(1 / 20)
    self._定时 = 引擎:定时(
        1,
        function()
            if not self.动画.是否播放 then
                coroutine.xpcall(co)
                return
            end
            return 1
        end
    )
    coroutine.yield()
end

function 数据:更新(dt)
    self.动画:更新(dt)
    return not self.动画.是否播放
end

function 数据:显示(x, y)
    self.动画:显示(self.目标.x, self.目标.y)
end

return 数据
