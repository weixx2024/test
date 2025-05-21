local GUI = require('GUI')(引擎, __res.F14)
local 地图层 = GUI:创建界面('地图层')
local 战场层 = GUI:创建界面('战场层')
local 登录层 = GUI:创建界面('登录层')
local 界面层 = GUI:创建界面('界面层')
local 窗口层 = GUI:创建界面('窗口层')
local 鼠标层 = GUI:创建鼠标('鼠标层')
local 资源层 = GUI:创建界面('资源层') --这层看不见，主要用来更新表情动画
--local 公告层 = GUI:创建界面('公告层')

function 资源层:初始化()
    --  self:置宽高(800, 600)
    self.emote = {}
    self.fonts = { 默认 = __res.F14, 宋体 = __res.F14 }
    for id = 0, 258 do
        local tca = __res:get('gires/emote/%02d.tca', id)
        if tca then --and tca.frame > 1
            local ani = tca:取动画(1)
            ani:置帧率(1 / 5)
            self.emote[id] = ani:播放(true)
            ani:置中心(-ani.资源.x, -ani.资源.y + ani.高度)
        end
    end
end

function 资源层:置倒时(g, n)
    if not g or g <= 0 or n <= 0 then
        self.倒时精灵 = nil
    else
        if not self.倒时精灵 then
            self.倒时精灵 = require('辅助/寻芳_倒时')(-1)
        end
        self.倒时精灵:置关卡(g, n)
    end
end

function 资源层:更新(dt)
    if self.倒时精灵 then
        self.倒时精灵:更新(dt)
    end
end

function 资源层:显示(x, y)
    if self.倒时精灵 then
        self.倒时精灵:显示(x, y)
    end
end

资源层:置可见(true, true)
-- 这里不能require 界面？因为会死循环
return GUI
