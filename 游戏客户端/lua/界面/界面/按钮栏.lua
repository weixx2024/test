-- local 法术快捷 = 界面层:创建控件('法术快捷', -370, -75, 310, 50)
-- do
--     function 法术快捷:初始化()

--     end

--     function 法术快捷:显示(x, y)

--     end

--     --===================================================================================
--     local 网格 = 法术快捷:创建网格('网格', 50, 18, 256, 24)
--     function 网格:初始化()
--         self:创建格子(24, 24, 8, 8, 1, 8)
--     end

--     function 网格:获得鼠标(x, y, i)
--         if self[i]:取精灵() then
--             技能提示(x, y, self[i]:取精灵().id)
--         end
--     end

--     function 网格:左键弹起(x, y, i)
--         local t = 鼠标.附加
--         if ggetype(t) == '技能数据' then
--             鼠标.附加 = 鼠标.附加:返回()
--             if t.type == 3 then --交换
--                 local p = _p << 4
--                 if __rpc:快捷键(p + t.i, p + i) then
--                     --self[i].精灵,self[t.i].精灵 = self[t.i].精灵,self[i].精灵
--                     _快捷键[_p][i], _快捷键[_p][t.i] = _快捷键[_p][t.i], _快捷键[_p][i]
--                 end
--             else
--                 if __rpc:快捷键((_p << 4) + i, t.id) then
--                     _快捷键[_p][i] = require('界面/数据/技能')(3, t.id)
--                     self[i]:置精灵(_快捷键[_p][i])
--                 end
--             end
--         elseif self[i]:取精灵() then
--             鼠标.附加 = self[i]:取精灵():拿起(i)
--             鼠标.附加.丢弃 = function(this)
--                 __rpc:快捷键((_p << 4) + i)
--                 self[i]:置精灵()
--                 鼠标.附加 = nil
--             end
--         end
--         return true
--     end

--     function 网格:右键弹起(x, y, i)
--         if self[i]:取精灵() and not __rol.是否战斗 then
--             __rpc:技能使用(i)
--         end
--         return true
--     end

--     function 网格:键盘事件(键码, 功能, 状态, 按住)
--         if 状态 and not 按住 then
--             for key = SDL.KEY_F1, SDL.KEY_F8 do
--                 if 键码 == key then
--                     local id = (key & 0xFFFF) - 57
--                     local x, y = self[id]:取坐标()
--                     self:右键弹起(x, y, id)
--                     break
--                 end
--             end
--         end
--     end
--     --===================================================================================
--     function 界面层:置快捷键(t)
--         if type(t) == 'table' then
--             _快捷键 = {{}, {}, {}}
--             for i, v in pairs(t) do
--                 local p, i = i >> 4, i & 0x0F
--                 if _快捷键[p] then
--                     _快捷键[p][i] = require('界面/数据/技能')(3, v)
--                 end
--             end
--             for i = 1, 8 do
--                 法术快捷.网格[i]:置精灵(_快捷键[_p][i])
--             end
--         end
--     end
-- end
--===================================================================================
local 队伍控件 = GUI:创建弹出控件('队伍控件', 0, 0, 118, 5 * 23)
do
    for i, v in ipairs { '组队操作', '召唤伙伴', ' 团  队' } do
        local 队伍按钮 = 队伍控件:创建按钮(v, 0, (i - 1) * 23)
        function 队伍按钮:初始化()
            __res.HYF:置大小(16):置颜色(187, 165, 75):置样式(SDL.TTF_STYLE_NORMAL)
            local txt = __res.HYF:取图像(v):置中心(-26, -4)
            self:置正常精灵(self:取拉伸精灵_宽度帧('gires/0x86D66B9A.tcp', 1, 117, txt))
            self:置按下精灵(self:取拉伸精灵_宽度帧('gires/0x86D66B9A.tcp', 2, 117, txt))
            self:置经过精灵(self:取拉伸精灵_宽度帧('gires/0x86D66B9A.tcp', 3, 117, txt))
        end

        function 队伍按钮:左键弹起()
            if v == '组队操作' and not __rol.是否组队 then
                if 鼠标层.是否组队 then
                    鼠标层:正常形状()
                else
                    鼠标层:组队形状()
                end
            elseif v == '召唤伙伴' then
                窗口层:打开伙伴()
            elseif v == ' 团  队' then
                窗口层:打开队伍()
            end

            队伍控件:置可见(false)
        end
    end
end
--===================================================================================
local 按钮栏 = 界面层:创建控件('按钮栏', -11 * 31, -31, 11 * 31, 31)
--===================================================================================
for i, v in ipairs {
    { name = '宝宝', dis = true, tip = '宝宝(Alt+Y)', zy = 'gires/0x6B5B54B1.tcp', key = SDL.KEY_Y },
    { name = '道具', tip = '道具(Alt+E)', zy = 'gires/0x6B5B54B1.tcp', key = SDL.KEY_E },
    -- { name = '组队', tip = '组队(Alt+T)', zy = 'gires/0x63E68C3A.tcp', key = SDL.KEY_T, ani = 'gires/0xEE3DFDA3.tcp', pop = 队伍控件 },
    { name = '组队', tip = '组队(Alt+T)', zy = 'gires/0x63E68C3A.tcp', key = SDL.KEY_T, ani = 'gires/0xEE3DFDA3.tcp' },
    { name = '攻击', tip = '攻击(Alt+A)', zy = 'gires/0xC02A6AD4.tcp', key = SDL.KEY_A }, --dis = true,
    { name = '给予', tip = '给予(Alt+G)', zy = 'gires/0x3DAF5F9F.tcp', key = SDL.KEY_G },
    { name = '交易', tip = '交易(Alt+X)', zy = 'gires/0xB7C4D153.tcp', key = SDL.KEY_X },
    { name = '宠物', tip = '宠物(Alt+P)', zy = 'gires/0x50DA84FD.tcp', key = SDL.KEY_P },
    { name = '任务', tip = '任务(Alt+Q)', zy = 'gires/0x3EEA6B43.tcp', key = SDL.KEY_Q },
    { name = '好友', tip = '好友(Alt+F)', zy = 'gires/0x8C564E44.tcp', key = SDL.KEY_F,
        ani = 'gires/0x9FEBB2F7.tcp' },
    { name = '帮派', tip = '帮派(Alt+B)', zy = 'gires/0x94362368.tcp', key = SDL.KEY_B, ani = 'gires/0x94362368.tcp' },
    { name = '系统', tip = '系统(Alt+S)', zy = 'gires/0x2EBA75DE.tcp', key = SDL.KEY_S }
} do
    local 按钮 = 按钮栏:创建按钮(v.name .. '按钮', -(12 - i) * 29, 2)
    function 按钮:初始化()
        if v.name == '宝宝' then
            self:置正常精灵(__res:getspr('ui/hzan1.png'))
            self:置按下精灵(__res:getspr('ui/hzan3.png'))
            self:置经过精灵(__res:getspr('ui/hzan2.png'))
            self:置禁止精灵(__res:getsf('ui/hzan2.png'):到灰度():到精灵())
            -- self:置禁止(true)
        else
            local tcp = self:设置按钮精灵(v.zy)
            if v.dis then
                self:置禁止精灵(tcp:取灰度精灵(1))
                self:置禁止(true)
            end
        end

        if v.ani then
            self.动画 = __res:getani(v.ani):置中心(0, 0):播放(true)
        end
        if v.tip then
            self:置提示(v.tip)
        end
    end

    function 按钮:更新(dt)
        if self.消息 and self.动画 then
            self.动画:更新(dt)
        end
    end

    function 按钮:显示(x, y)
        if self.消息 and self.动画 then
            self.动画:显示(x, y)
        end
    end

    function 按钮:左键弹起(x, y)
        if v.name == '道具' then
            窗口层:打开道具()
        elseif v.name == '组队' then
            if self.消息 then
                窗口层:打开申请加入队伍()
            -- elseif x then
            --     v.pop:置坐标(x, y - v.pop:取子控件数量() * 23)
            --     v.pop:置可见(true, true)
            elseif __rol.是否组队 then
                窗口层:打开队伍()
            else
                if 鼠标层.是否组队 then
                    鼠标层:正常形状()
                else
                    鼠标层:组队形状()
                end
            end
        elseif v.name == '攻击' then
            if 鼠标层.是否攻击 then
                鼠标层:正常形状()
            else
                鼠标层:攻击形状(true)
            end
        elseif v.name == '给予' then
            if 鼠标层.是否给予 then
                鼠标层:正常形状()
            else
                鼠标层:给予形状()
            end
        elseif v.name == '交易' then
            if 鼠标层.是否交易 then
                鼠标层:正常形状()
            else
                鼠标层:交易形状()
            end
        elseif v.name == '宠物' then
            窗口层:打开宠物()
        elseif v.name == '宝宝' then
            窗口层:打开孩子()
        elseif v.name == '任务' then
            窗口层:打开任务()
        elseif v.name == '好友' then
            local r, xx = __rpc:角色_点击好友按钮()
            self.消息 = xx
            if type(r) == "table" then
                窗口层:打开聊天窗口(r, true)
            else
                窗口层:打开好友()
            end
        elseif v.name == '帮派' then
            local r = __rpc:角色_取帮派信息()
            if type(r) == "string" then
                窗口层:提示窗口(r)
            elseif type(r) == "table" then
                窗口层:打开帮派现状(r)
            end
        elseif v.name == '系统' then
            窗口层:打开系统()
        end
        if v.name ~= '好友' then
            self.消息 = false
        end
    end

    function 按钮:键盘弹起(键码, 功能)
        if 战场层.是否可见 then
            return
        end
        if 功能 & SDL.KMOD_ALT ~= 0 and 键码 == v.key then
            self:左键弹起()
        end
        if v.name == '道具' then
            if 功能 & SDL.KMOD_ALT ~= 0 and 键码 == SDL.KEY_I then
                self:左键弹起()
            elseif 功能 & SDL.KMOD_ALT ~= 0 and 键码 == SDL.KEY_V then
                窗口层:打开法宝界面()
            elseif 功能 & SDL.KMOD_ALT ~= 0 and 键码 == SDL.KEY_R then
                窗口层:打开坐骑()
            end
        end
    end
end

function RPC:界面消息_队伍()
    if 窗口层.申请加入队伍窗口.是否可见 then
        coroutine.xpcall(窗口层.获取申请加入队伍, 窗口层)
    else
        按钮栏.组队按钮.消息 = true
    end
end

function RPC:界面消息_帮派()
    按钮栏.帮派按钮.消息 = true
end

function RPC:界面消息_任务(v)
end

function RPC:界面消息_好友(nid)
    __res:界面音效('ui_message')
    if 窗口层.好友聊天窗口.是否可见 and 窗口层.好友聊天窗口.curid == nid then
        窗口层:好友_刷新信息2(nid)
    else
        按钮栏.好友按钮.消息 = true
    end
end

-- ==================================================================================================
local 表情按钮 = 界面层:创建按钮('表情按钮', -400, -23, 50, 50)
do
    function 表情按钮:初始化()
        local tcp = __res:get('gires/emote/41.tca')

        local ani = tcp:取动画(1):置中心(0, -23):播放(true)
        for i = 1, ani.帧数 do
            ani:置当前帧(i) -- 载入
        end
        self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
        self:置经过精灵(ani)
        self:置按下精灵(ani)
    end

    表情按钮.检查透明 = 表情按钮.检查点

    function 表情按钮:获得鼠标(x, y)
        -- 鼠标提示(self:取坐标(), y - 30, '表情包子')
    end

    function 表情按钮:左键弹起(x, y)
        窗口层:打开表情()
    end

    function 表情按钮:键盘弹起(键码, 功能)
        if 功能 & SDL.KMOD_ALT ~= 0 and 键码 == SDL.KEY_0 then
            self:左键弹起()
        end
    end
end




local 发送按钮 = 界面层:创建小按钮('发送按钮', -370, -26, '发送')
function 发送按钮:初始化()
    self:置文本('发送')
    self:置可见(gge.platform ~= 'Windows')
end

function 发送按钮:左键弹起()
    界面层:发消息()
end

return 按钮栏
