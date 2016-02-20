function nothing() end

sel_items = reaper.CountSelectedMediaItems(0)
if sel_items > 0 then
  for i = 1, sel_items do
    it = reaper.GetSelectedMediaItem(0, i-1)
    takes = reaper.CountTakes(it)
    for t = 1, takes do
      take = reaper.GetTake(it, t-1)
      if reaper.TakeIsMIDI(take) ~= true then
        source = reaper.GetMediaItemTake_Source(take)
        filename = reaper.GetMediaSourceFileName(source, "")
        if filename:find('\\') ~= nil then
          source_name = string.match (filename, '\\.*\\(.*)%.')
        elseif filename:find('/') ~= nil then
          source_name = string.match (filename, '/.*/(.*)%.')
        end
        if source_name ~= nil then
          _, cur_name = reaper.GetSetMediaItemTakeInfo_String(take, 'P_NAME', '', false)
          if cur_name ~= source_name then
            reaper.GetSetMediaItemTakeInfo_String(take, 'P_NAME', source_name, true)
            q = 555
          end
        end
      end
    end
  end
  if q == 555 then
    reaper.UpdateItemInProject(it)
    script_title = 'Set names of sel items takes to their source names'
    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock(script_title, -1)
  else
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end
