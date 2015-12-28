if reaper.CountSelectedTracks(0) > 0 then
  seltr = reaper.GetSelectedTrack(0, 0)
  dep = reaper.GetMediaTrackInfo_Value(seltr, "I_FOLDERDEPTH")
  if dep < 0 then
    reaper.Main_OnCommand(40001, 0)
    new = reaper.GetSelectedTrack(0, 0)
    reaper.SetMediaTrackInfo_Value(seltr, "I_FOLDERDEPTH", 0)
    reaper.SetMediaTrackInfo_Value(new, "I_FOLDERDEPTH", dep)
  else
    reaper.Main_OnCommand(40001, 0)
  end
else
  n = reaper.CountTracks(0)
  if n > 0 then
    was_last_tr = reaper.GetTrack(0, n-1)
    dep = reaper.GetMediaTrackInfo_Value(was_last_tr, "I_FOLDERDEPTH")
    reaper.SetOnlyTrackSelected(was_last_tr)
    reaper.Main_OnCommand(40702, 0)
    new = reaper.GetSelectedTrack(0, 0)
    reaper.SetMediaTrackInfo_Value(was_last_tr, "I_FOLDERDEPTH", 0)
    reaper.SetMediaTrackInfo_Value(new, "I_FOLDERDEPTH", dep)
  end
end
