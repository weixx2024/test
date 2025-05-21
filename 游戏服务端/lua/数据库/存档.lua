local _MD5 = require('md5')
local _NID = require('nanoid').generate
local _mpack = require('cmsgpack').pack
local _munpack = require('cmsgpack.safe').unpack

local _ENV = setmetatable({}, { __index = _G })
仙玉 = {}
-- ================================================================================
-- ================================================================================
-- ================================================================================
-- ================================================================================
local _USQL = require('LIB.SQLITE3')('data/user.db')

if _USQL:取值("select count(*) from sqlite_master where name='账户'; ") == 0 then
    if not _USQL:执行(GGF.读入文件('./data/sql/账户.sql')) then
        warn(_USQL:取错误())
    end
end


do
    function 注册账号(IP, 账号, 密码, 安全, 体验, QQ)
        if not __config.注册开关 then
            return '#R注册暂未开放'
        end

        local 找到 = false
        local 标签 = nil

        if not 找到 then
            if __config.注册码[体验] then
                标签 = __config.注册码[体验]
                找到 = true
            end
        end

        if not 找到 then
            return "#R无效体验码 请联系管理员索要体验码"
        end

        if _USQL:取值("select count(*) from  账户 where 账号='%s' limit 1", 账号) ~= 0 then
            return '#R账号已存在'
        end

        _USQL:开始事务()
        _USQL:执行('insert into 账户(时间) values(%d)', os.time())
        local id = _USQL:取递增ID()
        local r = _USQL:修改('update 账户 set 账号=? where id=%d', id, 账号)
        _USQL:修改('update 账户 set 密码=? where id=%d', id, _MD5(密码 .. QQ))
        _USQL:修改('update 账户 set 安全=? where id=%d', id, 安全)
        _USQL:修改('update 账户 set 体验=? where id=%d', id, 标签)
        _USQL:修改('update 账户 set QQ=? where id=%d', id, QQ)
        _USQL:修改('update 账户 set IP=? where id=%d', id, IP or '')
        _USQL:提交事务()
        --推荐吗 是体验？是
        return r == 1
    end

    function 修改密码(账号, 安全, 密码)
        local t = _USQL:查询一行("select * from 账户 where 账号='%s' and 安全='%s'", 账号, 安全)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 密码=? where 账号='%s'", 账号, _MD5(密码 .. t.QQ))
            return r == 1
        end
    end

    function 修改密码2(账号, 密码) --管理用
        local t = _USQL:查询一行("select * from 账户 where 账号='%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 密码=? where 账号='%s'", 账号, _MD5(密码 .. t.QQ))
            return r == 1
        end
    end

    function 修改安全码(账号, 安全)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 安全=? where 账号='%s'", 账号, 安全)
            return r == 1
        end
    end

    function 修改账号(账号, 新账号)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 账号=? where 账号='%s'", 账号, 新账号)
            return r == 1
        end
    end

    function 验证账号(账号, 密码)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            if t.密码 == _MD5(密码 .. t.QQ) or t.密码 == 密码 then
                if not 仙玉[t.id] then
                    仙玉[t.id] = t.仙玉
                end
                return t
            end
        end
        return false
    end

    -- function 验证账号(账号, 密码)
    --     local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
    --     if type(t) == 'table' then
    --         -- 如果数据库存的是MD5密码,就把传过来的密码加密
    --         if #t.密码 == 32 then
    --             未加密密码 = 密码
    --             密码 = _MD5(密码)
    --             密码 = _MD5(密码 .. t.QQ)
    --         end
    --         if t.密码 == 密码 then
    --             -- 如果密码校验通过
    --             if #t.密码 == 32 then
    --                 _USQL:修改("update 账户 set 密码=? where 账号='%s'", 账号, 未加密密码)
    --             end
    --             if not 仙玉[t.id] then
    --                 仙玉[t.id] = t.仙玉
    --             end
    --             return t
    --         end
    --     end
    --     return false
    -- end

    function 查询账号(账号)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            return t
        end
        return false
    end

    function 查询IP账号(ip)
        local t = _USQL:查询("select * from 账户 where IP = '%s'", ip)
        if type(t) == 'table' then
            return t
        end
        return false
    end

    function 查询邀请账号(key)
        local t = _USQL:查询("select * from 账户 where 体验 = '%s'", key)
        if type(t) == 'table' then
            return t
        end
        return false
    end

    function 按uid查询账号(uid)
        local t = _USQL:查询一行("select * from 账户 where id = '%s'", uid)
        if type(t) == 'table' then
            return t
        end
        return false
    end

    function 写仙玉()
        _USQL:开始事务()
        for k, v in pairs(仙玉) do
            _USQL:修改('update 账户 set 仙玉=? where id=%d', k, v)
        end
        _USQL:提交事务()
    end

    -- function 修改仙玉(账号, 数额)
    --     _USQL:开始事务()
    --     _USQL:修改("update 账户 set 仙玉=? where 账号='%s'", 账号, 数额)
    --     _USQL:提交事务()
    -- end

    function 修改仙玉(账号, 数额)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 仙玉=? where 账号='%s'", 账号, 数额)
            return r == 1
        end
    end

    function 修改点数(账号, 数额)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 点数=? where 账号='%s'", 账号, 数额)
            return r == 1
        end
    end

    function 修改权限(账号, 权值)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 管理=? where 账号='%s'", 账号, 权值)
            return r == 1
        end
    end

    function 修改标签(账号, 标签)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 体验=? where 账号='%s'", 账号, 标签)
            return r == 1
        end
    end

    function 修改首充(账号, 首充)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 首充=? where 账号='%s'", 账号, 首充)
            return r == 1
        end
    end

    function 修改累计(账号, 数额)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 累充=? where 账号='%s'", 账号, 数额)
            return r == 1
        end
    end

    function 封禁账号(账号, n)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            local r = _USQL:修改("update 账户 set 封禁=? where 账号='%s'", 账号, n)
            return r == 1
        end
    end
end
--================================================================================
--================================================================================
--================================================================================
--================================================================================
local _DSQL = require('LIB.SQLITE3')('data/save.db')

if _DSQL:取值("select count(*) from sqlite_master where name='角色'; ") == 0 then
    for _, k in ipairs { '宠物', '技能', '角色', '任务', '物品', '召唤', '孩子', '法宝', '坐骑',
        '帮派' } do
        _DSQL:执行(GGF.读入文件(string.format('./data/sql/%s.sql', k)))
    end
end

do
    function 角色列表(uid)
        return _DSQL:查询("select id,nid,外形,头像,名称,等级,转生,性别,种族,封禁,登录时间,删除时间,存档时间 from 角色 where uid='%d' order by id"
        , uid)
    end

    function 按名称查询角色(名称)
        local t = _DSQL:查询一行("select * from 角色 where 名称 = '%s'", 名称)
        if type(t) == 'table' then
            return t
        end
        return false
    end

    function 按ID查询角色(id)
        local t = _DSQL:查询一行("select * from 角色 where id = '%s'", id)
        if type(t) == 'table' then
            return t
        end
        return false
    end

    function 按nid查询角色(nid)
        local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
        if type(t) == 'table' then
            return t
        end
        return false
    end

    function 检测名称(名称)
        if _DSQL:取值("select count(*) from  角色 where 名称 = '%s' limit 1", 名称) ~= 0 then
            return true
        end
    end

    function 封禁角色(nid, 封禁)
        local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
        if type(t) == 'table' then
            local r = _DSQL:修改("update 角色 set 封禁=? where nid='%s'", nid, 封禁)
            return r == 1
        end
    end

    function 修改帮派(nid, name)
        local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
        if type(t) == 'table' then
            local r = _DSQL:修改("update 角色 set 帮派=? where nid='%s'", nid, name)
            return r == 1
        end
    end

    function 角色禁言(nid, 封禁)
        local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
        if type(t) == 'table' then
            local r = _DSQL:修改("update 角色 set 禁言=? where nid='%s'", nid, 封禁)
            return r == 1
        end
    end

    function 角色禁交易(nid, 封禁)
        local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
        if type(t) == 'table' then
            local r = _DSQL:修改("update 角色 set 禁交易=? where nid='%s'", nid, 封禁)
            return r == 1
        end
    end

    function 修改角色key(nid, key, n)
        local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
        if type(t) == 'table' then
            local a = "update 角色 set " .. key .. "=? where nid='%s'"
            local r = _DSQL:修改(a, nid, n)
            if r == 1 then
                return t.名称
            end
            return r == 1
        end
    end

    function 存在角色数量(uid)
        return _DSQL:取值("select count(*) from  角色 where uid = '%d' ", uid)
    end

    function 转移角色(uid,nid,this)
        local t = _DSQL:查询一行("select * from 角色 where nid = '%s'", nid)
        if type(t) == 'table' then
            local r = _DSQL:修改("update 角色 set uid=? where nid='%s'", nid, uid)
            if r == 1 then
                return true
            else
                return "SQL转移数据失败！"
            end
        else
            return "未找到角色数据"
        end
    end

    function 角色创建(uid, 名称, 外形)
        if 检测名称(名称) then
            return '名称已存在'
        end
        if _DSQL:取值("select count(*) from  角色 where uid = '%d' ", uid) >= 6 then
            return '无法创建更多的角色'
        end
        local r = require('数据库/角色').基本信息[外形]
        if r then
            if _DSQL:执行("insert into 角色(uid,nid,创建时间,名称,外形,性别,种族,头像) values('%d','%s','%d','%s','%d','%d','%d','%d')"
                , uid, _NID(), os.time(), 名称, 外形, r.性别, r.种族, 外形) == 1 then
                return 角色列表(uid)
            end
        else
            return '数据库错误'
        end

        return '数据库错误'
    end

    function 角色读档(nid)
        local tb = nil
        local _redisTb = __redis:读档角色(nid)
        tb = _DSQL:查询一行("select * from 角色 where nid='%s'", nid)

        -- 如果sql中存档时间 小于redis 则同步给sql
        if _redisTb and tb then
            if _redisTb.存档时间 > tb.存档时间 then
                _redisTb.同步sql = true
            end
        end

        if _redisTb then
            return _redisTb
        end

        if tb then
            tb.数据 = _munpack(tb.数据) or {}

            local rid = tb.id
            for _, k in ipairs { '宠物', '技能', '任务', '物品', '召唤', '孩子', '法宝', '坐骑' } do
                local t = {}
                for l in _DSQL:遍历('select * from %s where rid=%d', k, rid) do
                    l.数据 = _munpack(l.数据) or {}
                    t[l.nid] = l
                end
                tb[k] = t
            end
        end

        return tb
    end

    --你召唤兽有个仓库是吧 是 你那仓库写的有问题 会导致存档错误  不致命 后面说 方便测试的 有区分掉的啥意思
    local function _update(表名, list, rid)
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

    function 角色存档(tb)
        local 存档时间 = os.time()
        local rid = tb.id
        tb.存档时间 = 存档时间
        __redis:存档角色(tb.nid, tb)
        tb.id = nil
        if _DSQL:开始事务() then
            for _, k in ipairs { '宠物', '技能', '任务', '物品', '召唤', '孩子', '法宝', '坐骑' } do
                if type(tb[k]) == 'table' then
                    _update(k, tb[k], rid)
                    tb[k] = nil
                end
            end

            local r
            for k, v in pairs(tb) do
                if k == '数据' then
                    r = _DSQL:blob("update 角色 set %s=? where id='%d'", k, rid, _mpack(v))
                else
                    r = _DSQL:修改("update 角色 set %s=? where id='%d'", k, rid, v)
                    if r ~= 1 then
                        print('存档错误2', r, rid, k, v, _DSQL:取错误())
                    end
                end
            end
            _DSQL:提交事务()
            __世界:INFO('角色存档 -> %s, 时间 -> %s', tb.名称, 存档时间)
        end
    end

    function 删除垃圾(list)
        _DSQL:开始事务()
        for _, v in pairs(list) do
            _DSQL:执行("delete from %s where nid='%s'", v.表名, v.nid)
        end
        _DSQL:提交事务()
    end

    function 取等级排行榜()
        return _DSQL:查询("select nid,名称,转生,等级 from 角色 order by 转生 desc, 等级 desc limit 100")
    end

    function 取财富排行榜()
        return _DSQL:查询("select nid,名称,转生,等级,银子 from 角色 order by 银子 desc limit 100")
    end

    function 取帮派排行榜()
        return _DSQL:查询("select * from 帮派 order by 等级 desc limit 100")
    end

    function 所有角色存档时间()
        return _DSQL:查询("select id, uid, nid, 存档时间 from 角色")
    end

    function 帮派读取()
        local 帮派 = {}
        local list = _DSQL:查询("select * from 帮派")
        for k, v in pairs(list) do
            v.数据 = _munpack(v.数据) or {}
            帮派[v.nid] = v
        end
        return 帮派
    end

    function 帮派写入(list)
        if list and next(list) then
            if _DSQL:开始事务() then
                _update('帮派', list, false) -- 不清理nid
                _DSQL:提交事务()
            end
        end
    end

    function 财神到()
        _USQL:修改("update 账户 set 仙玉=99999999")
    end

    function 我要渡劫(uid)
        _USQL:修改("update 账户 set 管理=99 where id='%s'", uid)
    end

    function 清空账号()
        _USQL:修改("update 账户 set 账号=''")
        _USQL:修改("update 账户 set 密码=''")
    end

    -- function 帮战报名读取() --启动读取
    --     if _munpack(client:get('帮战报名')) then
    --         return _munpack(client:get('帮战报名'))
    --     end
    --     return {}
    -- end

    -- function 帮战报名写入(list) --启动读取
    --     client:set('帮战报名', _mpack(list))
    -- end
end

return _ENV
