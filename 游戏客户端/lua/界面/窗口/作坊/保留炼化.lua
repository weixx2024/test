local 保留炼化窗口 = 窗口层:创建我的窗口('保留炼化窗口', 0, 0, 465, 325)
local _重复=false
function 保留炼化窗口:初始化()
    self:置精灵(__res:getspr('ui/ballianh.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 保留炼化窗口:显示(x, y)
end

保留炼化窗口:创建关闭按钮()



local 原属性列表 = 保留炼化窗口:创建多列列表('原属性列表', 28, 79, 197, 192)
local _sxd = __res:getspr('ui/zhk.png')
function 原属性列表:初始化()
    self.行高度 = 33
    self.选中精灵 = nil
    self.焦点精灵 = nil
    self:取文字():置大小(20)
    self:添加列(10, 7, 124, 20) --类型
    self:添加列(147, 7, 43, 20) --数值


    local t = {
        抗雷 = 20,
        抗水 = 20,
        抗风 = 20,
        强力克水 = 20,
        忽视抗混 = 20,
    }

    for k, v in pairs(t) do
        self:添加属性(k, v)
    end

end

function 原属性列表:添加属性(k, v)
    local r = self:添加(k, v)
    r.显示 = function(_, x, y)
        _sxd:显示(x, y)
    end


end

local 新属性列表 = 保留炼化窗口:创建多列列表('新属性列表', 237, 79, 197, 192)
function 新属性列表:初始化()
    self.行高度 = 33
    self.选中精灵 = nil
    self.焦点精灵 = nil
    self:取文字():置大小(20)
    self:添加列(10, 7, 124, 20) --类型
    self:添加列(147, 7, 43, 20) --数值
    local t = {
        抗雷 = 20,
        抗水 = 20,
        抗风 = 20,
        强力克水 = 20,
        忽视抗混 = 20,
    }

    for k, v in pairs(t) do
        self:添加属性(k, v)
    end
end

function 新属性列表:添加属性(k, v)
    local r = self:添加("#G" .. k, "#G" .. v) --:置颜色(r, g, b, a)
    r.显示 = function(_, x, y)
        _sxd:显示(x, y)
    end


end

local 再次炼化按钮 = 保留炼化窗口:创建按钮('再次炼化按钮', 352, 33)

function 再次炼化按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx531.png', '再次炼化'))
    self:置按下精灵(取按钮精灵2('ui/xx533.png', '再次炼化', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx532.png', '再次炼化'))
end

function 再次炼化按钮:左键弹起()

    local r = true
    if _重复 then
        r=窗口层:确认窗口('检查当前属性较好，确定再次%s么？',_来源) 
    end
    if not r then
        return 
    end

    if _来源 == "炼化" then
        窗口层:作坊再次炼化()
    elseif _来源 == "炼器" then
        窗口层:作坊再次炼器()
    elseif _来源 == "仙器炼化" then
        窗口层:再次仙器炼化()
    elseif _来源 == "神兵精炼" then
        窗口层:再次神兵精炼()
    end
end

local 保留按钮 = 保留炼化窗口:创建中按钮('保留按钮', 74, 286, "保留原属性")

function 保留按钮:左键弹起()
    self.父控件:置可见(false)
end

local 替换按钮 = 保留炼化窗口:创建中按钮('替换按钮', 294, 286, "替换新属性")

function 替换按钮:左键弹起()
    local r
    if _来源 == "炼化" then
        r = __rpc:角色_装备炼化属性替换()
    elseif _来源 == "炼器" then
        r = __rpc:角色_装备炼器属性替换()
    elseif _来源 == "仙器炼化" then
        r = __rpc:角色_仙器炼化属性替换()
    elseif _来源 == "神兵精炼" then
        r = __rpc:角色_神兵精炼属性替换()
    end

    if r then
        原属性列表:清空()
        for k, v in pairs(r) do
            if type(v) == "table" then
            原属性列表:添加属性("#G" .. v[1], "#G" .. v[2])
            end
        end
        窗口层:提示窗口("#Y新属性替换成功")
    end
end

local 提醒文本 = 保留炼化窗口:创建文本("提醒文本", 55, 35, 298, 14)
提醒文本:置文字(__res.F13)
提醒文本:置文本("使用当前炼化材料,你还可以炼化0次！")


function 窗口层:关闭保留炼化窗口()
    保留炼化窗口:置可见(false)
end

function 窗口层:打开保留炼化窗口(来源, t, r)
    保留炼化窗口:置可见(not 保留炼化窗口.是否可见)
    if not 保留炼化窗口.是否可见 then
        return
    end
    原属性列表:清空()
    for k, v in pairs(t) do
        if type(v) == "table" then
            原属性列表:添加属性(v[1], v[2])
        end

    end

    新属性列表:清空()
    for k, v in pairs(r) do
        if k~="重复" then
            新属性列表:添加属性(k, v)
        else
            _重复=v
        end
        
    end
    _来源 = 来源

end

--窗口层:打开保留炼化窗口()
return 保留炼化窗口
