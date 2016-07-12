n = 100

function nothing() end

tr = reaper.GetTrack(0,n-1)
if tr then
  reaper.Undo_BeginBlock()
  if reaper.GetMediaTrackInfo_Value(tr, 'B_PHASE') == 1 then
    reaper.SetMediaTrackInfo_Value(tr, 'B_PHASE', 0)
  else
    reaper.SetMediaTrackInfo_Value(tr, 'B_PHASE', 1)
  end 
  reaper.Undo_EndBlock('Toggle invert phase for track '..n, -1)
else reaper.defer(nothing) end
