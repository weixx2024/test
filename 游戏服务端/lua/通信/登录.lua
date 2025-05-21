function REG:获取公告()
    return __公告配置
end

function REG:获取种族()
    return __config.种族
end

function REG:获取区服()
    return __区服配置
end

function REG:登录_验证账号(id, 账号, 密码)
    local user = __存档.验证账号(账号, 密码)
    if user and _连接[id] then
        if user.封禁 ~= 0 then
            return '#R该账号已被禁止登录,请联系管理员!'
        end
        if not __config.服务器开关 and user.管理 == 0 then
            return '#R服务器维护中'
        end
        if not __config.登录开关 and user.管理 == 0 then
            return '#R暂未开放'
        end

        if __封禁IP[_连接[id].ip] then --登录ip
            return '#Y暂未开放'
        end
        if __封禁IP[user.IP] then --注册ip
            return '#G暂未开放'
        end

        _连接[id].uid = user.id --账号id
        _连接[id].管理 = user.管理 --管理权限
        _连接[id].账号 = 账号
        _连接[id].体验 = user.体验
        _连接[id].安全 = user.安全
        return __存档.角色列表(_连接[id].uid)
    end
    return '#R账号或密码错误!'
end

function REG:登录_进入游戏(id, i)
    if _连接[id] and _连接[id].uid then
        local t = __存档.角色列表(_连接[id].uid)[i]
        if t and not __玩家[t.nid] then
            if t.封禁 ~= 0 then
                return "#R该角色已被禁止登录,请联系管理员！"
            end
            if __封禁IP[_连接[id].ip] then --登录ip
                return "#R该角色已被禁止登录,请联系管理员！"
            end
            local data = __存档.角色读档(t.nid)
            data.ip = _连接[id].ip --登录的ip 不一定注册
            data.管理 = _连接[id].管理
            data.标签 = _连接[id].体验
            data.账号 = _连接[id].账号
            data.安全码 = _连接[id].安全

            local zid = t.id + 10000000
            _连接[zid] = {}
            _连接[zid].ip = _连接[id].ip
            _连接[zid].id = zid
            _连接[zid].主id = t.id
            _连接[zid].uid = _连接[id].uid
            _连接[zid].管理 = _连接[id].管理
            _连接[zid].账号 = _连接[id].账号
            _连接[zid].体验 = _连接[id].体验
            _连接[zid].安全 = _连接[id].安全
            _角色[zid] = require('对象/角色/角色')(data)

            _角色[id] = _角色[zid]
            _角色[id]:上线(id)
            return true
        end
        return false
    end
end

function REG:离线角色_快速加入(id)
    local 角色数据 = __存档.角色列表(_连接[id].uid)
    local 返回数据 = {}
    for i, v in pairs(角色数据) do
        返回数据[#返回数据 + 1] = { v, i }
        if __玩家[v.nid] then
            返回数据[#返回数据][1].在线 = true
        end
    end
    return 返回数据
end

function REG:离线登录_进入游戏(id, i, 数据)
    if _角色[id] == nil then return "#R/主角色异常" end
    local 主号 = __玩家[_角色[id].nid]
    if 主号 then
        if not 主号.是否队长 then
            主号.rpc:提示窗口('#Y你不是队长')
            return
        end
        if 主号.接口:取队伍人数() >= 5 then
            主号.rpc:提示窗口('#Y你的队伍已经满了')
            return
        end
    end
    if _连接[id] and _连接[id].uid then
        local t = __存档.角色列表(_连接[id].uid)[i]
        if t and not __玩家[t.nid] then
            助战链接id = t.id + 10000000
            _连接[助战链接id] = {}
            _连接[助战链接id].ip = _连接[id].ip
            _连接[助战链接id].id = 助战链接id
            _连接[助战链接id].主id = 主id
            _连接[助战链接id].uid = _连接[id].uid
            _连接[助战链接id].管理 = _连接[id].管理
            _连接[助战链接id].账号 = _连接[id].账号
            _连接[助战链接id].体验 = _连接[id].体验
            _连接[助战链接id].安全 = _连接[id].安全
            if t.封禁 ~= 0 then
                return "#R该角色已被禁止登录,请联系管理员！"
            end
            if __封禁IP[_连接[助战链接id].ip] then --登录ip
                return "#R该角色已被禁止登录,请联系管理员！"
            end
            local data = __存档.角色读档(t.nid)
            data.ip = _连接[助战链接id].ip --登录的ip 不一定注册
            data.管理 = _连接[助战链接id].管理
            data.标签 = _连接[助战链接id].体验
            data.账号 = _连接[助战链接id].账号
            data.安全码 = _连接[助战链接id].安全
            local 主号 = __玩家[_角色[id].nid]
            data.地图 = 主号.地图
            data.x = 主号.x
            data.y = 主号.y
            _角色[助战链接id] = require('对象/角色/角色')(data)
            _角色[助战链接id]:助战上线(助战链接id, _角色[id].nid)
            return true
        end
        return false
    end
end

function REG:登录_强制进入游戏(id, i)
    if _连接[id] and _连接[id].uid then
        local t = __存档.角色列表(_连接[id].uid)[i]
        if t then
            if t.封禁 ~= 0 then
                return "#R该角色已被禁止登录,请联系管理员！"
            end
            if __封禁IP[_连接[id].ip] then --登录ip
                return "#R该角色已被禁止登录,请联系管理员！"
            end
        end
        local P = t and __玩家[t.nid]
        if P then
            if P.cid then
                _角色[P.cid] = nil
            end
            _角色[id] = P
            return _角色[id]:重新上线(id, _连接[id])
        end
    end
end

function REG:登录_创建角色(id, 名称, 外形)
    if _连接[id] and _连接[id].uid then
        return __存档.角色创建(_连接[id].uid, 名称, 外形)
    end
end

function REG:是否开放注册(id)
    return true
end

function REG:注册账号(id, 账号, 密码, 安全, 体验, QQ)
    if __封禁IP[_连接[id].ip] then --登录ip
        return '#Y暂未开放'
    end
    return __存档.注册账号(_连接[id].ip, 账号, 密码, 安全, 体验, QQ)
end

function REG:助战_角色列表(id)
    local 助战列表 = __复制表(__存档.角色列表(_连接[id].uid))
    for i, v in pairs(助战列表) do
        if __玩家[v.nid] then
            v.在线 = true
        end
    end
    return 助战列表
end

function REG:助战_进入游戏(id, 助战索引, 主号id, 主号nid, 助战id)
    local 主号 = __玩家[主号nid]
    if 主号 then
        if not 主号.是否队长 then
            主号.rpc:提示窗口('#Y你不是队长')
            return
        end
        if 主号.接口:取队伍人数() >= 5 then
            主号.rpc:提示窗口('#Y你的队伍已经满了')
            return
        end
        local map = 主号.接口:取当前地图()
        if map and map.是否副本 then
            主号.rpc:提示窗口('#Y该地图无法召唤助战')
            return
        end
    else
        return
    end
    助战链接id = 助战id + 10000000
    _连接[助战链接id] = {}
    _连接[助战链接id].ip = _连接[id].ip
    _连接[助战链接id].id = 助战链接id
    _连接[助战链接id].主id = 主id
    _连接[助战链接id].uid = _连接[id].uid
    _连接[助战链接id].管理 = _连接[id].管理
    _连接[助战链接id].账号 = _连接[id].账号
    _连接[助战链接id].体验 = _连接[id].体验
    _连接[助战链接id].安全 = _连接[id].安全

    if _连接[id] and _连接[id].uid then
        local t = __存档.角色列表(_连接[id].uid)[助战索引]
        if t and not __玩家[t.nid] then
            if t.封禁 ~= 0 then
                return "#R该角色已被禁止登录,请联系管理员！"
            end
            if __封禁IP[_连接[助战链接id].ip] then --登录ip
                return "#R该角色已被禁止登录,请联系管理员！"
            end
            local data = __存档.角色读档(t.nid)
            data.ip = _连接[助战链接id].ip --登录的ip 不一定注册
            data.管理 = _连接[助战链接id].管理
            data.标签 = _连接[助战链接id].体验
            data.账号 = _连接[助战链接id].账号
            data.安全码 = _连接[助战链接id].安全

            local 主号 = __玩家[主号nid]

            data.地图 = 主号.地图
            data.x = 主号.x
            data.y = 主号.y

            _角色[助战链接id] = require('对象/角色/角色')(data)
            _角色[助战链接id]:助战上线(助战链接id, 主号nid)
            return true
        end
        return false
    end
end

local 切换开始 = {}
function REG:助战_切换角色(id, 切换前id, 切换前nid, 切换后id, 切换后nid)
    if 切换开始[id] then
        local 主号 = __玩家[切换前nid]
        主号.rpc:提示窗口('#Y你也太快了，男人太快可不好!')
        return true
    else
        local 切换前链接 = _连接[切换前id + 10000000]
        local 切换后连接 = _连接[切换后id + 10000000]
        local 切换前角色 = _角色[切换前id + 10000000]
        local 切换后角色 = _角色[切换后id + 10000000]
        local 主号 = __玩家[切换前nid]
        if 切换前角色 == nil or 切换后角色 == nil then
            主号.rpc:提示窗口('#Y系统异常，请重新组队切换!' .. (切换前id or 0) .. "," .. (切换前nid or 0) .. "," .. (切换后id or 0) .. "," .. (切换后nid or 0))
            return
        end
        if not 主号.是否队长 or not 主号.是否组队 then
            切换前角色.rpc:提示窗口('#Y只有队长才可以切换!')
            return
        elseif not __玩家[切换后nid] then
            切换前角色.rpc:提示窗口('#Y助战未上线!')
            return
        elseif not __玩家[切换后nid].是否组队 then
            切换前角色.rpc:提示窗口('#Y对方未加入队伍!')
            return
        elseif not __玩家[切换后nid].是否助战 then
            切换前角色.rpc:提示窗口('#Y只有助战才可以切换!')
            return
        end
        if 切换前角色.nid == 切换后nid then
            return
        end
        切换开始[id] = true
        _连接[id] = nil
        _角色[id] = nil
        _连接[id] = 切换后连接
        _角色[id] = 切换后角色
        if _角色[id]:角色_助战切换(id, 切换前nid) then
            切换开始[id] = nil
            return true
        end
    end
end

local errorNum = 0
function REG:检测(id, 检测信息)
    if not 检测信息 then
        errorNum = errorNum + 1
    end

    if errorNum > 10 then
        os.exit()
    end

    if 检测信息.cpu ~= nil and 检测信息.cpu ~= __cpu_id then
        os.exit()
    end

    if 检测信息.serialnumberu ~= nil and 检测信息.serialnumberu ~= __serialnumberu_id then
        os.exit()
    end
end
