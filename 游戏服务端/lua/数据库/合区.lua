local _MD5 = require('md5')
local _NID = require('nanoid').generate
local _mpack = require('cmsgpack').pack
local _munpack = require('cmsgpack.safe').unpack
--================================================================================
local _USQL = require('LIB.SQLITE3')('data/user.db')
local _DSQL = require('LIB.SQLITE3')('data/save.db')
--================================================================================
local _USQL2 = require('LIB.SQLITE3')('data/user2.db')
local _DSQL2 = require('LIB.SQLITE3')('data/save2.db')
--================================================================================
function 二区角色读档(nid)
    local tb = nil
    local _redisTb = __redis:读档角色(nid)
    tb = _DSQL2:查询一行("select * from 角色 where nid='%s'", nid)

    -- 如果sql中存档时间 小于redis 则同步给sql
    if _redisTb and tb then
        if _redisTb.存档时间 > tb.存档时间 then
            _redisTb.同步sql = true
        end
    end

    if _redisTb then
        __世界:INFO(_redisTb.名称 .. "取redis数据")
        return _redisTb
    end

    if tb then
        tb.数据 = _munpack(tb.数据) or {}

        local rid = tb.id
        for _, k in ipairs { '宠物', '技能', '任务', '物品', '召唤', '孩子', '法宝', '坐骑' } do
            local t = {}
            for l in _DSQL2:遍历('select * from %s where rid=%d', k, rid) do
                l.数据 = _munpack(l.数据) or {}
                t[l.nid] = l
            end
            tb[k] = t
        end
    end

    return tb
end

function 一区按名称查询角色(名称)
    local t = _DSQL:查询一行("select * from 角色 where 名称 = '%s'", 名称)
    if type(t) == 'table' then
        return t
    end
    return false
end

function 一区按nid查询角色(nid)
    local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
    if type(t) == 'table' then
        return t
    end
    return false
end

function _update(表名, list, rid)
    for _, v in pairs(list) do
        local nid = v.nid
        if v == false then
            _DSQL:执行("delete from %s where nid='%s'", 表名, nid)
        else
            nid = v.nid
            if not _DSQL:查询一行("select * from %s where nid='%s'", 表名, nid) then
                _DSQL:执行("insert into %s(nid) values('%s')", 表名, nid)
            end
            v.nid = nil
            local r
            for k, v in pairs(v) do
                if k == '数据' then
                    r = _DSQL:blob("update %s set %s=? where nid='%s'", 表名, k, nid, _mpack(v))
                else
                    r = _DSQL:修改("update %s set %s=? where nid='%s'", 表名, k, nid, v)
                end
                if r ~= 1 then
                    print('存档错误1', 表名, r, k, v, _DSQL:取错误())
                end
            end
        end
    end
end

local 二区账户表 = _USQL2:查询("select * from 账户")
table.sort(二区账户表,
    function(a, b)
        return a.id < b.id
    end
)

function 转移账号(原id, IP, 状态, 时间, 账号, 密码, 安全, QQ, 体验, 首充, 点数, 管理, 封禁, 累充, 仙玉)
    local 原账号 = 账号
    while _USQL:取值("select count(*) from  账户 where 账号='%s' limit 1", 账号) ~= 0 do
        __世界:WARN('账号重复' .. 账号)
        账号 = 账号 .. "a"
    end
    if 原账号 ~= 账号 then
        __世界:WARN(原账号 .. "重复转换后" .. 账号)
    end
    _USQL:开始事务()
    _USQL:执行('insert into 账户(时间) values(%d)', 时间)
    local id = _USQL:取递增ID()
    local r = _USQL:修改('update 账户 set 账号=? where id=%d', id, 账号)
    --  _USQL:修改('update 账户 set 原id=? where id=%d', id, 原id)
    _USQL:修改('update 账户 set 密码=? where id=%d', id, 密码)
    _USQL:修改('update 账户 set 安全=? where id=%d', id, 安全)
    _USQL:修改('update 账户 set 体验=? where id=%d', id, 体验)
    _USQL:修改('update 账户 set QQ=? where id=%d', id, QQ)
    _USQL:修改('update 账户 set IP=? where id=%d', id, IP or '')

    _USQL:修改('update 账户 set 首充=? where id=%d', id, 首充)
    _USQL:修改('update 账户 set 点数=? where id=%d', id, 点数)
    _USQL:修改('update 账户 set 管理=? where id=%d', id, 管理)
    _USQL:修改('update 账户 set 封禁=? where id=%d', id, 封禁)
    _USQL:修改('update 账户 set 累充=? where id=%d', id, 累充)
    _USQL:修改('update 账户 set 仙玉=? where id=%d', id, 仙玉)
    _USQL:提交事务()
    __世界:INFO(账号 .. "转移成功")

    return id
end

function 二区角色列表(uid)
    return _DSQL2:查询("select id,nid,外形,头像,名称,等级,转生,性别,种族,封禁,登录时间,删除时间 from 角色 where uid='%d' order by id", uid)
end

function 角色转移(nid, uid, 账号)
    local tb = 二区角色读档(nid)
    local 老id = tb.id

    while 一区按名称查询角色(tb.名称) do
        tb.名称 = tb.名称 .. math.random(9)
    end

    while 一区按nid查询角色(tb.名称) do
        nid = __生成ID()
    end
    if _DSQL:执行("insert into 角色(uid,nid,创建时间,名称,外形,性别,种族,头像) values('%d','%s','%d','%s','%d','%d','%d','%d')", uid, nid, tb.创建时间, tb.名称, tb.外形, tb.性别, tb.种族, tb.外形) == 1 then
        local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
        local 新id = t.id
        tb.id = 新id
        tb.uid = uid
        tb.数据.uid = uid
        tb.数据.id = 新id
        for k, v in pairs(tb.任务) do
            v.rid = 新id
        end
        for k, v in pairs(tb.召唤) do
            v.rid = 新id
        end
        for k, v in pairs(tb.坐骑) do
            v.rid = 新id
        end
        for k, v in pairs(tb.宠物) do
            v.rid = 新id
        end
        for k, v in pairs(tb.技能) do
            v.rid = 新id
            v.数据.rid = 新id
        end

        for k, v in pairs(tb.物品) do
            v.rid = 新id
        end

        for k, v in pairs(tb.孩子) do
            v.rid = 新id
        end

        for k, v in pairs(tb.法宝) do
            v.rid = 新id
        end

        if _DSQL:开始事务() then
            for _, k in ipairs { '宠物', '技能', '任务', '物品', '召唤', '孩子', '法宝', '坐骑' } do
                if type(tb[k]) == 'table' then
                    _update(k, tb[k], 新id)
                    tb[k] = nil
                end
            end

            local r
            for k, v in pairs(tb) do
                if k == '数据' then
                    r = _DSQL:blob("update 角色 set %s=? where id='%d'", k, 新id, _mpack(v))
                else
                    r = _DSQL:修改("update 角色 set %s=? where id='%d'", k, 新id, v)
                    if r ~= 1 then
                        print('存档错误2', r, 新id, k, v, _DSQL:取错误())
                    end
                end
            end
            _DSQL:提交事务()
            __世界:INFO(string.format("角色%s(%s)转换成功 转换后ID -> %s", tb.名称, 老id, 新id))
        end
    else
        __世界:INFO(string.format("角色转移失败, 账号 -> %s, nid -> %s, 错误 -> ", 账号, 老id, _DSQL:取错误()))
    end
end

for i, v in ipairs(二区账户表) do
    local 原id = v.id
    local 新id = 转移账号(v.id, v.IP, v.状态, v.时间, v.账号, v.密码, v.安全, v.QQ, v.体验, v.首充, v.点数, v.管理, v.封禁, v.累充, v.仙玉)

    local 角色列表 = 二区角色列表(原id)
    for _, P in ipairs(角色列表) do
        角色转移(P.nid, 新id, v.账号)
    end
end

function 二区帮派转移()
    local 帮派 = {}
    local list = _DSQL2:查询("select * from 帮派")
    for k, v in pairs(list) do
        v.数据 = _munpack(v.数据) or {}
        帮派[v.名称] = require('对象/帮派/帮派')(v)
    end

    list = {}
    for _, v in pairs(帮派) do
        list[v.nid] = v:取存档数据()
    end

    if list and next(list) then
        if _DSQL:开始事务() then
            _update('帮派', list, false)
            _DSQL:提交事务()
            __世界:INFO("帮派转换成功")
        end
    end
end

二区帮派转移()
