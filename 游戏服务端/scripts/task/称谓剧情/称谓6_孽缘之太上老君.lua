local 任务 = {
    名称 = '称谓6_孽缘之太上老君',
    别名 = '(六称)孽缘之太上老君',
    类型 = '称谓剧情',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '前往#Y方寸山#W找#G#u#[1135|38|11|$道士#]#u#W谈谈。',
    '去天宫找#G#u#[1113|12|8|$太上老君#]#u#W聊聊。',
    '回去告诉#G#u#[1135|38|11|$道士#]#u#W老君的情况。'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3045, 结束 = false, 台词 = '我们道家子弟的最高梦想就是见一见道门始祖#R太上老君#W，以我的功力是没有可能去#R天宫#W了，你能帮我去实现这个理想吗？' },
    [2] = { 头像 = 0, 台词 = '恩，反正这事也不算太难，就帮你吧。' },
    --0
    [3] = { 头像 = 6535, 结束 = false, 台词 = '快走吧快走吧，我忙着呢，别烦我！' },
    [4] = { 头像 = 0, 台词 = '老道~我只是受人之托来拜访你，否则我才不理你呢！' },
    --1
    [5] = { 头像 = 3045, 结束 = false, 台词 = '啊，太上老君跟你说话了呢，5555……真羡慕。谢谢你帮我实现了梦想！' },
    [6] = { 头像 = 0, 台词 = '哎，这算什么梦想啊……' },
    --2
}

function 任务:取对话(玩家)
    local r = _台词[self.对话进度]
    local 台词, 头像, 结束 = r.台词, r.头像, r.结束
    if 头像 == 0 then
        头像 = 玩家.原形
    end
    return 台词, 头像, 结束
end

function 任务:任务NPC对话(玩家, NPC)
    if not 玩家:剧情称谓是否存在(5) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '道士' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 2 then
                self.进度 = 1
            end
        elseif self.进度 == 2 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 6 then
                self:完成(玩家)
            end
        end
    elseif NPC.名称 == '太上老君' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 4 then
                self.进度 = 2
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 6, '老君')
    end
    self:删除()
end

return 任务
