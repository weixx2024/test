local 物品 = {
    名称 = '亲密丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}
function 物品:初始化(t)
    if not self.参数 then
        self.参数 = 10000
    end
end
function 物品:使用(对象)
    if 对象:添加亲密度(self.参数, 2) then
        self.数量 = self.数量 - 1
        对象:常规提示(string.format( "#Y#Y你的%s增加了#G%s#R点亲密，当前亲密值#G%s#R点。",对象.名称, self.参数, 对象.亲密))
    else
        return "当前召唤兽亲密已达上限！"
    end
end
function 物品:取描述()
    if self.参数 then
        return string.format( "#Y+%s亲密度",self.参数)
    end
end
return 物品
