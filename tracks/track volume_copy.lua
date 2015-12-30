tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  tr_vol = reaper.GetMediaTrackInfo_Value(tr, "D_VOL")
  reaper.SetExtState("me2beats_copy-paste", "vol", tr_vol, false)
end