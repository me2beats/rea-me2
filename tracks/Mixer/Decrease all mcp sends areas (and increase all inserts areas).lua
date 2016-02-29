num_of_tr = reaper.CountTracks(0)
if num_of_tr > 0 then
  
  script_title = "Decrease all mcp sends areas"
  reaper.Undo_BeginBlock()
  
  for t = 1, num_of_tr do
    tr = reaper.GetTrack(0,t-1)
    tr_send_scale = reaper.GetMediaTrackInfo_Value(tr, 'F_MCP_SENDRGN_SCALE')
    reaper.SetMediaTrackInfo_Value(tr, 'F_MCP_SENDRGN_SCALE', tr_send_scale-0.1)
  end
  reaper.Undo_EndBlock(script_title, -1)
else
  function nothing() end  reaper.defer(nothing)
end
