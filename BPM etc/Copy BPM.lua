reaper.Undo_BeginBlock()
bpm = reaper.GetProjectTimeSignature2(0)
reaper.SetExtState("me2beats_copy-paste", "bpm", bpm, false)
reaper.Undo_EndBlock('Copy BPM', -1)
