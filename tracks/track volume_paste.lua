local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

sel_tr_count = r.CountSelectedTracks()
if sel_tr_count == 0 then bla() return end

vol = r.GetExtState('me2beats_copy-paste', 'tr_vol')
if not (vol and vol ~= '') then bla() return end

r.Undo_BeginBlock() r.PreventUIRefresh(1)

for i = 0, sel_tr_count-1 do
  tr = r.GetSelectedTrack(0, i)
  r.SetMediaTrackInfo_Value(tr, 'D_PAN', vol)
end

r.PreventUIRefresh(-1) r.Undo_EndBlock('paste track volume', -1)