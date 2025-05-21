local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己, 来源)--(数据,挨打方,攻击方)
    local t = table.remove(data, 1)
    local co, tco = (coroutine.running())

    --自己.移动速度 = 200
    if t.躲避 then --没有动作_受击
        自己:置坐标(自己:取后退坐标(来源, 50))
    end
    if t.怨气  then
        自己:置怨气(t.怨气)
    end

    if t.天降流火 then
        self.目标 = t.位置 and 战场层:取对象(t.位置) or 自己
        战场层:添加技能(self)
        self.动画 = __res:getani('magic/fullscreen/%04d.tca', 1238):播放():置帧率(1 / 20)
        self._定时 = 引擎:定时(
            10,
            function()
                if self.动画 then
                    if not self.动画.是否播放 then
                        coroutine.xpcall(co)
                        return
                    end
                    return 10
                else
                    coroutine.xpcall(co)
                end
            end
        )
        coroutine.yield()    
    end
    
    if not t.躲避 and t.数值 then
        if t.物伤转增加 then
            自己:添加绿数字(t.数值, t.类型)
        else
            自己:添加红数字(t.数值, t.类型)
        end
        
    end
    if t.躲避 then
        self._定时 = 引擎:定时(
            10,
            function()
                if 来源.模型 == 'guard' then --攻击动画结果
                    coroutine.xpcall(co)
                    return
                end
                return 10
            end
        )
        coroutine.yield()
        自己:置坐标(自己.战斗坐标)
    elseif t.防御 then
        自己:动作_防御()
        自己:置帧率(1 / 15)
    elseif not t.死亡 then
        自己:动作_受击()
        自己:置帧率(1 / 20)
    end
    if t.反震 then
        来源:播放战斗(t.反震, 自己)
    end

    if t.死亡 then
        自己:动作_死亡()
        if t.消失 then
            自己.是否删除 = os.time()+2
        end
    end
    自己.是否死亡 = t.死亡
end

function 数据:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
        return not self.动画.是否播放
    end
end

function 数据:显示(x, y)
    if self.动画 then
        self.动画:显示(self.目标.x, self.目标.y)
    end
end

return 数据
