---@diagnostic disable: redundant-parameter


local 好友属性 = 窗口层:创建我的窗口('好友属性', 0, 0, 264, 321)

function 好友属性:初始化()
    self:置精灵(__res:getspr('gires/0x3D5D95E9.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    -- self.头像 = __res:getspr('photo/facelarge/%d.tga', 1)
end

function 好友属性:显示(x, y)
    if self.头像 then
        self.头像:显示(x + 21, y + 50)
    end
end

function 好友属性:置头像(id)
    self.头像 = nil
    if id then
        self.头像 = __res:getspr('photo/facelarge/%d.tga', id)
    end
end

好友属性:创建关闭按钮(0, 1)
--===========================================
for k, v in pairs {
    { name = '名称', y = 50 },
    { name = 'id', y = 84 },
    { name = '称谓', y = 117 },
    { name = '等级', y = 149 },
    { name = '种族', y = 183 },
    { name = '帮派', y = 216 },
    { name = '关系', y = 249 },
    { name = '好友度', y = 281 }
} do
    local 文本 = 好友属性:创建文本(v.name .. '文本', 164, v.y + 1, 79, 15)
    -- 文本:置文本(v.name)
end

--===========================================
for k, v in pairs {
    { name = '断交按钮', txt = '断  交' },
    { name = '历史信息按钮', txt = '历史信息' },
    { name = '更新按钮', txt = '更  新' },
    --  { name = '设为私聊按钮', txt = '设为私聊' }
} do
    local 按钮 = 好友属性:创建中按钮(v.name, 16, 167 + k * 35 - 35, v.txt)
    function 按钮:左键弹起()
        if v.name == "历史信息按钮" then
            if _nid then
                窗口层:打开历史消息(_nid)
            end

        elseif v.name == "断交按钮" then
            if _nid then
                coroutine.xpcall(
                    function()
                        if 窗口层:确认窗口('您确定要与%s断绝关系么？'
                            , _P.名称) then
                            if __rpc:角色_好友删除(_nid) then
                                窗口层:刷新好友列表()
                                self.父控件:置可见(false)
                            end
                        end
                    end
                )
            end

        elseif v.name == "更新按钮" then
            if _nid then
                if __rpc:角色_更新好友信息(_nid) then
                    好友属性:刷新属性()
                end
            end

        end
    end
end
local _关系 = {
    [0] = "陌生人",
    [1] = "好友",


}
function 好友属性:刷新属性()
    local r = __rpc:角色_获取好友属性(_nid)
    if type(r) == "table" then
        for k, v in ipairs {
            '名称',
            '称谓',
            '帮派',
            '好友度'
        } do
            好友属性[v .. '文本']:置文本(r[v])
        end
        好友属性.等级文本:置文本(r.转生 .. "转" .. r.等级 .. "级")
        好友属性.id文本:置文本(r.id + 10000)
        好友属性.种族文本:置文本(_种族[r.种族])
        好友属性.关系文本:置文本(_关系[r.关系])
        self:置头像(r.头像)
    end
end

function 窗口层:打开好友属性(P)
    好友属性:置可见(not 好友属性.是否可见)
    if not 好友属性.是否可见 then
        return
    end
    if not P then
        return
    end
    _nid = P.nid
    _P = P
    好友属性:刷新属性(P)


end

return 好友属性
