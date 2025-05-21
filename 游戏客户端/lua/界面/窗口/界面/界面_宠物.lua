

local 宠物窗口 = 窗口层:创建我的窗口('宠物窗口', 0, 0, 263, 302)
function 宠物窗口:初始化()
    self:置精灵(__res:getspr('gires/0x72199763.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 宠物窗口:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
end

function 宠物窗口:显示(x, y)
    if self.动画 then
        self.动画:显示(x + 60, y + 125)
    end
end

宠物窗口:创建关闭按钮(0, 1)

for k, v in pairs {
    { name = '观看按钮', txt = '观  看' },
    { name = '喂养按钮', txt = '喂  养' },
    { name = '炼妖按钮', txt = '炼  妖' },
    { name = '摆摊按钮', txt = '摆  摊' },
    { name = '召唤兽按钮', txt = '召 唤 兽' },
    { name = '更改名称按钮', txt = '更改名称' },
    { name = '坐骑按钮', txt = '坐  骑' },
    { name = '法宝按钮', txt = '法  宝' }--, dis = true
} do
    local 按钮
    if k <= 4 then
        if k == 1 then
            按钮 = 宠物窗口:创建我的多选按钮2('观看按钮', 27, 170 + k * 31 - 31, '观  看', '隐  藏')
        else
            按钮 = 宠物窗口:创建中按钮(v.name, 27, 170 + k * 31 - 31, v.txt)
        end
    else
        按钮 = 宠物窗口:创建中按钮(v.name, 150, 170 + (k - 4) * 31 - 31, v.txt)
    end
    if v.dis then
        按钮:置禁止(true)
    end
    function 按钮:左键弹起()
        if v.name == '观看按钮' then
            if _数据 then
                local r = __rpc:宠物_观看(_数据.nid, not self.是否选中)

                return true
            end
            return false
        elseif v.name == '喂养按钮' then
            窗口层:打开驯养宠物()
        elseif v.name == '炼妖按钮' then
            窗口层:打开炼妖窗口()
            宠物窗口:置可见(false)

        elseif v.name == '召唤兽按钮' then
            窗口层:打开召唤()
        elseif v.name == '摆摊按钮' then
            if __rol.是否摆摊 then
                窗口层:打开摆摊盘点()
            else
                local r = __rpc:角色_摆摊出摊()
                if type(r) == 'string' then
                    窗口层:提示窗口(r)
                else
                    窗口层:打开摆摊盘点()
                end
            end
            宠物窗口:置可见(false)
        elseif v.name == '坐骑按钮' then
            窗口层:打开坐骑()
        elseif v.name == '法宝按钮' then
            窗口层:打开法宝界面()
        elseif v.name == '更改名称按钮' then
            if _数据 then
                local 输入名称 = 宠物窗口.名称输入:取文本()
                if _数据.名称 == 输入名称 then
                    窗口层:提示窗口('#Y我现在就叫这个名字呀')
                    return
                end
                if require("数据/敏感词库")(输入名称, 1) then
                    窗口层:提示窗口("#Y你的输入的名称包含敏感词汇！")
                    return
                end
                local r = __rpc:宠物_改名(_数据.nid, 输入名称)
                if r then
                    _数据.名称 = 输入名称
                    窗口层:提示窗口('#Y改名成功！')
                end
            end

        end
    end
end

local 名称输入 = 宠物窗口:创建文本输入('名称输入', 153, 44, 88, 15)
名称输入:置颜色(255, 255, 255, 255)

for k, v in pairs { '等级文本', '耐力文本', '经验文本' } do
    local 文本 = 宠物窗口:创建文本(v, 153, 44 + 31 * k, 88, 15)
end
function 宠物窗口:置动画(id)
    self.动画 = nil
    self.动画 = require('对象/基类/动作') { 外形 = id, 模型 = 'stand' }
end

function 宠物窗口:刷新界面信息(r)
    if type(r) == 'table' then
        _数据 = r
        for k, v in pairs(r) do
            self.名称输入:置文本(r.名称)
            self.等级文本:置文本(tostring(r.等级))
            self.耐力文本:置文本(r.耐力 .. '/' .. r.最大耐力)
            self.经验文本:置文本(tostring(r.经验))
            self:置动画(r.外形)
            self.观看按钮:置选中(r.是否观看)
        end
    end
end

function 窗口层:打开宠物()
    宠物窗口:置可见(not 宠物窗口.是否可见)
    if not 宠物窗口.是否可见 then
        return
    end
    local r = __rpc:角色_打开宠物窗口()
    宠物窗口:刷新界面信息(r)
end

return 宠物窗口
