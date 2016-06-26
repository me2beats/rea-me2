reaper.Undo_BeginBlock()
master = reaper.GetMasterTrack(0)
_, chunk = reaper.GetTrackStateChunk(master, '', 0)
if chunk:find('\nHWOUT ') then
  hwout = chunk:match('\nMAINSEND .-\n(.-)\n<FXCHAIN')
  if not hwout then hwout = chunk:match('\nMAINSEND .-\n(.-)\n>') end
else hwout = 'empty' end
reaper.SetExtState("me2beats_copy-paste", "master_hwout", hwout, 0)
reaper.Undo_EndBlock('Copy hardware outputs of master', -1)
