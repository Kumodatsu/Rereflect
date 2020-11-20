local addon_name, RR = ...

-- Constants
local C = {
    EffectID        = 163267, -- 168657,
    ItemID          = 112384,
    ItemName        = "Reflecting Prism",
    BuffSearchCount = 40,
    DurationMargin  = 30, -- 2
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

local is_about_to_expire = function(margin, expiration)
    return expiration - GetTime() < margin
end

local is_effect_about_to_expire = function(unit, effect_id, margin)
    local expiration = get_effect_expiration(unit, effect_id)
    if not expiration then
        return nil
    end
    return is_about_to_expire(margin, expiration)
end

-- Dialog
local dialog = nil

local popup_accept = function()
    
end

local popup_cancel = function()
    
end

StaticPopupDialogs[C.PopupName] = {
    text           = "Your reflecting prism is about to run out.",
    button1        = "Okay",
    button2        = nil, -- "Cancel",
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
    local expiration = get_effect_expiration("player", C.EffectID)
    if not expiration then return end
    local expiring = is_about_to_expire(C.DurationMargin, expiration)
    if not dialog and expiring then
        dialog = StaticPopup_Show(C.PopupName)
    elseif dialog and not expiring then
        dialog = StaticPopup_Hide(C.PopupName)
    end
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
    IsAboutToExpire       = is_about_to_expire,
    IsEffectAboutToExpire = is_effect_about_to_expire
}
