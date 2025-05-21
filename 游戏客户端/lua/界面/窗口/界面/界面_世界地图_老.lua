

local 世界地图 = 窗口层:创建我的窗口('世界地图', 0, 0)
function 世界地图:初始化()
    self:置精灵(
        生成精灵(
            640,
            480,
            function()
                __res:getsf('smap/world.jpg'):显示(0, 0)
                __res:getsf('smap/worldb.tca'):显示(0, 0)
                __res:getsf('smap/worldlogo.tca'):显示(450, 30)
                
            end
        )
    )
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

--===============================================================================================





-- function 按钮:左键弹起()
--     self.父控件:置可见(false)
-- end

--当前地图
function 窗口层:打开世界地图()
    世界地图:置可见(not 世界地图.是否可见, true)

end

return 世界地图
