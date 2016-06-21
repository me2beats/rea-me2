function nothing() end

function get_current_project_tab_number ()
  retval = nil
  for p = 1, 1000 do
    retval = reaper.EnumProjects(p, '')
    if not retval then projects = p break end
  end
  local retval_0  = reaper.EnumProjects(-1, '')
  for p = 1, projects do
    retval  = reaper.EnumProjects(p-1, '')
    if retval == retval_0 then cur_proj_tab = p break end
  end
  retval = nil; return cur_proj_tab
end

cur_proj = get_current_project_tab_number ()

if cur_proj ~= 1 then
  reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(111)
  if cur_proj <= (projects+1)/2 then
    for i = 1, cur_proj-1 do reaper.Main_OnCommand(40862,0) end -- prev project tab
  else
    for i = cur_proj, projects do reaper.Main_OnCommand(40861,0) end -- next project tab
  end
  reaper.PreventUIRefresh(-111); reaper.Undo_EndBlock('Go to first project tab', -1)
else reaper.defer(nothing) end
