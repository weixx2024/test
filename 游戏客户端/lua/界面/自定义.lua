local SDL = require 'SDL'
local GUI = require '界面'
local GUI控件 = require('GUI.控件')
local _ENV = require('界面/资源')

function GUI控件:创建我的窗口(name, x, y, w, h)
    local 窗口 = self:创建窗口(name, x, y, w, h)
    窗口:注册事件(
        窗口,
        {
            可见事件 = function(_, v)
                __res:界面音效('sound/addon/%s.wav', v and 'open' or 'close')
            end
        }
    )

    return 窗口
end

function GUI控件:创建我的文本(name, x, y, w, h)
    local 文本 = self:创建文本(name, x, y, w, h)
    文本:置文字表(GUI.资源层.fonts)
    文本:置精灵表(GUI.资源层.emote)
    文本:注册事件(
        文本,
        {
            获得回调 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )

    return 文本
end

-- ===============================================================================================
-- 弹出列表
-- function GUI控件:创建文本组合(name, x, y, w, h)
--     local 组合框 = self:创建组合(name, x, y, w, h)
--     local 文本 = 组合框:创建组合文本(0, 0, w, h)

--     local 按钮 = 组合框:创建组合按钮(w - 20, 0) --x,y
--     function 按钮:初始化()
--         local tcp = __res:get('gires/button/down.tca')
--         self:置正常精灵(tcp:取精灵(1))
--         self:置按下精灵(tcp:取精灵(2))
--         self:置经过精灵(tcp:取精灵(3))
--     end

--     local 弹出 = 组合框:创建组合弹出(0, h, w, 120)
--     弹出:置精灵(require('SDL.精灵')(0, 0, 0, w, 120):置颜色(0, 0, 0, 200))

--     local 列表 = 组合框:创建组合列表(5, 5, w - 25, 110) --w,h
--     列表:置颜色(255, 255, 255)
--     列表:创建我的滑块()
--     return 组合框
-- end
function GUI控件:创建文本组合(name, x, y, w, h)
    local 组合框 = self:创建组合(name, x, y, w, h)
    local 文本 = 组合框:创建组合文本(0, 0, w, h)

    local 按钮 = 组合框:创建组合按钮(w - 20, 0) --x,y
    function 按钮:初始化()
        local tcp = __res:get('gires/button/down.tca')
        self:置正常精灵(tcp:取精灵(1))
        self:置按下精灵(tcp:取精灵(2))
        self:置经过精灵(tcp:取精灵(3))
    end

    local 弹出 = 组合框:创建组合弹出(0, h, w, 120)
    弹出:置精灵(require('SDL.精灵')(0, 0, 0, w, 120):置颜色(0, 0, 0, 200))

    local 列表 = 组合框:创建组合列表(5, 5, w - 25, 110) --w,h
    列表:置颜色(255, 255, 255)
    --    列表:创建我的滑块()
    return 组合框
end

function GUI控件:创建文本组合2(name, x, y, w, h)
    local 组合框 = self:创建组合(name, x, y, w, h)
    local 文本 = 组合框:创建文本(2, 2, w, h)

    local 按钮 = 组合框:创建按钮(w - 20, 0) --x,y
    function 按钮:初始化()
        local tcp = __res:get('gires4/jdmh/yjan/搜索按钮.tcp')
        self:置正常精灵(tcp:取精灵(1))
        self:置按下精灵(tcp:取精灵(2))
        self:置经过精灵(tcp:取精灵(3))
    end

    local 弹出 = 组合框:创建弹出(0, h, w, 120)
    弹出:置精灵(弹出:取拉伸精灵_宽高('gires4/jdmh/yjan/lbkdt.tcp', w, 120))

    local 列表 = 组合框:创建列表(5, 5, w - 25, 110) --w,h
    列表:置颜色(255, 255, 255)
    列表:创建我的滑块()
    return 组合框
end

--===============================================================================================
function GUI控件:创建文本输入(name, x, y, w, h) --
    local 输入 = self:创建输入(name, x, y, w, h)
    输入:置颜色(255, 255, 255, 255)
    输入:置限制字数(20)

    function 输入:获得鼠标()
        鼠标层:输入形状()
    end

    return 输入
end

--===============================================================================================
function GUI控件:创建数字输入(name, x, y, w, h)
    local 输入 = self:创建输入(name, x, y, w, h)
    输入:置颜色(255, 255, 255, 255)
    输入:置限制字数(10)
    输入:置模式(输入.数字模式)
    输入.最大值 = 999999999
    输入.最小值 = 0
    --输入:置文本(1)

    function 输入:获得鼠标()
        鼠标层:输入形状()
    end

    function 输入:输入事件()
        if self:取文本() == '' then
            if self.输入数值 then
                self:输入数值(0)
            end
            return
        end
        local t = self:取数值()
        if t < self.最小值 then
            self:置文本(self.最小值)
            t = self.最小值
        elseif t > self.最大值 then
            self:置文本(self.最大值)
            t = self.最大值
        end
        if self.输入数值 then
            self:输入数值(t)
        end
    end

    return 输入
end

function GUI控件:创建金额输入(name, x, y, w, h)
    local 输入 = self:创建输入(name, x, y, w, h)
    输入:置颜色(255, 255, 255, 255)
    输入:置限制字数(14)
    输入:置模式(输入.数字模式)


    function 输入:获得鼠标()
        鼠标层:输入形状()
    end

    function 输入:输入事件()
        local t = self:取文本():gsub(',', '')
        if t == '' then
            if self.输入数值 then
                self:输入数值(0)
            end
            return
        end

        if #t < 5 then
            输入:置颜色(255, 255, 255, 255)
        elseif #t < 6 then
            输入:置颜色(0x25, 0xda, 0x77, 255)
        elseif #t < 7 then
            输入:置颜色(0xfc, 0x45, 0xdc, 255)
        elseif #t < 8 then
            输入:置颜色(0xfb, 0xd8, 0x33, 255)
        elseif #t < 9 then
            输入:置颜色(0x04, 0xfd, 0xf4, 255)
        elseif #t < 10 then
            输入:置颜色(0x0a, 0xfd, 0x04, 255)
        else
            输入:置颜色(0xad, 0x10, 0x10, 255)
        end
        输入:置模式(输入.正常模式)
        输入:置文本(GGF.格式化货币(t))
        输入:置模式(输入.数字模式)
        if self.输入数值 then
            self:输入数值(tonumber(t))
        end
    end

    return 输入
end

--===============================================================================================
function GUI控件:设置按钮精灵(file, ...) --普通按钮
    local tcp = __res:get(file, ...)
    if not tcp then
        return
    end
    --print(tcp.frame, file)
    if tcp.frame == 1 then
        self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
        self:置按下精灵(tcp:取精灵(1):置中心(-1, -1))
    elseif tcp.frame == 3 then
        self:置正常精灵(tcp:取精灵(1))
        self:置按下精灵(tcp:取精灵(2))
        self:置经过精灵(tcp:取精灵(3))
        self:置禁止精灵(tcp:取图像(1):到灰度():到精灵())
    end
    self:注册事件(
        self,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return tcp
end

function GUI控件:设置按钮精灵2(file, ...) --选中按钮
    local tcp = __res:get(file, ...)
    if not tcp then
        print(file)
        return
    end
    --print(file, tcp.frame)
    if tcp.frame == 2 then
        self:置正常精灵(tcp:取精灵(1))
        --self:置按下精灵(tcp:取精灵(2))
        self:置经过精灵(tcp:取精灵(2))
        self:置选中正常精灵(tcp:取精灵(2))
    elseif tcp.frame == 3 then
        self:置正常精灵(tcp:取精灵(1))
        self:置按下精灵(tcp:取精灵(2))
        self:置经过精灵(tcp:取精灵(3))
        self:置选中正常精灵(tcp:取精灵(2))
    elseif tcp.frame == 4 then
        self:置正常精灵(tcp:取精灵(1))
        self:置按下精灵(tcp:取精灵(2))
        self:置经过精灵(tcp:取精灵(3))
        self:置选中正常精灵(tcp:取精灵(2))
    end
    self:注册事件(
        self,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return tcp
end

function GUI控件:设置按钮精灵3(file, ...)
    local tcp = __res:get(file, ...)
    if not tcp then
        print(file)
        return
    end
    --print(tcp.frame, file)
    if tcp.frame == 1 then
        self:置选中正常精灵(tcp:取精灵(1):置中心(0, 0))
        self:置选中按下精灵(tcp:取精灵(1):置中心(-1, -1))
    elseif tcp.frame == 3 then
        self:置选中正常精灵(tcp:取精灵(1))
        self:置选中按下精灵(tcp:取精灵(2))
        self:置选中经过精灵(tcp:取精灵(3))
    end
    return tcp
end

--===============================================================================================

function GUI控件:创建文字按钮(name, x, y, txt) --绿的
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        __res.F14:置颜色(0, 255, 0, 255)
        self:置正常精灵(__res.F14:取精灵(txt))
        self:置按下精灵(__res.F14:取精灵(txt):置中心(-1, -1))
    end

    按钮.检查透明 = 按钮.检查点
    return 按钮
end

function GUI控件:创建文字按钮2(name, x, y, txt) --白的
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        if txt then
            self:置文本(txt)
        end
    end

    function 按钮:置文本(txt)
        __res.F14:置颜色(255, 255, 255, 255)
        self:置正常精灵(__res.F14:取精灵(txt))
        self:置按下精灵(__res.F14:取精灵(txt):置中心(-1, -1))
    end

    按钮.检查透明 = 按钮.检查点
    return 按钮
end

function GUI控件:创建文字按钮3(name, x, y, txt) --黑的
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        if txt then
            self:置文本(txt)
        end
    end

    function 按钮:置文本(txt)
        __res.F14:置颜色(0, 0, 0, 255)
        self:置正常精灵(__res.F14:取精灵(txt))
        self:置按下精灵(__res.F14:取精灵(txt):置中心(-1, -1))
    end

    按钮.检查透明 = 按钮.检查点
    return 按钮
end

--===============================================================================================
function GUI控件:创建NPC文字按钮(name, x, y, txt)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        __res.F14:置颜色(0, 255, 0, 255)
        self:置正常精灵(__res.F14:取精灵(txt))
        __res.F14:置颜色(255, 255, 0, 255)
        self:置经过精灵(__res.F14:取精灵(txt))
        self:置按下精灵(__res.F14:取精灵(txt):置中心(-1, -1))
    end

    按钮.检查透明 = 按钮.检查点
    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

--===============================================================================================
function GUI控件:创建小按钮(name, x, y, txt, w)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        self:置文本(txt)
    end

    function 按钮:置文本(txt)
        self:置正常精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 1, txt))
        self:置按下精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 2, txt, 1, 1))
        self:置经过精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 3, txt))
        self:置禁止精灵(取按钮图像('gires/0x2BD1DEF7.tcp', 1, txt):到灰度():到精灵())
        self.文本 = txt
        return self
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建小小按钮(name, x, y, txt, w)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        self:置文本(txt)
    end

    function 按钮:置文本(txt)
        self:置正常精灵(取按钮精灵2('ui/xx1.png', txt))
        self:置按下精灵(取按钮精灵2('ui/xx3.png', txt, 1, 1))
        self:置经过精灵(取按钮精灵2('ui/xx2.png', txt))
        self:置禁止精灵(取按钮图像2('ui/xx1.png', txt):到灰度():到精灵())
        self.文本 = txt
        return self
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建红木小按钮(name, x, y, txt, w)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        __res.F13:置颜色(187, 165, 75)
        do
            local t = __res.F13:取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(17 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xan.tcp', 1, w,
                17, t))

            t:置中心(-(w - t.宽度) // 2 - 1, -(17 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xan.tcp', 2, w,
                17, t))

            t:置中心(-(w - t.宽度) // 2, -(17 - t.高度) // 2)
            self:置经过精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xan.tcp', 3, w,
                17, t))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建素材文本按钮(name, x, y, src, txt, w, h, r, g, b)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        __res.HYF:置颜色(r, g, b)
        do
            local t = __res.HYF:取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(h - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽高帧(src, 1, w, h, t))

            t:置中心(-(w - t.宽度) // 2 - 1, -(h - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽高帧(src, 1, w, h, t))

            t:置中心(-(w - t.宽度) // 2, -(h - t.高度) // 2)
            self:置经过精灵(self:取拉伸精灵_宽高帧(src, 1, w, h, t))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建红木按钮(name, x, y, txt, w)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        __res.HYF:置颜色(187, 165, 75)
        do
            local t = __res.HYF:取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(24 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽度帧('gires4/jdmh/yjan/an.tcp', 1, w, t))

            t:置中心(-(w - t.宽度) // 2 - 1, -(24 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽度帧('gires4/jdmh/yjan/an.tcp', 1, w, t))

            t:置中心(-(w - t.宽度) // 2, -(24 - t.高度) // 2)
            self:置经过精灵(self:取拉伸精灵_宽度帧('gires4/jdmh/yjan/an.tcp', 1, w, t))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

--===============================================================================================
function GUI控件:创建中按钮(name, x, y, txt, w)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        self:置正常精灵(取按钮精灵('gires/0x86D66B9A.tcp', 1, txt))
        self:置按下精灵(取按钮精灵('gires/0x86D66B9A.tcp', 2, txt, 1, 1))
        self:置经过精灵(取按钮精灵('gires/0x86D66B9A.tcp', 3, txt))
        self:置禁止精灵(取按钮图像('gires/0x86D66B9A.tcp', 1, txt):到灰度():到精灵())
    end

    function 按钮:置文本(txt)
        self:置正常精灵(取按钮精灵('gires/0x86D66B9A.tcp', 1, txt))
        self:置按下精灵(取按钮精灵('gires/0x86D66B9A.tcp', 2, txt, 1, 1))
        self:置经过精灵(取按钮精灵('gires/0x86D66B9A.tcp', 3, txt))
        self:置禁止精灵(取按钮图像('gires/0x86D66B9A.tcp', 1, txt):到灰度():到精灵())
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

-- function GUI控件:创建中按钮2(name, x, y, txt, w)
--     local 按钮 = self:创建按钮(name, x, y)
--     function 按钮:初始化()
--         local t = __res.F13:取图像(txt)
--         t:置中心(-(w - t.宽度) // 2, -(17 - t.高度) // 2)
--         ('gires4/jdmh/yjan/an.tcp', 1, w, t))
--         self:置正常精灵(self:取拉伸精灵_宽度帧('gires4/jdmh/yjan/xan.tcp', 1, w,
--         17, t))
--         self:置按下精灵(取按钮精灵('gires/0x86D66B9A.tcp', 2, txt, 1, 1))
--         self:置经过精灵(取按钮精灵('gires/0x86D66B9A.tcp', 3, txt))
--         self:置禁止精灵(取按钮图像('gires/0x86D66B9A.tcp', 1, txt):到灰度():到精灵())
--     end
--     self:取拉伸精灵_宽高帧('gires2/button/longlongbtn.tca', 1,)
--     按钮:注册事件(
--         按钮,
--         {
--             获得鼠标 = function(_, x, y)
--                 鼠标层:手指形状()
--             end
--         }
--     )
--     return 按钮
-- end


function GUI控件:创建中按钮2(name, x, y, txt, w)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        self:置正常精灵(取按钮精灵('gires3/button/longbtn.tcp', 1, txt, -10, -2, 'JMZ', 0, 0, 0))
        self:置按下精灵(取按钮精灵('gires3/button/longbtn.tcp', 2, txt, -9, -1, 'JMZ', 0, 0, 0))
        self:置经过精灵(取按钮精灵('gires3/button/longbtn.tcp', 3, txt, -10, -2, 'JMZ', 0, 0, 0))
        self:置禁止精灵(取按钮图像('gires3/button/longbtn.tcp', 1, txt, -10, -2, 'JMZ', 0, 0, 0):到灰度():
        到精灵())
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建四字按钮(name, x, y, txt, w)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        self:置正常精灵(取按钮精灵('gires3/button/longlongbtn.tcp', 1, txt, -8, -2, 'JMZ', 0, 0, 0))
        self:置按下精灵(取按钮精灵('gires3/button/longlongbtn.tcp', 2, txt, -7, -1, 'JMZ', 0, 0, 0))
        self:置经过精灵(取按钮精灵('gires3/button/longlongbtn.tcp', 3, txt, -8, -2, 'JMZ', 0, 0, 0))
        self:置禁止精灵(取按钮图像('gires3/button/longlongbtn.tcp', 1, txt, -8, -2, 'JMZ', 0, 0, 0):到灰度()
            :到精灵())
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建中按钮3(name, x, y, txt, w)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        __res.JMZ:置颜色(0, 0, 0)
        do
            local t = __res.JMZ:取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(24 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽度帧('gires3/button/longlongbtn.tcp', 1, w, t))

            t:置中心(-(w - t.宽度) // 2 - 1, -(24 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽度帧('gires2/button/longlongbtn.tca', 3, w, t))

            t:置中心(-(w - t.宽度) // 2, -(24 - t.高度) // 2)
            self:置经过精灵(self:取拉伸精灵_宽度帧('gires2/button/longlongbtn.tca', 2, w, t))

            t:置中心(-(w - t.宽度) // 2, -(24 - t.高度) // 2)
            self:置禁止精灵(self:取拉伸图像_宽度帧('gires2/button/longlongbtn.tca', 1, w, t):到灰度():
            到精灵())
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

-- ===============================================================================================
function GUI控件:创建标签按钮(name, x, y, txt, w)
    local 按钮 = self:创建单选按钮(name, x, y, w, 41)
    function 按钮:初始化()
        __res.HYF:置颜色(187, 165, 75)
        do
            local t = __res.HYF:取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(41 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/bq.tcp', 1, w, 32,
                t):置中心(0, -6))

            t:置中心(-(w - t.宽度) // 2 - 1, -(41 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/bq.tcp', 1, w, 32,
                t):置中心(0, -6))

            t:置中心(-(w - t.宽度) // 2, -(41 - t.高度) // 2)
            self:置选中正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/bq.tcp', 1, w
            , 41, t):置中心(0, 0))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

-- ===============================================================================================
function GUI控件:创建商城标签按钮(name, x, y, txt, w)
    local 按钮 = self:创建单选按钮(name, x, y, w, 41)
    function 按钮:初始化()
        __res.HYF:置颜色(187, 165, 75)
        do
            local t = __res.HYF:取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(41 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 1, w, 32,
                t):置中心(0, -6))

            t:置中心(-(w - t.宽度) // 2 - 1, -(41 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 1, w, 32,
                t):置中心(0, -6))

            t:置中心(-(w - t.宽度) // 2, -(41 - t.高度) // 2)
            self:置选中正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 1, w
            , 41, t):置中心(0, 0))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

-- ===============================================================================================
-- 取按钮精灵('gires/0x86D66B9A.tcp', 1, '任务追踪')
function GUI控件:创建中标签按钮(name, x, y, txt)
    local 按钮 = self:创建单选按钮(name, x, y, 85, 24)
    function 按钮:初始化()
        do
            self:置正常精灵(取按钮精灵('gires/0x86D66B9A.tcp', 1, txt))
            self:置按下精灵(取按钮精灵('gires/0x86D66B9A.tcp', 2, txt, 1, 1))
            self:置经过精灵(取按钮精灵('gires/0x86D66B9A.tcp', 3, txt))
            self:置禁止精灵(取按钮图像('gires/0x86D66B9A.tcp', 1, txt):到灰度():到精灵())
            self:置选中正常精灵(取按钮精灵('gires/0x86D66B9A.tcp', 2, txt))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

-- ===============================================================================================
function GUI控件:创建小标签按钮(name, x, y, txt)
    local 按钮 = self:创建单选按钮(name, x, y, 41, 25)
    function 按钮:初始化()
        __res.F14:置颜色(187, 165, 75)
        do
            local t = __res.F14:取图像(txt)
            t:置中心(-(41 - t.宽度) // 2, -(25 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/xbq.tcp', 1, 20,
                t):置中心(0, -5))
            t:置中心(-(41 - t.宽度) // 2 - 1, -(25 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/xbq.tcp', 2, 20,
                t):置中心(0, -5))

            t:置中心(-(41 - t.宽度) // 2, -(25 - t.高度) // 2 - 3)
            self:置选中正常精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/xbq.tcp', 2
            , 25, t):置中心(0, 0))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

-- ===============================================================================================
function GUI控件:创建自定义小标签按钮(name, x, y, txt, w, h)
    local 按钮 = self:创建单选按钮(name, x, y, w, h)
    function 按钮:初始化()
        __res.HYF:置颜色(187, 165, 75)
        do
            local t = __res.HYF:取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(h - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 1, w,
                h - 5, t):置中心(0, -5))
            t:置中心(-(w - t.宽度) // 2 - 1, -(h - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 2, w,
                h - 5, t):置中心(0, -5))

            t:置中心(-(w - t.宽度) // 2, -(h - t.高度) // 2 - 3)
            self:置选中正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 2
            , w, h, t):置中心(0, 0))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

-- ===============================================================================================
function GUI控件:创建小标签按钮2(name, x, y, w, txt)
    local 按钮 = self:创建单选按钮(name, x, y, w, 26)
    function 按钮:初始化()
        -- __res.F14:置颜色(187, 165, 75)
        do
            local t = __res.JMZ:置颜色(187, 165, 75):取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(21 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽度帧('gires4/jdmh/yjan/xbq.tcp', 1, w, t)
                :置中心(0, -5))
            t:置中心(-(w - t.宽度) // 2 - 1, -(21 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽度帧('gires4/jdmh/yjan/xbq.tcp', 2, w, t)
                :置中心(0, -5))

            t:置中心(-(w - t.宽度) // 2, -(21 - t.高度) // 2 - 3)
            self:置选中正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 1
            , w, 26, t):置中心(0, 0))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

--===============================================================================================
function GUI控件:创建横标签按钮(name, x, y, txt, w)
    local 按钮 = self:创建单选按钮(name, x, y, w, 26)
    function 按钮:初始化()
        __res.HYF:置颜色(187, 165, 75)
        do
            local t = __res.JMZ:置颜色(187, 165, 75):取图像(txt)
            t:置中心(-(w - t.宽度) // 2, -(21 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽度帧('gires4/jdmh/yjan/xbq.tcp', 1, w, t)
                :置中心(0, -5))
            t:置中心(-(w - t.宽度) // 2 - 1, -(21 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽度帧('gires4/jdmh/yjan/xbq.tcp', 2, w, t)
                :置中心(0, -5))

            t:置中心(-(w - t.宽度) // 2, -(21 - t.高度) // 2 - 3)
            self:置选中正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 1
            , w, 26, t):置中心(0, 0))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建向上按钮(name, x, y, w, h)
    local 按钮 = self:创建按钮(name, x, y, w, h)
    function 按钮:初始化(v)
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    return 按钮
end

function GUI控件:创建向下按钮(name, x, y, w, h)
    local 按钮 = self:创建按钮(name, x, y, w, h)
    function 按钮:初始化(v)
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    return 按钮
end

--===============================================================================================
function GUI控件:创建我的滑块()
    --  print(self.x + self.宽度)
    local 滚动条 = self:创建滚动条(self.宽度 - 23, 0, 23, self.高度 + 2)

    local 滑块按钮 = 滚动条:创建滚动按钮(2, 20, 18, self.高度 - 36)
    -- function 滑块按钮:初始化(v)
    -- 滑块按钮:置正常精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
    -- 滑块按钮:置经过精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
    -- 滑块按钮:置按下精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
    --   end

    local 减少按钮 = 滚动条:创建减少按钮(2, 0)

    function 减少按钮:初始化(v)
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    function 减少按钮:左键弹起(v)
        滚动条:置位置(滚动条._位置 - 40)
    end

    local 增加按钮 = 滚动条:创建增加按钮(2, -20)
    function 增加按钮:初始化(v)
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    function 增加按钮:左键弹起(v)
        滚动条:置位置(滚动条._位置 + 40)
    end

    return 滚动条
end

function GUI控件:创建我的滑块2() -- 带滑块
    -- print(self.x + self.宽度)
    local 滚动条 = self:创建滚动条(self.宽度 - 23, 0, 23, self.高度 + 2)

    local 滑块按钮 = 滚动条:创建滚动按钮(2, 20, 18, self.高度 - 36)
    function 滑块按钮:初始化(v)
        滑块按钮:置正常精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
        滑块按钮:置经过精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
        滑块按钮:置按下精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
    end

    local 减少按钮 = 滚动条:创建减少按钮(2, 0)

    function 减少按钮:初始化(v)
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    function 减少按钮:左键弹起(v)
        滚动条:置位置(滚动条._位置 - 40)
    end

    local 增加按钮 = 滚动条:创建增加按钮(2, -20)
    function 增加按钮:初始化(v)
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    function 增加按钮:左键弹起(v)
        滚动条:置位置(滚动条._位置 + 40)
    end

    return 滚动条
end

-- ===============================================================================================
function GUI控件:创建我的按钮(file, name, x, y, w, h)
    local 按钮 = self:创建按钮(name, x, y, w, h)
    function 按钮:初始化()
        if file:sub(-3) == 'tcp' then
            local tcp = __res:get(file)
            if not tcp then
                print(file)
                return
            end
            if tcp.frame == 1 then
                self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
                self:置按下精灵(tcp:取精灵(1):置中心(-1, -1))
            elseif tcp.frame == 3 then
                self:置正常精灵(tcp:取精灵(1))
                self:置按下精灵(tcp:取精灵(2))
                self:置经过精灵(tcp:取精灵(3))
                self:置禁止精灵(tcp:取图像(1):到灰度():到精灵())
            end
        else
            local spr = __res:getspr(file)
            if spr then
                self:置正常精灵(spr:置中心(0, 0))
                self:置按下精灵(spr:复制():置中心(-1, -1))
            end
        end
        return self
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建我的按钮2(name, x, y, w, h)
    local 按钮 = self:创建按钮(name, x, y, w, h)

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建人物头像按钮(name, x, y)
    local r = self:创建我的按钮2(name, x, y)









    return r
end

function GUI控件:创建召唤头像按钮(name, x, y)
    local r = self:创建按钮(name, x, y, 40, 40)
    function r:置头像(id)
        local sf = self:取拉伸图像_宽高('gires/main/border.bmp', 40, 40,
            __res:getsf('gires3/button/zhstx/%s.tcp', id):置中心(-2, -2)
        )
        local spr = sf:到精灵()
        self:置正常精灵(spr)
        self:置按下精灵(spr:复制():置中心(-1, -1))
        return self
    end

    r:置可见(true)
    return r
end

function GUI控件:创建物品召唤按钮(name, x, y)
    local 按钮 = self:创建我的按钮2(name, x, y, 55, 51)
    function 按钮:置召唤图(id)
        self:置可见(true)
        local sf = self:取拉伸图像_宽高('gires/main/border.bmp', 40, 40,
            __res:getsf('gires3/button/zhstx/%s.tcp', id):置中心(-2, -2)
        )
        local spr = sf:到精灵()
        self:置正常精灵(spr:置中心(-7, -5))
        self:置按下精灵(spr:复制():置中心(-8, -6))
    end

    function 按钮:置物品图(id)
        -- print(id)
        local spr = __res:getspr('item/item120/%04d.png', id)
        spr:置拉伸(50, 50, true)
        self:置正常精灵(spr:置中心(-2, 0))
        self:置按下精灵(spr:复制():置中心(-3, -1))
        self:置可见(true)
    end

    function 按钮:清空()
        self.对象 = nil
        self:置可见(false)
    end

    按钮.检查透明 = 按钮.检查点
    return 按钮
end

--===============================================================================================
function GUI控件:创建我的多选按钮(name, x, y)
    local 按钮 = self:创建多选按钮(name, x, y, 30, 28)
    function 按钮:初始化()
        self:置正常精灵(__res:getspr('gires/0x337A55AC.tcp'))
        self:置选中正常精灵(取按钮精灵('gires/0x337A55AC.tcp', 1, '√'))
    end

    按钮.检查透明 = 按钮.检查点
    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建我的多选按钮2(name, x, y, 选中, 未选中)
    local 按钮 = self:创建多选按钮(name, x, y)
    function 按钮:初始化()
        self:置正常精灵(取按钮精灵('gires/0x86D66B9A.tcp', 1, 选中))
        self:置按下精灵(取按钮精灵('gires/0x86D66B9A.tcp', 2, 选中, 1, 1))
        self:置经过精灵(取按钮精灵('gires/0x86D66B9A.tcp', 3, 选中))

        self:置选中正常精灵(取按钮精灵('gires/0x86D66B9A.tcp', 1, 未选中))
        self:置选中按下精灵(取按钮精灵('gires/0x86D66B9A.tcp', 2, 未选中, 1, 1))
        self:置选中经过精灵(取按钮精灵('gires/0x86D66B9A.tcp', 3, 未选中))
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建我的多选按钮3(name, x, y, 选中, 未选中)
    local 按钮 = self:创建多选按钮(name, x, y)
    function 按钮:初始化()
        self:置正常精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 1, 选中))
        self:置按下精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 2, 选中, 1, 1))
        self:置经过精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 3, 选中))

        self:置选中正常精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 1, 未选中))
        self:置选中按下精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 2, 未选中, 1, 1))
        self:置选中经过精灵(取按钮精灵('gires/0x2BD1DEF7.tcp', 3, 未选中))
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

-- local 滑块 = 区域1:创建滑块('滑块', 5, 670, 270, 15)
-- local 滑块按钮 = 滑块:创建滑块按钮(0, 0, 270, 15)

--===============================================================================================
function GUI控件:创建水平滚动条(name, x, y, w, h)
    local 滑块 = self:创建滑块(name, x, y, w, h)
    local 滑块按钮 = 滑块:创建滑块按钮('滑块按钮', 0, 0, w, h)
    --   function 滑块按钮:初始化()
    -- self:置正常精灵(__res:getspr('gires/0x94BCD6F0.tcp'))
    -- self:置经过精灵(__res:getspr('gires/0x94BCD6F0.tcp'))
    -- self:置按下精灵(__res:getspr('gires/0x94BCD6F0.tcp'))

    滑块按钮:置正常精灵(require('SDL.精灵')(0, 0, 0, 15, 15):置颜色(255, 255, 255, 255))
    滑块按钮:置经过精灵(require('SDL.精灵')(0, 0, 0, 15, 15):置颜色(255, 0, 0, 255))
    滑块按钮:置按下精灵(require('SDL.精灵')(0, 0, 0, 15, 15):置颜色(255, 0, 0, 255))



    --    end

    滑块:注册事件(
        滑块,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 滑块
end

--===============================================================================================
function GUI控件:创建关闭按钮(x, y)
    local 按钮 = self:创建按钮('关闭按钮', -25 + (x or 0), y or 0)
    function 按钮:初始化(v)
        local tcp = __res:get('gires/0xF11233BB.tcp')
        self:置正常精灵(tcp:取精灵(1))
        self:置按下精灵(tcp:取精灵(2))
        self:置经过精灵(tcp:取精灵(3))
    end

    function 按钮:左键弹起()
        self.父控件:置可见(false)
    end

    return 按钮
end

--===============================================================================================
function GUI控件:创建关闭按钮2()
    local 按钮 = self:创建按钮('关闭按钮', -20, 0)
    function 按钮:初始化(v)
        local tcp = __res:get('gires4/%s/yjan/gbxan2.tcp', v or 'jdmh')
        self:置正常精灵(tcp:取精灵(1))
        self:置按下精灵(tcp:取精灵(1):置中心(-1, -1))
        --self:置经过精灵(tcp:取精灵(3))
    end

    function 按钮:左键弹起()
        self.父控件:置可见(false)
    end

    return 按钮
end

function GUI控件:创建红木关闭按钮()
    local 按钮 = self:创建按钮('关闭按钮', -25, 0)
    function 按钮:初始化(v)
        -- local tcp = __res:get('gires4/%s/窗口底图/关闭按钮.tcp', v or 'jdmh')
        self:设置按钮精灵('gires4/%s/ckdt/gban.tcp', v or 'jdmh')
        -- self:置正常精灵(tcp:取精灵(1))
        -- self:置按下精灵(tcp:取精灵(1):置中心(-1, -1))
        --self:置经过精灵(tcp:取精灵(3))
    end

    function 按钮:左键弹起()
        self.父控件:置可见(false)
    end

    return 按钮
end

--===============================================================================================
local add
function GUI控件:创建加按钮(...)
    if not add then
        add = __res:get('gires/0x9C17654C.tcp')
    end
    local 按钮 = self:创建按钮(...)

    function 按钮:初始化()
        self:置提示('#Y按住shift每次加10点, 长按自动加点')
        self:置正常精灵(add:取精灵(1))
        self:置按下精灵(add:取精灵(1))
        self:置经过精灵(add:取精灵(2))
        self:置禁止精灵(add:取灰度精灵(1))
        self:置禁止(true)
        self.频率时间 = 0
    end

    function 按钮:更新()
        if 引擎:取鼠标状态() == SDL.BUTTON_LMASK and self.按下时间 and os.clock() - self.按下时间 > 0.5 and os.clock() - self.频率时间 > 0.1 then
            self.频率时间 = os.clock()
            self:左键弹起()
        end
    end

    function 按钮:左键按下()
        self.按下时间 = os.clock()
    end

    function 按钮:失去鼠标()
        self.按下时间 = nil
    end

    return 按钮
end

--===============================================================================================
local sub
function GUI控件:创建减按钮(...)
    if not sub then
        sub = __res:get('gires/0x536BB7AC.tcp')
    end
    local 按钮 = self:创建按钮(...)
    function 按钮:初始化()
        self:置提示('#Y按住shift每次减10点, 长按自动加点')
        self:置正常精灵(sub:取精灵(1))
        self:置按下精灵(sub:取精灵(1))
        self:置经过精灵(sub:取精灵(2))
        self:置禁止精灵(sub:取灰度精灵(1))
        self:置禁止(true)
        self.频率时间 = 0
    end

    function 按钮:更新()
        if 引擎:取鼠标状态() == SDL.BUTTON_LMASK and self.按下时间 and os.clock() - self.按下时间 > 0.5 and os.clock() - self.频率时间 > 0.1 then
            self.频率时间 = os.clock()
            self:左键弹起()
        end
    end

    function 按钮:左键按下()
        self.按下时间 = os.clock()
    end

    function 按钮:失去鼠标()
        self.按下时间 = nil
    end

    return 按钮
end

--===============================================================================================
function GUI控件:创建物品网格(...)
    local high_light_frame = __res:getspr('gires2/dialog/high_light_frame.tcp')
    local selectframe = __res:getspr('gires2/dialog/selectframe.tcp')
    local 网格 = self:创建网格(...)
    网格.当前页 = 1
    function 网格:初始化()
        self:创建格子(50, 50, 1, 1, 4, 6)
        self.数据 = _物品[1]
        self.记录格子 = 0
    end

    function 网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 网格:子前显示(x, y, i)
        if self.当前选中 == i then
            selectframe:显示(x, y)
        end
        if self.获得焦点 == i then
            high_light_frame:显示(x, y)
        end
        if self.前显示2 then
            self:前显示2(x, y, i)
        end
    end

    function 网格:获得鼠标(x, y, i)
        if self.记录格子 ~= i then
            self:清空请求(self.记录格子)
        end
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            self.获得焦点 = i
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存.
                if not self.数据[i].已请求 then
                    local r = __rpc:取物品描述(self.数据[i].nid)
                    if r and self.数据[i] then
                        self.数据[i].刷新显示 = true
                        self.数据[i].属性 = r
                        self:物品提示(x + 50, y + 50, self.数据[i])
                        self.数据[i].已请求 = true
                    end
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x, y, self.数据[i])
            end
        end
        self.记录格子 = i
    end

    function 网格:清空请求(i)
        if self.数据 and self.数据[i] then
            self.数据[i].已请求 = nil
        end
    end

    function 网格:失去鼠标(x, y, i)
        self.获得焦点 = false
    end

    function 网格:清空()
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end
        self.当前选中 = nil
    end

    function 网格:添加(i, v)
        if type(v) == 'table' then
            v.B = self.数据 --删除用
            v.i = i --物品所在位置
            v.I = (self.当前页 - 1) * 24 + i --物品所在服务器位置
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    function 网格:置页面(i)
        self.当前页 = i
        self.数据 = _物品[i]
    end

    function 网格:置选中(i)
        if self.数据[i] and self.数据[i].战斗是否可用 then
            self.当前选中 = i
            self.选中位置 = (self.当前页 - 1) * 24 + i
        end
    end

    function 网格:刷新单个道具(p) --todo
        self.数据[i] = nil
    end

    function 网格:管理取刷新道具(p, nid)
        网格:置页面(p)
        local list = __rpc:角色_物品列表管理(p, nid)
        --网格:清空()
        if type(list) == 'table' then
            for i, v in pairs(list) do
                if not self.数据[i] or self.数据[i].nid ~= v.nid and v.类别 ~= 6 then
                    v.来源 = '物品'
                    网格:添加(i, v)
                    self.数据[i]:刷新(v)
                else
                    self.数据[i]:刷新(v)
                end
            end
            for i, v in pairs(self.数据) do
                if not list[i] then
                    self.数据[i] = nil
                end
            end
        else
            网格:清空()
            return 1
        end
    end

    function 网格:刷新道具(p,nid)
        网格:置页面(p)
        local list = __rpc:角色_物品列表(p,nil,nid)
        --网格:清空()
        self.当前选中 = nil
        if type(list) == 'table' then
            for i, v in pairs(list) do
                if not self.数据[i] or self.数据[i].nid ~= v.nid then
                    v.来源 = '物品'
                    网格:添加(i, v)
                else
                    self.数据[i]:刷新(v)
                end
            end
            for i, v in pairs(self.数据) do
                if not list[i] then
                    self.数据[i] = nil
                end
            end
        end
    end

    网格:注册事件(
        网格,
        {
            左键按下 = function(_, x, y, i) --按下偏移
                if 网格.数据[i] then
                    网格[i]:置中心(-1, -1)
                    if gge.platform == 'Windows' then
                        网格:物品提示()
                    end
                end
            end,
            左键弹起 = function(_, x, y, i)
                if 网格.数据[i] then
                    网格[i]:置中心(0, 0)
                    网格:置选中(i)
                end
            end
        }
    )
    return 网格
end

function GUI控件:创建物品网格2(name, x, y, w, h) --这个创建右边有切换按钮
    local high_light_frame = __res:getspr('gires2/dialog/high_light_frame.tcp')
    local selectframe = __res:getspr('gires2/dialog/selectframe.tcp')
    local 网格 = self:创建网格(name, x, y, w, h)
    do
        function 网格:子显示(x, y, i)
            if self.数据[i] then
                self.数据[i]:显示(x, y)
            end
        end

        function 网格:子前显示(x, y, i)
            if self.当前选中 == i then
                selectframe:显示(x, y)
            end
            if self.获得焦点 == i then
                high_light_frame:显示(x, y)
            end
            if self.前显示2 then
                self:前显示2(x, y, i)
            end
        end

        function 网格:获得鼠标(x, y, i)
            if not 鼠标层.附加 and self.数据 and self.数据[i] then
                self.获得焦点 = i
                if self.数据[i].nid then
                    self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存
                    local r = __rpc:取物品描述(self.数据[i].nid)
                    if self.数据[i] and r then
                        self.数据[i].刷新显示 = true
                        self.数据[i].属性 = r
                        self:物品提示(x + 50, y + 50, self.数据[i])
                    end
                elseif self.数据[i].名称 then --本地
                    self:物品提示(x, y, self.数据[i])
                end
            end
        end

        function 网格:失去鼠标(x, y, i)
            self.获得焦点 = false
        end

        function 网格:清空()
            for k, v in pairs(self.数据) do
                self.数据[k] = nil
            end
        end

        function 网格:添加(i, v)
            if type(v) == 'table' then
                v.B = self.数据 --删除用
                v.i = i --物品所在位置
                v.I = (self.当前页 - 1) * 24 + i --物品所在服务器位置
                if ggetype(v) == '物品' then
                    self.数据[i] = v
                else
                    self.数据[i] = require('界面/数据/物品')(v)
                end
                return self.数据[i]
            end
            self.数据[i] = nil
        end

        function 网格:置页面(i)
            self.当前页 = i
            self.数据 = _物品[i]
            self.当前选中 = nil
            self.选中位置 = 0
        end

        function 网格:置选中(i)
            if self.数据[i] then
                self.当前选中 = i
                self.选中位置 = (self.当前页 - 1) * 24 + i
            end
        end

        function 网格:获取道具(p)
            return __rpc:角色_物品列表(p)
        end

        function 网格:刷新道具(p)
            p = p or self.当前页
            self:置页面(p)
            local list = self:获取道具(p)
            if type(list) == 'table' then
                for i, v in pairs(list) do
                    if not self.数据[i] or self.数据[i].nid ~= v.nid then
                        v.来源 = '物品'
                        self:添加(i, v)
                    else
                        self.数据[i]:刷新(v)
                    end
                end
                for i, v in pairs(self.数据) do
                    if not list[i] then
                        self.数据[i] = nil
                    end
                end
            end
        end

        function 网格:获取页面数()
            return __rpc:角色_包裹数量()
        end

        function 网格:打开()
            local n = self:获取页面数()
            if n == nil then
                n = self:获取页面数() or 1
            end
            for i = 1, 4 do
                self.父控件['物品栏' .. i]:置可见(i <= n)
            end
            self.父控件.物品栏1:置选中(true)
            self:刷新道具(1)
        end

        网格:注册事件(
            网格,
            {
                初始化 = function(self)
                    self:创建格子(50, 50, 1, 1, 4, 6)
                    self.当前页 = 1
                    self.数据 = _物品[1]
                end,
                左键按下 = function(_, x, y, i) --按下偏移
                    if 网格.数据[i] then
                        网格[i]:置中心(-1, -1)
                        网格:物品提示()
                    end
                end,
                左键弹起 = function(_, x, y, i)
                    if 网格.数据[i] then
                        网格[i]:置中心(0, 0)
                        网格:置选中(i)
                    end
                end
            }
        )
    end


    for i = 1, 4 do
        local 按钮 = self:创建单选按钮('物品栏' .. i, x + 308, y + i * 52 - 52)
        function 按钮:初始化()
            self:设置按钮精灵2('gires/0xC3622E6B.tcp')
        end

        function 按钮:选中事件(v)
            if v then
                网格:刷新道具(i)
            end
        end
    end
    self.物品栏1:置选中(true)

    return 网格
end

function GUI控件:创建物品网格3(name, x, y, w, h) --这个创建右边有切换按钮
    local high_light_frame = __res:getspr('gires2/dialog/high_light_frame.tcp')
    local selectframe = __res:getspr('gires2/dialog/selectframe.tcp')
    local 网格 = self:创建网格(name, x, y, w, h)
    网格.当前页 = 1

    -- function 网格:初始化()
    --     self:创建格子(50, 50, 1, 1, 4, 6)
    --     self.数据 = {}
    -- end

    function 网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 网格:子前显示(x, y, i)
        if self.当前选中 == i then
            selectframe:显示(x, y)
        end
        if self.获得焦点 == i then
            high_light_frame:显示(x, y)
        end
        if self.前显示2 then
            self:前显示2(x, y, i)
        end
    end

    function 网格:获得鼠标(x, y, i)
            if not 鼠标层.附加 and self.数据 and self.数据[i] then
                self.获得焦点 = i
                if self.数据[i].nid then
                    self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存
                    local r = __rpc:取物品描述(self.数据[i].nid)
                    if self.数据[i] and r then
                        self.数据[i].刷新显示 = true
                        self.数据[i].属性 = r
                        self:物品提示(x + 50, y + 50, self.数据[i])
                    end
                elseif self.数据[i].名称 then --本地
                    self:物品提示(x, y, self.数据[i])
                end
            end
        end

    function 网格:失去鼠标(x, y, i)
        self.获得焦点 = false
    end

    function 网格:清空()
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end
    end

    function 网格:添加(i, v)
        if type(v) == 'table' then
            v.B = self.数据 --删除用
            v.i = i --物品所在位置
            v.I = (self.当前页 - 1) * 24 + i --物品所在服务器位置
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    function 网格:置页面(i)
        self.当前页 = i
        self.数据 = _物品[i]
    end

    function 网格:置选中(i)
        if self.数据[i] and self.数据[i].战斗是否可用 then
            self.当前选中 = i
            self.选中位置 = (self.当前页 - 1) * 24 + i
        end
    end

    function 网格:刷新道具(p)
        -- 网格:置页面(p)
        local list = __rpc:角色_物品列表1(p)
        --网格:清空()
        if type(list) == 'table' then
            for i, v in pairs(list) do
                if not self.数据[i] or self.数据[i].nid ~= v.nid then
                    v.来源 = '物品'
                    网格:添加(i, v)
                else
                    self.数据[i]:刷新(v)
                end
            end
            for i, v in pairs(self.数据) do
                if not list[i] then
                    self.数据[i] = nil
                end
            end
        end
    end

    网格:注册事件(
            网格,
            {
                初始化 = function(self)
                    self:创建格子(45, 45, 3, 3, 3, 6)
                    -- self.当前页 = 1
                    self.数据 = {}
                end,
                左键按下 = function(_, x, y, i) --按下偏移
                    if 网格.数据[i] then
                        网格[i]:置中心(-1, -1)
                        网格:物品提示()
                    end
                end,
                左键弹起 = function(_, x, y, i)
                    if 网格.数据[i] then
                        网格[i]:置中心(0, 0)
                        网格:置选中(i)
                    end
                end
            }
        )
    return 网格
end


function GUI控件:创建管理物品网格(...)
    local high_light_frame = __res:getspr('gires2/dialog/high_light_frame.tcp')
    local selectframe = __res:getspr('gires2/dialog/selectframe.tcp')
    local 网格 = self:创建网格(...)
    网格.当前页 = 1
    function 网格:初始化()
        self:创建格子(50, 50, 1, 1, 4, 6)
        self.数据 = _物品[1]
        self.记录格子 = 0
    end

    function 网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 网格:子前显示(x, y, i)
        if self.当前选中 == i then
            selectframe:显示(x, y)
        end
        if self.获得焦点 == i then
            high_light_frame:显示(x, y)
        end
        if self.前显示2 then
            self:前显示2(x, y, i)
        end
    end

    function 网格:获得鼠标(x, y, i)
        if self.记录格子 ~= i then
            self:清空请求(self.记录格子)
        end
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            self.获得焦点 = i
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存.
                if not self.数据[i].已请求 then
                    local r = __rpc:取物品描述(self.数据[i].nid)
                    if r and self.数据[i] then
                        self.数据[i].刷新显示 = true
                        self.数据[i].属性 = r
                        self:物品提示(x + 50, y + 50, self.数据[i])
                        self.数据[i].已请求 = true
                    end
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x, y, self.数据[i])
            end
        end
        self.记录格子 = i
    end

    function 网格:清空请求(i)
        if self.数据 and self.数据[i] then
            self.数据[i].已请求 = nil
        end
    end

    function 网格:失去鼠标(x, y, i)
        self.获得焦点 = false
    end

    function 网格:清空()
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end
        self.当前选中 = nil
    end

    function 网格:添加(i, v)
        if type(v) == 'table' then
            v.B = self.数据 --删除用
            v.i = i --物品所在位置
            v.I = (self.当前页 - 1) * 24 + i --物品所在服务器位置
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    function 网格:置页面(i)
        self.当前页 = i
        self.数据 = _物品[i]
    end

    function 网格:置选中(i)
        if self.数据[i] and self.数据[i].战斗是否可用 then
            self.当前选中 = i
            self.选中位置 = (self.当前页 - 1) * 24 + i
        end
    end

    function 网格:刷新单个道具(p) --todo
        self.数据[i] = nil
    end

    function 网格:管理取刷新道具(p, nid)
        网格:置页面(p)
        local list = __rpc:角色_物品列表管理(p, nid)
        --网格:清空()
        if type(list) == 'table' then
            for i, v in pairs(list) do
                if not self.数据[i] or self.数据[i].nid ~= v.nid and v.类别 ~= 6 then
                    v.来源 = '物品'
                    网格:添加(i, v)
                    self.数据[i]:刷新(v)
                else
                    self.数据[i]:刷新(v)
                end
            end
            for i, v in pairs(self.数据) do
                if not list[i] then
                    self.数据[i] = nil
                end
            end
        else
            网格:清空()
            return 1
        end
    end

    function 网格:刷新道具(p,nid)
        网格:置页面(p)
        local list = __rpc:角色_物品列表(p,nil,nid)
        --网格:清空()
        self.当前选中 = nil
        if type(list) == 'table' then
            for i, v in pairs(list) do
                if not self.数据[i] or self.数据[i].nid ~= v.nid then
                    v.来源 = '物品'
                    网格:添加(i, v)
                else
                    self.数据[i]:刷新(v)
                end
            end
            for i, v in pairs(self.数据) do
                if not list[i] then
                    self.数据[i] = nil
                end
            end
        end
    end

    网格:注册事件(
        网格,
        {
            左键按下 = function(_, x, y, i) --按下偏移
                if 网格.数据[i] then
                    网格[i]:置中心(-1, -1)
                    if gge.platform == 'Windows' then
                        网格:物品提示()
                    end
                end
            end,
            左键弹起 = function(_, x, y, i)
                if 网格.数据[i] then
                    网格[i]:置中心(0, 0)
                    网格:置选中(i)
                end
            end
        }
    )
    return 网格
end


function GUI控件:创建商店网格(...)
    local high_light_frame = __res:getspr('gires2/dialog/high_light_frame.tcp')
    local selectframe = __res:getspr('gires2/dialog/selectframe.tcp')
    local 网格 = self:创建网格(...)

    function 网格:初始化()
        self:创建格子(50, 50, 1, 1, 4, 6)
        self.数据 = {}
    end

    function 网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 网格:子前显示(x, y, i)
        if self.当前选中 == i then
            selectframe:显示(x, y)
        end
        if self.获得焦点 == i then
            high_light_frame:显示(x, y)
        end
        if self.前显示2 then
            self:前显示2(x, y, i)
        end
    end

    function 网格:获得鼠标(x, y, i)
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            self.获得焦点 = i
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存.
                local r = __rpc:取物品描述(self.数据[i].nid)
                if r and self.数据[i] then
                    self.数据[i].刷新显示 = true
                    self.数据[i].属性 = r
                    self:物品提示(x + 50, y + 50, self.数据[i])
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x + 50, y + 50, self.数据[i])
            end
        end
    end

    function 网格:失去鼠标(x, y, i)
        self.获得焦点 = false
    end

    function 网格:清空()
        self.当前选中 = nil
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end
    end

    function 网格:添加(i, v)
        if type(v) == 'table' then
            v.i = i --物品所在位置
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    function 网格:置选中(i)
        if self.数据[i] then
            self.当前选中 = i
        end
    end

    网格:注册事件(
        网格,
        {
            左键按下 = function(_, x, y, i) --按下偏移
                if 网格.数据[i] then
                    网格[i]:置中心(-1, -1)
                    if gge.platform == 'Windows' then
                        网格:物品提示()
                    end
                end
            end,
            左键弹起 = function(_, x, y, i)
                if 网格.数据[i] then
                    网格[i]:置中心(0, 0)
                    网格:置选中(i)
                end
            end
        }
    )
    return 网格
end

function GUI控件:创建购买网格(name, x, y, w, h)
    local high_light_frame = __res:getspr('gires2/dialog/high_light_frame.tcp')
    local selectframe = __res:getspr('gires2/dialog/selectframe.tcp')
    local 网格 = self:创建网格(name, x, y, w, h)
    local maxPage = 8

    function 网格:初始化()
        self:创建格子(50, 50, 1, 1, 4, 6)
        self.数据 = {}
        self.page = 1
        self.totalPage = 1
        self.list = {}
    end

    function 网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 网格:子前显示(x, y, i)
        if self.当前选中 == i then
            selectframe:显示(x, y)
        end
        if self.获得焦点 == i then
            high_light_frame:显示(x, y)
        end
        if self.前显示2 then
            self:前显示2(x, y, i)
        end
    end

    function 网格:获得鼠标(x, y, i)
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            self.获得焦点 = i
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存.
                local r = __rpc:取物品描述(self.数据[i].nid)
                if r and self.数据[i] then
                    self.数据[i].刷新显示 = true
                    self.数据[i].属性 = r
                    self:物品提示(x + 50, y + 50, self.数据[i])
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x + 50, y + 50, self.数据[i])
            end
        end
    end

    function 网格:失去鼠标(x, y, i)
        self.获得焦点 = false
    end

    function 网格:清空()
        self.page = 1
        self.totalPage = 1
        self.当前选中 = nil
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end

        for k, v in pairs(self.list) do
            self.list[k] = nil
        end
    end

    function 网格:添加数据(t)
        if type(t) == 'table' then
            local num = 1
            local maxKey = 1
            self.page = 1

            -- 1 1-24
            -- 2 25-48
            -- 3 49-72
            -- 4 73-96
            -- 5 97-120
            -- 6 121-144
            -- 7 145-168
            -- 8 169-192
            for k, v in pairs(t) do
                v.index = k
                if k > maxKey then
                    maxKey = k
                end
            end

            if maxKey > 25 and maxKey < 49 then
                num = 2
            elseif maxKey > 49 and maxKey < 73 then
                num = 3
            elseif maxKey > 73 and maxKey < 97 then
                num = 4
            elseif maxKey > 97 and maxKey < 121 then
                num = 5
            elseif maxKey > 121 and maxKey < 145 then
                num = 6
            elseif maxKey > 148 and maxKey < 169 then
                num = 7
            elseif maxKey > 169 then
                num = 8
            end

            self.totalPage = num
            self.list = t

            for i = 1, maxPage do
                self.父控件['商店分页' .. i]:置可见(i <= self.totalPage)
            end

            if self.totalPage == 1 then
                self.父控件.商店分页1:置可见(false)
            else
                self.父控件.商店分页1:置选中(true)
            end

            self:刷新道具(1)
        end
    end

    function 网格:添加(i, v)
        if type(v) == 'table' then
            v.i = i --物品所在位置
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    function 网格:置选中(i)
        if self.数据[i] then
            self.当前选中 = i
            self.选中位置 = self.数据[i].index
        end
    end

    function 网格:置页面(i)
        self.当前页 = i
        self.当前选中 = nil
        self.选中位置 = 0
    end

    function 网格:获取道具(page)
        local startIndex = (page - 1) * 24 + 1
        local endIndex = page * 24
        local list = {}
        if self.list then
            for i = startIndex, endIndex, 1 do
                table.insert(list, self.list[i])
            end

            return list
        end
    end

    function 网格:刷新道具(p)
        p = p or self.当前页
        self:置页面(p)
        local list = self:获取道具(p)

        if type(list) == 'table' then
            for i, v in pairs(list) do
                if not self.数据[i] or self.数据[i].名称 ~= v.名称 then
                    v.来源 = '物品'
                    self:添加(i, v)
                else
                    self.数据[i]:刷新(v)
                end
            end
            for i, v in pairs(self.数据) do
                if not list[i] then
                    self.数据[i] = nil
                end
            end
        end
    end

    网格:注册事件(
        网格,
        {
            左键按下 = function(_, x, y, i) -- 按下偏移
                if 网格.数据[i] then
                    网格[i]:置中心(-1, -1)
                    if gge.platform == 'Windows' then
                        网格:物品提示()
                    end
                end
            end,
            左键弹起 = function(_, x, y, i)
                if 网格.数据[i] then
                    网格[i]:置中心(0, 0)
                    网格:置选中(i)
                end
            end
        }
    )

    for i = 1, maxPage do
        local 按钮 = self:创建单选按钮('商店分页' .. i, x + i * 36 - 36, y - 21)
        function 按钮:初始化()
            __res.F13:置颜色(255, 255, 255)
            local t = __res.F13:取图像(i)
            t:置中心(-(28 - t.宽度) // 2, -(16 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 1, 28, 16, t))

            t:置中心(-(28 - t.宽度) // 2 - 1, -(16 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 2, 28, 16, t):置中心(-1, -1))

            t:置中心(-(28 - t.宽度) // 2, -(16 - t.高度) // 2)
            self:置选中正常精灵(self:取拉伸精灵_宽高帧('gires4/jdmh/yjan/xbq.tcp', 2, 28, 16, t):置中心(0, 0))
        end

        function 按钮:选中事件(v)
            if v then
                网格:刷新道具(i)
            end
        end
    end

    self.商店分页1:置选中(true)

    return 网格
end

function GUI控件:创建玉符网格(...)
    local 网格 = self:创建网格(...)
    local zts = __res.F14:置颜色(255, 255, 255, 255)
    function 网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
            
            if self.数据[i].数量 ==1 then
                zts:置颜色(255, 255, 255, 255):取描边精灵(1, 0, 0, 0):显示(x,y)
            end
        elseif self.背景[i] then
            self.背景[i]:显示(x, y)
        end
    end

    function 网格:获得鼠标(x, y, i)
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存.
                local r = __rpc:取物品描述(self.数据[i].nid)
                if r and self.数据[i] then
                    self.数据[i].刷新显示 = true
                    self.数据[i].属性 = r
                    self:物品提示(x + 50, y + 50, self.数据[i])
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x, y, self.数据[i])
            end
        end
    end

    function 网格:清空()
        self.数据 = {}
    end

    function 网格:置背景(i, v)
        self.背景[i] = v
    end

    function 网格:添加(i, v)
        if type(v) == 'table' then
            v.i = i -- 物品所在位置
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    网格:注册事件(
        网格,
        {
            初始化 = function(_, x, y, i)
                网格.数据 = {}
                网格.背景 = {}
            end,
            左键按下 = function(_, x, y, i) --按下偏移
                if 网格.数据[i] then
                    网格[i]:置中心(-1, -1)
                    网格:物品提示()
                end
            end,
            左键弹起 = function(_, x, y, i)
                if 网格.数据[i] then
                    网格[i]:置中心(0, 0)
                end
            end
        }
    )
    return 网格
end

function GUI控件:创建提交网格(...)
    local 网格 = self:创建网格(...)

    function 网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        elseif self.背景[i] then
            self.背景[i]:显示(x, y)
        end
    end

    function 网格:获得鼠标(x, y, i)
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) -- 先显示缓存.
                local r = __rpc:取物品描述(self.数据[i].nid)
                if r and self.数据[i] then
                    self.数据[i].刷新显示 = true
                    self.数据[i].属性 = r
                    self:物品提示(x + 50, y + 50, self.数据[i])
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x, y, self.数据[i])
            end
        end
    end

    function 网格:清空()
        self.数据 = {}
    end

    function 网格:置背景(i, v)
        self.背景[i] = v
    end

    function 网格:添加(i, v)
        if type(v) == 'table' then
            v.i = i --物品所在位置
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    网格:注册事件(
        网格,
        {
            初始化 = function(_, x, y, i)
                网格.数据 = {}
                网格.背景 = {}
            end,
            左键按下 = function(_, x, y, i) -- 按下偏移
                if 网格.数据[i] then
                    网格[i]:置中心(-1, -1)
                    网格:物品提示()
                end
            end,
            左键弹起 = function(_, x, y, i)
                if 网格.数据[i] then
                    网格[i]:置中心(0, 0)
                end
            end
        }
    )
    return 网格
end

function GUI控件:创建技能网格(...)
    local 网格 = self:创建网格(...)
    function 网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 网格:获得鼠标(x, y, i)
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            if self.数据[i].名称 then --本地
                self:物品提示(x, y, self.数据[i])
            end
        end
    end

    function 网格:清空()
        self.数据 = {}

    end

    function 网格:置背景(i, v)
        self.背景[i] = v
    end
    function 网格:置选中(i)
        if self.数据[i] and self.数据[i].战斗是否可用 then
            self.当前选中 = i
            self.选中位置 = (self.当前页 - 1) * 8 + i
        end
    end
    function 网格:添加(i, v)---
        if type(v) == 'table' then
            v.i = i --物品所在位置
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] =   生成精灵(
                    48,
                    48,
                    function()
                        __res:getsf('magic/icon/9999.png'):置拉伸(48, 48):显示(0, 0)
                        if v.图标 then
                            __res:getsf('magic/icon/%04d.png', v.图标):置拉伸(44, 44):显示(2, 2)
                        end
                    end
                )
                
                -- local 道行,升级道行 = '',''
                -- if v.道行 then
                --     道行 = v.道行[1]..'年'..v.道行[2]..'天'..v.道行[3]..'时'
                -- end
                -- if v.升级道行 then
                --     升级道行 = v.升级道行[1]..'年'..v.升级道行[2]..'天'..v.升级道行[3]..'时'
                -- end
                -- self.数据[i].属性 = '#Y等级：'..v.等级..'级#r#Y灵气：'..v.灵气..'/'..v.灵气上限..'#r#Y道行：'..道行..'#r#Y升级道行：'..升级道行..'#r#Y'..v.技能
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    网格:注册事件(
        网格,
        {
            初始化 = function (_, x, y, i)
                网格.数据 = {}
                网格.背景 = {}
            end,
            左键按下 = function (_, x, y, i) --按下偏移
                if 网格.数据[i] then
                    网格[i]:置中心(-1, -1)
                   网格:物品提示()
                end
            end,
            左键弹起 = function (_, x, y, i)
                if 网格.数据[i] then
                    网格[i]:置中心(0, 0)
                end
            end,
            获得鼠标 = function (_, x, y, i)
                鼠标层:手指形状()
            end

        }
    )
    return 网格
end


--===============================================================================================
local 弹出右键 = GUI:创建弹出控件('弹出右键')
do
    local 列表 = 弹出右键:创建列表('右键列表', 5, 5, 90, 90)
    function 列表:初始化()
        列表:取文字():置颜色(255, 255, 255, 255)
        列表.焦点精灵:置颜色(88, 92, 232, 200)
        列表.选中精灵 = nil
        列表.行间距 = 3
    end

    function 列表:左键弹起()
        弹出右键:置可见(false)
        coroutine.xpcall(self.co, self:取文本(self.选中行))
    end

    function GUI控件:弹出右键(list)
        if 弹出右键.是否可见 then
            return
        end
        列表:清空()
        列表.co = coroutine.running()
        local w = 80
        for _, v in ipairs(list) do
            local r = 列表:添加(v)
            if r:取精灵().宽度 > 80 then
                w = r:取精灵().宽度
            end
        end
        弹出右键:置精灵(self:取拉伸精灵_宽高('gires4/jdmh/yjan/tmk2.tcp', w + 10,
            #list * 18 + 7), true)
        列表:置宽高(w, 弹出右键.高度 - 10)

        local x, y = 引擎:取鼠标坐标()
        弹出右键:置坐标(x, y)
        弹出右键:置可见(true)
        return coroutine.yield()
    end
end

function GUI控件:创建抗性长按钮(name, x, y, txt)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        __res.JMZ:置颜色(187, 165, 75)
        do
            local t = __res.JMZ:取图像(txt)
            t:置中心(-(289 - t.宽度) // 2, -(24 - t.高度) // 2)
            self:置正常精灵(self:取拉伸精灵_宽高('ui/btl.png', 289, 23, t))

            t:置中心(-(289 - t.宽度) // 2 - 1, -(24 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽高('ui/btl.png', 289, 23, t))

            t:置中心(-(289 - t.宽度) // 2, -(24 - t.高度) // 2)
            self:置经过精灵(self:取拉伸精灵_宽高('ui/btl.png', 289, 23, t))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

function GUI控件:创建抗性长按钮1(name, x, y, txt)
    local 按钮 = self:创建按钮(name, x, y)
    function 按钮:初始化()
        __res.JMZ:置颜色(187, 165, 75)
        do
            local t = __res.JMZ:取图像(txt)
            t:置中心(-(319 - t.宽度) // 2, -(24 - t.高度) // 2)
            --感觉是缺这个 素材
            self:置正常精灵(self:取拉伸精灵_宽高('ui/btl.png', 319, 23, t))

            t:置中心(-(319 - t.宽度) // 2 - 1, -(24 - t.高度) // 2 - 1)
            self:置按下精灵(self:取拉伸精灵_宽高('ui/btl.png', 319, 23, t))

            t:置中心(-(319 - t.宽度) // 2, -(24 - t.高度) // 2)
            self:置经过精灵(self:取拉伸精灵_宽高('ui/btl.png', 319, 23, t))
        end
    end

    按钮:注册事件(
        按钮,
        {
            获得鼠标 = function(_, x, y)
                鼠标层:手指形状()
            end
        }
    )
    return 按钮
end

--================================经典红木===============================================================

do
    local function loadgui(file)
        local r = gge.require(file, setmetatable({}, { __index = _ENV }))
        package.loaded[file] = r or file
        if not r then
            --   print('loadgui', file)
        end
    end

    -- local function loadgui(file)
    --     local env = setmetatable({}, {
    --         __index = function(t, k)
    --             local v = _G[k]
    --             if v ~= nil then
    --                 return v
    --             end
    --             return _ENV[k]
    --         end,
    --         __newindex = function(t, k, v)
    --             if k:sub(1, 1) == '_' then
    --                 _ENV[k] = v
    --             elseif k:sub(1, 2) == '__' then
    --                 _G[k] = v
    --             end
    --             rawset(t, k, v)
    --         end
    --     })
    --     local r = gge.require(file, env)
    --     --package.loaded[file] = r or file
    -- end

    loadgui('界面/鼠标/提示') --因为 置提示要在登录层之前，所以优先加载
    loadgui('界面/鼠标/物品')
    loadgui('界面/鼠标/物品查看')
    loadgui('界面/鼠标/召唤兽查看')

    loadgui('界面/地图层')
    loadgui('辅助/精灵_摊名')

    loadgui('对象/基类/状态')
    loadgui('对象/主角')
    -- loadgui('对象/召唤')
    loadgui('对象/怪物')
    loadgui('对象/玩家')
    loadgui('对象/跳转')
    loadgui('对象/NPC')
    loadgui('对象/物品')

    loadgui('战斗/基类/状态')
    loadgui('战斗/基类/数据')
    loadgui('战斗/对象')
    -- loadgui('地图')

    loadgui('界面/战场层')
    --===========================================
    -- 3种族 巨古老登录界面
    loadgui('界面/登录层')

    if __几种族 == 3 or __几种族 == 3.1 then
        loadgui('界面/登录/旧登录/角色创建')
        loadgui('界面/登录/旧登录/游戏开始')
        loadgui('界面/登录/旧登录/系统公告')
        loadgui('界面/登录/旧登录/选择区服')
        loadgui('界面/登录/旧登录/游戏登录')
        loadgui('界面/登录/旧登录/角色选择')
        loadgui('界面/登录/旧登录/账号注册')
        loadgui('界面/登录/旧登录/修改密码')
    else
        loadgui('界面/登录/旧登录4种族/角色创建')
        loadgui('界面/登录/旧登录4种族/游戏开始')
        loadgui('界面/登录/旧登录4种族/系统公告')
        loadgui('界面/登录/旧登录4种族/选择区服')
        loadgui('界面/登录/旧登录4种族/游戏登录')
        loadgui('界面/登录/旧登录4种族/角色选择')
        loadgui('界面/登录/旧登录4种族/账号注册')
        loadgui('界面/登录/旧登录4种族/修改密码')
    end
    --===========================================
    loadgui('界面/界面层')
    loadgui('界面/界面/信息栏')
    loadgui('界面/界面/状态栏')
    loadgui('界面/界面/聊天栏')
    loadgui('界面/界面/按钮栏')
    loadgui('界面/界面/队伍栏')
    loadgui('界面/界面/公告栏')
    loadgui('界面/界面/任务栏')
    --===========================================
    loadgui('界面/窗口层')
    -----------------------------------------------
    loadgui('界面/窗口/人物/属性')
    loadgui('界面/窗口/人物/抗性')
    loadgui('界面/窗口/人物/称谓')
    loadgui('界面/窗口/人物/七十二变')
    loadgui('界面/窗口/人物/技能')
    loadgui('界面/窗口/作坊/保留炼化')
    loadgui('界面/窗口/作坊/普通炼化')

    loadgui('界面/窗口/作坊/作坊')
    loadgui('界面/窗口/作坊/炼化装备')
    loadgui('界面/窗口/作坊/炼器')
    if __几种族 == 3.1 or __几种族 == 4.1 then
        loadgui('界面/窗口/作坊/炼化佩饰')
    end
    loadgui('界面/窗口/召唤/属性')
    loadgui('界面/窗口/召唤/物品')
    loadgui('界面/窗口/召唤/抗性')
    loadgui('界面/窗口/召唤/炼妖')
    loadgui('界面/窗口/召唤/驯养')
    loadgui('界面/窗口/召唤/内丹栏')
    loadgui('界面/窗口/召唤/技能')
    loadgui('界面/窗口/召唤/支援列表')
    loadgui('界面/窗口/道具/拆分')

    loadgui('界面/窗口/孩子/属性')
    loadgui('界面/窗口/孩子/天资')

    loadgui('界面/窗口/商城/多宝商城')
    loadgui('界面/窗口/商城/确定购买')
    loadgui('界面/窗口/商城/变身卡商店')
    loadgui('界面/窗口/好友/界面_好友')
    loadgui('界面/窗口/界面/界面_攻略')
    loadgui('界面/窗口/好友/界面_好友_好友属性')
    loadgui('界面/窗口/好友/界面_好友_回复窗口')
    loadgui('界面/窗口/好友/界面_好友_历史信息')
    loadgui('界面/窗口/好友/界面_好友_聊天窗口')
    loadgui('界面/窗口/好友/界面_好友_在线查询')

    loadgui('界面/窗口/帮派/界面_帮派_帮派现状')
    loadgui('界面/窗口/帮派/界面_帮派_帮派响应')
    loadgui('界面/窗口/帮派/界面_帮派_帮派创建')
    loadgui('界面/窗口/帮派/界面_帮派_帮派任命')
    loadgui('界面/窗口/帮派/界面_帮派_帮派管理')
    loadgui('界面/窗口/帮派/界面_帮派_加入帮派')

    loadgui('界面/窗口/界面/提示窗口')
    loadgui('界面/窗口/界面/确认窗口')
    loadgui('界面/窗口/界面/确认数据窗口')
    loadgui('界面/窗口/界面/输入窗口')
    loadgui('界面/窗口/界面/灯谜窗口')
    loadgui('界面/窗口/界面/界面_排行榜')
    loadgui('界面/窗口/界面/界面_表情')
    loadgui('界面/队伍格子')
    loadgui('界面/窗口/界面/界面_队伍_申请加入')
    -- loadgui('界面/窗口/界面/界面_队伍_快速加入')
    loadgui('界面/窗口/界面/界面_队伍')
    loadgui('界面/窗口/界面/界面_宠物')
    loadgui('界面/窗口/界面/界面_神兵预览')
    loadgui('界面/窗口/界面/界面_宠物驯养')
    loadgui('界面/窗口/界面/界面_法宝')
    loadgui('界面/窗口/界面/界面_交易')
    loadgui('界面/窗口/界面/界面_给予')
    loadgui('界面/窗口/界面/界面_聊天记录')
    loadgui('界面/窗口/界面/界面_寄售')
    loadgui('界面/窗口/界面/界面_寄售管理')
    loadgui('界面/窗口/界面/界面_任务')
    loadgui('界面/窗口/界面/界面_世界地图')
    loadgui('界面/窗口/界面/界面_系统')
    loadgui('界面/窗口/界面/界面_小地图')
    loadgui('界面/窗口/界面/界面_选择频道')
    loadgui('界面/窗口/界面/界面_坐骑')
    loadgui('界面/窗口/界面/界面_坐骑_技能')
    loadgui('界面/窗口/界面/界面_伙伴')
    loadgui('界面/窗口/界面/界面_助战')
    loadgui('界面/窗口/npc/宠物领养')
    loadgui('界面/窗口/npc/取款')
    loadgui('界面/窗口/npc/押注')
    loadgui('界面/窗口/npc/对话')
    if __几种族 == 3 or __几种族 == 3.1 then
        loadgui('界面/窗口/npc/转种族')
        loadgui('界面/窗口/npc/转生窗口')
        loadgui('界面/窗口/npc/飞升窗口')
        loadgui('界面/窗口/npc/转生重选')
        loadgui('界面/窗口/npc/飞升重选')
    else
        loadgui('界面/四种族窗口/npc/转种族')
        loadgui('界面/四种族窗口/npc/转生窗口')
        loadgui('界面/四种族窗口/npc/飞升窗口')
        loadgui('界面/四种族窗口/npc/转生重选')
        loadgui('界面/四种族窗口/npc/飞升重选')
    end
    if __几种族 == 3 or __几种族 == 4 then
        loadgui('界面/窗口/道具/道具')
    else
        loadgui('界面/四种族窗口/道具/道具')
    end
    loadgui('界面/窗口/npc/作坊总管')
    loadgui('界面/窗口/npc/灌输灵气')
    loadgui('界面/窗口/npc/仙器升级')
    loadgui('界面/窗口/npc/仙器炼化')
    loadgui('界面/窗口/npc/物品兑换')
    loadgui('界面/窗口/npc/仙器重铸')
    loadgui('界面/窗口/npc/神兵升级')
    loadgui('界面/窗口/npc/神兵强化')
    loadgui('界面/窗口/npc/神兵炼化')
    loadgui('界面/窗口/npc/神兵精炼')
    loadgui('界面/窗口/npc/装备打造')
    loadgui('界面/窗口/npc/装备镶嵌')
    loadgui('界面/窗口/npc/装备镶嵌高级')
    loadgui('界面/窗口/npc/香火')
    loadgui('界面/窗口/npc/还愿')
    -- loadgui('界面/窗口/npc/赎回')
    loadgui('界面/窗口/npc/当铺')
    loadgui('界面/窗口/npc/卖出')
    loadgui('界面/窗口/npc/购买')
    -- loadgui('界面/窗口/npc/寄售')
    loadgui('界面/窗口/npc/召唤兽寄存')
    loadgui('界面/窗口/npc/炼妖石合成')
    loadgui('界面/窗口/npc/宝石合成')
    loadgui('界面/窗口/npc/宝石鉴定')
    loadgui('界面/窗口/npc/宝石重铸')
    loadgui('界面/窗口/npc/宝石摘除')
    loadgui('界面/窗口/战斗/战斗_人物菜单')
    loadgui('界面/窗口/战斗/战斗_召唤菜单')
    loadgui('界面/窗口/战斗/战斗_召唤界面')
    loadgui('界面/窗口/战斗/战斗_法术界面')
    loadgui('界面/窗口/战斗/战斗_自动窗口')

    loadgui('界面/窗口/摆摊/摆摊盘点')
    loadgui('界面/窗口/摆摊/查看购买')

    loadgui('界面/窗口/界面/界面_月卡')

    loadgui('界面/窗口/管理/管理_1')
    loadgui('界面/窗口/管理/账号管理')
    loadgui('界面/窗口/管理/角色管理')
    loadgui('界面/窗口/管理/道具管理')
    loadgui('界面/窗口/管理/装备管理')
    loadgui('界面/窗口/管理/召唤管理')
    loadgui('界面/窗口/管理/服务器管理')

    
    loadgui('界面/窗口/帮战/帮战信息显示')
    loadgui('界面/窗口/帮战/帮战战况')
    ------------------------------------------------------
    loadgui('界面/鼠标层')
    loadgui('界面/鼠标/坐标提示')
    loadgui('界面/鼠标/技能提示')
end
登录层:置可见(true)
登录层:切换界面(登录层.游戏开始)
