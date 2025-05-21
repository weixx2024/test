local 角色 = require('角色')
function 角色:日志_初始化()
    if self.是否机器人 then
        return
    end
    self.行为记录 = {}
    self.寄售记录 = {}
    self.交易记录 = {}
    self.仙玉记录 = {}
    self.银子记录 = {}
    if self.管理 > 0 then
        if not GGF.判断文件('管理日志/' .. self.账号 .. '/') then
            GGF.写出文件('管理日志/' .. self.账号 .. '/')
        end
        local file2 = string.format("管理日志/%s/%s.log", self.账号, os.date('%Y-%m-%d', os.time()))
        self._file2 = assert(io.open(file2, 'a+'), '打开失败')
        self._file2:setvbuf("no", 0)
        -- if not GGF.判断文件('data/gm/' .. self.账号 .. '/') then
        --     GGF.写出文件('data/gm/' .. self.账号 .. '/')
        -- end
        -- local file3 = string.format("data/gm/%s/%s.log", self.账号, os.date('%Y-%m-%d', os.time()))
        -- self._file3 = assert(io.open(file3, 'a+'), '打开失败')
        -- self._file3:setvbuf("no", 0)
    end
end

function 角色:日志_记录(...)
    if self.是否机器人 then
        return
    end
    self:LOG_角色(...)
end

function 角色:日志_寄售记录(msg, ...)
    if self.是否机器人 then
        return
    end
    if select('#', ...) > 0 then
        msg = msg:format(...)
    end
    table.insert(self.寄售记录, tostring(msg))
end

function 角色:日志_银子记录(msg, ...)
    if self.是否机器人 then
        return
    end
    if select('#', ...) > 0 then
        msg = string.format("[%s]", os.date('%Y-%m-%d-%H-%M', os.time())) .. msg:format(...)
    end
    table.insert(self.银子记录, tostring(msg))
end

function 角色:日志_交易记录(msg, ...)
    if self.是否机器人 then
        return
    end
    if select('#', ...) > 0 then
        msg = string.format("[%s]", os.date('%Y-%m-%d-%H-%M', os.time())) .. msg:format(...)
    end
    table.insert(self.交易记录, tostring(msg))
end

function 角色:日志_仙玉记录(msg, ...)
    if self.是否机器人 then
        return
    end
    if select('#', ...) > 0 then
        msg = string.format("[%s]", os.date('%Y-%m-%d-%H-%M', os.time())) .. msg:format(...)
    end
    table.insert(self.仙玉记录, tostring(msg))
end

function 角色:GM_输入日志(...)
    if self.是否机器人 then
        return
    end
    self:LOG_管理(...)
    self.rpc:添加管理日志(...)
end

function 角色:LOG_角色(msg, ...)
    if self.是否机器人 then
        return
    end
    if select('#', ...) > 0 then
        msg = string.format("[%s]", os.date('%Y-%m-%d-%H-%M', os.time())) .. msg:format(...)
    end
    table.insert(self.行为记录, tostring(msg))
end

function 角色:日志_下线()
    if self.是否机器人 then
        return
    end
    if #self.行为记录 > 0 then
        local file = string.format("角色日志/%s/%s/%s.log", self.账号, self.id,
            os.date('%Y-%m-%d-%H-%M', os.time()))
        GGF.写出文件(file, table.concat(self.行为记录, '\n'))
    end
    if #self.寄售记录 > 0 then
        local file = string.format("寄售日志/%s/%s/%s.log", self.账号, self.id,
            os.date('%Y-%m-%d-%H-%M', os.time()))
        GGF.写出文件(file, table.concat(self.寄售记录, '\n'))
    end
    if #self.银子记录 > 0 then
        local file = string.format("银子日志/%s/%s/%s.log", self.账号, self.id,
            os.date('%Y-%m-%d-%H-%M', os.time()))
        GGF.写出文件(file, table.concat(self.银子记录, '\n'))
    end
    if #self.交易记录 > 0 then
        local file = string.format("交易日志/%s/%s/%s.log", self.账号, self.id,
            os.date('%Y-%m-%d-%H-%M', os.time()))
        GGF.写出文件(file, table.concat(self.交易记录, '\n'))
    end
    if #self.仙玉记录 > 0 then
        local file = string.format("仙玉日志/%s/%s/%s.log", self.账号, self.id,
            os.date('%Y-%m-%d-%H-%M', os.time()))
        GGF.写出文件(file, table.concat(self.仙玉记录, '\n'))
    end
end

function 角色:LOG_管理(msg, ...)
    if self.是否机器人 then
        return
    end
    ggexpcall(
        function(...)
            if select('#', ...) > 0 then
                msg = msg:format(...)
            end
            local time = os.time()
            --  cprint(string.format('[%s] %s', os.date('%X', time), tostring(msg)))
            if self._file2 then
                self._file2:write(string.format('[%s]  %s\n', os.date('%X', time), tostring(msg)))
            end
            -- if self._file3 then
            --     self._file3:write(string.format('[%s]  %s\n', os.date('%X', time), tostring(msg)))
            -- end
        end,
        ...
    )
end
