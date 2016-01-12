sel_it_count = reaper.CountSelectedMediaItems(0)
if sel_it_count > 0 then
  mouse_it = reaper.BR_ItemAtMouseCursor()
  if mouse_it ~= nil then
  
    script_title = "set source of active take of sel item to source of take under mouse"
    reaper.Undo_BeginBlock()
    
    source_take = reaper.GetActiveTake(mouse_it)
    source = reaper.GetMediaItemTake_Source(source_take)
    filename = reaper.GetMediaSourceFileName(source, "")
    for i = 0, sel_it_count-1 do
      it = reaper.GetSelectedMediaItem(0, i)
      take = reaper.GetActiveTake(it)
      clonedsource = reaper.PCM_Source_CreateFromFile(filename)
      reaper.SetMediaItemTake_Source(take, clonedsource)
      reaper.UpdateItemInProject(it)
      
    end
    reaper.UpdateArrange()
    reaper.Undo_EndBlock(script_title, -1)
--  reaper.Main_OnCommand(40441, 0) -- rebuild peaks for selected items

  else
    function nothing()
    end
    reaper.defer(nothing)
  end
else
  function nothing()
  end
  reaper.defer(nothing)
end
