local 购买 = 窗口层:创建我的窗口('购买', 0, 0, 341, 435)
function 购买:初始化()
    self:置精灵(__res:getspr('gires/0x4843852C.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

购买:创建关闭按钮(0, 1)

local 价格 = 购买:创建文本("价格", 140, 272, 140, 16)
local 数量 = 购买:创建数字输入('数量', 140, 298, 140, 16)
数量:置颜色(255, 255, 255, 255)
local 总额 = 购买:创建文本("总额", 140, 326, 140, 16)
local 现金 = 购买:创建文本("现金", 140, 353, 140, 16)

local 网格 = 购买:创建购买网格('网格', 17, 45, 305, 203) --你有没有商店 超过4页的 超过4页就报错
function 网格:左键弹起(x, y, i)
    if self.数据[i] then
        if self.数据[i] ~= self.上次选中 then
            self.上次选中 = self.数据[i]
            数量:置文本('1')
            价格:置文本(self.数据[i].价格)
            总额:置文本(self.数据[i].价格)
        else
            数量:置文本(数量:取数值() + 1)
            总额:置文本(数量:取数值() * self.数据[i].价格)
        end
    end
end

local 购买按钮 = 购买:创建小按钮('购买按钮', 165, 390, '购买')
function 购买按钮:左键弹起()
    if 网格.选中位置 and co then
        购买:置可见(false)
        coroutine.resume(co, 网格.选中位置, 数量:取数值())
    end
end

function 窗口层:打开购买(sj, list)
    购买:置可见(true)
    网格.选中位置 = nil
    网格:清空()
    网格:添加数据(list)
    数量:置文本('')
    价格:置文本('')
    总额:置文本('')
    现金:置文本(银两颜色(sj))
    co = coroutine.running()
    return coroutine.yield()
end

function RPC:购买窗口(...)
    return 窗口层:打开购买(...)
end

return 购买
