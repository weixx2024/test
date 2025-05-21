-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-24 01:37:19
-- @Last Modified time  : 2022-08-30 10:11:44
local 技能库 = require('数据/技能库')
local 数据 = {}
local function _角度算方向8(a)
    local r
    if (a > 157 and a < 203) then
        r = 6 --"左"
    elseif (a > 202 and a < 248) then
        r = 3 --"左上"
    elseif (a > 247 and a < 293) then
        r = 7 --"上"
    elseif (a > 292 and a < 338) then
        r = 4 --"右上"
    elseif (a > 337 or a < 24) then
        r = 8 --"右"
    elseif (a > 23 and a < 69) then
        r = 1 --"右下"
    elseif (a > 68 and a < 114) then
        r = 5 --"下"
    elseif (a > 113) then
        r = 2 --"左下"
    end
    return r, a
end
function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 初始目标 = t.原始目标
    local 目标顺序 = t.目标顺序
    local tcp = __res:get('magic/%04d.tcp', 1280)
    if #初始目标 > 0 then
        self.结束流程 = false
        战场层:添加技能(self)
        self.动画 = {}
        for i=1,#初始目标 do
            self.动画[i] = {}
            local 对象 = 战场层:取对象(初始目标[i])
            if 对象 then
                for n,v in ipairs(目标顺序[i]) do
                    self.动画[i][n] = require('对象/基类/动画')(tcp)
                    self.动画[i][n].禁止更新 = true
                    local 新对象 = 战场层:取对象(v)
                    local 目标数据 = 对象:取攻击坐标(新对象)
                    local px,py = 对象.xy.x,对象.xy.y
                    self.动画[i][n].pxy = {x=px,y=py}
                    local 角度 = 对象.xy:取角度(目标数据)
                    self.动画[i][n]:置方向(_角度算方向8(角度))
                    self.动画[i][n]:置帧率(1/15)
                    对象 = 战场层:取对象(v)
                end
            end
        end
        local i = 1
        ::下一个::
        for n=1,#self.动画 do
            self.动画[n][i].禁止更新 = false
        end
        self._定时 = 引擎:定时(
            10,
            function()
                --等待目标结束
                if (not tco or coroutine.status(tco) == 'dead') and self.动画[1][i]:取当前帧()/self.动画[1][i]:取帧数() >= 0.7 then
                    coroutine.xpcall(co)
                    return false
                end
                return 10
            end
        )
        coroutine.yield()
        for n=1,#目标顺序 do
            local 新对象 = 战场层:取对象(目标顺序[n][i])
            新对象:播放战斗({t.目标[目标顺序[n][i]][1]})
            table.remove(t.目标[目标顺序[n][i]],1)
        end
        for n=1,#self.动画 do
            self.动画[n][i].禁止更新 = true
        end
        i = i + 1
        if i < #目标顺序[1]+1 then
            goto 下一个
        end
    end
    self.结束流程 = true
end

function 数据:更新(dt)
    for i,v in ipairs(self.动画) do
        for x,_ in ipairs(v) do
            if not _.禁止更新 then
                _:更新(dt)
            end
        end
    end
    return self.结束流程
end

function 数据:显示(x, y)
    for i,v in ipairs(self.动画) do
        for x,_ in ipairs(v) do
            if not _.禁止更新 then
                _:显示(_.pxy.x, _.pxy.y)
            end
        end
    end
end

return 数据
