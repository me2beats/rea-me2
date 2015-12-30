start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
time_sel_len = end_time - start_time
reaper.SetExtState("me2beats_copy-paste", "time_sel", time_sel_len, false)
