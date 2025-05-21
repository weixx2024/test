local 注册窗口 = GUI:创建模态窗口('注册窗口')
local 锚点 = {}
function 注册窗口:初始化()
    self:置精灵(
        self:取经典红木窗口(
            342,
            342,
            '注册账号',
            function()
                local 框84 = self:取拉伸图像_宽高('gires4/经典红木/元件按钮/多行文本框.tcp', 139, 23)
                框84:显示(148, 34)
                local 框120 = self:取拉伸图像_宽高('gires4/经典红木/元件按钮/多行文本框.tcp', 139, 23)
                for i = 73, 73 + 32 * 5, 32 do
                    框120:显示(145, i)
                end
                for i, v in ipairs {
                    { name = '选择区服', x = 64, y = 37 },
                    { name = '账   号', x = 67, y = 78 },
                    { name = '密   码', x = 67, y = 110 },
                    { name = '确认密码', x = 67, y = 142 },
                    { name = '安 全 码', x = 67, y = 174 },
                    { name = '邀 请 码', x = 67, y = 206 },
                    { name = 'Q     Q', x = 67, y = 238 }
                }
                do
                    __res.JMZ:取图像(v.name):显示(v.x, v.y)
                end
            end
        )
    )
end

注册窗口:创建关闭按钮()

local 选区控件 = 注册窗口:创建组合('选区控件', 153, 38, 135, 16)
do
    选区控件:创建组合文本(0, 0, 135, 16)
    选区控件:置文本('默认')
    local 下拉按钮 = 选区控件:创建组合按钮(112, 0)
    function 下拉按钮:初始化()
        self:置正常精灵(__res:getspr('gires4/经典红木/元件按钮/下键按钮.tcp'):置拉伸(14, 14))
        -- self:置按下精灵(__res:getspr('ui/zcxl2.png'):置拉伸(14, 14))
    end

    local 弹出控件 = 选区控件:创建组合弹出(-3, 20, 141, 96)
    弹出控件.绝对坐标 = true
    function 弹出控件:初始化()
        self:置精灵(__res:getspr('ui/zcxl.png'))
    end

    弹出列表 = 选区控件:创建组合列表(3, 3, 141, 90)
end

for i = 1, 6 do
    _ENV['输入' .. i] = 注册窗口:创建文本输入('输入' .. i, 148, 76 + i * 32 - 32, 133, 16)
    if i == 4 then
        _ENV['输入' .. i]:置限制字数(6) --安全码
        _ENV['输入' .. i]:置模式(_ENV['输入' .. i].数字模式)
    end
    _ENV['输入' .. i]:置颜色(255, 255, 255, 255)
end


local 注册按钮 = 注册窗口:创建按钮('注册按钮', 140, 277)
do
    function 注册按钮:初始化(v)
        self:设置按钮精灵('gires2/login/create.tca')
    end

    function 注册按钮.左键弹起()
        local 输入 = {}
        for i = 1, 6 do
            输入[i] = _ENV['输入' .. i]:取文本()
            if 输入[i] == '' then
                登录层:打开提示('#R注册信息不能为空！')
                return
            elseif #输入[i] < 4 then
                登录层:打开提示('#R注册信息长度不能低于4位！')
                return
            end
        end
        if 输入[2] ~= 输入[3] then
            登录层:打开提示('#R两次密码不一样！')
            return
        end

        if not __rpc:是否开放注册() then
            登录层:打开提示('#R注册暂时停止！')
            return
        end
        table.remove(输入, 3) -- 删除确认密码
        -- 输入[2] = 输入[2] --GGF.MD5(输入[2])
        输入[2] = GGF.MD5(输入[2])
        local r = __rpc:注册账号(table.unpack(输入))
        if r == true then
            登录层:打开提示('#K注册成功！')
        elseif type(r) == 'string' then
            登录层:打开提示(r)
        else
            登录层:打开提示('#R注册失败！')
        end
    end
end

function 登录层:打开注册窗口()
    if __rpc:是否开放注册() then
        local list = __rpc:获取区服()
        if type(list) == 'table' then
            弹出列表:清空()
            for i, v in ipairs(list) do
                弹出列表:添加(v.服名)
                if i == 1 then
                    选区控件:置文本(v.服名)
                end
            end
        else
            登录层:打开提示('#R注册暂时停止！')
            return
        end
        注册窗口:置可见(true)
        注册窗口:置坐标((引擎.宽度 - 注册窗口.宽度) // 2, (引擎.高度 - 注册窗口.高度) // 2)
    else
        登录层:打开提示('#R注册暂时停止！')
    end
end

return 注册窗口
