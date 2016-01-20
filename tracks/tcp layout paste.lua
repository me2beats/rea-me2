function nothing()
end

sel_tr_count = reaper.CountSelectedTracks(0)
if sel_tr_count ~= nil then
  tcp_layout = reaper.GetExtState("me2beats copy-paste", "tcp_layout")
  if tcp_layout ~= nil then
  
    script_title = "tcp layout paste"
    reaper.Undo_BeginBlock()
    
    for i = 1, sel_tr_count do
      tr = reaper.GetSelectedTrack(0, i-1)
      if tr ~= nil then
      mcp_layout = reaper.BR_GetMediaTrackLayouts(tr)
      reaper.BR_SetMediaTrackLayouts(tr, mcp_layout, tcp_layout)
      end
    
    reaper.Undo_EndBlock(script_title, -1)
    
    end
  else
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end
