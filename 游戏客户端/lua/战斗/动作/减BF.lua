
local 数据 = {}
local 技能库 = require('数据/技能库')
function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 目标 = t.位置 and 战场层:取对象(t.位置) or 自己
    if t.tx and 技能库[t.tx] then
        self.动画 = __res:getani('magic/%04d.tca', t.tx)
        if self.动画 == nil then
            self.动画 = __res:getani('magic/%04d.tcp', t.tx)
        end
        if self.动画 then
            战场层:添加技能(self)
            self.动画:播放():置帧率(1 / 20)
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
    end
    if t.id == "隐身" or t.id == 9901    then --or t.id == 901
        目标.隐身 = false
        目标:置隐身效果(false)
    end
    if 目标 and type(t.id) == 'number' then
        目标:删除BUFF(t.id)
        if t.id == 401 then
            目标:播放()
        end
    end
end



function 数据:更新(dt)
    self.动画:更新(dt)
    return not self.动画.是否播放
end

function 数据:显示(x, y)
    self.动画:显示(x, y)
end

return 数据
