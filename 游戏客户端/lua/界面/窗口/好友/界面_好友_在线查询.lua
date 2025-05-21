

local 在线查询 = 窗口层:创建我的窗口('在线查询', 0, 0, 347, 277)
do
    function 在线查询:初始化()
        self:置精灵(__res:getspr('gires/0xB4F0663F.tcp'))
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    end

    function 在线查询:显示(x, y)
    end

    在线查询:创建关闭按钮(0, 1)
end

local 角色名称 = 在线查询:创建文本输入('名称输入', 93, 42, 225, 14)
角色名称:置颜色(255, 255, 255, 255)
角色名称:置限制字数(14)
local 数字ID = 在线查询:创建数字输入('ID输入', 93, 73, 225, 14)
数字ID:置颜色(255, 255, 255, 255)

local 介绍文本 = 在线查询:创建文本('介绍文本', 35, 115, 280, 95)
--===========================================






do

    local function 取介绍(t)
        local list = {}
        table.insert(list, string.format("名称:%s(%s)", t.名称, t.id))
        table.insert(list, string.format("等级:%s转%s级", t.转生, t.等级))
        table.insert(list, string.format("种族:%s", t.种族))
        table.insert(list, string.format("性别:%s", _性别[t.性别]))
        return table.concat(list, "#r")
    end

    for k, v in pairs {
        { name = '确定按钮', txt = '确  定' },
        { name = '设为私聊按钮', txt = '设为私聊' },
        { name = '加为好友按钮', txt = '加为好友' }
    } do
        if k ~= 2 then
            local 按钮 = 在线查询:创建中按钮(v.name, 30 + k * 103 - 103, 231, v.txt)
            function 按钮:左键弹起()
                if v.name == '确定按钮' then
                    local name = 角色名称:取文本()
                    local id = 数字ID:取文本()
                    if id == "" and name == "" then
                        窗口层:提示窗口("#Y 请先输入要查询的玩家昵称或者ID")
                        return
                    end
                    local t = __rpc:角色_好友查询({ id, name })
                    _查询数据 = nil
                    if type(t) == "string" then
                        窗口层:提示窗口(t)
                        return
                    elseif type(t) == "table" then
                        _查询数据 = t
                        介绍文本:清空()
                        介绍文本:置文本(取介绍(t))
                    end
                elseif v.name == '加为好友按钮' then
                    if _查询数据 then
                        coroutine.xpcall(function()
                            local r = __rpc:角色_添加好友(_查询数据.nid)
                        end)
                    else
                        窗口层:提示窗口("#Y请先输入要查询的玩家昵称或者ID")
                    end


                end
            end
        end

    end
end

function 窗口层:打开在线查询()
    在线查询:置可见(not 在线查询.是否可见)
    if not 在线查询.是否可见 then
        return
    end
    _查询数据 = nil
    数字ID:置文本("")
    角色名称:置文本("")
    介绍文本:置文本("")
end

return 在线查询
