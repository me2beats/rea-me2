local n = 100

function nothing() end reaper.defer(nothing)

local _,_,_,_,_,resolution,val = reaper.get_action_context()

local tr = reaper.GetTrack(0,n-1)
if tr then
  if val > 0.5*resolution then
    reaper.SetMediaTrackInfo_Value(tr, 'B_MUTE', 1)
  elseif val < 0.5*resolution then
    reaper.SetMediaTrackInfo_Value(tr, 'B_MUTE', 0)
  end
end
