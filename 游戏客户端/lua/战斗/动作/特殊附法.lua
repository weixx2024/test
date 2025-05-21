-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-24 01:37:19
-- @Last Modified time  : 2022-08-30 10:11:44
local 技能库 = require('数据/技能库')
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 技能 = 技能库[t.id] or {}
    if 技能.特效 then
        if 技能.特效 == 1705 then --老的不是全屏
            self.动画 = __res:getani('magic/fullscreen/%04d.tca', 技能.特效)
        elseif 技能.特效 then
            self.动画 = __res:getani('magic/%04d.tca', 技能.特效)
        end
        __res:技能音效(技能.特效)
    end
    local sj = math.random(3)
    if t.原始目标 then
        local 对象 = 战场层:取对象(t.原始目标)
        if t.id == "剑荡八荒" then
            自己.移动速度 = 1000
            自己:动作_闪现移动(自己:取四方闪现攻击坐标(对象))
            self._定时 = 引擎:定时(
            10,
            function()
                    --移动到目标
                    if 保护 then
                        if 保护.是否移动 then
                            return 10
                        else
                            保护:置方向(保护.战斗方向)
                        end
                    end
                    if not 自己.是否移动 and not 自己.是否特殊移动 and not 自己.是否闪现 then
                        coroutine.xpcall(co)
                        return
                    end
                    return 10
                end
            )
            coroutine.yield()
        end
    end
    if t.id == "天降脱兔" then
        自己:动作_二段物理攻击(nil,"attackc1-1","attackc1-2")
        自己:置帧率(1 / 15)
        self._定时 = 引擎:定时(
            10,
            function()
                if 保护 then --等待保护结束
                    if coroutine.status(pco) ~= 'dead' then
                        return 10
                    end
                end
                --等待目标结束
                if (not tco or coroutine.status(tco) == 'dead') and (自己.模型 == 'guard' or 自己.模型 == 'die') then
                    coroutine.xpcall(co)
                    return
                end
                return 10
            end
        )
        coroutine.yield()
    else
        自己:动作_物理攻击(nil,"attackc"..sj.."-1")
        自己:置帧率(1 / 35)
        自己:置帧事件(function(dh, a, b)
            if a / b >= 0.7 then --帧数》70% 播放掉血
                coroutine.xpcall(co)
                return false
            end
        end)
        coroutine.yield()
    end
    
    self.目标 = {}
    for i, v in pairs(t.目标) do
        local tg = 战场层:取对象(v.位置)
        self.目标[i] = tg
    end

    if self.动画 then
        战场层:添加技能(self)
        self.动画:播放():置帧率(1 / 20)
        if 技能.全屏 then
            self.全屏 = true
            local x, y = 战场层:取全屏位置(技能.全屏)
            local tcp = self.动画.资源
            local w, h = tcp.width // 2, tcp.height // 2
            self.动画:置中心(-tcp.x + w - x, -tcp.y + h - y)
        end
    end

    coroutine.xpcall(function()
        for i, v in pairs(self.目标) do
            v:播放战斗(t.目标[i])
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
