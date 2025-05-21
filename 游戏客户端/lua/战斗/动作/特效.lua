local 技能库 = require('数据/技能库')
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data)
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
        if not __设置.分体法术特效 and 技能.分体特效 then
            self.动画 = __res:getani('magic/new/%04d.tca', 技能.分体特效)
        else
            self.动画 = __res:getani('magic/%04d.tca', 技能.特效)
        end
    end

    -- local 目标位置 = 战场层:取对象(t.施法)
    -- if 目标位置 then
    --     目标位置:动作_法术攻击()
    --     目标位置:置帧率(10)
    -- end

    __res:技能音效(技能.特效)
    战场层:添加技能(self)
    if self.动画 then
        self.动画:播放():置帧率(1 / 20)
        if 技能.全屏 and __设置.分体法术特效 then
            self.全屏 = true
            local x, y = 战场层:取全屏位置(技能.全屏)
            local tcp = self.动画.资源
            local w, h = tcp.width // 2, tcp.height // 2
            self.动画:置中心(-tcp.x + w - x, -tcp.y + h - y)
        end
    end

    self.目标 = {}
    for i, v in pairs(t.目标) do
        if v.位置 then
            local tg = 战场层:取对象(v.位置)
            self.目标[i] = tg
        end
    end

    self._定时 = 引擎:定时(
        10,
        function()
            if self.动画 then
                if not self.动画.是否播放 then
                    coroutine.xpcall(co)
                    return
                end
                return 10
            else
                coroutine.xpcall(co)
            end
        end
    )
    coroutine.yield()

    for i, v in pairs(self.目标) do
        v:播放战斗(t.目标[i], v)
    end
end

function 数据:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
        return not self.动画.是否播放
    end
end

function 数据:显示(x, y)
    if self.动画 then
        if self.全屏 then
            self.动画:显示(0, 0)
        else
            for i, v in pairs(self.目标) do
                self.动画:显示(v.xy.x, v.xy.y)
            end
        end
    end
end

return 数据
