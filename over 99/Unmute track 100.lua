n = 100

function nothing() end

tr = reaper.GetTrack(0,n-1)
if tr then
  reaper.Undo_BeginBlock()
  if reaper.GetMediaTrackInfo_Value(tr, 'B_MUTE') == 1 then
    reaper.SetMediaTrackInfo_Value(tr, 'B_MUTE', 0)
  end 
  reaper.Undo_EndBlock('Unmute track '..n, -1)
else reaper.defer(nothing) end
