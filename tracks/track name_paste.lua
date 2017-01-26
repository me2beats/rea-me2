local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

sel_tr_count = r.CountSelectedTracks()
if sel_tr_count == 0 then bla() return end

tr_name = r.GetExtState("me2beats_copy-paste", "track_name")
if not (tr_name and tr_name ~= '') then  bla() return end

r.Undo_BeginBlock() r.PreventUIRefresh(1)

for i = 1, sel_tr_count do
  tr = r.GetSelectedTrack(0, i-1)
  if tr then r.GetSetMediaTrackInfo_String(tr, "P_NAME", tr_name, 1) end
end

r.PreventUIRefresh(-1) r.Undo_EndBlock('paste track name', -1)