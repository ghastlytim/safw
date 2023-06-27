--[[
    open source, enjoy!
    example usage:
    
    local notification = loadstring(game:HttpGet('https://raw.githubusercontent.com/boop71/cappuccino/main/v3/notification.lua'))()
    notification({
        Title = 'Cappuccino',
        Text = 'very cool notification for gaming',
        Image = 'rbxassetid://6353325673',    --optional
        Options = {                           --optional 
            'Yes',
            'No',
            'Cheese',
            'Cancel',
        },
        CloseOnCallback = true,               --optional
        Duration = 10,                        --optional
        Callback = function(o)
            print('Option '..o..' was chosen')
        end,
    })
]]

local function instance(className,properties,children)
    local object = Instance.new(className,parent)

    for i, v in pairs(properties or {}) do
        object[i] = v
    end

    for i, self in pairs(children or {}) do
        self.Parent = object
    end

    return object
end
local function ts(object,tweenInfo,properties)
    if tweenInfo[2] and typeof(tweenInfo[2]) == 'string' then
        tweenInfo[2] = Enum.EasingStyle[ tweenInfo[2] ]
    end

    game:service('TweenService'):create(object, TweenInfo.new(unpack(tweenInfo)), properties):Play()
end
local function clone(self,newProperties,children)
    local clone = self:Clone()

    for property,value in next, (newProperties or {}) do
        clone[property] = value
    end

    for _,module in next, (children or {}) do
        module.Parent = clone
    end

    return clone
end
local function udim2(x1,x2,y1,y2)
    local t = tonumber
    return UDim2.new(t(x1),t(x2),t(y1),t(y2))
end
local function rgb(r,g,b)
    return Color3.fromRGB(r,g,b)
end
local function round(exact, quantum)
    local quant, frac = math.modf(exact/quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end
local function border(self,borderSize,additional)
    borderSize = math.floor(borderSize / 2) == borderSize / 2 and borderSize or borderSize + 1

    local border = clone(self,{
        Parent = self,
        Position = udim2(0,borderSize/2,0,borderSize/2),
        Size = udim2(1,-borderSize,1,-borderSize)
    })

    if border:FindFirstChild('UICorner') then
        self.UICorner:GetPropertyChangedSignal('CornerRadius'):connect(function()
            border.UICorner.CornerRadius = UDim.new(self.UICorner.CornerRadius.Scale, self.UICorner.CornerRadius.Offset - 1)
        end)

        border.UICorner.CornerRadius = UDim.new(self.UICorner.CornerRadius.Scale, self.UICorner.CornerRadius.Offset - 1)
    end

    for property,value in next, (additional or {}) do
        border[property] = value
    end

    return border
end


if not game.CoreGui:FindFirstChild('notifications') then
    instance('ScreenGui',{
        Parent = game.CoreGui,
        Name = 'notifications'
    },{
        instance('Frame',{
            Size = udim2(0,20,1,36),
            Position = udim2(0,0,0,-36),
            BackgroundTransparency = 1,
        },{
            instance('UIListLayout',{
                VerticalAlignment = 'Bottom',
            })
        })
    })
end

local frame = game.CoreGui.notifications.Frame

function notify(t)
    local textSize = game:service('TextService'):GetTextSize(tostring(t.Text),14,'Gotham',Vector2.new(math.huge,70))

    local notifyFrame = instance('Frame',{
        Parent = frame,
        Size = udim2(0,2000,0,0),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    local function close()
        ts(notifyFrame,{0.3,'Sine'},{
            Size = udim2(0,2000,0,0)
        })

        wait(0.35)
        notifyFrame:Destroy()
    end

    local realSize = (t.Image and textSize.X + 90 or textSize.X + 26)
    local body = instance('Frame',{
        Size = udim2(0,realSize > 150 and realSize or 150,0,70),
        Position = udim2(0,5,0,5),
        BackgroundColor3 = rgb(23,23,23),
        Parent = notifyFrame
    },{
        instance('UICorner',{
            CornerRadius = UDim.new(0,3)
        })
    })

    local main = instance('Frame',{
        Parent = body,
        Size = udim2(1,-12,1,-12),
        Position = udim2(0,6,0,6),
        BackgroundTransparency = 1,
    })
    
    if t.Image then
        local image = instance('ImageLabel',{
            Parent = main,
            Image = t.Image,
            BackgroundTransparency = 1,
            Size = udim2(0,58,0,58),
        },{
            instance('UICorner',{
                CornerRadius = UDim.new(0,3)
            })
        })   
    end

    local textFrame = instance('Frame',{
        Parent = main,
        Size = udim2(1,t.Image and -64 or 0,1,0),
        Position = udim2(0, t.Image and 64 or 0,0,0),
        BackgroundColor3 = rgb(33,33,33),
    },{
        instance('UICorner',{
            CornerRadius = UDim.new(0,3),
        }),
        instance('UIGradient',{
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0,0),
                NumberSequenceKeypoint.new(0.45,1),
                NumberSequenceKeypoint.new(1,1)
            }),
            Rotation = 6
        }),
        instance('TextLabel',{
            Position = udim2(0,4,0,1),
            Size = udim2(1,-4,0,20),
            Text = tostring(t.Title),
            BackgroundTransparency = 1,
            Font = 'GothamSemibold',
            TextColor3 = rgb(180,180,180),
            TextXAlignment = 'Left',
            TextSize = 14,
        }),
        instance('TextLabel',{
            Position = udim2(0,4,0,not t.Options and 27 or 20),
            BackgroundTransparency = 1,
            Text = tostring(t.Text),
            TextColor3 = rgb(255,255,255),
            Font = 'Gotham',
            TextSize = 14,
            Size = udim2(1,-4,1,-36),
            TextXAlignment = 'Left'
        })
    })

    if t.Duration and typeof(t.Duration) == 'number' then
        local durationText = instance('TextLabel',{
            Parent = textFrame,
            Text = math.floor(t.Duration),
            BackgroundTransparency = 1,
            TextColor3 = rgb(120,120,120),
            Font = 'Gotham',
            TextSize = 12,
            Size = udim2(0,60,0,20),
            Position = udim2(1,-64,0,0),
            TextXAlignment = 'Right',
        })

        spawn(function()
            wait(0.6)

            t.Duration = math.floor(t.Duration)

            spawn(function()
                while true do
                    t.Duration = t.Duration - 1
                    durationText.Text = t.Duration
                    if t.Duration <= 0 then
                        close()
                        break
                    end
                    wait(1)
                end
            end)
        end)
    end

    if t.Options then
        local barSize = game:service('TextService'):GetTextSize(table.concat(t.Options),11,'Gotham',Vector2.new(math.huge,14))
        local optionBar = instance('Frame',{
            Parent = textFrame,
            Size = udim2(0,((barSize.X + 80) + (6 * #t.Options)),0,14),
            Position = udim2(0,0,1,-14),
            BackgroundColor3 = rgb(66,66,66),
        },{
            instance('UICorner',{
                CornerRadius = UDim.new(0,3),
            }),
            instance('UIListLayout',{
                FillDirection = 'Horizontal',
            }),
            instance('UIGradient',{
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0,0),
                    NumberSequenceKeypoint.new(0.7,0.6),
                    NumberSequenceKeypoint.new(1,1)
                }),
                Rotation = 6
            })
        })

        for a,v in next, t.Options do
            v = tostring(v)
            local buttonSize = game:service('TextService'):GetTextSize(v,11,'Gotham',Vector2.new(math.huge,14))
            local button = instance('TextButton',{
                Parent = optionBar,
                Size = udim2(0,buttonSize.X + 6,1,0),
                Text = v,
                TextColor3 = rgb(130,130,130),
                TextSize = 11,
                Font = 'Gotham',
                BackgroundTransparency = 1,
            })

            button.MouseEnter:connect(function()
                ts(button,{0.3,'Sine'},{
                    TextColor3 = rgb(255,255,255)
                })
            end)
            button.MouseLeave:connect(function()
                ts(button,{0.3,'Sine'},{
                    TextColor3 = rgb(130,130,130)
                })
            end)
            button.MouseButton1Click:connect(function()
                t.Callback(v)

                if t.CloseOnCallback then
                    close()
                end
            end)
        end
    end

    ts(notifyFrame,{0.3,'Sine'},{
        Size = udim2(0,2000,0,80)
    })
end

return notify
