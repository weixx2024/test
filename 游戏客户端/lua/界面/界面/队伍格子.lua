-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-04-20 21:39:18
-- @Last Modified time  : 2024-04-21 04:32:40

--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2024-04-20 16:31:14
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2024-04-20 16:52:29
FilePath: \pc客户端New\lua\界面\控件\队伍格子.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 队伍格子 = class("队伍格子")
local ggf = require("GGE.函数")
function 队伍格子:初始化(当前)
  self.当前=当前
  self.py = {x = 70, y = 170}
end
function 队伍格子:置数据(数据, bh, lx)
  self.数据 = nil
  self.图像 = nil
  self.动画 = {}
  local 加入数据 = ggf.insert(self.动画)
  local nsf = require("SDL.图像")(143, 290)
  if 数据 then
    if nsf:渲染开始() then
      if 数据.在线 then
        __res.F14:置颜色(173,216,230)
        local 宽度 = __res.F14:取宽度(数据.名称)
        __res.F14:取图像(数据.名称):显示(math.floor(65- 宽度 / 2), 180)
        宽度 = __res.F14:取宽度(数据.等级 .. "级")
        __res.F14:取图像(数据.等级 .. "级"):显示(math.floor(65- 宽度 / 2), 205)
      else
        __res.F14:置颜色(157, 157, 157)
        local 宽度 = __res.F14:取宽度(数据.名称)
        __res.F14:取图像(数据.名称):显示(math.floor(65- 宽度 / 2), 180)
        宽度 = __res.F14:取宽度(数据.等级 .. "级")
        __res.F14:取图像(数据.等级 .. "级"):显示(math.floor(65- 宽度 / 2), 205)
      end
      __res.F14:置颜色(255, 255, 255)
      nsf:渲染结束()
    end
    self.图像 = nsf:到精灵()
    加入数据(require('对象/基类/动作') {外形 =  数据.外形, 模型 = 'stand' }:置循环(true))--attack)
    self.数据 = 数据
  else
    if nsf:渲染开始() then
      __res:getPNGCC(2, 636, 573, 143, 290):显示(0, 0)
      nsf:渲染结束()
    end
    self.图像 = nsf:到精灵()
  end
end
function 队伍格子:更新(dt)
  for k, v in pairs(self.动画) do
    v:更新(dt)
  end
end
function 队伍格子:显示(x, y)
  self.图像:显示(x, y)
  for k, v in pairs(self.动画) do
    v:显示(x + self.py.x, y + self.py.y)
  end

end
return 队伍格子
