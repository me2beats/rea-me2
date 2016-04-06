bpm = reaper.GetExtState("me2beats_copy-paste", "bpm")
if bpm ~= '' then
  reaper.Undo_BeginBlock()
  reaper.SetCurrentBPM(0, bpm, true)
  reaper.Undo_EndBlock('Paste BPM', -1)
end
