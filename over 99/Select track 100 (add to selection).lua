n = 100
tr = reaper.GetTrack(0,n-1)
if tr then reaper.SetTrackSelected(tr, 1) end
function nothing() end; reaper.defer(nothing)
