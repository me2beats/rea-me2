tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  tr_color = reaper.GetMediaTrackInfo_Value(tr, "I_CUSTOMCOLOR")
  reaper.SetExtState("me2beats_copy-paste", "color", tr_color, false)
end
