local GUI = require '界面'
local 地图寻路 = require('地图/寻路')
local 地图类 = class('地图', 地图寻路)

function 地图类:初始化(id, width, height)
    id = id & 0x1FFFF
    local map = assert(__res:getmap(id), '地图不存在'..(id or "无"))
    GUI.界面层:置地图(id)
    self.id = id
    local t = require('数据/地图库')[id] 
    if t then
        __res:地图音乐(t.music)
    end
    self.名称 = t and t.name or '未知'
    self.背景 = t and t.bg or 104000 --战斗
    self._map = map
    self.宽度 = map.width
    self.高度 = map.height
    self.列数 = map.colnum
    self.行数 = map.rownum
    self.总数 = map.mapnum
    self.地表 = {}
    self.遮罩 = {}
    self.对象 = {}
    self.obj = {}

    self:置宽高(width or 引擎.宽度, height or 引擎.高度)
    --==================================================================================
    地图寻路.地图寻路(self, self.列数 * 16, self.行数 * 12, map:取障碍())
end

function 地图类:随机坐标()
    x = math.random(self.宽度) // 20
    y = math.random(self.高度)
    return x, (self.高度 - y) // 20
end

function 地图类:置宽高(w, h)
    self._w = w
    self._h = h
    self._w2 = w // 2
    self._h2 = h // 2
    self._w3 = self.宽度 - self._w2
    self._h3 = self.高度 - self._h2

    self._x = nil
    self._y = nil
end

function 地图类:更新(dt, xy)
    if self.up then --刷新玩家或遮罩
        self.up = false
        self.obj = {}
        for k, v in pairs(self.对象) do
            table.insert(self.obj, v)
        end
        --先对玩家，NPC排序
        table.sort(
            self.obj,
            function(a, b)
                return a:取排序点() < b:取排序点()
            end
        )

        --计算遮罩插入的位置
        for _, m in pairs(self.遮罩) do
            for i = #self.obj, 1, -1 do
                local p = self.obj[i]
                if ggetype(p) ~= '地图遮罩' then
                    if m:检查排序点(p, self.xy) then
                        table.insert(self.obj, i + 1, m)
                        break
                    end
                end
            end
        end

        --删除最底下的遮罩
        -- while ggetype(self.obj[1]) == '地图遮罩' do
        --     table.remove(self.obj, 1)
        -- end
    end

    for _, v in ipairs(self.obj) do
        if v:更新(dt) then
            self.up = true
        end
    end

    local x, y = xy.x, xy.y
    if x == self._x and y == self._y then --刷新地表
        return
    end

    self._x = x
    self._y = y
    if x > self._w3 then
        x = self._w3
    end
    if y > self._h3 then
        y = self._h3
    end
    x = x - self._w2
    y = y - self._h2
    if x < 0 then
        x = 0
    end
    if y < 0 then
        y = 0
    end
    self.x = x
    self.y = y
    self.xy = require('GGE.坐标')(x, y)

    self.list = {}
    self.遮罩 = {}
    local sid = (y // 240) * self.列数 + (x // 320)
    local id = sid
    x = -(x % 320)
    y = -(y % 240)

    if self.宽度 < self._w then --如果 地图小于屏幕，居中
        x = (self._w - self.宽度) // 2
        y = (self._h - self.高度) // 2
        self.x = x
        self.y = y
        self.xy = require('GGE.坐标')(-x, -y)
    end

    for cy = y, self._h, 240 do
        for cx = x, self._w, 320 do
            if self.地表[id] then
                self.地表[id].x = cx
                self.地表[id].y = cy
                table.insert(self.list, self.地表[id])
                for k, v in pairs(self.地表[id].遮罩) do
                    self.遮罩[v.id] = v
                end
            elseif self.地表[id] == nil then
                self.地表[id] = {}
                coroutine.xpcall(
                    function()
                        self.地表[id].精灵,self.地表[id].遮罩 = self._map:取精灵2(id,true)
                        self._x = nil --刷新
                    end
                )
            end

            id = id + 1
            if id == self.列数 or id == self.总数 then
                break
            end
        end
        sid = sid + self.列数
        id = sid
        if sid >= self.总数 then
            break
        end
    end
    self.up = true
    self._map:更新()
end

-- local 障碍 = require("SDL.精灵")(0,0,0,20,20):置颜色(0,0,0,150)
-- local 路径 = require("SDL.精灵")(0,0,0,20,20):置颜色(0,255,0,150)
--格子 = require("GGE.坐标")(20,20)
function 地图类:显示()
    for i, v in ipairs(self.list) do
        v.精灵:显示(v.x, v.y)
    end
end

function 地图类:显示对象()
    for _, v in ipairs(self.obj) do
        v:显示(self.xy)
    end
    for _, v in ipairs(self.obj) do
        if v.显示顶层 then
            v:显示顶层(self.xy)
        end
    end
end

function 地图类:添加(v)
    if v and v.nid then
        self.对象[v.nid] = v
        self.up = true
        -- 需要绑定队长和队友
        self:绑定队伍(v)

        self:绑定神行(v)

        return v
    end
end

function 地图类:绑定神行(v)
    if v.神行符 then
        v.神行 = {}
        for i = 1, 5 do
            table.insert(
                v.神行,
                __map:添加(require('对象/神行')({
                    外形 = v.外形,
                    原形 = v.原形,
                    nid = __生成ID(),
                    x = v.x,
                    y = v.y,
                    透明度 = 0
                })))
        end
    end
end

function 地图类:绑定队伍(v)
    -- 队员加载，绑定队长位置
    if v.队长 and v.队伍位置 then
        local 队长 = self.对象[v.队长]
        if 队长 and 队长.队伍 then
            队长.队伍[v.队伍位置] = v
        end
    end
    -- 队长加载，绑定队员位置
    if v.是否队长 and v.队友 then
        for i, P in ipairs(v.队友) do
            local 队员 = self.对象[P]
            if 队员 then
                v.队伍[i + 1] = 队员
            end
        end
    end
end

function 地图类:删除(nid)
    self.对象[nid] = nil
    self.up = true
end

function 地图类:对象开关神行符(nid, flag)
    if __rol.nid == nid then
        __rol.神行符 = flag
    end
    if self.对象[nid] then
        self.对象[nid].神行符 = flag
    end
end

function 地图类:取对象(nid)
    return self.对象[nid]
end

function 地图类:重新排序()
    self.up = true
end

-- 帮战
function 地图类:修改动作(nid, 动作)
    if self.对象[nid] then
        self.对象[nid]:修改动作(动作)
        self.up = true
    end
end

function 地图类:点亮冰塔(nid, r)
    if self.对象[nid] then
        self.up = true
        return self.对象[nid]:点亮冰塔(r)
    end
end

function 地图类:点亮火塔(nid, r)
    if self.对象[nid] then
        self.up = true
        return self.对象[nid]:点亮火塔(r)
    end
end

return 地图类
