local 物品 = {
    名称 = '超级藏宝图',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}
local _地图 = { 101295, 101299, 1110, 1135, 1173, 1131, 1142, 1092 }
function 物品:初始化()
    if not self.地图数据 then
        local map = 取随机地图(_地图)
        if map then
            local X, Y = map:取随机坐标()
            self.地图数据 = { id = map.id, x = X, y = Y, map.名称 }
            self.显示位置 = string.format('#Y坐标:%s(%d,%d)', map.名称, X, Y)
        end
    end
end

function 物品:掉落包(对象)
    if not 对象:取包裹空位() then
        对象:提示窗口('#Y 你的包裹已经满了！')
        return
    end

    if not 对象:取包裹空位() then
        对象:提示窗口('#Y 你的包裹已经满了！')
        return
    end

    local 掉落包 = 取掉落包('物品', '超级藏宝图')
    if 掉落包 then
        local r = 随机物品(掉落包)
        if r then
            local 物品 = 生成物品(r)
            if 物品 then
                if 对象:添加物品({ 物品 }) then
                    self.数量 = self.数量 - 1
                    if r.广播 then
                        对象:发送系统("#C%s使用超级藏宝图，一铲子下去，发现一个#G#m(%s)[%s]#m#n#89", 对象.名称, r.nid, r.名称)
                    end
                end
            end
        else
            对象:提示窗口('#Y 你的包裹已经满了2！')
        end
    end
end

local _地图 = {
    1201, 1217, 101300, 101299, 101295

}
function 物品:刷出妖王(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    self.时间 = os.time() + 900
    for _ = 1, 10, 1 do
        local X, Y = map:取随机坐标() --真坐标
        map:添加NPC {
            名称 = "三妖王界",
            外形 = 2018,
            脚本 = 'scripts/npc/挖宝妖王.lua',
            时间 = self.时间,
            X = X,
            Y = Y,
        }
    end
    玩家:发送系统("%s挖宝惊动了%s的妖王", 玩家.名称, map.名称)
end

function 物品:使用(对象)
    local map = 对象:取当前地图()
    if not self.地图数据 then
        self:掉落包(对象)
    else
        if map and self.地图数据.id == map.id then
            if math.abs(self.地图数据.x - 对象.X) < 5 and math.abs(self.地图数据.y - 对象.Y) < 5 then
                if math.random(100) < 20 then
                    self:刷出妖王(对象)
                    self.数量 = self.数量 - 1
                else
                    self:掉落包(对象)
                end
            else
                对象:提示窗口('#Y 要在宝图记录的坐标才可以挖到宝藏哦！')
            end
        else
            对象:提示窗口('#Y 要在宝图记录的坐标才可以挖到宝藏哦！')
        end
    end
end

function 物品:取描述()
    if self.显示位置 then
        return self.显示位置
    end
    return "#Y未知地图"
end

return 物品
