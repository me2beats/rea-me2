n = 100
tr = reaper.GetTrack(0,n-1)
if tr then reaper.SetOnlyTrackSelected(tr) end
function nothing() end; reaper.defer(nothing)
