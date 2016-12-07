local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

tracks = r.CountTracks()
if tracks == 0 then bla() return end

r.Undo_BeginBlock()

for i = 0, tracks-1 do
  tr = r.GetTrack(0,i)
  instr_idx = r.TrackFX_GetInstrument(tr)
  if instr_idx ~= -1 then goto continue end
  
  fx = r.TrackFX_GetCount(tr)
  for j = 0, fx-1 do
    enabled = r.TrackFX_GetEnabled(tr, j)
    if enabled == true then r.TrackFX_SetEnabled(tr, j, 0) end
  end
  
  ::continue::
  _, tr_name = r.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
  if tr_name:match'BUSS' then
    muted = r.GetMediaTrackInfo_Value(tr, 'B_MUTE')
    if muted == 0 then r.SetMediaTrackInfo_Value(tr, 'B_MUTE',1) end
  end
  
end

r.Undo_EndBlock('bypass all track FX but instruments and mute sends', -1)
