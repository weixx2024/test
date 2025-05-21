local 召唤抗性 = 窗口层:创建我的窗口('召唤抗性', 0, 0, 280, 427)
function 召唤抗性:初始化()
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

function 召唤抗性:可见事件(v)
    if v == false then
        __rpc:角色_关闭召唤抗性窗口()
    end
end

local 抗性文本1 = 召唤抗性:创建我的文本('抗性文本1', 15, 15, 125, 400)
local 抗性文本2 = 召唤抗性:创建我的文本('抗性文本2', 140, 15, 125, 400)
抗性文本1:置文字(__res.F16)
抗性文本2:置文字(__res.F16)
抗性文本1:置文本('')
抗性文本2:置文本('')

function 抗性文本1:获得回调(x, y)
end

function 抗性文本2:获得回调(x, y)
end

function 召唤抗性:添加抗性(r)
    if r then
        抗性文本1:清空()
        抗性文本2:清空()
        local y = 0
        local zh = ''
        local zj = ''
        for k, v in pairs(r) do
            local s = "%0.3g"
            if k == "亲密" then
                s = "%d"
            elseif k == "成长" then
                s = "%0.3f"
            end
            if v%1==0 then
                s = "%d"
            end
            y = y + 1
            if y == 1 then
                zh = zh .. k .. ' #u ' .. string.format(s, v) .. ' #u\n'
            elseif y == 2 then
                zj = zj .. k .. ' #u ' .. string.format(s, v) .. ' #u\n'
                y = 0
            end
        end
        抗性文本1:置文本('#cc8a483' .. zh)
        抗性文本2:置文本('#cc8a483' .. zj)
    end
end

function 窗口层:打开召唤抗性(nid)
    召唤抗性:置可见(not 召唤抗性.是否可见)
    if not 召唤抗性.是否可见 then
        return
    end

    local r = __rpc:召唤_打开抗性窗口(nid)
    召唤抗性:添加抗性(r)
end

return 召唤抗性
