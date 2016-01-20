tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  script_title = "tcp layout copy"
  reaper.Undo_BeginBlock()
  
  _, tcp_layout = reaper.BR_GetMediaTrackLayouts(tr)
  reaper.SetExtState("me2beats copy-paste", "tcp_layout", tcp_layout, false)

  reaper.Undo_EndBlock(script_title, -1)
else
  function nothing()
  end
  reaper.defer(nothing)
end
