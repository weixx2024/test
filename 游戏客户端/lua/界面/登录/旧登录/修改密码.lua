

local 修改密码窗口 = GUI:创建模态窗口('修改密码窗口')
function 修改密码窗口:初始化()
    self:置精灵(__res:getspr('ui/xiugaimima2.png'))
end

function 修改密码窗口:显示(x, y)
end

local 按钮 = 修改密码窗口:创建关闭按钮()
function 按钮:初始化(v)
    local tcp = __res:get('gires3/button/close.tcp')
    self:置正常精灵(tcp:取精灵(1):置缩放(0.7):置中心(-10, 0))
    self:置按下精灵(tcp:取精灵(2):置缩放(0.7):置中心(-10, 0))
    -- self:置经过精灵(tcp:取精灵(3):置缩放(0.7))
end

local 选区控件 = 修改密码窗口:创建组合('选区控件2', 105, 35, 135, 16)
do
    选区控件:创建组合文本(0, 0, 135, 16)
    选区控件:置文本('默认')
    local 下拉按钮 = 选区控件:创建组合按钮(120, 0)
    function 下拉按钮:初始化()
        self:置正常精灵(__res:getspr('ui/zcxl1.png'):置拉伸(14, 14))
        self:置按下精灵(__res:getspr('ui/zcxl2.png'):置拉伸(14, 14))
    end

    local 弹出控件 = 选区控件:创建组合弹出(-3, 20, 141, 96)
    弹出控件.绝对坐标 = true
    function 弹出控件:初始化()
        self:置精灵(__res:getspr('ui/zcxl.png'))
    end

    弹出列表 = 选区控件:创建组合列表(3, 3, 141, 90)

end

for i = 1, 4 do
    _ENV['输入' .. i] = 修改密码窗口:创建文本输入('输入' .. i, 105, 37 + i * 35, 137, 16)
    _ENV['输入' .. i]:置颜色(255, 255, 255, 255)
end

-- local 账号输入 = 修改密码窗口:创建文本输入('账号输入', 105, 69, 137, 16)
-- local 安全码输入 = 修改密码窗口:创建文本输入('安全码输入', 105, 105, 137, 16)
-- local 密码输入 = 修改密码窗口:创建文本输入('密码输入', 105, 141, 137, 16)
-- local 确认密码输入 = 修改密码窗口:创建文本输入('确认密码输入', 105, 177, 137, 16)


local 修改按钮 = 修改密码窗口:创建按钮('修改按钮', 93, 202)
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
