local _ENV = require('界面/窗口/管理/管理_1')
装备管理区域 = 标签控件:创建区域(装备管理按钮, 0, 0, 580, 300)

do
    local _装备库 = require('数据/装备库')
    local _神兵库 = require('数据/神兵库')
    local _抗性库 = require('数据/抗性库2')
    function 装备管理区域:初始化()
        self:置精灵(
            生成精灵(
                580,
                300,
                function()
                    __res.JMZ:取图像("装备名称"):显示(10, 2)
                    __res.JMZ:取图像("等级"):显示(210, 2)
                    __res.JMZ:取图像("序号"):显示(305, 2)
                    __res.JMZ:取图像("基本属性"):显示(36, 36)
                    __res.JMZ:取图像("能否交易"):显示(515, 25)
                    __res.JMZ:取图像("炼化属性"):显示(230, 36)
                    __res.JMZ:取图像("炼器属性"):显示(426, 36)
                    local sf = __res:getsf('ui/zhk.png') -- self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20):显示(80, 0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 50, 20):显示(250, 0):显示(340, 0)
                    for i = 1, 9 do
                        sf:显示(1, 30 + i * 27)
                        sf:显示(195, 30 + i * 27)
                        sf:显示(390, 30 + i * 27)
                    end
                end
            )
        )
    end

    local 名称输入 = 装备管理区域:创建文本输入('装备名称输入', 83, 2, 130, 14)
    名称输入:置颜色(255, 255, 255, 255)
    local 等级输入 = 装备管理区域:创建数字输入('装备等级输入', 253, 2, 50, 14)
    等级输入:置颜色(255, 255, 255, 255)
    local 序号输入 = 装备管理区域:创建数字输入('装备序号输入', 343, 2, 50, 14)
    序号输入:置颜色(255, 255, 255, 255)


    for i = 1, 9, 1 do
        local 输入 = 装备管理区域:创建文本输入('基本属性' .. i, 6, 35 + i * 27, 130, 14) -- 类型
        local 输入2 = 装备管理区域:创建文本输入('炼化属性' .. i, 200, 35 + i * 27, 130, 14) -- 类型
        local 输入3 = 装备管理区域:创建文本输入('炼器属性' .. i, 395, 35 + i * 27, 130, 14) -- 类型
        输入:置颜色(255, 255, 255, 255)
        输入2:置颜色(255, 255, 255, 255)
        输入3:置颜色(255, 255, 255, 255)
    end


    for i = 1, 9, 1 do
        local 输入 = 装备管理区域:创建文本输入('基本属性值' .. i, 143, 35 + i * 27, 50, 14) -- 类型
        local 输入2 = 装备管理区域:创建文本输入('炼化属性值' .. i, 337, 35 + i * 27, 50, 14) -- 类型
        local 输入3 = 装备管理区域:创建文本输入('炼器属性值' .. i, 532, 35 + i * 27, 50, 14) -- 类型
        输入:置颜色(255, 255, 255, 255)
        输入2:置颜色(255, 255, 255, 255)
        输入3:置颜色(255, 255, 255, 255)
    end

    local 预览按钮 = 装备管理区域:创建小按钮("预览按钮", 405, 0, "预览")
    local 发放按钮 = 装备管理区域:创建小按钮("发放按钮", 460, 0, "发放")
    local _能否交易 = true
    local 绑定按钮 = 装备管理区域:创建多选按钮('绑定按钮', 540, 3)
    function 绑定按钮:初始化()
        local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
        self:置正常精灵(tcp:取精灵(1))
        self:置选中正常精灵(tcp:取精灵(2))
        -- self:置提示('绑定按钮')
        self:置选中(_能否交易)
    end

    function 绑定按钮:选中事件(b)
        _能否交易 = b
    end

    local function 取属性_预览_神兵()
        local 装备名称 = 名称输入:取文本()
        local 装备等级 = 等级输入:取文本()
        local 属性序号 = 序号输入:取文本()
        if 装备等级 == "" then
            装备等级 = 1
        end
        if 属性序号 == "" then
            属性序号 = 1
        else
            属性序号 = tonumber(属性序号)
        end


        local t = {}
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['基本属性' .. i]:取文本()
            local 数值 = 装备管理区域['基本属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                table.insert(t, string.format('#cFEFF72%s %+.1f', 类型, 数值))
            end
        end
        if #t == 0 then --没有输入属性
            local sx = _神兵库[装备名称][属性序号]
            if sx then
                for i, v in ipairs(sx.属性) do
                    table.insert(t, string.format('#cFEFF72%s %+.1f', v.类型, v.数值 * 装备等级))
                end
            end
        end
        table.insert(t, string.format("#cFEFF72等级 %s", 装备等级))
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['炼化属性' .. i]:取文本()
            local 数值 = 装备管理区域['炼化属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                table.insert(t, string.format('#cDCA770%s %+.1f', 类型, 数值))
            end
        end
        local 炼器 = 0
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['炼器属性' .. i]:取文本()
            local 数值 = 装备管理区域['炼器属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                炼器 = 炼器 + 1
            end
        end
        炼器 = 炼器 > 5 and 5 or 炼器
        if 炼器 > 0 then
            table.insert(t, string.format("#r#cFEFF72【炼器】#C开光次数%s", 炼器))
            table.insert(t, "#cA39BB2【炼器属性】")
            for i = 1, 9, 1 do
                local 类型 = 装备管理区域['炼器属性' .. i]:取文本()
                local 数值 = 装备管理区域['炼器属性值' .. i]:取文本()
                if 类型 ~= "" and 数值 ~= "" then
                    table.insert(t, string.format('#G%s %+.1f%%', 类型, 数值))
                end
            end
        end
        return table.concat(t, '\n')
    end

    local function 取属性_预览()
        local t = {}
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['基本属性' .. i]:取文本()
            local 数值 = 装备管理区域['基本属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                table.insert(t, string.format('#cFEFF72%s %+.1f', 类型, 数值))
            end
        end
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['炼化属性' .. i]:取文本()
            local 数值 = 装备管理区域['炼化属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                table.insert(t, string.format('#G%s %+.1f', 类型, 数值))
            end
        end
        local 炼器 = 0
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['炼器属性' .. i]:取文本()
            local 数值 = 装备管理区域['炼器属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                炼器 = 炼器 + 1
            end
        end
        炼器 = 炼器 > 5 and 5 or 炼器
        if 炼器 > 0 then
            table.insert(t, string.format("#r#cFEFF72【炼器】#C开光次数%s", 炼器))
            table.insert(t, "#cA39BB2【炼器属性】")
            for i = 1, 9, 1 do
                local 类型 = 装备管理区域['炼器属性' .. i]:取文本()
                local 数值 = 装备管理区域['炼器属性值' .. i]:取文本()
                if 类型 ~= "" and 数值 ~= "" then
                    table.insert(t, string.format('#G%s %+.1f%%', 类型, 数值))
                end
            end
        end
        return table.concat(t, '\n')
    end

    function 预览按钮:左键弹起()
        local 装备名称 = 名称输入:取文本()
        local 装备等级 = 等级输入:取文本()
        local 属性需要 = 序号输入:取文本()
        if not _装备库[装备名称] then
            窗口层:提示窗口('#R装备名称错误')
            return
        end
        local t = _装备库[装备名称]
        t = require('界面/数据/物品')(t)
        if t.神兵 then
            t.属性 = 取属性_预览_神兵()
        else
            t.属性 = 取属性_预览()
        end

        窗口层:打开物品提示(t)
    end

    local function 取属性_发送()
        local t = {}
        t.基本属性 = {}
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['基本属性' .. i]:取文本()
            local 数值 = 装备管理区域['基本属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                table.insert(t.基本属性, { 类型, tonumber(数值) })
            end
        end
        t.炼化属性 = {}
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['炼化属性' .. i]:取文本()
            local 数值 = 装备管理区域['炼化属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                table.insert(t.炼化属性, { 类型, tonumber(数值) })
            end
        end
        t.炼器属性 = {}
        for i = 1, 9, 1 do
            local 类型 = 装备管理区域['炼器属性' .. i]:取文本()
            local 数值 = 装备管理区域['炼器属性值' .. i]:取文本()
            if 类型 ~= "" and 数值 ~= "" then
                table.insert(t.炼器属性, { 类型, tonumber(数值) })
            end
        end
        return t
    end

    function 发放按钮:左键弹起()
        if _选中角色 then
            local 装备名称 = 名称输入:取文本()
            if not _装备库[装备名称] then
                窗口层:提示窗口('#R装备名称错误')
                return
            end
            local t = 取属性_发送()
            t.禁止交易 = not _能否交易
            t.等级 = tonumber(等级输入:取文本())
            t.序号 = tonumber(序号输入:取文本())
            t.名称 = 装备名称
            local list = {}

            for k, v in ipairs(t.基本属性) do
                if not _抗性库[v[1]] then
                    table.insert(list, v[1])
                end
            end
            if #list > 0 then
                窗口层:提示窗口('#Y基本属性#R' .. table.concat(list, '、 ') .. '#Y错误，请查证后填写')
                return
            end
            for k, v in ipairs(t.炼化属性) do
                if not _抗性库[v[1]] then
                    table.insert(list, v[1])
                end
            end
            if #list > 0 then
                窗口层:提示窗口('#Y炼化属性#R' .. table.concat(list, '、 ') .. '#Y错误，请查证后填写')
                return
            end
            for k, v in ipairs(t.炼器属性) do
                if not _抗性库[v[1]] then
                    table.insert(list, v[1])
                end
            end
            if #list > 0 then
                窗口层:提示窗口('#Y炼器属性#R' .. table.concat(list, '、 ') .. '#Y错误，请查证后填写')
                return
            end
            local r = __rpc:角色_GM_发放装备(_当前账号, _选中角色, t)
            if type(r) == "string" then
                窗口层:提示窗口(r)
                return
            end
            名称输入:置文本("")




        else
            窗口层:提示窗口('#Y请先选中操作角色')

        end


    end

end
