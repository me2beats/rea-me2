if reaper.CountSelectedMediaItems(0) > 0 then
  tr = reaper.GetSelectedTrack(0, 0)
  dep = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
  ok, vol, pan = reaper.GetTrackUIVolPan(tr, 0, 0)
  tr_vol = reaper.GetMediaTrackInfo_Value(tr, "D_VOL")
  if dep < 0 then
    reaper.Main_OnCommand(40001, 0)
    tr_n = reaper.GetSelectedTrack(0, 0)
    reaper.SetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH", 0)
    reaper.SetMediaTrackInfo_Value(tr_n, "I_FOLDERDEPTH", dep)
  else	
	reaper.Main_OnCommand(40001, 0)
	tr_n = reaper.GetSelectedTrack(0, 0)
  end
  ok_1, vol_1, pan_1 = reaper.GetTrackUIVolPan(tr_n, 0, 0)
  reaper.SetMediaTrackInfo_Value(tr_n, "D_VOL", vol)
end