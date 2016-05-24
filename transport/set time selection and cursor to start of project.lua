function nothing() end

start_ts, end_ts =  reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
if end_ts - start_ts > 0 then
  reaper.Undo_BeginBlock()
  start_ts = 0
  reaper.GetSet_LoopTimeRange(1, 0, start_ts, end_ts, 0)
  reaper.SetEditCurPos(0, false, false)
  reaper.Undo_EndBlock('set time selection and cursor to start of project', -1)
end

