-- local 道具 = 窗口层:创建我的窗口('道具', 0, 0, 400, 490)
-- local _现金 = true
-- do
--     function 道具:初始化()
--         self:置精灵(
--             self:取老水墨窗口(
--                 self.宽度,
--                 self.高度,
--                 '\n物\n品\n栏',
--                 function()
--                     self:取拉伸图像_宽高('gires4/smsj/yjan/donghuazhanshi.tcp', 99, 131):显示(162
--                         , 46)
--                     local stf = self:取拉伸图像_宽高('gires4/smsj/yjan/suofangwup.tcp', 56,
--                         56)
--                     local stf2 = self:取拉伸图像_宽高('gires4/smsj/yjan/wupinlanb.tcp', 56
--                         , 56)
--                     stf:显示(101, 33)
--                     stf:显示(46, 33)
--                     stf2:显示(101, 33)
--                     stf2:显示(46, 33)
--                     stf:显示(101, 90)
--                     stf:显示(46, 90)
--                     stf2:显示(101, 90)
--                     stf2:显示(46, 90)
--                     stf:显示(101, 147)
--                     stf:显示(46, 147)
--                     stf2:显示(101, 147)
--                     stf2:显示(46, 147)
--                     stf:显示(320, 33)
--                     stf:显示(265, 33)
--                     stf2:显示(320, 33)
--                     stf2:显示(265, 33)
--                     stf:显示(320, 90)
--                     stf:显示(265, 90)
--                     stf2:显示(320, 90)
--                     stf2:显示(265, 90)
--                     stf:显示(320, 147)
--                     stf:显示(265, 147)
--                     stf2:显示(320, 147)
--                     stf2:显示(265, 147)
--                     self:取拉伸图像_宽高('gires4/bianjiqi/shuruwenbenkuang.tcp', 135, 18):显示(85, 210):显示(85
--                         , 233)
--                     __res.J16B:置颜色(0, 0, 0)
--                     --   __res.J16B:取图像("现金"):显示(50, 210)
--                     __res.J16B:取图像("师贡"):显示(50, 233)
--                     __res:getsf('gires3/0xDD1A4C3F.tcp'):显示(46, 260)
--                 end
--             )
--         )
--         self:置坐标(10, (引擎.高度 - 500) // 2) --道具栏界面.tcp
--     end

--     function 道具:更新(dt)
--         if self.动画 then
--             self.动画:更新(dt)
--         end
--     end

--     function 道具:前显示(x, y)
--         if self.动画 then
--             self.动画:显示2(x + 200, y + 160)
--         end
--     end

--     function 道具:置动画模型(id)
--         self.动画 = require('对象/基类/动作') { 外形 = id or __rol.原形, 模型 = 'attack' } --attack
--         self.动画:置循环(true)
--     end
-- end
-- 道具:创建关闭按钮()

-- for i, v in ipairs {
--     { name = '存款', x = 87, y = 211, k = 120, g = 15 },
--     { name = '银子', x = 87, y = 211, k = 120, g = 15 },
--     { name = '师贡', x = 87, y = 234, k = 120, g = 15 }
-- } do
--     local 文本 = 道具:创建文本(v.name .. '文本', v.x, v.y, v.k, v.g)
--     文本:置文字(__res.F16B)
--     文本:置文本('')
-- end

-- local 存现文本 = 道具:创建文本('存现文本', 50, 210, 50, 20)
-- 存现文本:置文字(__res.J16B)
-- 存现文本:置文本('#K现金')

-- local 装备网格 = 道具:创建网格('装备网格', 46, 33, 330, 170)
-- do


--     local _底图 = require("SDL.精灵")(0, 0, 0, 50, 50):置颜色(0, 0, 0, 150)

--     function 装备网格:初始化()
--         self:添加格子(3, 3, 50, 50) --1披风
--         self:添加格子(58, 3, 50, 50) --2帽子
--         self:添加格子(222, 3, 50, 50) --3面具
--         self:添加格子(277, 3, 50, 50) --4项链
--         self:添加格子(3, 60, 50, 50) --5武器
--         self:添加格子(58, 60, 50, 50) --6衣服
--         self:添加格子(222, 60, 50, 50) --7戒指
--         self:添加格子(277, 60, 50, 50) --8戒指
--         self:添加格子(3, 117, 50, 50) --9挂件
--         self:添加格子(58, 117, 50, 50) --10鞋子
--         self:添加格子(222, 117, 50, 50) --11腰带
--         self:添加格子(277, 117, 50, 50) --12护身符
--         self.数据 = {}
--         self.记录格子 = 0
--         self.底图 = {}
--         for i, v in ipairs {
--             "pifengdi.png",
--             "maozidi.png",
--             "mianjidi.png",
--             "xiangliandi.png",
--             "wuqidi.png",
--             "yifudi.png",
--             "jiezhidi.png",
--             "jiezhidi.png",
--             "guajidi.png",
--             "xiezidi.png",
--             "yaodidi.png",
--             "hushenfufdi.png",



--         } do
--             table.insert(self.底图, __res:getspr('gires4/ty/%s', v))

--         end
--     end

--     function 装备网格:子显示(x, y, i)
--         if self.数据[i] then
--             _底图:显示(x, y)
--             self.数据[i]:显示(x, y)
--         else
--             if self.底图[i] then
--                 self.底图[i]:显示(x, y)
--             end
--         end
--     end

--     function 装备网格:获得鼠标(x, y, i)
--         if self.记录格子 ~= i then
--             self:清空请求记录(self.记录格子)
--         end
--         if not 鼠标层.附加 and self.数据 and self.数据[i] then
--             if self.数据[i].nid then
--                 self:物品提示(x, y, self.数据[i]) --先显示缓存.
--                 if not self.数据[i].已请求 then
--                     local r = __rpc:取物品描述(self.数据[i].nid)
--                     if r and self.数据[i] then
--                         self.数据[i].刷新显示 = true
--                         self.数据[i].属性 = r
--                         self:物品提示(x, y, self.数据[i])
--                     end
--                     self.数据[i].已请求 = true
--                 end

--             elseif self.数据[i].名称 then --本地
--                 self:物品提示(x, y, self.数据[i])
--             end
--         end
--         self.记录格子 = i
--     end

--     function 装备网格:清空请求记录(i)
--         if self.数据 and self.数据[i] then
--             self.数据[i].已请求 = nil
--         end
--     end

--     function 装备网格:右键弹起(x, y, i)
--         if self.数据[i] then
--             if __rpc:角色_脱下装备(i) then
--                 self.数据[i] = nil
--             else
--                 窗口层:提示窗口('#R没有多余的空位。')
--             end
--         end
--     end

--     function 装备网格:左键弹起(x, y, i)
--         if gge.platform ~= 'Windows' then
--             self:右键弹起(x, y, i)
--         end
--     end
-- end

-- --===============================================================================================
-- local 道具网格 = 道具:创建物品网格('道具网格', 47, 261, 305, 203)
-- do
--     function 道具网格:左键弹起(x, y, i)
--         if gge.platform ~= 'Windows' then
--             if self.数据[i] then
--                 self.当前选中 = i
--             end
--         else
--             if 鼠标层.附加 then
--                 local m = 鼠标层.附加
--                 if m.来源 == '物品' then
--                     if m.i ~= i then --原地
--                         if m.是否拆分 then
--                             if not self.数据[i] then
--                                 local r, a, b = __rpc:角色_物品拆分(m.I, (_P - 1) * 24 + i, m.拆分数量)
--                                 if r == 1 then
--                                     self:添加(m.i, a)
--                                     self:添加(i, b)
--                                 elseif r == 2 then
--                                     self:添加(m.i, self.数据[i])
--                                     self:添加(i, m.self) --m.self才是真身
--                                 end
--                             end
--                         else
--                             local r, a, b = __rpc:角色_物品交换(m.I, (_P - 1) * 24 + i)
--                             if r == 1 then --合并
--                                 m:删除()
--                                 self:添加(i, a)
--                             elseif r == 2 then --交换
--                                 self:添加(m.i, self.数据[i])
--                                 self:添加(i, m.self) --m.self才是真身
--                             elseif r == 3 then --合并2
--                                 self:添加(m.i, a)
--                                 self:添加(i, b)
--                             end
--                         end
--                     end
--                 elseif m.来源 == '装备' and not self.数据[i] then
--                     -- local r = __rpc:角色_物品卸下装备(m.i, (_P - 1) * 24 + i)

--                     -- if type(r) == 'number' then
--                     --     self.数据[i] = require('界面/数据/物品')(_装备[m.i])
--                     --     _装备[m.i] = nil
--                     -- elseif type(r) == 'string' then
--                     --     窗口层:提示窗口(r)
--                     -- end
--                 end
--                 鼠标层.附加 = m:返回()
--             elseif self.数据[i] then
--                 if __rol.是否战斗 then
--                     return
--                 end
--                 if 引擎:取功能键状态(SDL.KMOD_SHIFT) then --聊天框
--                     界面层:输入对象(self.数据[i])
--                 else
--                     鼠标层.附加 = self.数据[i]:拿起()
--                 end
--             end
--         end
--     end

--     function 道具网格:右键弹起(x, y, i)
--         local m = self.数据[i]
--         if m then
--             if __rol.是否战斗 then
--                 if not m.战斗是否可用 then
--                     return
--                 end
--                 道具:置可见(false)
--                 鼠标层:道具形状()
--                 鼠标层.道具 = m
--                 coroutine.resume(co, m.I)
--                 return
--             end
--             self:物品提示()
--             local r, v = __rpc:角色_物品使用(m.I)
--             if r == 1 and type(v) == 'table' then --更新
--                 m:刷新(v)
--             elseif r == 2 then --删除
--                 m:删除()
--             elseif r == 3 and type(v) == 'number' then --装备
--                 m:到装备(装备网格.数据, v)
--             elseif type(r) == 'string' then
--                 窗口层:提示窗口(r)
--             elseif type(v) == 'string' then
--                 窗口层:提示窗口(v)
--             else
--                 窗口层:提示窗口('#R该物品无法使用。')
--             end
--         end
--     end

--     function 道具网格:键盘弹起(键码, 功能)
--         local m = 鼠标层.附加
--         if m and m.来源 == '物品' and m.数量 > 1 then
--             if 键码 ~= SDL.KEY_LSHIFT and 键码 ~= SDL.KEY_RSHIFT then
--                 return
--             end
--             鼠标层.附加 = m:返回()
--             local r = 窗口层:打开拆分窗口(m.数量)
--             if r and r > 0 and r <= m.数量 then
--                 鼠标层.附加 = m:拆分拿起(r)
--             end
--         end
--     end
-- end


-- --===============================================================================================




-- for i, v in ipairs { 'djyi', 'djer', 'djsan', 'djsi' } do
--     local 按钮 = 道具:创建单选按钮('物品栏' .. i, 355, 260 + i * 40 - 40, 39, 37)
--     function 按钮:初始化()
--         self:设置按钮精灵2('gires3/button/%s.tcp', v)
--     end

--     function 按钮:左键弹起()
--         local m = 鼠标层.附加
--         if ggetype(m) == '物品' then
--             if m.是否拆分 then
--                 return false
--             end
--             鼠标层.附加 = m:返回()
--             coroutine.xpcall(
--                 function()
--                     --为了return false
--                     if __rpc:角色_物品交换(m.I, i << 8) then
--                         m:删除()
--                     end
--                 end
--             )
--             return false
--         end
--     end

--     function 按钮:选中事件(v)
--         if v then
--             窗口层:刷新道具(i)
--         end
--     end
-- end


-- local 加锁按钮 = 道具:创建我的按钮('gires3/button/jiasuo.tcp', '加锁按钮', 172, 178)
-- local 解锁按钮 = 道具:创建我的按钮('gires3/button/jiesuo.tcp', '解锁2按钮', 192, 178)
-- local 时间锁按钮 = 道具:创建我的按钮('gires3/button/shijiansuo.tcp', '时间锁按钮',
--     212, 178)
-- local 设定按钮 = 道具:创建我的按钮('gires3/button/sheding.tcp', '设定按钮', 232, 178)




-- function 解锁按钮:左键弹起()
--     local r = 窗口层:输入窗口('', "请输入安全码")
--     if r then
--         __rpc:角色_解交易锁(r)
--     end
--     道具:置可见(false)
-- end

-- 道具.物品栏1:置选中(true)

-- local function 置物品栏数量(n)
--     n = n or 1
--     for i = 1, 4 do
--         道具['物品栏' .. i]:置可见(i <= n)
--     end
-- end

-- if gge.platform ~= 'Windows' then
--     local 使用按钮 = 道具:创建小按钮('使用按钮', 227, 173, '使用')
--     function 使用按钮:左键弹起()
--         if 道具网格.当前选中 and 道具网格.数据[道具网格.当前选中] then
--             local m = 道具网格.数据[道具网格.当前选中]
--             if __rol.是否战斗 then
--                 if not m.战斗是否可用 then
--                     return
--                 end
--                 道具:置可见(false)
--                 鼠标层:道具形状()
--                 鼠标层.道具 = m
--                 coroutine.resume(co, m.I)
--                 return
--             end

--             self:物品提示()
--             local r, v = __rpc:角色_物品使用(m.I)
--             if r == 1 and type(v) == 'table' then --更新
--                 m:刷新(v)
--             elseif r == 2 then --删除
--                 m:删除()
--             elseif r == 3 and type(v) == 'number' then --装备
--                 m:到装备(装备网格.数据, v)
--             elseif type(r) == 'string' then
--                 窗口层:提示窗口(r)
--             elseif type(v) == 'string' then
--                 窗口层:提示窗口(v)
--             else
--                 窗口层:提示窗口('#R该物品无法使用。')
--             end
--             道具网格.当前选中 = nil
--         end
--     end

--     local 丢弃按钮 = 道具:创建小按钮('丢弃按钮', 290, 173, '丢弃')
--     function 丢弃按钮:左键弹起()
--         if 道具网格.当前选中 and 道具网格.数据[道具网格.当前选中] then
--             local m = 道具网格.数据[道具网格.当前选中]
--             if m then
--                 m:丢弃()
--             end
--         end
--         道具网格.当前选中 = nil
--     end

--     local 整理按钮 = 道具:创建小按钮('整理按钮', 227, 203, '整理')
--     function 整理按钮:左键弹起()
--         道具网格.当前选中 = nil
--         __rpc:角色_物品整理(道具网格.当前页)
--     end

--     local 发送按钮 = 道具:创建小按钮('发送按钮', 290, 203 + 24, '发送')
--     function 发送按钮:左键弹起()
--         self:置可见(false, false)
--         道具.解锁按钮:置可见(false, false)
--         _弹出开关 = false
--         if 道具网格.当前选中 and 道具网格.数据[道具网格.当前选中] then
--             local m = 道具网格.数据[道具网格.当前选中]
--             if m then
--                 界面层:输入对象(m)
--             end
--         end
--         道具网格.当前选中 = nil
--     end

--     local 解锁按钮 = 道具:创建小按钮('解锁按钮', 290, 203 + 48, '解锁')
--     function 解锁按钮:左键弹起()
--         local r = 窗口层:输入窗口('', "请输入安全码")
--         if r then
--             __rpc:角色_解交易锁(r)
--         end
--         道具.发送按钮:置可见(false, false)
--         _弹出开关 = false
--         self:置可见(false, false)
--         道具:置可见(false)
--     end

--     local 更多按钮 = 道具:创建小按钮('更多按钮', 290, 203, '更多')
--     function 更多按钮:左键弹起()
--         _弹出开关 = _弹出开关 == false and true or false
--         发送按钮:置可见(_弹出开关 == true, _弹出开关 == true)
--         解锁按钮:置可见(_弹出开关 == true, _弹出开关 == true)
--     end

-- else
--     -- file, name, x, y, txt, w)水墨书卷\元件按钮
--     local 整理按钮 = 道具:创建合成文字按钮('gires4/smsj/yjan/anniu.tcp', '整理按钮',
--         231, 228, '  整理')
--     function 整理按钮:左键弹起()
--         __rpc:角色_物品整理(道具网格.当前页)
--     end

--     local 换装按钮 = 道具:创建合成文字按钮('gires4/smsj/yjan/anniu.tcp', '换装按钮',
--         308, 228, '  换装')
--     function 换装按钮:左键弹起()

--     end

--     local 摆摊按钮 = 道具:创建水墨小按钮('摆摊按钮', 255, 208, '摆摊', 34) --name, x, y, txt, w)
--     function 摆摊按钮:左键弹起()
--         if __rol.是否摆摊 then
--             窗口层:打开摆摊盘点()
--         else
--             local r = __rpc:角色_摆摊出摊()
--             if type(r) == 'string' then
--                 窗口层:提示窗口(r)
--             else
--                 窗口层:打开摆摊盘点()
--             end
--         end
--         道具:置可见(false)
--     end

--     local 形象装扮按钮 = 道具:创建水墨小按钮('形象装扮按钮', 300, 208, '形象装扮', 70) --name, x, y, txt, w)
--     function 形象装扮按钮:左键弹起()
--         __res.F13:置颜色(255, 255, 255)
--         do
--             local t = __res.F13:取图像(txt)
--             t:置中心(-(w - t.宽度) // 2, -(17 - t.高度) // 2)
--             self:置正常精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 1, w,
--                 17, t))

--             t:置中心(-(w - t.宽度) // 2 - 1, -(17 - t.高度) // 2 - 1)
--             self:置按下精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 2, w,
--                 17, t))

--             t:置中心(-(w - t.宽度) // 2, -(17 - t.高度) // 2)
--             self:置经过精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 3, w,
--                 17, t))










--         end
--     end

--     local 存款按钮 = 道具:创建多选按钮('存款按钮', 184, 210) --name, x, y, txt, w)
--     function 存款按钮:初始化()
--         __res.F13:置颜色(255, 255, 255)
--         local t = __res.F13:取图像('存款')
--         t:置中心(-(34 - t.宽度) // 2, -(17 - t.高度) // 2)
--         self:置正常精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 1, 34, 17,
--             t))
--         t:置中心(-(34 - t.宽度) // 2 - 1, -(17 - t.高度) // 2 - 1)
--         self:置按下精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 2, 34, 17,
--             t))
--         t:置中心(-(34 - t.宽度) // 2, -(17 - t.高度) // 2)
--         self:置经过精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 3, 34, 17,
--             t))
--         t = __res.F13:取图像('现金')
--         t:置中心(-(34 - t.宽度) // 2, -(17 - t.高度) // 2)
--         self:置选中正常精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 1, 34
--             , 17, t))
--         t:置中心(-(34 - t.宽度) // 2 - 1, -(17 - t.高度) // 2 - 1)
--         self:置选中按下精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 2, 34
--             , 17, t))
--         t:置中心(-(34 - t.宽度) // 2, -(17 - t.高度) // 2)
--         self:置选中经过精灵(self:取拉伸精灵_宽高帧('gires4/smsj/yjan/xiaoannniu.tcp', 1, 34
--             , 17, t))
--     end

--     function 存款按钮:左键弹起(v)
--         _现金 = not _现金
--         道具.银子文本:置可见(_现金)
--         道具.存款文本:置可见(not _现金)
--         local s = _现金 and "#K现金" or "#K存款"
--         存现文本:置文本(s)
--     end
-- end





-- function 窗口层:刷新道具(p)
--     _P = p
--     道具网格:刷新道具(p)
-- end

-- function 窗口层:刷新银子()
--     local n = __rpc:角色_取银子()
--     道具.银子文本:置文本(银两颜色(n))
-- end

-- function 窗口层:刷新师贡()
--     local n = __rpc:角色_取师贡()
--     道具.师贡文本:置文本(银两颜色(n))
-- end

-- function 窗口层:打开道具()
--     道具:置可见(not 道具.是否可见)
--     if not 道具.是否可见 then
--         return
--     end
--     if gge.platform ~= 'Windows' then
--         _弹出开关 = false
--         道具.发送按钮:置可见(false, false)
--         道具.解锁按钮:置可见(false, false)
--     else

--         _弹出开关 = false
--         --  道具.当铺按钮:置可见(false, false)
--         --  道具.换装按钮:置可见(false, false)


--     end

--     local 现金, 存款, 师贡, 栏数, 原形 = __rpc:角色_打开物品窗口()
--     道具.银子文本:置文本(银两颜色(现金))
--     道具.存款文本:置文本(银两颜色(存款))
--     道具.师贡文本:置文本(银两颜色(师贡))

--     道具.银子文本:置可见(_现金)
--     道具.存款文本:置可见(not _现金)

--     置物品栏数量(栏数)
--     if not _P then --首次打开
--         _P = 1
--         _装备 = {}
--     end

--     local list = __rpc:角色_装备列表()
--     for k, v in pairs(list) do
--         require('界面/数据/物品')(v):到装备(装备网格.数据, k)
--     end
--     窗口层:刷新道具(_P)
--     道具:置动画模型(原形)
-- end

-- function 窗口层:打开战斗道具(nid)
--     道具:置可见(true) --重连
--     道具.是否可见 = false
--     道具网格:清空()
--     窗口层:打开道具(nid)
--     co = coroutine.running()

--     return coroutine.yield()
-- end

-- return 道具
