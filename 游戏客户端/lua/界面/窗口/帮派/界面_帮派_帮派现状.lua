

local 帮派现状 = 窗口层:创建我的窗口('帮派现状', 0, 0, 520, 425)
function 帮派现状:初始化()
    self:置精灵(__res:getspr('gires/0x2178F59A.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 帮派现状:显示(x, y)
end

for k, v in pairs { "名称文本", "创始人文本", "成员数量文本", "战绩值文本", "财产值文本",
    "建设度文本", "等级文本", "名望值文本", "帮主文本" } do
    local 文本 = 帮派现状:创建文本(v, 107, 44 + k * 28 - 28, 96, 15)
end

帮派现状:创建文本("宗旨文本", 227, 60, 251+23, 148)
--帮派现状.宗旨文本:创建我的滑块()



local 成员列表 = 帮派现状:创建多列列表('成员列表', 227, 247, 251+23, 158)
function 成员列表:初始化()
    self.行高度 = 20
    self:添加列(0, 3, 95, 20) --名称
    self:添加列(95, 3, 58, 20) --职务
    self:置选中精灵宽度(251)

end

function 成员列表:添加成员(t)
    local r = self:添加(t.名字, t.职务)
    r.nid=t.nid
end

function 成员列表:左键弹起(x, y, i, t)
end

成员列表:创建我的滑块()



帮派现状:创建关闭按钮(0, 1)
local 帮战按钮 = 帮派现状:创建中按钮('帮战按钮', 63, 320, '帮战战报')
function 帮战按钮:左键弹起()

end

local 管理按钮 = 帮派现状:创建中按钮('管理按钮', 63, 370, '帮派管理')
function 管理按钮:左键弹起()
    窗口层:打开帮派管理()
end

local function 职务排序(t)



end

function 帮派现状:刷新现状(t)
    成员列表:清空()
    for k, v in pairs(t) do
        if type(v) ~= "table" then
            帮派现状[k .. "文本"]:置文本(v)
        end
    end
   -- 帮派现状.宗旨文本:置文本("fdsahjfkhdsjkfhjkdshfjkdshfjksdhfjkhsdjfhdjkshfjkdshfjkhdsjkfhsdk孵化基地康师傅就开始电话费加快速度孵化基地开始放假看电视")
    --  local hx = 1
    for k, v in pairs(t.核心成员) do
        成员列表:添加成员(v)
    end
end

function 窗口层:打开帮派现状(t)
    帮派现状:置可见(not 帮派现状.是否可见)
    if not 帮派现状.是否可见 then
        return
    end
    if type(t) ~= "table" then
        return
    end
    帮派现状:刷新现状(t)




end

return 帮派现状
