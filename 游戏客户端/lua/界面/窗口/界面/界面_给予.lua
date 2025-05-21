

local 给予 = 窗口层:创建我的窗口('给予', 0, 0, 341, 384)
function 给予:初始化()
    self:置精灵(__res:getspr('gires/0x00BDB963.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

给予:创建关闭按钮(0, 1)

local 数量输入 = 给予:创建数字输入('数量输入', 139, 272, 139, 15)
数量输入:置颜色(255, 255, 255, 255)

local 道具网格 = 给予:创建物品网格2('道具网格', 16, 43, 309, 207)
do
    function 道具网格:左键弹起(x, y, i)
        local t = self.数据[i]
        if t then
            数量输入.最大值 = t.数量
            if t ~= self.上次选中 then
                self.上次选中 = t
                数量输入:置文本('1')
            elseif 数量输入:取数值() < t.数量 then
                数量输入:置文本(数量输入:取数值() + 1)
            end
        end
    end

    function 道具网格:右键弹起(x, y, i)
        if self.数据[i] then
            数量输入:置文本(self.数据[i].数量)
        end
    end
end

local 银两输入 = 给予:创建数字输入('银两输入', 139, 306, 139, 15)
银两输入:置颜色(255, 255, 255, 255)

local 对象文本 = 给予:创建文本('对象文本', 20, 340, 300, 20)

local 给予按钮 = 给予:创建小按钮('给予按钮', 147, 340, '给予')
function 给予按钮:左键弹起()
    if _P then
        给予:置可见(false)

        local list = {}
        if 道具网格.选中位置 ~= 0 and 数量输入:取数值() > 0 then
            table.insert(list, { 道具网格.选中位置, 数量输入:取数值() })
        end
        -- local r = __rpc:角色_给予(_P.nid, 银两输入:取数值(), list)-
        local 台词, 外形, 结束 = __rpc:角色_给予(_P.nid, 银两输入:取数值(), list)
        窗口层.对话.是否结束 = 结束
        if _P and _P.是否NPC and type(台词) == 'string' then
            窗口层:给予对话(_P.nid, 外形 or _P.外形, 台词)
        end
    end
end

function 窗口层:打开给予(P)
    给予:置可见(not 给予.是否可见)
    if not 给予.是否可见 then
        return
    end
    if P.是否NPC then
        对象文本:置文本('#GNPC:  #Y%s', P.名称)
    else
        对象文本:置文本('#R玩家:  #Y%s', P.名称)
    end
    _P = P
    银两输入:置文本("")
    道具网格:打开()
end

function RPC:被动给予(nid, 台词, 外形, 结束)
    窗口层.对话.是否结束 = 结束
    if type(台词) == 'string' then
        窗口层:给予对话(nid, 外形, 台词)
    end
end

function RPC:打开给予(nid)
    local P = __map:取对象(nid)
    if P then
        窗口层:打开给予(P)
    end
end

return 给予
