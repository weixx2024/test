

local 人物抗性 = 窗口层:创建我的窗口('人物抗性', 0, 0, 280, 427)
function 人物抗性:初始化()
    self:置精灵(
        生成精灵(
            280,
            427,
            function()
                __res:getsf('gires/0x76CCB3E2.tcp'):显示(0, 0)
            end
        )
    )

    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

local 抗性文本1 = 人物抗性:创建我的文本('抗性文本1', 15, 15, 125, 400)
local 抗性文本2 = 人物抗性:创建我的文本('抗性文本2', 140, 15, 125, 400)
抗性文本1:置文字(__res.F16)
抗性文本2:置文字(__res.F16)
抗性文本1:置文本('')
抗性文本2:置文本('')

function 抗性文本1:获得回调(x, y)
end

function 抗性文本2:获得回调(x, y)
end

function 人物抗性:添加抗性(r)
    if r then
        抗性文本1:清空()
        抗性文本2:清空()
        local y = 0
        local zh = ''
        local zj = ''
        for k, v in pairs(r) do
            y = y + 1
            if y == 1 then
                zh = zh .. k .. ' #u ' .. v .. ' #u\n'
            elseif y == 2 then
                zj = zj .. k .. ' #u ' .. v .. ' #u\n'
                y = 0
            end
        end
        抗性文本1:置文本('#cc8a483' .. zh)
        抗性文本2:置文本('#cc8a483' .. zj)
    end
end

function 窗口层:打开人物抗性()
    人物抗性:置可见(not 人物抗性.是否可见)
    if not 人物抗性.是否可见 then
        return
    end
    self:重新打开人物抗性()
end

function 窗口层:重新打开人物抗性()
    local r = __rpc:角色_打开抗性窗口()
    人物抗性:添加抗性(r) 
end
return 人物抗性
