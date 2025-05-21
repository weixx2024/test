local 公告栏 = 界面层:创建控件('公告控件', 0, 50, 引擎.宽度, 25)
function 公告栏:初始化()
    self:置宽高(引擎.宽度, 25)
    if not self.内容 then
        self.内容 = {}
        self.开关 = false
    end

end

local 文本 = 公告栏:创建我的文本("内容文本", 0, 0, 引擎.宽度+100, 25)
function 公告栏:重新初始化()
    self:置宽高(引擎.宽度, 25)
    if self.开关 then
        self:置精灵(require('SDL.精灵')(0, 0, 0, self.宽度, 25):置颜色(0, 0, 0, 200))
    end
    文本:置宽高(self.宽度, 25)
end

function 公告栏:更新(dt)
    if not self.开关 and #self.内容 > 0 then
        self:开启播放()
    end
    if self.开关 then
        self.i = self.i - 1
        文本:置中心(-self.i, 0)
        if self.i + self.ww <= 0 then
            self:播放完一条()
        end
    end
end

function 公告栏:显示(x, y)

end

function 公告栏:播放完一条()
    文本:置文本("")
    文本:置中心(-self.宽度, 0)
    self.开关 = false
    if #self.内容 == 0 then
        self:置精灵()
    end
end

function 公告栏:开启播放()
    self.ww = 文本:置文本(self.内容[1])
    文本:置中心(-self.宽度, 0)
    self.i = self.宽度
    self.开关 = true
    table.remove(self.内容, 1)


end

function 公告栏:添加内容(txt)
    if not self._spr then
        self:置精灵(require('SDL.精灵')(0, 0, 0, self.宽度, 25):置颜色(0, 0, 0, 200))
    end

    table.insert(self.内容, txt)
end

function 界面层:添加公告(txt, ...)
    if select('#', ...) > 0 then
        txt = txt:format(...)
    end

    公告栏:添加内容(txt)
end

function RPC:界面信息_公告(txt, ...)
    if type(txt) == 'string' then
        界面层:添加公告(txt, ...)
    end
end

return 公告栏
