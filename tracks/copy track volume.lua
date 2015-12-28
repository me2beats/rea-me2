if reaper.CountSelectedMediaItems(0) > 0 then
  tr = reaper.GetSelectedTrack(0, 0)
  ok, vol, pan = reaper.GetTrackUIVolPan(tr, 0, 0)
  tr_vol = reaper.GetMediaTrackInfo_Value(tr, "D_VOL")
  reaper.SetExtState("Buffer", "vol", tr_vol, false)
end

