local 战斗数据 = class('战斗数据')

function 战斗数据:初始化(位置)
    self.位置 = 位置
    self.时长 = 0
end

function 战斗数据:物理攻击(位置, 目标, 追加, 天降流火)
    table.insert(self, { nid = __生成ID(), 动作 = '物攻', 位置 = 位置, 目标 = 目标, 追加=追加, 天降流火=天降流火})
    return self
end

function 战斗数据:物理伤害(数值, 防御, 死亡, 消失, 怨气, 天降流火)
    local t = { nid = __生成ID(), 动作 = '物伤', 数值 = 数值, 防御 = 防御, 死亡 = 死亡, 消失 = 消失, 怨气 = 怨气, 天降流火=天降流火 }
    table.insert(self, t)
    return t
end

function 战斗数据:物理反击(目标)
    table.insert(self, { nid = __生成ID(), 动作 = '物反', 目标 = 目标 })
    return self
end

function 战斗数据:法术反击(目标)
    table.insert(self, { nid = __生成ID(), 动作 = '法反', 目标 = 目标 })
    return self
end

function 战斗数据:物理法术(法术, 目标)
    self[#self].附法 = { nid = __生成ID(), 动作 = '附法', id = 法术, 目标 = 目标 }
    return self
end

function 战斗数据:群体理法术(法术, 目标)
    if self[#self].附法 == nil then
        self[#self].附法 = {nid = __生成ID(), 动作 = '附法', id = 法术,目标={}}
    end
    for i,v in pairs(目标) do
        if v.位置 and v[1] then
            if self[#self].附法.目标[v.位置] then
                v[1].位置 = v.位置
                -- v[1].动作 = '附法'
                v[1].id = 法术
                self[#self].附法.目标[v.位置][#self[#self].附法.目标[v.位置]+1] = v[1]
            else
                v[1].id = 法术
                v[1].位置 = v.位置
                self[#self].附法.目标[v.位置] = {位置=v.位置,v[1]}
            end
        end
    end
    return self
end

function 战斗数据:法术(法术, 目标)
    table.insert(self, { nid = __生成ID(), 动作 = '法术', id = 法术, 目标 = 目标 })
    return self
end

function 战斗数据:特效(法术, 目标) --只有特效 没有人物动作
    table.insert(self, { nid = __生成ID(), 动作 = '特效', id = 法术, 目标 = 目标, 施法 = false })
    return self
end

function 战斗数据:法术后(目标)
    table.insert(self, { nid = __生成ID(), 动作 = '法术后', 目标 = 目标 })
    return self
end

function 战斗数据:法术伤害(数值, 死亡, 消失, 类型, 怨气)
    local t = { nid = __生成ID(), 动作 = '法伤', 数值 = 数值, 死亡 = 死亡, 消失 = 消失, 类型 = 类型, 怨气 = 怨气 }
    table.insert(self, t)
    return t
end

function 战斗数据:道具(目标)
    table.insert(self, { nid = __生成ID(), 动作 = '道具', 目标 = 目标 })
    return self
end

function 战斗数据:召唤(数据)
    table.insert(self, { nid = __生成ID(), 动作 = '召唤', 数据 = 数据 })
    return self
end

function 战斗数据:召还(位置)
    table.insert(self, { nid = __生成ID(), 动作 = '召还', 位置 = 位置 })
    return self
end

function 战斗数据:捕捉(目标, 结果)
    table.insert(self, { nid = __生成ID(), 动作 = '捕捉', 目标 = 目标, 结果 = 结果 })
    return self
end

function 战斗数据:逃跑(结果)
    table.insert(self, { nid = __生成ID(), 动作 = '逃跑', 结果 = 结果 })
    return self
end

function 战斗数据:提示(内容)
    table.insert(self, { nid = __生成ID(), 动作 = '提示', 内容 = 内容 })
    return self
end

function 战斗数据:喊话(内容)
    table.insert(self, { nid = __生成ID(), 动作 = '喊话', 内容 = 内容 })
    return self
end

function 战斗数据:气血(数值, 特效)
    table.insert(self, { nid = __生成ID(), 动作 = '气血', 数值 = 数值, 特效 = 特效 })
    return self
end

function 战斗数据:怨气(数值, 特效)
    table.insert(self, { nid = __生成ID(), 动作 = '怨气', 怨气 = 数值, 特效 = 特效 })
    return self
end

function 战斗数据:魔法(数值, 特效)
    table.insert(self, { nid = __生成ID(), 动作 = '魔法', 数值 = 数值, 特效 = 特效 })
    return self
end

function 战斗数据:特殊物理法术(法术, 目标,位置)
    self[#self].特殊附法 = { 动作='特殊附法', id = 法术, 目标 = 目标,原始目标=位置}
    return self
end

function 战斗数据:无特效物理法术( 目标,位置)
    self[#self].无特效附法 = { 动作='无特效附法',  目标 = 目标,原始目标=位置}
    return self
end

function 战斗数据:蜃光流星法术(法术,目标,目标顺序,位置)
    self[#self].特殊附法 = { 动作='蜃光流星法术', id = 法术, 目标 = 目标,目标顺序=目标顺序,原始目标=位置}
    return self
end


function 战斗数据:群体目标添加特效(id,位置)
    if #self==0 or self[#self].动作 ~= "群体加特效" then
        table.insert(self, { 动作 = '群体加特效', id = id ,位置={}})
    end
    self[#self].位置[#self[#self].位置+1] = 位置
    return self
end

function 战斗数据:群体添加特效(id,位置)
    table.insert(self, { 动作 = '群体加特效', id = id ,位置=位置})
    return self
end


function 战斗数据:死亡(消失)
    table.insert(self, { nid = __生成ID(), 动作 = '死亡', 消失 = 消失 })
    return self
end

function 战斗数据:复活(特效)
    table.insert(self, { nid = __生成ID(), 动作 = '复活', 特效 = 特效 })
    return self
end

function 战斗数据:添加BUFF(id,位置,tx)
    table.insert(self, { nid = __生成ID(), 动作 = '加BF', tx=tx,id = id ,位置=位置})
    return self
end

function 战斗数据:删除BUFF(id,位置,tx)
    table.insert(self, { nid = __生成ID(), 动作 = '减BF',tx=tx, id = id ,位置=位置})
    return self
end

function 战斗数据:全屏特效(法术, 目标)
    table.insert(self, { 动作 = '全屏特效', id = 法术, 目标 = 目标 })
    return self
end

function 战斗数据:孩子喊话(内容)
    table.insert(self, { nid = __生成ID(), 动作 = '孩子喊话', 内容 = 内容 })
    return self
end

function 战斗数据:孩子技能()
    table.insert(self, { nid = __生成ID(), 动作 = '孩子技能' })
    return self
end

function 战斗数据:暗影离魂攻击(位置, 目标)
    table.insert(self, { 动作 = '暗影离魂', 位置 = 位置, 目标 = 目标 })
    return self
end

function 战斗数据:切换外形(id,位置,目标)
    table.insert(self, { 动作 = '切换外形', id = id ,位置=位置,目标})
    return self
end


function 战斗数据:添加特效(id,位置)
    table.insert(self, { 动作 = '加特效', id = id,位置=位置})
    return self
end

function 战斗数据:目标添加特效(id,位置)
    table.insert(self, { 动作 = '加特效', id = id ,位置=位置})
    return self
end

function 战斗数据:水中探月法术(法术, 目标,位置)
    table.insert(self, { 动作='水中探月法术', id = 法术, 目标 = 目标,原始目标=位置})
    return self
end

function 战斗数据:驱逐(特效,位置)
    table.insert(self, { 动作 = '驱逐', id = 特效,位置=位置})
    return self
end

return 战斗数据
