-- @Author              : GGELUA
-- @Date                : 2022-03-07 18:52:00
-- @Last Modified by    : baidwwy
-- @Last Modified time  : 2023-01-08 11:04:32

local SDL = require 'SDL'
local GUI = class('GUI')
package.loaded.GUI = GUI
local GUI控件 = require 'GUI.控件'
require 'GUI.输入'
require 'GUI.按钮'
require 'GUI.窗口'
require 'GUI.文本'
require 'GUI.网格'
require 'GUI.列表'
require 'GUI.标签'
require 'GUI.滑块'
require 'GUI.进度'
require 'GUI.组合'

local function _注册事件(self, 窗口)
    窗口:注册事件(
        self,
        {
            -- 更新事件 = function(_, dt, x, y)
            --     self:_更新(dt, x, y)
            -- end,
            键盘事件 = function(...)
                if not self._msg.键盘 then
                    self._msg.键盘 = {}
                end
                table.insert(self._msg.键盘, select(select('#', ...), ...))
            end,
            输入事件 = function(...)
                if not self._msg.输入 then
                    self._msg.输入 = {}
                end
                table.insert(self._msg.输入, select(select('#', ...), ...))
            end,
            输入法事件 = function(...)
                if not self._msg.输入法 then
                    self._msg.输入法 = {}
                end
                table.insert(self._msg.输入法, select(select('#', ...), ...))
            end,
            鼠标事件 = function(...)
                if not self._msg.鼠标 then
                    self._msg.鼠标 = {}
                end
                table.insert(self._msg.鼠标, select(select('#', ...), ...))
            end,
            用户事件 = function(...)
                if not self._msg.用户 then
                    self._msg.用户 = {}
                end
                table.insert(self._msg.用户, select(select('#', ...), ...))
            end
            -- 窗口事件 = function(...)
            --     table.insert(self._msg.窗口, select(select('#', ...), ...))
            -- end
        }
    )
end

function GUI:初始化(窗口, 文字)
    self._文字= 文字 and 文字:置颜色(255, 255, 255, 255)
    self._win   = 窗口
    self._界面= {}
    self._root  = self
    self._popup = {}
    self._tip   = {}
    self._modal = {}
    self._msg   = {}
    if 窗口 then
        _注册事件(self, 窗口)
    end
end

function GUI:更新(dt, x, y)
    if self._鼠标 and self._鼠标.消息事件 then
        self._鼠标:消息事件(self._msg)
    end

    if #self._tip > 0 then --提示
        if self._msg.鼠标 then
            for i, v in ipairs(self._msg.鼠标) do
                if v.type == SDL.MOUSE_MOTION then --鼠标移动时清空
                    self._tip = {}
                    break
                end
            end
        end

        for _, v in ipairs(self._tip) do
            v:_更新(dt, x, y)
        end
    end

    if #self._popup > 0 then --弹出
        if self._msg.鼠标 and #self._popup > 0 then
            local pop = self._popup[#self._popup]
            for i, v in ipairs(self._msg.鼠标) do
                if v.type == SDL.MOUSE_UP then --非碰撞按下时关闭
                    if not pop:检查点(v.x, v.y) and pop.自动关闭 ~= false then
                        v.x = -9999
                        v.y = -9999
                        pop:置可见(false)
                        break
                    end
                end
            end
        end

        for i, v in ipairs(self._popup) do
            if not v.是否可见 then
                table.remove(self._popup, i)
                break
            end
        end
        --控件更新会截获鼠标消息，所以放在系统后面
        for i = #self._popup, 1, -1 do
            local v = self._popup[i]
            v:_更新(dt, x, y)
            v:_消息事件(self._msg)
        end
    end

    if #self._modal > 0 then --模态
        for i = #self._modal, 1, -1 do
            local v = self._modal[i]
            v:_更新(dt, x, y)
            v:_消息事件(self._msg)
            self:清空消息()
        end

        for i, v in ipairs(self._modal) do
            if not v.是否可见 then
                table.remove(self._modal, i)
                break
            end
        end
    end

    if next(self._msg) then
        --从最后显示的控件开始发消息
        for i = #self._界面, 1, -1 do
            local v = self._界面[i]
            if v.是否可见 then
                v:_消息事件(self._msg)
            end
        end

        self._msg = {}
    end

    for _, v in ipairs(self._界面) do
        if v.是否可见 then
            v:_更新(dt, x, y)
        end
    end

    if self._鼠标 and self._鼠标.更新 then
        self._鼠标:更新(dt, x, y)
        --self._鼠标:消息事件(self._msg)
    end
end

function GUI:显示(x, y)
    for _, v in ipairs(self._界面) do
        if v.是否可见 then
            if v._显示 then
                v:_显示(x, y)
            end
        end
    end

    for _, v in ipairs(self._modal) do
        v:_显示(x, y)
    end

    for _, v in ipairs(self._popup) do
        v:_显示(x, y)
    end

    if self._鼠标 and self._鼠标.显示 then
        self._鼠标:显示(x, y)
    end

    for _, v in ipairs(self._tip) do
        if v.是否可见 then
            v:_显示(x, y)
        end
    end
end

function GUI:创建模态窗口(...)
    return GUI控件.创建模态窗口(self, ...)
end

--弹出列表，弹出右键等等（当鼠标非碰撞点击时关闭，或者置可见false）
function GUI:创建弹出窗口(...)
    return GUI控件.创建弹出窗口(self, ...)
end

function GUI:创建弹出控件(...)
    return GUI控件.创建弹出控件(self, ...)
end

--鼠标停留 (当鼠标移动关闭)
function GUI:创建提示控件(...)
    return GUI控件.创建提示控件(self, ...)
end

function GUI:创建鼠标(名称)
    self._鼠标 = GUI控件('鼠标', 0, 0, self._win.宽度, self._win.高度, self)
    self[名称] = self._鼠标
    return self._鼠标
end

function GUI:创建界面(名称, x, y, w, h)
    assert(not self[名称], 名称 .. '：已存在')
    self[名称] = GUI控件(名称, x or 0, y or 0, w or self._win.宽度, h or self._win.高度, self)
    table.insert(self._界面, self[名称])
    return self[名称]
end

function GUI:重新初始化(名称, ...)
    local 控件 = self[名称]
    if 控件 then
        控件:重新初始化(...)
    end
end

function GUI:释放界面(名称)
    local 控件 = self[名称]
    if 控件 then
        控件:释放()
        for i, v in ipairs(self._界面) do
            if v == 控件 then
                table.remove(self._界面, i)
                break
            end
        end
        --释放引用(控件)
        self[名称] = nil
    end
end

function GUI:释放引用(v)
    --释放require
    for k, v1 in pairs(package.loaded) do
        if v == v1 then
            package.loaded[k] = nil
            break
        end
    end

    --释放全局
    for k, v1 in pairs(_G) do
        if v == v1 then
            _G[k] = nil
            break
        end
    end
end

--模态
function GUI:清空消息()
    if self._msg.鼠标 then
        local t = self._msg.鼠标
        for _, v in ipairs(t) do
            v.x = -9999
            v.y = -9999
        end
        self._msg = { 鼠标 = t }
    else
        self._msg = {}
    end
end

function GUI:取输入焦点()
    return self._输入焦点
end

function GUI:置默认输入(v)
    self._defipt = v
end

function GUI:取默认输入()
    return self._defipt
end

function GUI:置渲染窗口(v)
    self._win = v
end

function GUI:置事件窗口(v)
    self._win:取消注册事件(self)
    _注册事件(self, v)
end

return GUI
