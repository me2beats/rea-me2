tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  tr_recmode = reaper.GetMediaTrackInfo_Value(tr, "I_RECMODE")
  reaper.SetExtState("me2beats_copy-paste", "recmode", tr_recmode, false)
end
