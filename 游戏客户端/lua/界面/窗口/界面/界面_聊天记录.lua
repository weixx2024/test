

local 聊天记录 = 窗口层:创建我的窗口('聊天记录', 0, 0, 437, 425)
do
    function 聊天记录:初始化()
        self:置精灵(__res:getspr('gires/0x010D181E.tcp'))
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    end

    聊天记录:创建关闭按钮(0, 1)
end

local 聊天列表 = 聊天记录:创建列表('聊天列表', 21, 40, 372, 333)
do
    function 聊天列表:初始化()
        self.选中精灵 = nil
        self.焦点精灵 = nil
        self.行间距 = 2
    end

    function 聊天列表:聊天添加(t)
        local r = self:添加(t):置精灵()

        local 文本 = r:创建我的文本('文本', 0, 0, self.宽度, 500)
        文本.获得回调 = 聊天列表.文本获得回调
        文本.回调左键弹起 = 聊天列表.文本回调左键弹起
        文本.回调右键弹起 = 聊天列表.文本回调右键弹起
        local _, h = 文本:置文本(t)
        文本:置高度(h)
        r:置高度(h)
        r:置可见(true, true)
    end
end
聊天列表:创建我的滑块()

for i, v in ipairs { "队伍", "当前", "帮派", "夫妻", "世界", "系统", "私聊", "经济", "游侠" } do
    local 按钮 = 聊天记录:创建小按钮(v .. '按钮', 10 + i * 46 - 46, 388, v)
    function 按钮:左键弹起()
        聊天列表:清空()
        if 内容表[v] then
            for _, v in ipairs(内容表[v]) do
                聊天列表:聊天添加(v)
            end
        end
    end
end

function 窗口层:打开聊天记录(主聊天)
    聊天记录:置可见(not 聊天记录.是否可见)
    if not 聊天记录.是否可见 then
        return
    end
    聊天列表.文本获得回调 = 主聊天.文本获得回调
    聊天列表.文本回调左键弹起 = 主聊天.文本回调左键弹起
    聊天列表.文本回调右键弹起 = 主聊天.文本回调右键弹起
    内容表 = { 游侠 = {}, 队伍 = {}, 当前 = {}, 帮派 = {}, 夫妻 = {}, 世界 = {}, GM = {}, 系统 = {},
        私聊 = {}, 经济 = {} }

    聊天列表:清空()
    for _, v in 主聊天:遍历项目文本() do
        local pd = tonumber(v:sub(2, 3))
        if pd == 64 then
            table.insert(内容表.游侠, v)
        elseif pd == 65 then
            table.insert(内容表.队伍, v)
        elseif pd == 66 then
            table.insert(内容表.当前, v)
        elseif pd == 67 then
            table.insert(内容表.帮派, v)
        elseif pd == 68 then
            table.insert(内容表.夫妻, v)
        elseif pd == 69 then
            table.insert(内容表.世界, v)
        elseif pd == 70 then
            table.insert(内容表.GM, v)
        else
            table.insert(内容表.系统, v)
        end
        聊天列表:聊天添加(v)
    end
end

return 聊天记录
