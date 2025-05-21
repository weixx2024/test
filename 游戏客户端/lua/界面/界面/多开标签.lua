local 多开标签 = 界面层:创建控件('多开标签控件', 0, 0, 引擎.宽度, 25)
function 多开标签:初始化()
    self:置宽高(引擎.宽度, 25)
    -- self.内容 = {}
    -- self.开关 = false
    self:置精灵(
        require('SDL.精灵')(0, 0, 0, self.宽度, 25)
        :置颜色(221, 221, 221, 255)
    )
    self.角色列表 = {}
    self.助战列表 = {}
end

local 按钮 = {}
for i = 1, 5 do
    local 多开切换标签 = 多开标签:创建单选按钮('多开标签' .. i, (i - 1) * 170, 0)
    function 多开切换标签:初始化()
        self:设置按钮精灵2('ui/1.tcp', v)
        -- self:置可见(false)
        -- self.pos = nil
    end

    function 多开切换标签:左键弹起()
        if not self.多开切换索引 then
            窗口层:提示窗口("该角色已下线或未设置")
            return
        end
        __gui.窗口层:切换助战(self.多开切换索引)
    end

    按钮[i] = 多开切换标签
end

local 下线按钮组 = {}
for i = 1, 5, 1 do
    local 下线按钮 = 多开标签:创建按钮('下线按钮' .. i, 155 + (i - 1) * 170, 6)
    function 下线按钮:初始化()
        self:设置按钮精灵('ui/3.tcp', v)
        self:置宽高(15, 15)
    end

    function 下线按钮:左键弹起()
        __rpc:角色_助战下线(self.nid)
    end

    下线按钮组[i] = 下线按钮
end

local 名称文本组 = {}
for i = 1, 5 do
    local 名称文本 = 多开标签:创建文本('名称文本' .. i, 5 + (i - 1) * 170, 6, 110, 20)
    名称文本:置文字(__res.F14)
    名称文本组[i] = 名称文本
end

local 助手召唤 = 多开标签:创建按钮('助手召唤' .. 1, 0, 0)

function 助手召唤:初始化()
    self:设置按钮精灵('ui/2.tcp', v)
end

function 助手召唤:左键弹起()
    if __rol.是否队长 then
        窗口层:打开助战()
    else
        if __rpc:角色_创建队伍() then
            __rol.是否组队 = true
            __rol:置队长(true)
            窗口层:提示窗口('#Y组队成功，你现在是队长了。')
            窗口层:打开助战()
        end
    end
end

function RPC:界面信息_多开标签(t)
    if type(t) ~= "table" then
        多开标签:置可见(false)
        return
    end
    多开标签.角色列表 = t
    多开标签.助战列表 = __rpc:助战_角色列表()

    local 多开标签索引 = {}
    for i, 角色 in ipairs(多开标签.助战列表) do
        if 角色 and 角色.nid then
            多开标签索引[角色.nid] = i
        end
    end

    local i = 1
    for k, v in pairs(t) do
        if type(v) == "table" then
            if v.名称 then
                名称文本组[i]:置文本("#K" .. v.名称 .. " - " .. "(" .. _性别[v.性别] .. _种族[v.种族] .. ")", __res.F14)
            else
                名称文本组[i]:置文本(tostring(k), __res.F14)
            end
            if 多开标签索引[v.nid] then
                v.多开切换索引 = 多开标签索引[v.nid]
            else
                v.多开切换索引 = nil
            end
            名称文本组[i]:置可见(true)
            按钮[i]:置可见(true)
            下线按钮组[i]:置可见(true)
            按钮[i].多开切换索引 = v.多开切换索引
            下线按钮组[i].nid = v.nid
            i = i + 1
            if i > 5 then
                break
            end
        end
    end

    for j = i, 5 do
        名称文本组[j]:置可见(false)
        按钮[j]:置可见(false)
        下线按钮组[j]:置可见(false)
    end
    local 助手更新后x = i - 2
    助手召唤:置坐标(172 + 170 * (助手更新后x), 4)
end

return 多开标签
