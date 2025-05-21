

local 帮派创建 = 窗口层:创建我的窗口('帮派创建', 0, 0, 534, 124)
function 帮派创建:初始化()
    self:置精灵(__res:getspr('gires/0x489E50BB.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 帮派创建:显示(x, y)
end

function 帮派创建:可见事件(v)
    if v == false and co then
        coroutine.resume(co)
    end
end

--帮派创建:创建关闭按钮(0, 1)


local 名称输入 = 帮派创建:创建文本输入('名称输入', 89, 35, 220, 15)
名称输入:置颜色(255, 255, 255, 255)

local 宗旨输入 = 帮派创建:创建文本输入('宗旨输入', 88, 75, 412, 15)
宗旨输入:置颜色(255, 255, 255, 255)
宗旨输入:置限制字数(30)
local 创建按钮 = 帮派创建:创建中按钮('_创建按钮', 325, 30, '创  建')

function 创建按钮:左键弹起()
    local mc = 名称输入:取文本()
    local zz = 宗旨输入:取文本()
    if zz == "" then
        zz = "帮主很懒，什么也没写"
    end
    if mc == "" then
        窗口层:提示窗口("#Y请输入帮派名称")
        return
    elseif require("数据/敏感词库")(mc, 1) then
        窗口层:提示窗口("#Y你的帮派名称包含敏感词汇！")
        return
    elseif require("数据/敏感词库")(zz, 1) then
        窗口层:提示窗口("#Y你的帮派宗旨包含敏感词汇！")
        return
    end
    if co then
        coroutine.resume(co, mc, zz)
        self.父控件:置可见(false)
    end
end

local 取消按钮 = 帮派创建:创建中按钮('取消按钮', 419, 30, '取  消')

function 取消按钮:左键弹起()
    self.父控件:置可见(false)
end

function 窗口层:打开帮派创建()
    帮派创建:置可见(not 帮派创建.是否可见)
    if not 帮派创建.是否可见 then
        return
    end
end

function RPC:创建帮派窗口()
    co = coroutine.running()
    窗口层:打开帮派创建()
    return coroutine.yield()
end

return 帮派创建
