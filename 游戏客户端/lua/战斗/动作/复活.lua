
local 数据 = {}
local 技能库 = require('数据/技能库')
function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 目标 = t.位置 and 战场层:取对象(t.位置) or 自己
    if t.特效 then
        local 技能 = 技能库[t.特效]
        self.动画 = __res:getani('magic/%04d.tca', t.特效)
        __res:技能音效(t.特效)
        self.动画:播放():置帧率(1 / 20)
        self.目标 = {目标}
        战场层:添加技能(self)
        if 技能.全屏 then
            self.全屏 = true
            local x, y = 战场层:取全屏位置(技能.全屏)
            local tcp = self.动画.资源
            local w, h = tcp.width // 2, tcp.height // 2
            self.动画:置中心(-tcp.x + w - x, -tcp.y + h - y)
        end
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
    if 目标 then
        目标:动作_复活()
    end
end

function 数据:更新(dt)
    self.动画:更新(dt)
    return not self.动画.是否播放
end

function 数据:显示(x, y)
    if self.全屏 then
        self.动画:显示(0, 0)
    else
        for i, v in pairs(self.目标) do
            self.动画:显示(v.x, v.y)
        end
    end
end

return 数据
