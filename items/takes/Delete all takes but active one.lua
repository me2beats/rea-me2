function nothing() end
function del_act_take() reaper.Main_OnCommand(40129, 0) end
function hello()
  takes = reaper.GetMediaItemNumTakes(it)
  cur_take_num = reaper.GetMediaItemInfo_Value(it, 'I_CURTAKE')
  for t = 0, cur_take_num-1 do
    take = reaper.GetMediaItemTake(it, 0)
    reaper.SetActiveTake(take)
    del_act_take()
  end
  for t = takes-1, cur_take_num+1, -1 do
    take = reaper.GetMediaItemTake(it, 1)
    reaper.SetActiveTake(take)
    del_act_take()
  end
  reaper.UpdateItemInProject(it)
end

items = reaper.CountSelectedMediaItems(0)
if items > 0 then
  script_title = 'Delete all takes but active one'
  reaper.Undo_BeginBlock()
  reaper.PreventUIRefresh(1)
  if items == 1 then
    it = reaper.GetSelectedMediaItem(0, 0)
    hello()
  else
----  save selected items---------------
    t = {}
    for i = 0, items-1 do
      it = reaper.GetSelectedMediaItem(0,i)
      guid = reaper.BR_GetMediaItemGUID(it)
      table.insert(t, guid)
    end
---------------------------------------
    reaper.Main_OnCommand(40289, 0)--  unselect all items
    for i = 1, #t do
      it = reaper.BR_GetMediaItemByGUID(0, t[i])
      reaper.SetMediaItemSelected(it, true)
      hello()
      reaper.SetMediaItemSelected(it, false)
    end
---- restore sel items-------------------
    for i = 1, #t do
      it = reaper.BR_GetMediaItemByGUID(0, t[i])
      reaper.SetMediaItemSelected(it, true)
    end
-----------------------------------------
  end
  reaper.Undo_EndBlock(script_title, -1)
  reaper.PreventUIRefresh(-1)
else
  reaper.defer(nothing)
end
