num_of_sel_tr = reaper.CountSelectedTracks(0)
if num_of_sel_tr > 0 then
  if num_of_sel_tr == 1 then
    script_title = "Increase mcp sends areas for 1 track"
  else
    script_title = "Increase mcp sends areas for "..num_of_sel_tr.." tracks"
  end
  reaper.Undo_BeginBlock()

  for t = 1, num_of_sel_tr do
    tr = reaper.GetSelectedTrack(0,t-1)
    tr_send_scale = reaper.GetMediaTrackInfo_Value(tr, 'F_MCP_SENDRGN_SCALE')
    reaper.SetMediaTrackInfo_Value(tr, 'F_MCP_SENDRGN_SCALE', tr_send_scale+0.1)
  end
  reaper.Undo_EndBlock(script_title, -1)
else
  function nothing() end reaper.defer(nothing)
end
