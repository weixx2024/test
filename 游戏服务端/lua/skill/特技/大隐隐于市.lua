local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '大隐隐于市',
    种族 = 2 --天界
}

local BUFF
function 法术:回合开始(攻击方, 挨打方)
    if not 攻击方:取BUFF('隐身') then
        local 几率 = self:取机率(挨打方)
        if 几率 > math.random(100) then
            local b = 攻击方:进入添加BUFF(BUFF)
            if b then
                b.回合 = 1
                攻击方.当前数据:添加BUFF("隐身",攻击方.位置)
                攻击方.是否隐身 = true
            end
        end
    end
end

function 法术:取机率(召唤)
    local ndjl = 300
    return ndjl
end

BUFF = {
    法术 = '隐身',
    名称 = '隐身',
    id = '隐身'
}

法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.是否隐身 = false
        if self.效果 then
            for i,v in pairs(self.效果) do
                单位[i] =  单位[i] - v
            end
        end
    end
end


return 法术
