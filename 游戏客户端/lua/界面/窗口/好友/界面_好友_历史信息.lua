

local 历史消息 = 窗口层:创建我的窗口('历史消息', 0, 0, 437, 425)

function 历史消息:初始化()
    self:置精灵(__res:getspr('gires/0xDA0999BE.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 历史消息:显示(x, y)
end

历史消息:创建关闭按钮(0, 1)

local 聊天列表 = 历史消息:创建列表('聊天列表', 21, 40, 394, 362)
do
    function 聊天列表:初始化()
        self.选中精灵 = nil
        self.焦点精灵 = nil
        self.行间距 = 2
        self.记录 = {






        }

    end

    function 聊天列表:聊天添加(t)
        local r = self:添加(t):置精灵()

        local 文本 = r:创建我的文本('文本', 0, 0, self.宽度, 500)

        local _, h = 文本:置文本(t)
        文本:置高度(h)
        r:置高度(h)
        r:置可见(true, true)
    end
end

local 列表上按钮 = 历史消息:创建按钮('列表上按钮', 377, 383)
function 列表上按钮:初始化()
    self:设置按钮精灵('gires/0x287AF2DA.tcp')
end

function 列表上按钮:左键弹起()
    历史消息.聊天列表:向上滚动()
    历史消息.聊天列表:自动滚动(false)
end

local 列表下按钮 = 历史消息:创建按钮('列表下按钮', 397, 383)
function 列表下按钮:初始化()
    self:设置按钮精灵('gires/0x03539D9C.tcp')
end

function 列表下按钮:左键弹起()
    if not 历史消息.聊天列表:向下滚动() then
        历史消息.聊天列表:自动滚动(true)
    end
end

function 窗口层:好友_添加聊天记录(name,nid, t)
    if not __好友聊天记录[nid] then
        __好友聊天记录[nid] = {}
    end
    table.insert(__好友聊天记录[nid], { 名称 = name, time = t.time, txt = t.txt })
end

function 窗口层:打开历史消息(nid)
    历史消息:置可见(not 历史消息.是否可见)
    if not 历史消息.是否可见 then
        return
    end
    聊天列表:清空()
    if nid then
        if not __好友聊天记录[nid] then
            __好友聊天记录[nid] = {}
        end
        for i, v in ipairs(__好友聊天记录[nid]) do
            聊天列表:聊天添加(string.format("#R%s  %s #r#W%s", os.date('%Y-%m-%d %X', v.time), v.名称, v.txt))
        end
    end












end

return 历史消息
