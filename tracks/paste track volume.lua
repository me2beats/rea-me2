if reaper.CountSelectedMediaItems(0) > 0 then
  tr = reaper.GetSelectedTrack(0, 0)
  vol = reaper.GetExtState("Buffer", "vol")
  ok_1, vol_1, pan_1 = reaper.GetTrackUIVolPan(tr, 0, 0)
  reaper.SetMediaTrackInfo_Value(tr, "D_VOL", vol)
end