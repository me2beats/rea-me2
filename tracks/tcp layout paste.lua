local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

sel_tr_count = r.CountSelectedTracks()
if sel_tr_count == 0 then bla() return end

tcp_layout = r.GetExtState('me2beats copy-paste', 'tcp_layout')
if not tcp_layout or tcp_layout == '' then bla() return end

r.Undo_BeginBlock(); r.PreventUIRefresh(1)

for i = 0, sel_tr_count-1 do
  tr = r.GetSelectedTrack(0, i)
  mcp_layout = r.BR_GetMediaTrackLayouts(tr)
  r.BR_SetMediaTrackLayouts(tr, mcp_layout, tcp_layout)
end

r.PreventUIRefresh(-1); r.Undo_EndBlock('tcp layout paste', -1)