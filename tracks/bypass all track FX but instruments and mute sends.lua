local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

local tracks = r.CountTracks()
if tracks == 0 then bla() return end

r.Undo_BeginBlock()

for i = 0, tracks-1 do
  local tr = r.GetTrack(0,i)
  local instr_idx = r.TrackFX_GetInstrument(tr)
  if instr_idx ~= -1 then goto continue end
  
  fx = r.TrackFX_GetCount(tr)
  for j = 0, fx-1 do
    enabled = r.TrackFX_GetEnabled(tr, j)
    if enabled == true then r.TrackFX_SetEnabled(tr, j, 0) end
  end
  
  ::continue::
  
  if r.GetTrackNumSends(tr, 0) > 0 then 
    muted = r.GetMediaTrackInfo_Value(tr, 'B_MUTE')
    if muted == false then r.SetMediaTrackInfo_Value(tr, 'B_MUTE',1) end
  end
  
end

r.Undo_EndBlock('bypass all track FX but instruments and mute sends', -1)
