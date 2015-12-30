tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  tr_recin = reaper.GetMediaTrackInfo_Value(tr, "I_RECINPUT")
  reaper.SetExtState("me2beats_copy-paste", "recin", tr_recin, false)
end
