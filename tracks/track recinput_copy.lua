tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  tr_recin = reaper.GetMediaTrackInfo_Value(tr, "I_RECINPUT")
  reaper.SetExtState("Buffer", "recin", tr_recin, false)
end
