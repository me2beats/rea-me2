sel_tr_count = reaper.CountSelectedTracks(0)
if sel_tr_count ~= nil then
  window, segment, details = reaper.BR_GetMouseCursorContext()
  if segment == "track" then
    source_tr = reaper.BR_GetMouseCursorContext_Track()
	tr_automode = reaper.GetMediaTrackInfo_Value(source_tr, "I_AUTOMODE")
    for i = 1, sel_tr_count do
      tr = reaper.GetSelectedTrack(0, i-1)
      if tr ~= nil then
        reaper.SetMediaTrackInfo_Value(tr, "I_AUTOMODE", tr_automode)
      end
    end
  end
end