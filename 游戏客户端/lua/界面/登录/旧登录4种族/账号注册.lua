local 注册窗口 = GUI:创建模态窗口('注册窗口')
local list = {}
function 注册窗口:初始化()
    self:置精灵(__res:getspr('ui/zhuce2.png'))
end

local 按钮 = 注册窗口:创建关闭按钮(10)
function 按钮:初始化(v)
    local tcp = __res:get('gires3/button/close.tcp')
    self:置正常精灵(tcp:取精灵(1):置缩放(0.7))
    self:置按下精灵(tcp:取精灵(2):置缩放(0.7))
    -- self:置经过精灵(tcp:取精灵(3):置缩放(0.7))
end

local 选区控件 = 注册窗口:创建组合('选区控件', 97, 29, 135, 16)
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
for i = 1, 6 do
    _ENV['输入' .. i] = 注册窗口:创建文本输入('输入' .. i, 96, 29 + i * 33, 137, 16)
    _ENV['输入' .. i]:置颜色(255, 255, 255, 255)
    _ENV['输入' .. i]:置限制字数(32)
end
local 注册按钮 = 注册窗口:创建按钮('注册按钮', 91, 252)
do
    function 注册按钮:初始化(v)
        self:置正常精灵(__res:getspr('ui/zhuceanniu1.png'))
        self:置按下精灵(__res:getspr('ui/zhuceanniu2.png'))
    end

    function 注册按钮.左键弹起()
        local 服名 = 选区控件:取文本()
        for k, v in pairs(list) do
            if v.服名 == 服名 then
                __rpc.地址 = v.地址
                __rpc.端口 = v.端口
                __rpc:开始连接(function()
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
                end)
            end
        end
    end
end

function 登录层:打开注册窗口()
    if __rpc:是否开放注册() then
        list = __rpc:获取区服()
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
