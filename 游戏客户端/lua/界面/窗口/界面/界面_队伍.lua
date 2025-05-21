local 队伍 = 窗口层:创建我的窗口('队伍', 0, 0, 329, 347)

local _队伍成员 = {}

function 队伍:初始化()
    self:置精灵(__res:getspr('gires/0xF5B8E062.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

队伍:创建关闭按钮(0, -348)

do
    local 队伍列表 = 队伍:创建多列列表('队伍列表', 20, 92, 289, 142)
    function 队伍列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(16)
        self:添加列(0, 2, 105, 20) --名称
        self:添加列(130, 2, 65, 20) --等级
        self:添加列(200, 2, 50, 20) --种族
        self:添加列(250, 2, 50, 20) --性别
    end

    for k, v in ipairs {
        { name = '踢出队伍', x = 50, y = 260 },
        { name = '离开队伍', x = 200, y = 260 },
        { name = '移交队长', x = 50, y = 300 },
        { name = '请求列表', x = 200, y = 300 },
    } do
        local 按钮 = 队伍:创建中按钮(v.name .. '按钮', v.x, v.y, v.name)
        function 按钮:左键弹起()
            if v.name == '踢出队伍' then
                local 选中行 = 队伍列表.选中行
                if __rol.是否队长 and 选中行 > 0 then
                    local 玩家 = _队伍成员[选中行]
                    if not 玩家 then
                        return
                    end
                    if 玩家.nid == __rol.nid then
                        return
                    end
                    local r = __rpc:角色_踢出队伍(玩家.nid)
                    if r then
                        队伍列表:删除选中()
                        table.remove(_队伍成员, 选中行)
                    end
                end
            elseif v.name == '离开队伍' then
                local r
                if __rol.是否队长 then
                    r = __rpc:角色_解散队伍()
                elseif __rol.是否组队 then
                    r = __rpc:角色_离开队伍()
                end
                if r then
                    队伍:置可见(false)
                    窗口层:关闭申请加入队伍()
                end
            elseif v.name == '移交队长' then
                local 选中行 = 队伍列表.选中行
                if __rol.是否队长 and 选中行 > 0 then
                    local 玩家 = _队伍成员[选中行]
                    if not 玩家 then
                        return
                    end
                    if 玩家.nid == __rol.nid then
                        return
                    end
                    local r = __rpc:角色_移交队长(玩家.nid)
                    if r then
                        窗口层:关闭申请加入队伍()
                    end
                end
            elseif v.name == '请求列表' then
                if __rol.是否队长 then
                    窗口层:打开申请加入队伍()
                end
            end
        end
    end
end

function 窗口层:打开队伍()
    队伍:置可见(not 队伍.是否可见)
    if not 队伍.是否可见 then
        return
    end
    local r = __rpc:角色_打开队伍窗口()
    队伍.队伍列表:清空()
    if type(r) == 'table' then
        _队伍成员 = r -- 存内存
        for i, v in ipairs(r) do
            队伍.队伍列表:添加(v.名称, v.等级, _种族[v.种族], _性别[v.性别])
        end
    end
end

function 窗口层:创建队伍()
    if __rpc:角色_创建队伍() then
        __rol.是否组队 = true
        __rol:置队长(true)
        窗口层:提示窗口('#Y组队成功，你现在是队长了。')
    end
end

return 队伍
