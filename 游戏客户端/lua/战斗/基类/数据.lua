local 状态 = require('战斗/基类/状态')
local 战斗数据 = class('战斗数据', 状态)

function 战斗数据:初始化(t)

end

function 战斗数据:更新(dt)
    self[状态]:更新(dt)
end

function 战斗数据:显示(xy)
    self[状态]:显示(xy)
end

function 战斗数据:显示底层(xy)
    --self[状态]:显示底层(xy)
end

function 战斗数据:显示顶层(xy)
    self[状态]:显示顶层(xy)
end

function 战斗数据:取闪现攻击坐标(对象, 距离)
    local txy = 对象.战斗坐标
    local a = self.xy:取弧度(txy)
    local r = self.xy:取距离(txy)
    return self.xy:取距离坐标(r - (距离 or 50), a)
end

function 战斗数据:取四方闪现攻击坐标(对象, 距离)
    local txy = 对象.战斗坐标
    -- 怪物的中心坐标
    local mx, my = txy.x, txy.y
    -- 固定距离
    local fixed_distance = 50
    -- 定义方向和坐标变化
    local directions = {
        {name = "前", dx = 0, dy = -1},
        {name = "后", dx = 0, dy = 1},
        {name = "左", dx = -1, dy = 0},
        {name = "右", dx = 1, dy = 0},
        {name = "左前", dx = -1, dy = -1},
        {name = "右前", dx = 1, dy = -1},
        {name = "左后", dx = -1, dy = 1},
        {name = "右后", dx = 1, dy = 1}
    }
    -- 计算新坐标
    local function calculateNewPosition(direction)
        local new_px = mx + direction.dx * fixed_distance
        local new_py = my + direction.dy * fixed_distance
        return new_px, new_py
    end
    local fx = math.random(8)
    local new_px, new_py = calculateNewPosition(directions[fx])
    local xys = require('GGE.坐标')(new_px, new_py)
    local a = xys:取弧度(txy)
    local r = xys:取距离(txy)
    return xys:取距离坐标(r - (距离 or 50), a)
end

function 战斗数据:取攻击坐标(对象, 距离)
    local txy = 对象.战斗坐标
    local a = self.战斗坐标:取弧度(txy)
    local r = self.战斗坐标:取距离(txy)
    return self.战斗坐标:取距离坐标(r - (距离 or 50), a)
end

function 战斗数据:取暗影离魂攻击坐标(对象, 距离)
    local txy = 对象.战斗坐标
    local a = self.xy:取弧度(txy)
    local r = self.xy:取距离(txy)
    local zb = self.xy:取距离坐标(r-50 , a)
    zb.y=zb.y+40
    return zb
end

function 战斗数据:取后退坐标(对象, 距离)
    return self.xy:取距离坐标(距离, 对象.xy:取弧度(self.xy))
end

local function loadact(file)
    local r = gge.require(file, setmetatable({ 战场层 = 战场层, 窗口层 = 窗口层, 界面层 = 界面层 },
        { __index = _G }))
    package.loaded[file] = r or file
    return r
end



local _动作 = {
    物攻 = loadact('战斗/动作/物攻'),
    物伤 = loadact('战斗/动作/物伤'),
    物反 = loadact('战斗/动作/物反'),
    法反 = loadact('战斗/动作/法反'),
    附法 = loadact('战斗/动作/附法'),
    法术 = loadact('战斗/动作/法术'),
    特效 = loadact('战斗/动作/特效'),
    法术后 = loadact('战斗/动作/法术后'),
    法伤 = loadact('战斗/动作/法伤'),
    道具 = loadact('战斗/动作/道具'),
    召唤 = loadact('战斗/动作/召唤'),
    召还 = loadact('战斗/动作/召还'),
    捕捉 = loadact('战斗/动作/捕捉'),
    逃跑 = loadact('战斗/动作/逃跑'),
    加BF = loadact('战斗/动作/加BF'),
    减BF = loadact('战斗/动作/减BF'),
    魔法 = loadact('战斗/动作/魔法'),
    气血 = loadact('战斗/动作/气血'),
    死亡 = loadact('战斗/动作/死亡'),
    复活 = loadact('战斗/动作/复活'),
    提示 = loadact('战斗/动作/提示'),
    怨气 = loadact('战斗/动作/怨气'),
    喊话 = loadact('战斗/动作/喊话'),
    孩子喊话 = loadact('战斗/动作/孩子喊话'),
    孩子技能 = loadact('战斗/动作/孩子技能'),
    暗影离魂 = loadact('战斗/动作/暗影离魂'),
    切换外形 = loadact('战斗/动作/切换外形'),
    加特效 = loadact('战斗/动作/加特效'),
    水中探月法术 = loadact('战斗/动作/水中探月法术'),
    驱逐 = loadact('战斗/动作/驱逐'),
    特殊附法 = loadact('战斗/动作/特殊附法'),
    无特效附法 = loadact('战斗/动作/无特效附法'),
    群体加特效 = loadact('战斗/动作/群体加特效'),
    蜃光流星法术 = loadact('战斗/动作/蜃光流星法术'),
    全屏特效 = loadact('战斗/动作/全屏特效'),
    天降流火 = loadact('战斗/动作/天降流火'),
    
}

function 战斗数据:播放战斗(data, ...)
    if not data then
        return
    end
    local arg = { ... }
    local co, main = coroutine.running()
    local tco
    coroutine.xpcall(
        function()
            tco = coroutine.running()
            while data[1] do
                local t = data[1]
                if _动作[t.动作] then
                    local s = setmetatable({}, { __index = _动作[t.动作] })
                    self[s] = s
                    if data[1].nid then
                        __rpc:角色_播放动作返回(data[1].nid)
                    end
                    s:播放战斗(data, self, table.unpack(arg))
                    self[s] = nil
                else
                    warn('动作不存在:', t.动作)
                    table.remove(data, 1)
                end
            end
            if not main then
                coroutine.xpcall(co)
            end
        end
    )
    if main then --从定时器
        return tco
    elseif coroutine.status(tco) ~= 'dead' then
        coroutine.yield()
    end
end

return 战斗数据
