local 窗口层 = require '界面'.窗口层
local 鼠标层 = require '界面'.鼠标层
local selectframe = __res:getspr('gires2/dialog/selectframe.tcp')
local sellmark = __res:getspr('gires2/main/sellmark.tcp')

local 物品库 = require("数据/物品库")

local function 取描述(t)
    if t.描述 then
        return t.描述
    end
    if t.名称 and 物品库[t.名称] then
        return 物品库[t.名称].desc
    end
    if t.id and 物品库[t.id] then
        return 物品库[t.id].desc
    end
    return '#R' .. t.名称 .. '是个未知物品,请联系管理员！'
end

local function 取名称(t)
    if t.名称 then
        if t.名称:match('(.*)#') == "翠玉扳指" or t.名称:match('(.*)#') == "血瓷戒指" or t.名称:match('(.*)#') == "冥灵戒指"
            or t.名称:match('(.*)#') == "珊瑚瓣" or t.名称:match('(.*)#') == "黑木戒指" or t.名称:match('(.*)#') == "盘古之戒"
            or t.名称:match('(.*)#') == "灵草戒指" then
            return t.名称
        else
            return t.名称:match('(.*)#') or t.名称
        end
    end
    return '未知'
end

local function 取图标(t)
    if t.图标 then
        return t.图标
    end
    if t.名称:match('(.*)#') == "翠玉扳指" or t.名称:match('(.*)#') == "血瓷戒指" or t.名称:match('(.*)#') == "冥灵戒指"
        or t.名称:match('(.*)#') == "珊瑚瓣" or t.名称:match('(.*)#') == "黑木戒指" or t.名称:match('(.*)#') == "盘古之戒"
        or t.名称:match('(.*)#') == "灵草戒指" then
    else
        t.名称 = t.名称:match('(.*)#') or t.名称
    end

    if t.名称 and 物品库[t.名称] then
        return 物品库[t.名称].id
    end
    if t.id and 物品库[t.id] then
        return 物品库[t.id].id
    end
    -- table.print(t)
    return 15774
end

local 物品类别 = { '药物', '装备', '材料', '道具', '法宝', '任务', '道具', '道具', '道具', '道具' }
-- 待添加 高级装备 仙器 神兵

local 物品 = class('物品')
物品.数量 = 1
物品.类别 = '道具' -- 左上角
物品.来源 = '物品' -- 来源位置

function 物品:物品(t)
    self:刷新(t)
end

function 物品:刷新(t)
    if type(t.名称) ~= "string" then
        t.名称 = "错误物品"
    end
    for k, v in pairs(t) do
        self[k] = v
    end
    if t.类别 then
        self.类别 = 物品类别[t.类别] or t.类别
    end
    if not t.单价 then
        self.单价 = nil
    end
    self.id = 取图标(t)

    self.图标 = __res:getspr('item/item120/%04d.png', self.id) --:置过滤(true)--todo
    if self.图标 then
        self.图标:置过滤(true)
    end
    self.名称 = 取名称(t)
    t.名称 = self.名称
    if t.阶数 then
        self.描述 = string.gsub(取描述(t), "【阶数】%%s", "【阶数】" .. t.阶数 .. "阶")
    else
        self.描述 = 取描述(t)
    end

    if self.图标 then
        self.图标120 = self.图标:复制()
        if t.数量 and t.数量 > 1 then
            self.num = __res.F14:置颜色(255, 255, 255, 255):取描边精灵(t.数量, 0, 0, 0)
        else
            self.num = nil
        end
        if self.缩小 then
            self.图标:置拉伸(self.缩小, self.缩小, true)
        else
            self.图标:置拉伸(50, 50, true)
        end
        if __rol and __rol.是否战斗 then
            if self.条件 then
                self.战斗是否可用 = self.条件 & 1 == 1
                self.己方是否可用 = self.对象 == 12
                self.敌方是否可用 = self.对象 == 12
            end
            if not self.战斗是否可用 then
                self.图标:置颜色(100, 100, 100, 255)
            end
        end
    end
end

function 物品:显示(x, y)
    if self.up then
        selectframe:显示(x - 1, y - 1)
        return
    end
    if self.图标 then
        self.图标:显示(x, y)
    end
    if self.num then
        self.num:显示(x, y)
    end
    if self.sell or self.单价 then
        sellmark:显示(x, y)
    end
end

function 物品:显示图标(x, y)
    if self.图标 then
        self.图标:显示(x, y)
    end
end

function 物品:显示鼠标(x, y)
    if self.图标 then
        self.图标:显示(x - 25, y - 25)
    end
end

function 物品:检查点(x, y)
    if self.图标 then
        return self.图标:检查点(x, y)
    end
end

function 物品:拿起()
    self.up = true
    return setmetatable({ 显示 = self.显示鼠标, ['self'] = self },
        { __name = '拿起', __index = self, __newindex = self })
end

function 物品:返回()
    self.up = false
    if self.是否拆分 then
        self.num = __res.F14:置颜色(255, 255, 255, 255):取描边精灵(self.数量, 0, 0, 0)
    end
end

function 物品:拆分拿起(n)
    self.是否拆分 = true
    self.拆分数量 = n
    self.num = __res.F14:置颜色(255, 255, 255, 255):取描边精灵(self.数量 - n, 0, 0, 0)

    return self
end

function 物品:丢弃()
    鼠标层.附加 = self:返回()
    coroutine.xpcall(
        function()
            if 窗口层:确认窗口('#R物品#Y%s#R被丢弃后将会直接被删除且无法找回，您确定要丢弃这件物品吗？'
                , self.名称) then
                if __rpc:角色_物品丢弃(self.I) then
                    self:删除()
                end
            end
        end
    )
end

function 物品:删除()
    if self.B then
        self.B[self.i] = nil
    end
end

function 物品:到12装备(B, i)
    self.刷新显示 = true
    self:删除()
    self.B = B
    self.i = i --部位
    self.来源 = '装备'
    self.图标:置拉伸(40, 40, true)
    B[i] = self
    self.图标:置颜色()
    return self
end

function 物品:到装备(B, i)
    self.刷新显示 = true
    self:删除()
    self.B = B
    self.i = i --部位
    self.来源 = '装备'
    if i == 2 or i == 4 then
        self.图标:置拉伸(40, 40, true)
    elseif i == 5 or i == 10 then
        self.图标:置拉伸(65, 65, true)
    elseif i == 6 then
        self.图标:置拉伸(100, 100, true)
    end
    B[i] = self
    self.图标:置颜色()
    return self
end

function 物品:到商城()
    if self.图标 then
        self.图标:置拉伸(70, 70, true)
    end

    return self
end

function 物品:复制()
    if self.图标 then
        if self.缩小 then
            self.图标:置拉伸(self.缩小, self.缩小, true)
        else
            self.图标:置拉伸(50, 50, true)
        end
    end
    return self
end

--交易========================================

function 物品:加数量()
    if self.self and self.数量 + 1 > self.self.数量 then
        return
    end
    self.数量 = self.数量 + 1
    self.num = __res.F14:置颜色(255, 255, 255, 255):取描边精灵(self.数量, 0, 0, 0)
    return self
end

function 物品:减少数量()
    if self.self and self.数量 - 1 < 0 then
        return
    end
    self.数量 = self.数量 - 1
    self.num = __res.F14:置颜色(255, 255, 255, 255):取描边精灵(self.数量, 0, 0, 0)
    return self
end

function 物品:提交()
    self.sell = true
    if self._提交 then
        self._提交:加数量()
        return self._提交
    end
    self._提交 = setmetatable({
        sell = false,
        数量 = 0,
        ['self'] = self
    }, { __name = '提交', __index = self })
    return self._提交:加数量()
end

function 物品:清空提交()
    self.sell = false
    self._提交 = nil
end

--摆摊========================================
function 物品:上架(v)
    self.单价 = v
end

function 物品:下架()
    self.单价 = nil
end

--作坊========================================

function 物品:镜像()
    return setmetatable({
        数量 = 1,
        num = false,
        ['self'] = self
    }, { __name = '镜像', __index = self })
end

return 物品
