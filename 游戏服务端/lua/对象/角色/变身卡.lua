local 角色 = require('角色')
local _变身卡库 = __脚本['scripts/make/变身卡库.lua']
function 角色:角色_变身卡商店()
    return self.银子, self.其它.卡集容量
end

function 角色:角色_购买变身卡(t)
    local s = _变身卡库[t.名称]
    if not s then
        return "#Y 没有这样的卡片"
    end
    s = s[t.属性编号]
    if not s or not s.价格 then
        return "#Y 没有这样的卡片"
    end
    t.单价 =s.价格
  
    local 总价 = t.单价 * t.购买数量
    if self.银子 < 总价 then
        return "#Y 你没有那么多银子"
    end
    local 名称 = t.类型 == 1 and t.name .. "卡" or t.name .. "属性卡"

    if t.购买数量 > 4 then
        local 位置 = 0
        for i, v in ipairs(self.卡集) do
            if v.key == t.名称 and v.属性类型 == t.类型 and v.属性id == t.属性编号 then
                位置 = i
                break
            end
        end

        if 位置 == 0 and #self.卡集 >= self.其它.卡集容量 then
            return "#Y卡集已经没有空位了"
        end
        self.银子 = self.银子 - 总价
        self.rpc:提示窗口("#Y你花费%s购买了%s张%s已经放入卡册", 总价, t.购买数量, 名称)
        if 位置 == 0 then
            table.insert(self.卡集, {
                name = t.name,
                key = t.名称,
                属性类型 = t.类型,
                属性id = t.属性编号,
                数量 = t.购买数量

            })
        else
            self.卡集[位置].数量 = self.卡集[位置].数量 + t.购买数量
        end



    else
        local 物品表 = {}

        for i = 1, t.购买数量, 1 do
            table.insert(物品表, __沙盒.生成变身卡 {
                名称 = 名称,
                key = t.名称,
                name = t.name,
                属性类型 = t.类型,
                属性id = t.属性编号
            })
        end

        if not self:物品_检查添加(物品表) then
            self.rpc:提示窗口("#Y包裹没有空余的道具栏")
            return 
        end
        self.银子 = self.银子 - 总价
        if self:物品_添加(物品表) then
            self.rpc:提示窗口("#Y你花费%s购买了%s张%s", 总价, t.购买数量, 名称)
        end

    end
end

function 角色:放入卡册(t)
    if type(t) == "table" then
        for i, v in ipairs(self.卡集) do
            if v.key == t.key and v.属性类型 == t.属性类型 and v.属性id == t.属性id then
                self.卡集[i].数量 = self.卡集[i].数量 + 1
                return true
            end
        end
        if #self.卡集 >= self.其它.卡集容量 then
            self.rpc:常规提示("#Y卡集已经没有空位了")
            return
        end
        t.数量 = 1
        table.insert(self.卡集, t)
        return true
    end
end

function 角色:角色_取出卡片(n)
    if not self.卡集[n] then
        return 0
    end
    local t = self.卡集[n]
    local 名称 = t.属性类型 == 1 and t.key or t.name .. "属性卡"
    local r = __沙盒.生成变身卡 {
        名称 = 名称,
        key = t.key,
        name = t.name,
        属性类型 = t.属性类型,
        属性id = t.属性id
    }
    if self:物品_添加({ r }) then
        self.卡集[n].数量 = self.卡集[n].数量 - 1
        if self.卡集[n].数量 <= 0 then
            table.remove(self.卡集, n)
            return 0
        end
        return self.卡集[n].数量
    else
        return "#Y身上没有空余的包裹栏"
    end


end

function 角色:角色_打开七十二变()
    return self.卡集
end
