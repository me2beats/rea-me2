function nothing() end

sel_tr = reaper.GetSelectedTrack(0,0)
if sel_tr ~= nil then
  script_title = 'set mcp sends area to 0.3'
  reaper.Undo_BeginBlock()
  reaper.SetMediaTrackInfo_Value(sel_tr, 'F_MCP_SENDRGN_SCALE', 0.3)
  reaper.Undo_EndBlock(script_title, -1)
else
  reaper.defer(nothing)
end
