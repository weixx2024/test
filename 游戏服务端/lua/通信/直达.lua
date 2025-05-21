local _过滤操作 = {}
_过滤操作.角色_移动开始 = true
_过滤操作.角色_移动更新 = true
_过滤操作.角色_移动结束 = true

do
    function SVR:绑定角色()
        for k, v in pairs(require('对象/角色/角色')) do
            if k:sub(1, 6) == '角色' then
                REG[k] = function(_, id, ...)
                    if _角色[id] then
                        -- if gge.isdebug then
                        --     if not _过滤操作[k] then
                        --         print("接口访问：", k)
                        --     end
                        -- end

                        local r = { ggexpcall(v, _角色[id], ...) }
                        if r[1] == gge.FALSE then
                            _角色[id].rpc:提示窗口('#R崩了#15')
                        else
                            return table.unpack(r)
                        end
                    end
                end
            end
        end
    end
    SVR:绑定角色()
    function SVR:绑定召唤()
        for k, v in pairs(require('对象/召唤/召唤')) do
            if k:sub(1, 6) == '召唤' then
                REG[k] = function(_, id, nid, ...)
                    if _角色[id] then
                        if __召唤[nid] then
                            local r = { ggexpcall(v, __召唤[nid], ...) }
                            if r[1] == gge.FALSE then
                                _角色[id].rpc:提示窗口('#R崩了#15')
                            else
                                return table.unpack(r)
                            end
                        else
                            __世界:print('召唤不存在', nid)
                        end
                    end
                end
            end
        end
    end
    SVR:绑定召唤()
    function SVR:绑定宠物()
        for k, v in pairs(require('对象/宠物')) do
            if k:sub(1, 6) == '宠物' then
                REG[k] = function(_, id, nid, ...)
                    if _角色[id] then
                        if __宠物[nid] then
                            return ggexpcall(v, __宠物[nid], ...)
                        else
                            __世界:print('宠物不存在', nid)
                        end
                    end
                end
            end
        end
    end

    SVR:绑定宠物()

    function SVR:绑定坐骑()
        for k, v in pairs(require('对象/坐骑/坐骑')) do
            if k:sub(1, 6) == '坐骑' then
                REG[k] = function(_, id, nid, ...)
                    if _角色[id] then
                        if __坐骑[nid] then
                            local r = { ggexpcall(v, __坐骑[nid], ...) }
                            if r[1] == gge.FALSE then
                                _角色[id].rpc:提示窗口('#R崩了#15')
                            else
                                return table.unpack(r)
                            end
                        else
                            __世界:print('坐骑不存在', nid)
                        end
                    end
                end
            end
        end
    end

    SVR:绑定坐骑()

    function SVR:绑定孩子()
        for k, v in pairs(require('对象/孩子/孩子')) do
            if k:sub(1, 6) == '孩子' then
                REG[k] = function(_, id, nid, ...)
                    if _角色[id] then
                        if __孩子[nid] then
                            local r = { ggexpcall(v, __孩子[nid], ...) }
                            if r[1] == gge.FALSE then
                                _角色[id].rpc:提示窗口('#R崩了#15')
                            else
                                return table.unpack(r)
                            end
                        else
                            __世界:print('孩子不存在', nid)
                        end
                    end
                end
            end
        end
    end

    SVR:绑定孩子()
end
