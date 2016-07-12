n = 100

function nothing() end

tr = reaper.GetTrack(0,n-1)
if tr then
  reaper.Undo_BeginBlock()
  if reaper.GetMediaTrackInfo_Value(tr, 'I_SOLO') == 0 then
    reaper.SetMediaTrackInfo_Value(tr, 'I_SOLO', 1)
  else
    reaper.SetMediaTrackInfo_Value(tr, 'I_SOLO', 0)
  end
  reaper.Undo_EndBlock('Toggle solo for track '..n, -1)
else reaper.defer(nothing) end
