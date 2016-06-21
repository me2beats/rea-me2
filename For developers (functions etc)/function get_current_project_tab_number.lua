function get_current_project_tab_number ()
  for p = 1, 1000 do
    retval = reaper.EnumProjects(p, '')
    if not retval then x = p break end
  end
  local retval_0  = reaper.EnumProjects(-1, '')
  for p = 1, x do
    retval  = reaper.EnumProjects(p-1, '')
    if retval == retval_0 then cur_proj_tab = p break end
  end
  x, retval = nil, nil
  return cur_proj_tab
end
