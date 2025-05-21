-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-09-07 15:17:32


local 任务 = {
    名称 = '元宵_亲友拜年',
    别名 = '亲友拜年',
    类型 = '节日任务'
}
function 任务:任务初始化(玩家, ...)
    print('模板任务初始化')
    self.进度 = 1
end

-- function 任务:任务上线(玩家)
--     --self.i = 3
-- end
function 任务:任务更新(玩家, sec)
end

function 任务:任务取详情(玩家)
    return '任务描述 #G' .. tostring(self.进度)
end

function 任务:任务NPC对话(玩家, NPC)
    -- if NPC.名称 == '渔村村长' and NPC.台词 then
    --     NPC.台词 = NPC.台词:gsub('menu\n', 'menu\n模板\n')
    -- end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    -- if NPC.名称 == '渔村村长' then
    --     if i == '模板' then
    --         NPC.台词 = 'NPC说'
    --         NPC.结束 = false
    --     else
    --         NPC.台词 = '我说'
    --         NPC.头像 = 玩家.外形
    --         NPC.结束 = nil
    --     end
    -- end
end

function 任务:升级事件(玩家)
end

function 任务:切换地图前事件(玩家, 地图)
    if 玩家.等级 < 10 then
        return false
    end
end
return 任务
