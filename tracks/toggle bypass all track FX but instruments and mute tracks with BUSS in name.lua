local undo = 2
local name = 'BUSS'

local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

tracks = r.CountTracks()
if tracks == 0 then bla() return end
_, _, sec, cmd = r.get_action_context()

state = r.GetToggleCommandState(cmd)

r.Undo_BeginBlock()

for i = 0, tracks-1 do
  tr = r.GetTrack(0,i)

  fx = r.TrackFX_GetCount(tr)
  for j = 0, fx-1 do
    instr_idx = r.TrackFX_GetInstrument(tr)
    if instr_idx == -1 or instr_idx ~= j then
      
      if state == 0 then r.TrackFX_SetEnabled(tr, j, 0)
      else r.TrackFX_SetEnabled(tr, j, 1) end
    end
  end

  _, tr_name = r.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
  if tr_name:match(name) then
    if state == 0 then r.SetMediaTrackInfo_Value(tr, 'B_MUTE',1)
    else r.SetMediaTrackInfo_Value(tr, 'B_MUTE',0) end
  end
end


if state == 0 then r.SetToggleCommandState( sec, cmd, 1 )
else r.SetToggleCommandState( sec, cmd, 0 ) end

r.RefreshToolbar2(sec, cmd)

r.Undo_EndBlock('toggle bypass all track FX and mute tracks with "BUSS" in name', 2)
