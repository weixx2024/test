local _抗性库 = require('数据/抗性库')
local 抗性类型 = { "法术抗性", "物理属性", "五行属性", "法术增强", "其他" }
local 高度列表 = { 0, 0, 0, 0, 0 }

local 抗性列表 = {}
local table_抗性长按钮 = {}

local 召唤抗性 = 窗口层:创建我的窗口('召唤抗性', 0, 0, 319, 800)
function 召唤抗性:初始化()
    self:置坐标(引擎.宽度 - 362 - 319, (引擎.高度 - 455) // 2)
end

for k, v in ipairs(抗性类型) do
    local y = k == 1 and 24 or 0
    local 抗性列表项 = 召唤抗性:创建多列列表(v, 5, y, 319, 666)

    function 抗性列表项:初始化()
        self.行高度 = 20
        self:置文字(__res.F12)
        self:添加列(0, 2, 62, 14)
        self:添加列(92, 2, 88, 14)
        self:添加列(147, 2, 62, 14)
        self:添加列(239, 2, 77, 14)
    end

    function 抗性列表项:添加抗性(数据)
        self:置颜色(255, 255, 255)
        if 数据[1] and 数据[2] then
            self:添加(数据[1].抗性, 数据[1].数值, 数据[2].抗性, 数据[2].数值)
        elseif 数据[1] then
            self:添加(数据[1].抗性, 数据[1].数值)
        end
        高度列表[k] = 高度列表[k] + 20
    end

    function 抗性列表项:右键弹起()
        召唤抗性:置可见(false)
    end

    table.insert(抗性列表, 抗性列表项)
end

for k, v in ipairs(抗性类型) do
    local 抗性长按钮 = 召唤抗性:创建抗性长按钮1('抗性长按钮' .. k, 0, (k - 1) * 24, v)
    table.insert(table_抗性长按钮, 抗性长按钮)
end

function 窗口层:重排召唤抗性按钮()
    local 总高度 = 0
    for i = 1, #table_抗性长按钮 do
        if i ~= 1 then
            总高度 = 总高度 + 高度列表[i - 1]
            table_抗性长按钮[i]:置坐标(0, (i - 1) * 24 + 总高度)
        end
    end
end

function 召唤抗性:添加抗性(r)
    if r then
        for n = 1, #抗性类型 do
            抗性列表[n]:清空()
            local 临时抗性 = {}
            for i = 1, #_抗性库[抗性类型[n]] do
                local 属性 = _抗性库[抗性类型[n]][i]
                local 数值 = r[属性]
                if 数值 and 数值 ~= 0 then
                    if _抗性库.整数范围[属性] then
                        临时抗性[#临时抗性 + 1] = { 抗性 = 属性, 数值 = math.floor(数值) }
                    else
                        临时抗性[#临时抗性 + 1] = { 抗性 = 属性, 数值 = string.format("%.2f", 数值) }
                    end
                end
                if #临时抗性 >= 2 or (#临时抗性 >= 1 and i == #_抗性库[抗性类型[n]]) then
                    抗性列表[n]:添加抗性(临时抗性, i)
                    临时抗性 = {}
                end
            end
            if n ~= 1 then
                local 临时高度 = 0
                for q = 1, n - 1 do
                    临时高度 = 临时高度 + 高度列表[q]
                end
                临时高度 = 临时高度 + 24 * n
                抗性列表[n]:置坐标(7, 临时高度)
            end
        end
        窗口层:重排召唤抗性按钮()
    end
    召唤抗性:置精灵(
        生成精灵(
            319,
            高度列表[1] + 高度列表[2] + 高度列表[3] + 高度列表[4] + 高度列表[5] + 24 * 5 + 5,
            function()
                召唤抗性:取拉伸图像_宽高('gires4/经典红木/元件按钮/透明框_2.tcp', 319,
                    高度列表[1] + 高度列表[2] + 高度列表[3] + 高度列表[4] + 高度列表[5] + 24 * 5 + 5):显示(0, 0)
            end
        )
    )
end

function 窗口层:打开召唤抗性(nid)
    召唤抗性:置可见(not 召唤抗性.是否可见)
    if not 召唤抗性.是否可见 then
        return
    end

    self:重新打开召唤抗性(nid)
end

function 窗口层:重新打开召唤抗性(nid)
    召唤抗性:置坐标(引擎.宽度 - 390, (引擎.高度 - 455) // 2)
    高度列表 = { 0, 0, 0, 0, 0 }

    local r = __rpc:召唤_打开抗性窗口(nid)

    召唤抗性:添加抗性(r)
end

召唤抗性:创建关闭按钮(-3, 0)

return 召唤抗性
