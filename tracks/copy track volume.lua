tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  tr_vol = reaper.GetMediaTrackInfo_Value(tr, "D_VOL")
  reaper.SetExtState("Buffer", "vol", tr_vol, false)
end