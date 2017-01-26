local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

sel_tr_count = r.CountSelectedTracks()
if sel_tr_count == 0 then bla() return end

tr_color = r.GetExtState('me2beats_copy-paste', 'color')
if not (tr_color and tr_color ~= '') then bla() return end

r.Undo_BeginBlock() r.PreventUIRefresh(1)

for i = 1, sel_tr_count do
  tr = r.GetSelectedTrack(0, i-1)
  r.SetMediaTrackInfo_Value(tr, 'I_CUSTOMCOLOR', tr_color)
end

r.PreventUIRefresh(-1) r.Undo_EndBlock('paste track color', -1)