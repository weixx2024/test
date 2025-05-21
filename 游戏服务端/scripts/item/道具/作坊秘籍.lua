local 物品 = {
    名称 = '作坊秘籍',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
local _作坊 = {
    "步摇坊",
    "湛卢坊",
    "七巧坊",
    "生莲坊",
    "同心坊",
    "炼器坊",
}
function 物品:使用(对象)
    对象:作坊窗口(self.nid,{self.作坊,_作坊[self.作坊],self.作者,self.段位,self.等级,self.熟练})
end

function 物品:取描述()
    return string.format("#Y%s秘籍，作者 %s，%s段，%s级，熟练 %s", _作坊[self.作坊], self.作者, self.段位
        , self.等级, self.熟练)
end

return 物品
