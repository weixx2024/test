local 回复窗口 = 窗口层:创建我的窗口('回复窗口', 0, 0, 534, 124)

function 回复窗口:初始化()
    self:置精灵(__res:getspr('gires/0xD04E2707.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 回复窗口:显示(x, y)
end

local 名称文本 = 回复窗口:创建我的文本('名称文本', 89, 36, 200, 15)
local 内容输入 = 回复窗口:创建文本输入('内容输入', 31, 75, 470, 15)
内容输入:置颜色(255, 255, 255, 255)
内容输入:置限制字数(30)
-- for k, v in pairs { '发送', '短信', '取消' } do
--     if k ~= 2 then
--         local 按钮 = 回复窗口:创建小按钮(v .. '按钮', 330 + k * 63 - 63, 30, v)
--         function 按钮:左键弹起()
--             if v == '取消' then
--                 self.父控件:置可见(false)
--             elseif v == '发送' then
--                 if _P then
--                     local txt = 内容输入:取文本()
--                     if txt == "" then
--                         窗口层:提示窗口("#Y清先输入信息内容")
--                         return
--                     end
--                     coroutine.xpcall(function()
--                         __rpc:角色_发送好友信息({ _P.nid, txt })
--                     end)
--                     if __rol then
--                         窗口层:好友_添加聊天记录(__rol.名称, _P.nid, { time = os.time(), txt = txt })
--                     end
--                     self.父控件:置可见(false)
--                 end
--             end
--         end
--     end

-- end

local 发送按钮 = 回复窗口:创建小按钮('发送按钮', 330, 30, '发送')
function 发送按钮:左键弹起()
    if _P then
        local txt = 内容输入:取文本()
        if txt == "" then
            窗口层:提示窗口("#Y清先输入信息内容")
            return
        end
        coroutine.xpcall(function()
            __rpc:角色_发送好友信息({ _P.nid, txt })
        end, function(err)
            窗口层:提示窗口("#Y发送失败: " .. tostring(err))
        end)
        if __rol then
            窗口层:好友_添加聊天记录(__rol.名称, _P.nid, { time = os.time(), txt = txt })
        end
        内容输入:置文本("") -- 清空输入框
    end
    self.父控件:置可见(false)
end

function 发送按钮:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
        self:左键弹起()
    end
end

local 取消按钮 = 回复窗口:创建小按钮('取消按钮', 420, 30, '取消')
function 取消按钮:左键弹起()
    self.父控件:置可见(false)
end

local 选择按钮 = 回复窗口:创建按钮('选择按钮', 291, 32)

function 选择按钮:初始化()
    self:设置按钮精灵('gires/0xB6843921.tcp')
end

function 选择按钮:左键弹起()
    if _P then
        coroutine.xpcall(function()
            local r = __rpc:角色_添加好友(_P.nid)
        end)
    end
end

function 窗口层:打开回复窗口(P)
    回复窗口:置可见(not 回复窗口.是否可见)
    if not 回复窗口.是否可见 then
        return
    end
    _P = P
    if _P then
        名称文本:置文本(_P.名称)
        内容输入:置文本("")

    end

end

return 回复窗口
