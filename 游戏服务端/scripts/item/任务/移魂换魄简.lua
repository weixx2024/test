local 物品 = {
  名称 = '移魂换魄简',
  叠加 = 999,
  类别 = 10,
  类型 = 0,
  对象 = 1,
  条件 = 2,
  绑定 = false
}

function 物品:使用(对象)
  local r = 对象:取任务("移魂换魄简")
  if r then
    r:清除变身(对象)
  end
  local rw = 生成任务 { 名称 = '移魂换魄简' }

  if rw then
    rw:添加任务(对象)
    self.数量 = self.数量 - 1
  end
end

return 物品
