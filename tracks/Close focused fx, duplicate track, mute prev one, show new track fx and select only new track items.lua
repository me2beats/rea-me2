function nothing() end

retval, trnum, _, fxnum = reaper.GetFocusedFX()
if retval == 1 then
  reaper.PreventUIRefresh(111)
  reaper.Undo_BeginBlock()
  tr = reaper.GetTrack(0,trnum-1)
  reaper.TrackFX_SetOpen(tr, fxnum, false)
  reaper.SetOnlyTrackSelected(tr)
  reaper.Main_OnCommand(40062,0) -- duplicate tracks
  reaper.SetMediaTrackInfo_Value(tr, 'B_MUTE', 1)
  n_tr = reaper.GetTrack(0,trnum)
  reaper.TrackFX_SetOpen(n_tr, fxnum, true)
  reaper.Main_OnCommand(40421,0) -- select all items in track
  reaper.PreventUIRefresh(-111)
  reaper.Undo_EndBlock('Close focused fx, duplicate track, mute prev one, show new track fx and select only new track items', -1)
else
  reaper.defer(nothing)
end
