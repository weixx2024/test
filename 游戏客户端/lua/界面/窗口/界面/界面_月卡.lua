local 月卡窗口 = 窗口层:创建我的窗口('月卡窗口', 0, 0, 650, 450)
do
    function 月卡窗口:初始化()
        self:置精灵(
            self:取老红木窗口(
                self.宽度,
                self.高度,
                '月卡',
                function()
                    self:取拉伸图像_宽高('ui/mall-month-card-bg.png', 600, 395):显示(27, 28)
                    
                end
            )
        )
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
        self.禁止滚动 = true
    end

    function 月卡窗口:显示(x, y)

        
    end

    月卡窗口:创建关闭按钮()
end
local 天数文本 = 月卡窗口:创建我的文本('天数文本', 556, 385, 50, 30)
月卡窗口.天数文本:置文本('')


-- 创建中按钮(v.name .. '按钮', v.x, v.y, v.name)
local 领取奖励 = 月卡窗口:创建中按钮('领取奖励', 284, 380, '领取奖励')
function 领取奖励:左键弹起()
    print("领取奖励:左键弹起")
    local r,t = __rpc:角色_月卡奖励()
    if type(r) == 'string' then
        窗口层:提示窗口(r)
    end
    if t then
        领取奖励:置禁止(true)
    end
end

local 防刷校验 = true



function 窗口层:打开月卡(t)
    月卡窗口:置可见(not 月卡窗口.是否可见)
    if not 月卡窗口.是否可见 then
        return
    end
    local 剩余天数,是否领取 = __rpc:角色_月卡数据()
    if 剩余天数 <= 0 or 是否领取 then
        领取奖励:置禁止(true)
    else
        领取奖励:置禁止(false)
    end
    月卡窗口.天数文本:置文本(剩余天数)
    月卡窗口:置坐标((引擎.宽度 - 月卡窗口.宽度) // 2, (引擎.高度 - 月卡窗口.高度) // 2)
end

return 月卡窗口
