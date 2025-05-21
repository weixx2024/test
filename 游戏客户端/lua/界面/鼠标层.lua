

function 鼠标层:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)

    self.cursor = {}

    for i = 97, 118 do
        self.cursor[i - 96] = __res:getani('gires/cursor/%s.tca', string.char(i))
        if self.cursor[i - 96] then
            self.cursor[i - 96]:播放(true)
        end
    end
    self.cursor.上下箭头 = __res:getani('gires3/button/sxjt.tcp'):播放(true)
    self.是否正常 = true
    self.cur = self.cursor[1]
end

function 鼠标层:更新(dt)
    if self.附加 and self.附加.更新 then
        self.附加:更新(dt)
    end
    if self.cur and self.cur.更新 then
        self.cur:更新(dt)
    end
end

function 鼠标层:显示(x, y)
    if self.附加 then
        self.附加:显示(x, y)
    end
    if self.cur then
        self.cur:显示(x, y)
    end
end

function 鼠标层:消息事件(msg)
    if msg.鼠标 then
        for _, v in ipairs(msg.鼠标) do
            if v.type == SDL.MOUSE_MOTION then --鼠标移动时清空
                if self.附加 and self.附加.移动 then
                    self.附加:移动()
                elseif self.是否手指 or self.是否输入 or self.是否手指 or self.是否拉伸 then
                    self:正常形状()
                end
            elseif v.type == SDL.MOUSE_UP then
                if v.button == SDL.BUTTON_RIGHT then
                    if self.附加 then
                        self.附加:返回()
                        self.附加 = nil
                        v.type = nil
                    elseif not self.是否正常 then
                        self:正常形状()
                        v.type = nil
                    end

                    break
                end
            end
        end
    end
end

local function _def(self, id, hide)
    for _, k in ipairs {
        '是否正常',
        '是否输入',
        '是否手指',
        '是否禁止',
        '是否组队',
        '是否好友',
        '是否交易',
        '是否法术',
        '是否给予',
        '是否攻击',
        '是否保护',
        '是否道具',
        '是否捕捉',
        '是否拉伸'
    } do
        self[k] = false
    end
    self.cur = self.cursor[id]
    if hide then
        界面层:置可见(false)
        窗口层:置可见(false)
    end
end

function 鼠标层:正常形状()
    _def(self, 1)
    self.是否正常 = true
    if not 登录层.是否可见 then
        界面层:置可见(true)
        窗口层:置可见(true)
    end
end

function 鼠标层:输入形状()
    if self.是否正常 ~= true or self.附加 then
        return
    end
    _def(self, 2)
    self.是否正常 = true
    self.是否输入 = true
end

function 鼠标层:手指形状()
    if (self.是否正常 ~= true and self.是否拉伸 ~= true) or self.附加 then
        return
    end
    _def(self, 3)
    self.是否正常 = true --因为在按钮上
    self.是否手指 = true
end

function 鼠标层:禁止形状()
    _def(self, 4)
    self.是否禁止 = true
end

function 鼠标层:组队形状(v)
    if not self.是否组队 and (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 5 or 4, true)
    self.是否组队 = true
end

function 鼠标层:好友形状(v)
    if not self.是否好友 and (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 7 or 6, true)
    self.是否好友 = true
end

function 鼠标层:交易形状(v)
    if not self.是否交易 and (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 9 or 8, true)
    self.是否交易 = true
end

function 鼠标层:法术形状(v)
    if not self.是否法术 and (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 11 or 10)
    self.是否禁止 = not v
    self.是否法术 = true
end

function 鼠标层:给予形状(v)
    if not self.是否给予 and (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 13 or 12, true)
    self.是否给予 = true
end

function 鼠标层:攻击形状(v)
    if (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 15 or 14)
    self.是否禁止 = not v
    self.是否攻击 = true
end

function 鼠标层:保护形状(v)
    if not self.是否保护 and (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 17 or 16, true)
    self.是否禁止 = not v
    self.是否保护 = true
end

function 鼠标层:道具形状(v)
    if not self.是否道具 and (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 19 or 18, true)
    self.是否禁止 = not v
    self.是否道具 = true
end

function 鼠标层:捕捉形状(v)
    if not self.是否捕捉 and (self.是否正常 ~= true or self.附加) then
        return
    end
    _def(self, v and 21 or 20, true)
    self.是否禁止 = not v
    self.是否捕捉 = true
end

function 鼠标层:拉伸形状()
    if self.是否正常 ~= true or self.附加 then
        return
    end
    _def(self, '上下箭头')
    self.是否拉伸 = true
end

return 鼠标层:置可见(true)
