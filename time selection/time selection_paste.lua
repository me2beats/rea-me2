time_sel = reaper.GetExtState("me2beats_copy-paste", "time_sel")
edit_pos = reaper.GetCursorPosition()
reaper.GetSet_LoopTimeRange2(0, true, false, edit_pos, edit_pos + time_sel, false)
