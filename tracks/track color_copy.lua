tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  tr_color = reaper.GetMediaTrackInfo_Value(tr, "I_CUSTOMCOLOR")
  reaper.SetExtState("Buffer", "color", tr_color, false)
end
