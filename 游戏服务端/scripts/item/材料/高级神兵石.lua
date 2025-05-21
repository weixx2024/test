local 物品 = {
    名称 = '高级神兵石',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    绑定 = false,
}
function 物品:初始化()
    if not self.参数 then
        self.参数 = 1
    end
end
function 物品:使用(对象)

end
function 物品:取描述()
    if not self.参数 then
        self.参数 = 1
    end
    return "#Y适用: #G"..self.参数.."级及以下神兵升级"
end
return 物品