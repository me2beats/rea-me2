reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(111)
for p = 1, 1000 do
  retval = reaper.EnumProjects(p, '')
  if not retval then projects = p break end
end
for i = 0, projects-1 do
  reaper.Main_OnCommand(1016,0) -- transport: stop
  reaper.Main_OnCommand(40861,0) -- next project tab
end
reaper.PreventUIRefresh(-111); reaper.Undo_EndBlock('Stop all projects', -1)
