
local 技能库 = require('数据/技能库')
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 技能 = 技能库[t.id]
    if not 技能 then
        warn('技能不存在：', t.id)
        return
    end

    if 技能.特效 == 1705 then --老的不是全屏
        self.动画 = __res:getani('magic/fullscreen/%04d.tca', 技能.特效)
    elseif 技能.特效 then
        self.动画 = __res:getani('magic/%04d.tca', 技能.特效)
    end

    if not self.动画 then
        return
    end
    __res:技能音效(技能.特效)
    自己:动作_物理攻击()
    自己:置帧率(1 / 30)
    自己:置帧事件(function(dh, a, b)
        if a / b >= 0.7 then --帧数》70% 播放掉血
            coroutine.xpcall(co)
            return false
        end
    end)
    coroutine.yield()

    战场层:添加技能(self)
    self.动画:播放():置帧率(1 / 20)
    self.目标 = {}
    for i, v in pairs(t.目标) do
        local tg = 战场层:取对象(v.位置)
        self.目标[i] = tg
    end

    if 技能.全屏 then
        self.全屏 = true
        local x, y = 战场层:取全屏位置(技能.全屏)
        local tcp = self.动画.资源
        local w, h = tcp.width // 2, tcp.height // 2
        self.动画:置中心(-tcp.x + w - x, -tcp.y + h - y)
    end

    -- self._定时 = 引擎:定时(
    --     200,
    --     function()
    --         coroutine.xpcall(co)
    --     end
    -- )
    -- coroutine.yield()

    coroutine.xpcall(function()
        for i, v in pairs(self.目标) do
            v:播放战斗(t.目标[i], 自己)
        end
    end)
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
