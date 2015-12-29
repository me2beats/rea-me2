tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  tr_automode = reaper.GetMediaTrackInfo_Value(tr, "I_AUTOMODE")
  reaper.SetExtState("Buffer", "automode", tr_automode, false)
end
