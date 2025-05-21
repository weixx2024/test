local 修改密码窗口 = GUI:创建模态窗口('修改密码窗口')
function 修改密码窗口:初始化()
    self:置精灵(
        self:取经典红木窗口(
            266,
            249,
            '修改密码',
            function()
                local 框120 = self:取拉伸图像_宽高('gires4/经典红木/元件按钮/多行文本框.tcp', 123, 22)
                for i = 29, 29 + 36 * 4, 36 do
                    框120:显示(112, i)
                end
                for i, v in ipairs {
                    { name = '服 务 器', x = 33, y = 32 },
                    { name = '账    号', x = 33, y = 68 },
                    { name = '安 全 码', x = 33, y = 104 },
                    { name = '新 密 码', x = 33, y = 140 },
                    { name = '确认密码', x = 33, y = 176 }
                } do
                    __res.JMZ:取图像(v.name):显示(v.x, v.y)
                end
            end
        )
    )
end

function 修改密码窗口:显示(x, y)
end

修改密码窗口:创建关闭按钮()

local 选区控件 = 修改密码窗口:创建组合('选区控件2', 115, 32, 143, 18)
do
    选区控件:创建组合文本(0, 0, 135, 16)
    选区控件:置文本('默认')
    local 下拉按钮 = 选区控件:创建组合按钮(120, 0)
    function 下拉按钮:初始化()
        self:设置按钮精灵('gires4/经典红木/元件按钮/下键按钮.tcp')
    end

    local 弹出控件 = 选区控件:创建组合弹出(-3, 20, 141, 96)
    function 弹出控件:初始化()
        -- self:置精灵(__res:getspr('ui/zcxl.png'))
    end

    弹出控件.绝对坐标 = true
    弹出列表 = 选区控件:创建组合列表(3, 3, 141, 90)
end

for i = 1, 4 do
    _ENV['输入' .. i] = 修改密码窗口:创建文本输入('输入' .. i, 116, 33 + i * 36, 120, 16)
    _ENV['输入' .. i]:置颜色(255, 255, 255, 255)
end

-- local 账号输入 = 修改密码窗口:创建文本输入('账号输入', 105, 69, 137, 16)
-- local 安全码输入 = 修改密码窗口:创建文本输入('安全码输入', 105, 105, 137, 16)
-- local 密码输入 = 修改密码窗口:创建文本输入('密码输入', 105, 141, 137, 16)
-- local 确认密码输入 = 修改密码窗口:创建文本输入('确认密码输入', 105, 177, 137, 16)


local 修改按钮 = 修改密码窗口:创建按钮('修改按钮', 98, 202)
function 修改按钮:初始化(v)
    self:置正常精灵(__res:getspr('ui/xiugai1.png'))
    self:置按下精灵(__res:getspr('ui/xiugai2.png'))
end

function 修改按钮.左键弹起()
    local 输入 = {}
    for i = 1, 4 do
        输入[i] = _ENV['输入' .. i]:取文本()
        if 输入[i] == '' then
            登录层:打开提示('#R信息不能为空！')
            return
        elseif #输入[i] < 4 then
            登录层:打开提示('#R信息长度不能低于4位！')
            return
        end
    end
    if 输入[3] ~= 输入[4] then
        登录层:打开提示('#R两次密码不一样！')
        return
    end
    table.remove(输入, 4) -- 删除确认密码
    输入[3] = GGF.MD5(输入[3])
    local r = __rpc:修改密码(选区控件:取文本(), table.unpack(输入))
    if r == true then
        登录层:打开提示('#K修改成功！')
    elseif type(r) == 'string' then
        登录层:打开提示(r)
    else
        登录层:打开提示('#R修改失败！')
    end
end

function 登录层:打开修改密码窗口()
    local list = __rpc:获取区服()
    if type(list) == 'table' then
        弹出列表:清空()
        for i, v in ipairs(list) do
            弹出列表:添加(v.服名)
            if i == 1 then
                选区控件:置文本(v.服名)
            end
        end
        修改密码窗口:置可见(true)
        修改密码窗口:置坐标((引擎.宽度 - 修改密码窗口.宽度) // 2, (引擎.高度 - 修改密码窗口
            .高度) // 2)
    end
end

return 修改密码窗口
