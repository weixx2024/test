local 角色 = require('角色')

function 角色:进入观战(对象)
    if not 对象.是否战斗 then
        return
    end
    local 战斗 = 对象.战斗
    if not 战斗 then
        return
    end
    local 战场 = 战斗.战场
    if not 战场 then
        return
    end
    self.是否观战 = true
    self.观战 = 对象
    self.观战.战场 = 战场
    战场:加入观战(self)

    local 位置 = 战斗.位置
    local 回合数 = 战场.回合数
    local data = 战场:取数据(位置)
    local 数据 = 战场._数据

    self.rpc:进入战斗(data, 位置, 回合数, true, 数据)
    self.rpn:添加状态(self.nid, 'vs') --周围
end

function 角色:删除观战()
    if self.是否观战 then
        if self.观战 then
            local 战场 = self.观战.战场
            if 战场 then
                战场:退出观战(self)
            end
        end
    end
end

function 角色:角色_退出观战()
    if self.是否观战 then
        self.rpc:退出战斗()
        self.是否PK = false
        self.是否观战 = false
        self.是否战斗 = false

        self.rpn:删除状态(self.nid, 'vs') --周围

        self.观战 = nil
    end
end

function 角色:退出观战()
    if self.是否观战 then
        self.rpc:退出战斗()
        self.是否PK = false
        self.是否观战 = false
        self.是否战斗 = false

        self.rpn:删除状态(self.nid, 'vs') --周围

        self.观战 = nil
    end
end
