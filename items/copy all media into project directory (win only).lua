project_path = reaper.GetProjectPath('')
items = reaper.CountMediaItems(0)
if items > 0 then
  ask = reaper.MB('Project path is '..project_path..', continue?', 'Copy all media into project directory', 1)
  if ask == 1 then
    files_tb = {}
    for i = 1, items do
      it = reaper.GetMediaItem(0, i-1)
      takes = reaper.CountTakes(it)
      for t = 1, takes do
        take = reaper.GetTake(it, t-1)
        if reaper.TakeIsMIDI(take) ~= true then
          source = reaper.GetMediaItemTake_Source(take)
          filename = reaper.GetMediaSourceFileName(source, "")
          found = 0
          for ii = 1, #files_tb do
            if filename == files_tb[ii] then found = 1 break end
          end
          if found == 0 then table.insert(files_tb, filename) end
        end
      end
    end
    for iii = 1, #files_tb do
      os.execute('copy '..[["]]..files_tb[iii]..[[" "]]..project_path..[["]])
    end
  end
end
