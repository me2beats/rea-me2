local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

tr = r.GetSelectedTrack(0, 0)
if not tr then bla() return end

r.Undo_BeginBlock()

_, tcp_layout = r.BR_GetMediaTrackLayouts(tr)
r.DeleteExtState('me2beats_copy-paste', 'tcp_layout', 0)
r.SetExtState('me2beats copy-paste', 'tcp_layout', tcp_layout, 0)

r.Undo_EndBlock('tcp layout copy', -1)
