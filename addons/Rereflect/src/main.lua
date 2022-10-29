local addon_name, RR = ...

local INFINITY = math.huge

local BUFF_SEARCH_COUNT = 40
local DURATION_MARGIN   = 30 -- in seconds
local POPUP_NAME        = "RR_EXPIRATION_POPUP"
local EFFECTS           = {
  163267, -- Reflecting Prism
  121308, -- Disguise
}

-- Functions

local function get_effect(effect_id)
 for i = 1, BUFF_SEARCH_COUNT do
    local name, _, _, _, _, expiration, _, _, _, id = UnitBuff("player", i)
    if id == effect_id then
      return i, name, expiration - GetTime(), id
    end
  end
  return nil
end

local function is_about_to_expire(duration)
  return duration < DURATION_MARGIN
end

local function get_longest_effect()
  local effect_i, effect_name, effect_duration, effect_id
  effect_duration = -INFINITY 
  for _, effect in ipairs(EFFECTS) do
    local i, name, duration, id = get_effect(effect)
    if i and duration > effect_duration then
      effect_i        = i
      effect_name     = name
      effect_duration = duration
      effect_id       = id
    end
  end
  if not effect_i then return nil end
  return effect_i, effect_name, effect_duration, effect_id
end

-- Dialog

local dialog = nil

StaticPopupDialogs[POPUP_NAME] = {
  text         = "Your %s is about to run out.",
  button1      = "Dismiss",
  OnAccept     = function() end,
  OnCancel     = function() end,
  timeout      = DURATION_MARGIN,
  whileDead    = false,
  hideOnEscape = false,
}

-- Events and update
local event_frame = CreateFrame("Frame", "RR_EVENT_FRAME", nil)

local previous_id = nil
function event_frame:OnUpdate(dt)
  local index, name, duration, id = get_longest_effect()
  if not index then
    previous_duration = nil
    if dialog then
      StaticPopup_Hide(POPUP_NAME)
    end
    return
  end
  if id ~= previous_id then
    dialog = StaticPopup_Hide(POPUP_NAME)
  end
  previous_id = id
  local expiring = is_about_to_expire(duration)
  if not dialog and expiring then
    dialog = StaticPopup_Show(POPUP_NAME, name)
  elseif dialog and not expiring then
    dialog = StaticPopup_Hide(POPUP_NAME)
  end
end

event_frame:SetScript("OnUpdate", event_frame.OnUpdate)
