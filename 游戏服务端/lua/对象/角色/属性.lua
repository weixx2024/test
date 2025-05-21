local 角色 = require('角色')

function 角色:属性_初始化()
    self.刷新的属性 = {}
    self:刷新属性()
end

function 角色:属性_更新()
    if next(self.刷新的属性) then
        coroutine.xpcall(
            function()
                if self.刷新的属性.头像 then
                    self.rpc:置人物头像(self.刷新的属性.头像)
                end
                if self.刷新的属性.气血 or self.刷新的属性.最大气血 then
                    self.rpc:置人物气血(self.刷新的属性.气血 or self.气血, self.刷新的属性.最大气血
                        or self.最大气血)
                end
                if self.刷新的属性.魔法 or self.刷新的属性.最大魔法 then
                    self.rpc:置人物魔法(self.刷新的属性.魔法 or self.魔法, self.刷新的属性.最大魔法
                        or self.最大魔法)
                end
                if self.刷新的属性.经验 then
                    self.rpc:置人物经验(self.刷新的属性.经验, self.刷新的属性.最大经验)
                end
                if self.刷新的属性.外形 then
                    self.rpc:切换外形(self.nid, self.外形)
                    self.rpn:切换外形(self.nid, self.外形)
                end
                if self.刷新的属性.名称颜色 then
                    self.rpc:切换名称颜色(self.nid, self.名称颜色)
                    self.rpn:切换名称颜色(self.nid, self.名称颜色)
                end
                if self.刷新的属性.技能 then
                    self.rpc:请求刷新人物技能()
                end
                if self.刷新的属性.召唤列表 then
                    self.rpc:请求刷新召唤列表()
                end
                if self.刷新的属性.银子 then
                    self.rpc:刷新银子()
                end
                if self.刷新的属性.师贡 then
                    self.rpc:刷新师贡()
                end
                if self.刷新的属性.称谓 then
                    self.rpc:切换称谓(self.nid, self.刷新的属性.称谓)
                end
                if self.刷新的属性.仙玉 then
                    self.rpc:刷新仙玉()
                end
                self.rpc:请求刷新人物()

                self.刷新的属性 = {}
            end
        )
    end
end

function 角色:角色_打开人物窗口()
    return self:角色_取窗口属性()
end

function 角色:添加体力(n)
    if self.体力 >= self.最大体力 then
        return
    end
    self.体力 = self.体力 + math.floor(n)
    if self.体力 > self.最大体力 then
        self.体力 = self.最大体力
    end
    return self.体力
end

function 角色:角色_人物加点(t)
    if not self.是否战斗 and type(t) == 'table' then
        local n = 0
        for k, v in pairs(t) do
            if k ~= '潜力' and self[k] and type(v) == 'number' then
                n = n + v
            end
        end
        if n <= self.潜力 then
            self.潜力 = self.潜力 - n
            self.根骨 = self.根骨 + t.根骨
            self.灵性 = self.灵性 + t.灵性
            self.力量 = self.力量 + t.力量
            self.敏捷 = self.敏捷 + t.敏捷
            self:刷新属性()
            return self:角色_取窗口属性()
        end
    end
end



function 角色:角色_人物洗点()
    if self.是否战斗 then
        return
    end
    if self.飞升 == 1 then
        self.根骨 = self.等级+60
        self.灵性 = self.等级+60
        self.力量 = self.等级+60
        self.敏捷 = self.等级+60
    else
        self.根骨 = self.等级
        self.灵性 = self.等级
        self.力量 = self.等级
        self.敏捷 = self.等级
    end
    self.潜力 = self.等级 * 4 + self.转生 * 60
    if self.化形丹 and self.化形丹 >= 1 then
        self.潜力 = self.潜力 + 60
    end
    self:刷新属性()
end

function 角色:角色_取窗口属性()
    self = self.战斗 or self
    local r = {}
    for _, v in pairs {
        'id',
        '名称',
        '外形',
        '原形',
        '头像',
        '种族',
        '称谓',
        '帮派',
        '声望',
        '最大声望',
        '战绩',
        '最大战绩',
        '等级',
        '转生',
        '飞升',
        '经验',
        '最大经验',
        '气血',
        '最大气血',
        '魔法',
        '最大魔法',
        '攻击',
        '速度',
        '根骨',
        '灵性',
        '力量',
        '敏捷',
        '潜力'
    } do
        r[v] = self[v]
    end
    r.根骨 = self.装备属性.根骨 + self.根骨 + self.其它.四维加成 * 10
    r.灵性 = self.装备属性.灵性 + self.灵性 + self.其它.四维加成 * 10
    r.力量 = self.装备属性.力量 + self.力量 + self.其它.四维加成 * 10
    r.敏捷 = self.装备属性.敏捷 + self.敏捷 + self.其它.四维加成 * 10
    return r
end

function 角色:角色_打开抗性窗口()
    local r = {}
    if self.战斗 and self.是否战斗 then
        for _, k in pairs(require('数据库/抗性库')) do
            if self.战斗[k] ~= 0 then
                -- r[k] = string.format("%.2f", self.战斗[k])
                r[k] = self.战斗[k]
            end
        end
    else
        for _, k in pairs(require('数据库/抗性库')) do
            if self.抗性[k] ~= 0 then
                -- r[k] = string.format("%.2f", self.抗性[k])
                r[k] = self.抗性[k]
            end
        end
        local 五行 = {"金","木","水","火","土"}
        for i,v in ipairs(五行) do
            if self[v] and self[v] > 0 then
                r[v] = self[v]
            end
        end
    end
    return r
end
