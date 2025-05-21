
local 普通炼化窗口 = 窗口层:创建我的窗口('普通炼化窗口', 0, 0, 256, 325)
_跳过动画 = false
function 普通炼化窗口:初始化()
    self:置精灵(__res:getspr('ui/ptlh.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 普通炼化窗口:显示(x, y)
end

普通炼化窗口:创建关闭按钮()



local 原属性列表 = 普通炼化窗口:创建多列列表('原属性列表', 28, 79, 197, 192)
local _sxd = __res:getspr('ui/zhk.png')
function 原属性列表:初始化()
    self.行高度 = 33
    self.选中精灵 = nil
    self.焦点精灵 = nil
    self:取文字():置大小(20)
    self:添加列(10, 7, 124, 20) --类型
    self:添加列(147, 7, 43, 20) --数值
end

function 原属性列表:添加属性(k, v)
    local r = self:添加("#G" .. k, "#G" .. v)
    r.显示 = function(_, x, y)
        _sxd:显示(x, y)
    end


end

local 再次炼化按钮 = 普通炼化窗口:创建按钮('再次炼化按钮', 168, 33)

function 再次炼化按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx531.png', '再次炼化'))
    self:置按下精灵(取按钮精灵2('ui/xx533.png', '再次炼化', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx532.png', '再次炼化'))
end

function 再次炼化按钮:左键弹起()
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

local 确定按钮 = 普通炼化窗口:创建中按钮('确定按钮', 86, 287, "确定")

function 确定按钮:左键弹起()
    self.父控件:置可见(false)
end

local 提醒文本 = 普通炼化窗口:创建文本("提醒文本", 30, 27, 130, 30)
提醒文本:置文字(__res.F13)
提醒文本:置文本("使用当前炼化材料,#r你还可以炼化0次！")

function 窗口层:刷新普通炼化窗口(t)
    if not 普通炼化窗口.是否可见 then
        窗口层:打开普通炼化窗口(t)
    else
        原属性列表:清空()
        for k, v in pairs(t) do
           -- if type(v) == "table" then
                原属性列表:添加属性(k, v)
           -- end

        end
    end
end

function 窗口层:关闭普通炼化窗口()
    普通炼化窗口:置可见(false)
end

function 窗口层:打开普通炼化窗口(来源, t)
    普通炼化窗口:置可见(not 普通炼化窗口.是否可见)
    if not 普通炼化窗口.是否可见 then
        return
    end
    原属性列表:清空()
    for k, v in pairs(t) do
       -- if type(v) == "table" then
            原属性列表:添加属性(k, v)
       -- end

    end
    _来源 = 来源

end

-- 窗口层:打开普通炼化窗口()
return 普通炼化窗口
