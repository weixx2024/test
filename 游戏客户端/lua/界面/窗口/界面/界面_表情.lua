

local 表情 = 窗口层:创建我的窗口('表情', 0, 0, 530, 420)
do
    function 表情:初始化()
        self:置精灵(
            生成精灵(
                530,
                420,
                function()
                    self:取拉伸图像_宽高('gires/main/message_box2.png', 530, 420):显示(0, 0)
                end
            )
        )
        self:置坐标((引擎.宽度 - self.宽度) // 2, 引擎.高度 - 460)
        self.emote = {}
        -- self.fonts = {默认 = __res.F14, 宋体 = __res.F14}
        for id = 0, 211 do
            local tca = __res:get('gires/emote/%02d.tca', id)
            if tca then --and tca.frame > 1
                local ani = tca:取动画(1)
                ani:置帧率(1 / 5)
                self.emote[id] = ani:播放(true)
                -- ani:置中心(-ani.资源.x, -ani.资源.y + ani.高度)
            end
        end
        self.页数 = 1
    end

    local data = {
        {
            { a = 0, b = 63 },
            { a = 74, b = 99 }
        },
        {
            { a = 101, b = 113 },
            { a = 117, b = 153 },
            { a = 184, b = 211 }
        }
    }
    local by = { 55, 63 }

    function 表情:更新(dt)
        for k, v in pairs(data[self.页数]) do
            for i = v.a, v.b do
                self.emote[i]:更新(dt)
            end
        end
    end

    function 表情:显示(x, y)
        local h = 0
        local l = 0
        for k, v in pairs(data[self.页数]) do
            for i = v.a, v.b do
                l = l + 1
                if l > 10 then
                    h = h + 1
                    l = 1
                end
                self.emote[i]:显示(x + 8 + h * by[self.页数], y + l * 39)
            end
        end
    end

    function 表情:左键弹起(x, y, a, b)
        for k, v in pairs(data[self.页数]) do
            for i = v.a, v.b do
                if self.emote[i] and self.emote[i]:检查点(a, b) then
                    GUI:取输入焦点():添加文本('#' .. i)
                    self:置可见(false)
                    return
                end
            end
        end
    end
end

local 按钮 = 表情:创建按钮('关闭按钮', -20, 0)
function 按钮:初始化(v)
    local tcp = __res:get('gires/0x9CF17792.tcp')
    self:置正常精灵(tcp:取精灵(1):置中心(x or 0, y or 0))
    self:置按下精灵(tcp:取精灵(2):置中心(x or 0, y or 0))
    self:置经过精灵(tcp:取精灵(3):置中心(x or 0, y or 0))
end

function 按钮:左键弹起()
    self.父控件:置可见(false)
end

local 上一页按钮 = 表情:创建按钮('上一页按钮', 195, 391)
function 上一页按钮:初始化()
    self:置正常精灵(
        生成精灵(
            60,
            25,
            function()
                self:取拉伸图像_宽高('gires/main/message_box2.png', 60, 25):显示(0, 0)
                __res.JMZ:取图像('上一页'):显示(4, 4)
            end
        )
    )
    self:置按下精灵(
        生成精灵(
            60,
            25,
            function()
                self:取拉伸图像_宽高('gires/main/message_box2.png', 60, 25):显示(0, 0)
                __res.JMZ:取图像('上一页'):显示(5, 5)
            end
        )
    )
    self:置经过精灵(
        生成精灵(
            60,
            25,
            function()
                self:取拉伸图像_宽高('gires/main/message_box2.png', 60, 25):显示(0, 0)
                __res.JMZ:取图像('上一页'):显示(4, 4)
            end
        )
    )
end

function 上一页按钮:左键弹起()
    表情.页数 = 1
    表情.上一页按钮:置可见(false)
    表情.下一页按钮:置可见(true)
end

local 下一页按钮 = 表情:创建按钮('下一页按钮', 292, 391)

function 下一页按钮:初始化()
    self:置正常精灵(
        生成精灵(
            60,
            25,
            function()
                self:取拉伸图像_宽高('gires/main/message_box2.png', 60, 25):显示(0, 0)
                __res.JMZ:取图像('下一页'):显示(4, 4)
            end
        )
    )
    self:置按下精灵(
        生成精灵(
            60,
            25,
            function()
                self:取拉伸图像_宽高('gires/main/message_box2.png', 60, 25):显示(0, 0)
                __res.JMZ:取图像('下一页'):显示(5, 5)
            end
        )
    )
    self:置经过精灵(
        生成精灵(
            60,
            25,
            function()
                self:取拉伸图像_宽高('gires/main/message_box2.png', 60, 25):显示(0, 0)
                __res.JMZ:取图像('下一页'):显示(4, 4)
            end
        )
    )
end

function 下一页按钮:左键弹起()
    表情.页数 = 2
    表情.上一页按钮:置可见(true)
    表情.下一页按钮:置可见(false)
end

function 窗口层:打开表情()
    表情:置可见(not 表情.是否可见)
    if not 表情.是否可见 then
        return
    end

    if 表情.页数 == 1 then
        表情.上一页按钮:置可见(false)
        表情.下一页按钮:置可见(true)
    else
        表情.上一页按钮:置可见(true)
        表情.下一页按钮:置可见(false)
    end
end

--窗口层:打开表情()
return 表情
