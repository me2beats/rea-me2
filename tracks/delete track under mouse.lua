function nothing() end

track = reaper.BR_TrackAtMouseCursor()
if track then
  reaper.Undo_BeginBlock()
  reaper.DeleteTrack(track)
  reaper.Undo_EndBlock('remove item under mouse', -1)
else reaper.defer(nothing) end
