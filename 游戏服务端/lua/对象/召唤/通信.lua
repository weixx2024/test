local 召唤 = require('召唤')

function 召唤:召唤_改名(v)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 or type(v) ~= 'string' then
        return '#Y当前状态下无法进行此操作'
    end
    self.名称 = v
    -- if self.是否观看 then
    --     mast.rpc:切换名称(self.nid, v)
    --     mast.rpn:切换名称(self.nid, v)
    -- end
    return true
end

function 召唤:召唤_参战(v)
    local mast = self.主人
    if not self.主人:剧情称谓是否存在(self.携带) then
        return '#Y参战该召唤兽需要获得' .. self.携带 .. "级称谓！"
    end
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    if mast.转生 == 0 and self.等级 > mast.等级 + 15 then
        return '#Y参战召唤兽等级不能高于人物15级！'
    end
    if not mast.召唤[self.nid] then
        return '#Y你没有这样的召唤兽！'
    end
    --参战条件判断
    if mast.参战召唤 then
        mast.参战召唤.是否参战 = false
    end
    self.是否参战 = v == true
    if self.是否参战 then
        mast.参战召唤 = self
        mast.rpc:界面信息_召唤(self:取界面数据())
    else
        mast.rpc:界面信息_召唤()
        mast.参战召唤 = nil
    end
    return self.是否参战
end

function 召唤:召唤_加点(t)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    local 加点总和 = 0
    for k, v in pairs(t) do
        加点总和 = 加点总和 + v
    end
    if 加点总和 <= self.潜力 then
        self.潜力 = self.潜力 - 加点总和
        self.根骨 = self.根骨 + t[1]
        self.灵性 = self.灵性 + t[2]
        self.力量 = self.力量 + t[3]
        self.敏捷 = self.敏捷 + t[4]
        self:刷新属性()
    end
    self:召唤_刷新窗口属性()
    return true
end

function 召唤:召唤_刷新窗口属性()
    self.主人.rpc:召唤_刷新窗口属性(self:召唤_取窗口属性())
end


function 召唤:召唤_放生()
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end

    if mast.参战召唤 == self then
        return '#Y请先取消参战状态！'
    end
    if mast.观看召唤 == self then
        return '#Y请先取消观看状态！'
        -- mast.当前地图:删除召唤(self)
    end
    if self.被管制 then
        return '#Y请先取消管制状态！'
    end
    self:删除()
    return true
end

function 召唤:召唤_观看(v)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    if mast.观看召唤 then
        mast.当前地图:删除召唤(mast.观看召唤)
        mast.观看召唤 = nil
    end
    self.是否观看 = v == true

    if self.是否观看 then
        self.x, self.y = mast.x, mast.y
        mast.当前地图:添加召唤(self)
        mast.观看召唤 = self
    end

    return self.是否观看
end

function 召唤:召唤_驯养()
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    if self.忠诚 >= 100 then
        return '#Y召唤兽忠诚已满！'
    end
    local v = self.主人:物品_获取('宠物口粮')
    local gv = self.主人:物品_获取('高级宠物口粮')
    local n = 1
    if gv then
        gv:减少(1)
        n = 5
    elseif v then
        v:减少(1)
        n = 2
    else
        return '#Y你的包裹里没有宠物口粮'
    end
    self.忠诚 = self.忠诚 + n
    if self.忠诚 > 100 then
        self.忠诚 = 100
    end
    return true
end

function 召唤:召唤_取窗口抗性()
    local r = {}
    if self.战斗 then
        for _, k in pairs(require('数据库/抗性库')) do
            if self.战斗[k] and self.战斗[k] ~= 0 then
                r[k] = self.战斗[k]
            end
        end
    else
        for _, k in pairs(require('数据库/抗性库')) do
            if self.抗性[k] ~= 0 then
                r[k] = self.抗性[k]
            end
        end
    end
  
    for _, k in pairs { "成长", "亲密", "初血", "初法", "初攻", "初敏" ,"金","木","水","火","土"} do
        r[k] = self[k]
    end

    return r
end

function 召唤:召唤_取窗口属性()
    self = self.战斗 or self
    local r = {}
    for _, v in pairs {
        'nid',
        '等级',
        '转生',
        '飞升',
        '外形',
        '染色',
        '名称',
        '忠诚',
        '气血',
        '最大气血',
        '魔法',
        '最大魔法',
        '攻击',
        '速度',
        '经验',
        '最大经验',
        '根骨',
        '灵性',
        '力量',
        '敏捷',
        '潜力',
        '类型',
        '是否参战',
        '是否观看',
        '天生技能',
        "后天技能",
        '类型',
        '技能格子',
        '技能'
    } do
        r[v] = self[v]
    end
    local list = {}

    for _, v in ipairs(self.内丹) do
        table.insert(list, {
            名称 = v.技能,
            等级 = v.等级,
            转生 = v.转生,
            点化 = v.点化
        })
    end
    r.内丹 = list

    local 天生技能表 = {}
    for _, v in ipairs(self.技能) do
        if self:是否天生技能(v.名称) then
            table.insert(天生技能表, {
                名称 = v.名称,
                描述 = v:法术取描述(self)
            })
        end
    end
    r.天生技能表 = 天生技能表

    local 后天技能表 = {}
    for _, v in ipairs(self.技能) do
        if self:是否后天技能(v.名称) then
            table.insert(后天技能表, {
                名称 = v.名称,
                描述 = v:法术取描述(self)
            })
        end
    end
    r.后天技能表 = 后天技能表

    if not self.战斗 then
        self.主人.当前查看召唤 = self
    end
    return r
end


function 召唤:是否后天技能(name)
    for _,v in ipairs(self.后天技能) do
        if v == name then
            return true
        end
    end
    return false
end

function 召唤:是否天生技能(name)
    for _,v in ipairs(self.天生技能) do
        if v == name then
            return true
        end
    end
    return false
end

function 召唤:召唤_取内丹列表()
    local list = {}
    for _, v in ipairs(self.内丹) do
        table.insert(list, {
            名称 = v.技能,
            等级 = v.等级,
            转生 = v.转生,
            点化 = v.点化,
            经验 = v.经验,
            最大经验 = v.最大经验,
            元气 = v.元气,
            最大元气 = v.最大元气,
            描述 = v:取描述(self)
        })
    end
    return list
end

function 召唤:召唤_打开抗性窗口()
    return self:召唤_取窗口抗性()
end

function 召唤:召唤_物品使用(i)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    return self.主人:角色_召唤物品使用(i, self)
end

function 召唤:召唤_取内丹(name)
    for _, v in ipairs(self.内丹) do
        if v.技能 == name then
            return v
        end
    end
end

function 召唤:召唤_删除内丹(name)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    for i, v in ipairs(self.内丹) do
        if v.技能 == name then
            table.remove(self.内丹, i)
            return
        end
    end
end

function 召唤:召唤_吐出内丹(name)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    local 内丹 = self:召唤_取内丹(name)
    if 内丹 then
        local r = 内丹:吐出(self)
        if r and self.主人:物品_检查添加 { r } then
            self:召唤_删除内丹(name)
            self.主人:物品_添加 { r }
            self:刷新属性()
            self.主人.rpc:常规提示('#Y这只召唤兽吐出了一颗内丹。')
            return true
        end
    else
        return '#R内丹不存在'
    end
end

function 召唤:召唤_内丹经验转换(name)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    local 内丹 = self:召唤_取内丹(name)
    if 内丹 then
        if 内丹.等级 >= 内丹.等级上限 then
            if 内丹.转生 >= self.转生 then
                return "#Y请先转生召唤兽"
            end
            if 内丹:转生处理(self) then
                self.刷新的属性.内丹 = true
                return string.format("#Y%s#W内丹转生成功！", 内丹.技能)
            end
        else
            if self.经验 < 500 then
                return "#Y一次最少要转换500点经验，你的召唤兽经验不够了。"
            end
            local n = math.floor(self.经验 * 0.2)
            local lv, ts = 内丹.等级, nil
            if 内丹:添加经验(n, self) then
                self.经验 = self.经验 - n
                self.刷新的属性.内丹 = true
                if 内丹.等级 > lv then
                    ts = string.format("#Y%s内丹升到%s级", 内丹.技能, 内丹.等级)
                end
                return 内丹.经验, 内丹.等级,
                    string.format("#Y%s的%s内丹获得#R%s#Y点经验",
                        召唤.名称, 内丹.技能, n), ts
            end
        end
    end
end
