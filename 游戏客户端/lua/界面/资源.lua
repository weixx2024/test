local GUI控件 = require('GUI.控件')
local _ENV = setmetatable({}, { __index = _G })
SDL = require 'SDL'
GUI = require '界面'
GGF = require('GGE.函数')
RPC = GUI.RPC or {}
_R = _ENV --res
地图层 = GUI.地图层
战场层 = GUI.战场层
登录层 = GUI.登录层
窗口层 = GUI.窗口层
界面层 = GUI.界面层
鼠标层 = GUI.鼠标层
_物品 = { {}, {}, {}, {}, {} }
_性别 =
    setmetatable(
        { '男', '女' },
        {
            __index = function(t, k)
                return '?'
            end
        }
    )
_种族 =
    setmetatable(
        { '人', '魔', '仙', '鬼' },
        {
            __index = function(t, k)
                return '?'
            end
        }
    )


local 素材宽度裁剪系数 = 0.25
local 素材高度裁剪系数 = 0.25



--===============================================================================================
function 时间排序(t)
    table.sort(
        t,
        function(a, b)
            return a.获得时间 < b.获得时间
        end
    )
    return t
end

function 时间排序2(t)
    table.sort(
        t,
        function(a, b)
            return a.获得时间 > b.获得时间
        end
    )
    return t
end

function 坐骑排序(t)
    table.sort(
        t,
        function(a, b)
            return a.几座 < b.几座
        end
    )
    return t
end

function 召唤排序(t)
    table.sort(
        t,
        function(a, b)
            return a.顺序 < b.顺序
        end
    )
    return t
end

function 银两颜色(v)
    v = tostring(v)
    if #v <= 0 or tonumber(v) == nil then
        return v
    elseif #v < 5 then
        return '#W' .. GGF.格式化货币(v)
    elseif #v < 6 then
        return '#c25da77' .. GGF.格式化货币(v)
    elseif #v < 7 then
        return '#cfc45dc' .. GGF.格式化货币(v)
    elseif #v < 8 then
        return '#cfbd833' .. GGF.格式化货币(v)
    elseif #v < 9 then
        return '#c04fdf4' .. GGF.格式化货币(v)
    elseif #v < 10 then
        return '#c0afd04' .. GGF.格式化货币(v)
    else
        return '#cad1010' .. GGF.格式化货币(v)
    end
end

function 取按钮精灵(tcp, i, txt, x, y, z, r, g, b, a) --从tcp
    x = x or 0
    y = y or 0
    z = z or "F15B"
    local sf = __res:get(tcp)
    if sf == nil then
        sf = __res:get('gires/0x86D66B9A.tcp')
    end
    sf = sf:取图像(i)
    if sf:渲染开始() then
        local tsf = txt
        if type(txt) == 'string' then
            if __res[z] then
                tsf = __res[z]:置颜色((187 or r), (165 or g), (75 or b), (255 or a)):取图像(txt)
            end
        end
        if tsf then
            tsf:显示((sf.宽度 - tsf.宽度) // 2 + x, (sf.高度 - tsf.高度) // 2 + y + 1)
        end

        sf:渲染结束()
    end
    return sf:到精灵()
end

function 取按钮精灵2(file, txt, x, y) --从文件
    x = x or 0
    y = y or 0
    local sf = __res:getsf(file)
    if sf:渲染开始() then
        local tsf = txt
        if type(txt) == 'string' then
            tsf = __res.F12:置颜色(187, 165, 75, 255):取图像(txt)
        end
        tsf:显示((sf.宽度 - tsf.宽度) // 2 + x, (sf.高度 - tsf.高度) // 2 + y + 1)
        sf:渲染结束()
    end
    return sf:到精灵()
end

function 取按钮图像(tcp, i, txt, x, y)
    x = x or 0
    y = y or 0
    local sf = __res:get(tcp):取图像(i)
    if sf:渲染开始() then
        local tsf = txt
        if type(txt) == 'string' then
            tsf = __res.F15B:置颜色(187, 165, 75, 255):取图像(txt)
        end
        tsf:显示((sf.宽度 - tsf.宽度) // 2 + x, (sf.高度 - tsf.高度) // 2 + y + 1)
        sf:渲染结束()
    end
    return sf
end

function 取按钮图像2(tcp, txt, x, y)
    x = x or 0
    y = y or 0
    local sf = __res:getsf(tcp)
    if sf:渲染开始() then
        local tsf = txt
        if type(txt) == 'string' then
            tsf = __res.F12:置颜色(187, 165, 75, 255):取图像(txt)
        end
        tsf:显示((sf.宽度 - tsf.宽度) // 2 + x, (sf.高度 - tsf.高度) // 2 + y + 1)
        sf:渲染结束()
    end
    return sf
end

--===============================================================================================
function 生成精灵(w, h, fun)
    local sf = require('SDL.图像')(w, h)
    if sf:渲染开始(0, 0, 0, 0) then
        fun()
        sf:渲染结束()
    end
    return sf:到精灵()
end

--===============================================================================================
do --宽度
    function 取拉伸图像_宽度帧(file, i, sfw, fun)
        local info, sf = {}

        sf = __res:get(file):取图像(i):置中心(0, 0)

        local p = sfw > sf.宽度 and sf.宽度 or sfw
        p = math.ceil(p * 素材宽度裁剪系数)

        if p > 100 then
            p = math.floor(p / 10)
        end

        info = {
            p1 = p,
            p2 = p,
        }

        info[i] = sf

        if sfw == sf.宽度 and not fun then
            return sf
        end
        local sfh = sf.高度
        local nsf = require('SDL.图像')(sfw, sfh)

        if nsf:渲染开始(0, 0, 0, 0) then
            if sfw == sf.宽度 then
                sf:显示(0, 0)
            else
                sf:置区域(0, 0, info.p1, sfh):显示(0, 0) --左
                sf:置区域(sf.宽度 - info.p2, 0, info.p2, sfh):显示(sfw - info.p2, 0) --右
                --中
                if sfw > sf.宽度 then
                    sf:复制区域(info.p1, 0, sf.宽度 - info.p1 - info.p2, sfh):平铺(sfw - info.p1 - info.p2, sfh)
                        :显示(info.p1, 0)
                else
                    sf:置区域(info.p1, 0, sfw - info.p1 - info.p2, sfh):显示(info.p1, 0)
                end
            end

            if type(fun) == 'function' then
                fun()
            elseif fun then
                fun:显示(0, 0)
            end
            nsf:渲染结束()
        end
        return nsf
    end

    function 取拉伸图像_宽度(file, ...)
        return 取拉伸图像_宽度帧(file, 1, ...)
    end

    function 取拉伸精灵_宽度帧(...)
        return 取拉伸图像_宽度帧(...):到精灵()
    end

    function 取拉伸精灵_宽度(file, ...)
        return 取拉伸精灵_宽度帧(file, 1, ...)
    end

    function GUI控件:取拉伸图像_宽度帧(...)
        return 取拉伸图像_宽度帧(...)
    end

    function GUI控件:取拉伸图像_宽度(...)
        return 取拉伸图像_宽度(...)
    end

    function GUI控件:取拉伸精灵_宽度帧(...)
        return 取拉伸精灵_宽度帧(...)
    end

    function GUI控件:取拉伸精灵_宽度(...)
        return 取拉伸精灵_宽度(...)
    end
end
--===============================================================================================
do --高度
    function 取拉伸图像_高度帧(file, i, sfh, fun)
        local info, sf = {}

        sf = __res:get(file):取图像(i):置中心(0, 0)

        local p = sfh > sf.高度 and sf.高度 or sfh

        p = math.ceil(p * 素材高度裁剪系数)

        if p > 100 then
            p = math.floor(p / 10)
        end

        info = {
            p1 = p,
            p2 = p,
        }

        info[i] = sf

        if sfh == sf.高度 and not fun then
            return sf
        end
        local sfw = sf.宽度
        local nsf = require('SDL.图像')(sfw, sfh)

        if nsf:渲染开始(0, 0, 0, 0) then
            if sfh == sf.高度 then
                sf:显示(0, 0)
            else
                sf:置区域(0, 0, sfw, info.p1):显示(0, 0) --上
                sf:置区域(0, sf.高度 - info.p2, sfw, info.p2):显示(0, sfh - info.p2) --下

                if sfh > sf.高度 then --中
                    sf:复制区域(0, info.p1, sfw, sf.高度 - info.p1 - info.p2):平铺(sfw, sfh - info.p1 - info.p2)
                        :显示(0, info.p1)
                else
                    sf:置区域(0, info.p1, sfw, sfh - info.p1 - info.p2):显示(0, info.p1)
                end
            end

            if type(fun) == 'function' then
                fun()
            elseif fun then
                fun:显示(0, 0)
            end
            nsf:渲染结束()
        end
        return nsf
    end

    function 取拉伸图像_高度(file, ...)
        return 取拉伸图像_高度帧(file, 1, ...)
    end

    function 取拉伸精灵_高度帧(...)
        return 取拉伸图像_高度帧(...):到精灵()
    end

    function 取拉伸精灵_高度(file, ...)
        return 取拉伸精灵_高度帧(file, 1, ...)
    end

    function GUI控件:取拉伸图像_高度帧(...)
        return 取拉伸图像_高度帧(...)
    end

    function GUI控件:取拉伸图像_高度(...)
        return 取拉伸图像_高度(...)
    end

    function GUI控件:取拉伸精灵_高度帧(...)
        return 取拉伸精灵_高度帧(...)
    end

    function GUI控件:取拉伸精灵_高度(...)
        return 取拉伸精灵_高度(...)
    end
end
--===============================================================================================
do --宽高
    function 取拉伸图像_宽高帧(file, i, sfw, sfh, fun)
        local info, sf = {}

        if file:sub(-3) == 'tcp' then
            sf = __res:get(file):取图像(i):置中心(0, 0)
        else
            sf = __res:getsf(file)
        end

        local 宽度 = sfw > sf.宽度 and sf.宽度 or sfw
        local 高度 = sfh > sf.高度 and sf.高度 or sfh

        p1 = math.ceil(宽度 * 素材宽度裁剪系数)
        p2 = math.ceil(高度 * 素材高度裁剪系数)

        if p1 > 100 then
            p1 = math.floor(p1 / 10)
        end

        if p2 > 100 then
            p2 = math.floor(p2 / 10)
        end


        info = {
            p1 = p1,
            p2 = p1,
            p3 = p2,
            p4 = p2,
        }

        if file == 'smap/1001.tcp' then
            info = {
                p1 = 70,
                p2 = 70,
                p3 = 70,
                p4 = 70,
            }
        end

        info[i] = sf

        if sfw == sf.宽度 and sfh == sf.高度 and not fun then
            return sf
        end

        local nsf = require('SDL.图像')(sfw, sfh)

        if nsf:渲染开始(0, 0, 0, 0) then
            sf:置区域(0, 0, info.p1, info.p1):显示(0, 0) --1
            if sfw <= sf.宽度 then
                sf:置区域(info.p1, 0, sfw - info.p1 - info.p2, info.p1):显示(info.p1, 0) --2
            else
                sf:复制区域(info.p1, 0, sf.宽度 - info.p1 - info.p2, info.p1):平铺(sfw - info.p1 - info.p2,
                    info.p1):显示(info.p1, 0)
            end
            sf:置区域(sf.宽度 - info.p2, 0, info.p2, info.p2):显示(sfw - info.p2, 0) --3

            if sfh <= sf.高度 then
                sf:置区域(0, info.p1, info.p1, sfh - info.p1 - info.p3):显示(0, info.p1) --4
            elseif file == 'gires4/jdmh/ckdt/ptjmd.tcp' then
                sf:复制区域(0, 45, info.p1, sf.高度 - 45 - info.p3):平铺(info.p1, sfh - 45 - info.p3):显示(0,
                    45)
            else
                sf:复制区域(0, info.p1, info.p1, sf.高度 - info.p1 - info.p3):平铺(info.p1,
                    sfh - info.p1 - info.p3):显示(0, info.p1)
            end

            if sfw <= sf.宽度 and sfh <= sf.高度 then
                sf:置区域(info.p1, info.p1, sfw - info.p1 - info.p2, sfh - info.p1 - info.p3):显示(info.p1, info.p1) --5
            elseif sfh - info.p1 - info.p3 > 0 then
                sf:复制区域(info.p1, info.p1, sf.宽度 - info.p1 - info.p2, sf.高度 - info.p1 - info.p3):平铺(sfw
                    - info.p1 - info.p2, sfh - info.p1 - info.p3):显示(info.p1, info.p1)
            end

            if sfh <= sf.高度 then
                sf:置区域(sf.宽度 - info.p2, info.p2, info.p2, sfh - info.p2 - info.p4):显示(sfw - info.p2,
                    info.p2) --6
            elseif file == 'gires4/jdmh/ckdt/ptjmd.tcp' then
                sf:复制区域(sf.宽度 - info.p2, 45, info.p2, sf.高度 - 45 - info.p4):平铺(info.p2,
                    sfh - 45 - info.p4):显示(sfw - info.p2, 45)
            else
                sf:复制区域(sf.宽度 - info.p2, info.p2, info.p2, sf.高度 - info.p2 - info.p4):平铺(info.p2,
                    sfh - info.p2 - info.p4):显示(sfw - info.p2, info.p2)
            end

            sf:置区域(0, sf.高度 - info.p3, info.p3, info.p3):显示(0, sfh - info.p3) --7
            if sfw <= sf.宽度 then
                sf:置区域(info.p3, sf.高度 - info.p3, sfw - info.p3 - info.p4, sfh - info.p3):显示(info.p3,
                    sfh - info.p3) --8
            else
                sf:复制区域(info.p3, sf.高度 - info.p3, sf.宽度 - info.p3 - info.p4, info.p3):平铺(sfw -
                    info.p3 - info.p4, info.p3):显示(info.p3, sfh - info.p3)
            end

            sf:置区域(sf.宽度 - info.p4, sf.高度 - info.p4, info.p4, info.p4):显示(sfw - info.p4, sfh - info.p4) --9

            if type(fun) == 'function' then
                fun()
            elseif fun then
                fun:显示(0, 0)
            end
            nsf:渲染结束()
        end
        return nsf
    end

    function 取拉伸图像_宽高(file, ...)
        return 取拉伸图像_宽高帧(file, 1, ...)
    end

    function 取拉伸精灵_宽高帧(...)
        return 取拉伸图像_宽高帧(...):到精灵()
    end

    function 取拉伸精灵_宽高(file, ...)
        return 取拉伸精灵_宽高帧(file, 1, ...)
    end

    function GUI控件:取拉伸图像_宽高帧(...)
        return 取拉伸图像_宽高帧(...)
    end

    function GUI控件:取拉伸图像_宽高(...)
        return 取拉伸图像_宽高(...)
    end

    function GUI控件:取拉伸精灵_宽高帧(...)
        return 取拉伸精灵_宽高帧(...)
    end

    function GUI控件:取拉伸精灵_宽高(...)
        return 取拉伸精灵_宽高(...)
    end
end
--===============================================================================================
function GUI控件:取经典红木窗口(w, h, name, fun)
    local sf = require('SDL.图像')(w, h)
    if sf:渲染开始(0, 0, 0, 0) then
        __res:getsf('gires4/jdmh/ckdt/ptjmh.tcp'):置区域(0, 0, w - 6, h - 3):显示(3, 0)
        self:取拉伸图像_宽高('gires4/jdmh/ckdt/ptjmd.tcp', w, h):显示(0, 0)
        if type(name) == 'string' then
            name = __res.HYF:置颜色(187, 165, 75):取图像(name)
        end
        if name then
            name:显示(w // 2 - name.宽度 // 2, 7)
        end

        if fun then
            fun()
        end
        sf:渲染结束()
    end
    return sf:到精灵()
end

function GUI控件:取老红木窗口(w, h, name, fun)
    local sf = require('SDL.图像')(w, h)
    if sf:渲染开始(0, 0, 0, 0) then
        -- __res:getsf('gires4/jdmh/ckdt/ptjmh.tcp'):置区域(0, 0, w - 6, h - 3):显示(3, 0)
        self:取拉伸图像_宽高('ui/jiemian.png', w, h):显示(0, 0)
        if type(name) == 'string' then
            name = __res.HYF16:置颜色(247, 243, 0):取图像(name)
        end
        if name then
            name:显示(w // 2 - name.宽度 // 2, 5)
        end

        if fun then
            fun()
        end
        sf:渲染结束()
    end
    return sf:到精灵()
end

return _ENV
