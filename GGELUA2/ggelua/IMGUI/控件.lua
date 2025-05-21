-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-03-07 18:52:00
-- @Last Modified time  : 2022-12-15 02:20:46


local im = require 'gimgui'
local IM控件 = class('IM控件')
IM控件.是否可见 = true
IM控件.x = 0
IM控件.y = 0

function IM控件:初始化(name, x, y, w, h)
    self.名称 = name and tostring(name) or nil
    self.x = x
    self.y = y
    self.宽度 = w
    self.高度 = h

    self._子控件 = {}
    if x == 0 and y == 0 then
        self.x = nil
        self.y = nil
    end
end

function IM控件:_更新(...)
    for _, v in ipairs(self._子控件) do
        if v.是否可见 then
            if v.是否禁止 then
                im.BeginDisabled(true)
            end
            if rawget(v, 'x') and rawget(v, 'y') then
                if not v.是否窗口 then
                    im.SetCursorPos(v.x, v.y)
                end
            end
            v:_更新(...)
            if v.是否禁止 then
                im.EndDisabled()
            end
        end
    end
    for i, v in ipairs(self._子控件) do
        if not v.是否可见 and v._temp then
            table.remove(self._子控件, i)
            break
        end
    end
end

function IM控件:调用()
    self:_更新()
end

function IM控件:_检查鼠标()
    if im.IsItemHovered() then
        if self._tip then
            im.SetTooltip(self._tip)
        end
        self.是否鼠标焦点 = true
        self:发送消息('焦点事件', true)
    elseif self.是否鼠标焦点 then
        self.是否鼠标焦点 = false
        self:发送消息('焦点事件', false)
    end
    if self.是否鼠标焦点 and im.IsMouseDown() then
        self:发送消息('左键按下')
    end
    if self.是否鼠标焦点 and im.IsMouseReleased() then
        self:发送消息('左键弹起')
    end
    if im.IsMouseClicked() then
        self:发送消息('左键点击')
    end

    if im.IsItemClicked() then
        if ggetype(self) ~= 'IM按钮' then
            self:发送消息('左键单击')
        end
        if im.IsMouseDoubleClicked() then
            self:发送消息('左键双击')
        end
    end
    if im.IsItemClicked(1) then
        self:发送消息('右键单击')
        if im.IsMouseDoubleClicked(1) then
            self:发送消息('右键双击')
        end
    end
    --GetMouseClickedCount 取点击次数
    --IsAnyMouseDown 鼠标按下
    --GetMousePos 取鼠标坐标

    if im.IsItemActive() then
        if im.IsMouseDragging() then
            self:发送消息('左键拖动', im.GetMouseDragDelta())
        end
        if im.IsMouseDragging(1) then
            self:发送消息('右键拖动', im.GetMouseDragDelta())
        end
    end
end

function IM控件:置可见(val, sub)
    if val and self.是否实例 and self.是否禁止 then
        return self
    end
    if self._lock then
        self.是否可见 = val == true
        return
    end
    self._lock = true
    if self:发送消息('可见事件', val) == false then
        return self
    end
    self.是否可见 = val == true

    if not self.是否实例 and val then
        if rawget(self, '初始化') then
            ggexpcall(self.初始化, self)
        end
        self.是否实例 = true
    end
    if sub then
        for _, v in ipairs(self._子控件) do
            if v.置可见 then
                v:置可见(val, sub)
            end
        end
    end
    self._lock = nil
    return self
end

function IM控件:置禁止(v)
    self.是否禁止 = v == true
    return self
end

function IM控件:取坐标()
    if rawget(self, 'x') then
        return self.x, self.y
    end
    return im.GetCursorPos()
end

function IM控件:置坐标(x, y)
    self.x = x
    self.y = y
    return self
end

function IM控件:隐藏名称()
    self._name = '##' .. tostring(self)
    return self
end

function IM控件:发送消息(name, ...)
    local fun = rawget(self, name)
    if type(fun) == 'function' then
        return coroutine.xpcall(fun, self, ...)
    end
end

do
    local _分隔线 = {
        是否可见 = true,
        _更新 = function()
            im.Separator()
        end
    }
    function IM控件:分隔线()
        table.insert(self._子控件, _分隔线)
        return self
    end
end

do
    local _同行 = {
        是否可见 = true,
        _更新 = function()
            im.SameLine()
        end
    }
    function IM控件:同行()
        table.insert(self._子控件, _同行)
        return self
    end
end
--NewLine
--Spacing 间距
--Dummy 空白
--Indent 缩进
--Unindent取消缩进
do
    local _对齐 = {
        是否可见 = true,
        _更新 = function()
            im.AlignTextToFramePadding()
        end
    }
    function IM控件:对齐()
        table.insert(self._子控件, _对齐)
        return self
    end
end

do
    local _文本 = {
        是否可见 = true,
        _更新 = function(self)
            im.TextWrapped(self._txt)
        end
    }
    function IM控件:文本(v, ...)
        if select('#', ...) > 0 then
            v = string.format(v, ...)
        end
        table.insert(self._子控件, setmetatable({ _txt = v }, { __index = _文本 }))
        return self
    end
end

function IM控件:置提示(v)
    self._tip = v
end

function IM控件:创建控件(name, ...)
    assert(self[name] == nil, name .. '->已经存在')
    self[name] = IM控件(name, ...)
    table.insert(self._子控件, self[name])
    return self[name]
end

function IM控件:删除控件(name)
    for i, v in ipairs(self._子控件) do
        if v == self[name] then
            table.remove(self._子控件, i)
            self[name] = nil
            return true
        end
    end
end

function IM控件:清空控件()
    for i, v in ipairs(self._子控件) do
        if v.名称 then
            self[v.名称] = nil
        end
    end
    self._子控件 = {}
end
IM控件.清空 = IM控件.清空控件
--==============================================================================
local IM选项 = class('IM选项', IM控件)
do
    function IM选项:初始化()
        self._flag = 2 | 4
        self.是否选中 = false
    end

    function IM选项:_更新()
        if im.Selectable(self.名称, self.是否选中, self._flag) then
            self:发送消息('选中事件', self.是否选中)
            if im.IsMouseDoubleClicked() then --ImGuiMouseButton_Left flag = 4
                self:发送消息('左键双击')
            end
        end
        IM控件._更新(self)
    end

    function IM选项:置选中(b)
        self.是否选中 = b == true
    end
end
--==============================================================================
function IM控件:创建选项(name, ...)
    assert(self[name] == nil, name .. '->已经存在')
    self[name] = IM选项(name, ...)
    table.insert(self._子控件, self[name])
    return self[name]
end

return IM控件
