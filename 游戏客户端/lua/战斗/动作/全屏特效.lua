-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-28 04:41:04
-- @Last Modified time  : 2024-03-26 03:34:59

-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-24 11:14:33
-- @Last Modified time  : 2023-08-26 23:14:18
local 技能库 = require('数据/技能库')
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 技能 = 技能库[t.id]
    print(t.id,技能.特效)
    if not 技能 then
        print('技能不存在：', t.id)
        return
    end
    if 技能.特效 == 1705 then --老的不是全屏
        self.动画 = __res:getani('magic/fullscreen/%04d.tca', 技能.特效)
    elseif 技能.特效 then
        self.动画 = __res:getani('magic/%04d.tca', 技能.特效)
    end
     print('开关',__设置.全屏法术开关)
    local 五法特效 = {105,205,305,405,505,605,705,805,905,1005,1105,1205,1705,1805,1905,2005}
    if not __设置.全屏法术开关 then
        for i = 1 , #五法特效 do
            if 技能.特效 == 五法特效[i] then
                local 临时特效 = 技能.特效 + 10001
                self.动画 = __res:getani('magic/%04d.tca', 临时特效)
                技能.全屏 = nil
            end
        end
    else
        for i = 1 , #五法特效 do
            if 技能.特效 == 五法特效[i] then
                技能.全屏 = 0
            end
        end
    end

    if not self.动画 then
        return
    end
    __res:技能音效(技能.特效)

    战场层:添加技能(self)
    self.动画:播放():置帧率(1 / 20)
    self.全屏 = true
    local x, y = 战场层:取全屏位置(技能.全屏)
    local tcp = self.动画.资源
    local w, h = tcp.width // 2, tcp.height // 2
    self.动画:置中心(-tcp.x + w - x, -tcp.y + h - y)
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
    self.动画:显示(0, 0)
end

return 数据
