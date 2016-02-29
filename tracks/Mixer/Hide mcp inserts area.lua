function nothing() end

sel_tr = reaper.GetSelectedTrack(0,0)
if sel_tr ~= nil then
  script_title = 'Hide mcp inserts area'
  reaper.Undo_BeginBlock()
  reaper.SetMediaTrackInfo_Value(sel_tr, 'F_MCP_SENDRGN_SCALE', 1)
  reaper.Undo_EndBlock(script_title, -1)
else
  reaper.defer(nothing)
end
