local addon_name, RR = ...

-- Constants
local C = {
    EffectID        = 168657, -- 163267,
    ItemID          = 112384,
    BuffSearchCount = 40,
    DurationMargin  = 2, -- 30,
    PopupName       = "RR_EXPIRATION_POPUP" 
}

-- Functions
local get_effect_expiration = function(unit, effect_id)
    for i = 1, C.BuffSearchCount do
        local name, _, _, _, _, expiration, _, _, _, id = UnitBuff(unit, i)
        if id == effect_id then
            return expiration
        end
    end
    return nil
end

local is_effect_about_to_expire = function(unit, effect_id, margin)
    local expiration = get_effect_expiration(unit, effect_id)
    if not expiration then
        return nil
    end
    return expiration - GetTime() < margin
end

-- Dialog
StaticPopupDialogs[C.PopupName] = {
    text           = "Your reflecting prism is about to run out.",
    button1        = "Yes",
    button2        = "Yes (but on another button)",
    OnAccept       = popup_accept,
    OnCancel       = popup_cancel,
    timeout        = C.DurationMargin,
    whileDead      = false,
    hideOnEscape   = false
}

-- Events and update
local event_frame = CreateFrame("Frame", "RR_EVENT_FRAME", nil)

event_frame:RegisterEvent "ADDON_LOADED"
event_frame:RegisterEvent "UNIT_AURA"

event_frame.OnUpdate = function(self, dt)
    
end

event_frame.OnEvent = function(self, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == addon_name then
        
    elseif event == "UNIT_AURA" and arg1 == "player" then
        
    end
end

event_frame:SetScript("OnUpdate", event_frame.OnUpdate)
event_frame:SetScript("OnEvent",  event_frame.OnEvent)

-- Testing
RR_API = {
    C                     = C,
    GetEffectExpiration   = get_effect_expiration,
    IsEffectAboutToExpire = is_effect_about_to_expire
}
