local r = reaper; local function action(act) r.Main_OnCommand(act, 0) end 
local function nothing() end; local function bla() r.defer(nothing) end

init_sel_tracks = {}
local function SaveSelectedTracks (table)
  for i = 0, r.CountSelectedTracks(0)-1 do table[i+1] = r.GetSelectedTrack(0, i) end
end

local function RestoreSelectedTracks (table)
  action(40297) -- Unselect all tracks
  for _, track in ipairs(table) do r.SetTrackSelected(track, 1) end
end

function SaveCursorPos() init_cursor_pos = r.GetCursorPosition() end

function RestoreCursorPos() r.SetEditCurPos(init_cursor_pos, 0, 0) end

--------------------------------------------------------------------------------------------

local cur = r.GetCursorPosition()

local _, region_id = r.GetLastMarkerAndCurRegion(0, cur)
if region_id ~= -1 then
  local same_names_tb = {}
  local _, _, x_r_src, y_r_src, name_src, idx_src = r.EnumProjectMarkers3(0,region_id)

  local _, _, regions = r.CountProjectMarkers(0)
  for i = 0, regions-1 do
    if i ~= region_id then
      local _, _, x_r, y_r, name, idx = r.EnumProjectMarkers3(0,i)
      if name == name_src then same_names_tb[#same_names_tb+1] = {x_r, y_r, idx} end
    end
  end

  if #same_names_tb > 0 then  

    local src_items_tb, src_items_tb_trm = {}, {}
    for l = 0, r.CountMediaItems(0)-1 do
      local item = r.GetMediaItem(0,l)
      local pos, len = r.GetMediaItemInfo_Value(item, 'D_POSITION'), r.GetMediaItemInfo_Value(item, 'D_LENGTH') 
      if  (x_r_src < pos+len and x_r_src > pos) or
          (y_r_src > pos and y_r_src < pos+len) or
          (x_r_src <= pos and y_r_src >= pos+len) then
        local tr = reaper.GetMediaItem_Track(item)
        src_items_tb[#src_items_tb+1] = {item, pos, pos+len, tr}
        if pos < x_r_src and pos+len > y_r_src then x, y = x_r_src, y_r_src
        elseif pos < x_r_src then x, y = x_r_src, pos+len
        elseif pos+len > y_r_src then x, y = pos, y_r_src
        else x, y = pos, pos+len end
        src_items_tb_trm[#src_items_tb_trm+1] = {item, x, y, tr}
      end
    end

    if #src_items_tb > 0 then

      r.Undo_BeginBlock(); r.PreventUIRefresh(-1)
      
      SaveSelectedTracks(init_sel_tracks); SaveCursorPos()

      local ripple = r.GetToggleCommandState(1155)
      if ripple == 1 then
        action(1155)
        ripple = r.GetToggleCommandState(1155)
        if ripple == 1 then action(1155) else ripple = 2 end
      else ripple = nil end

      action(40289) -- Unselect all items

------get offset
      local offset = src_items_tb_trm[1][2] - x_r_src
      for i = 2, #src_items_tb do
        if src_items_tb_trm[i][2] - x_r_src < offset then offset = src_items_tb_trm[i][2] - x_r_src end
      end

------get the topmost tr with items to copy

      local topmost_tr = src_items_tb[1][4]
      local num =  r.GetMediaTrackInfo_Value(topmost_tr, 'IP_TRACKNUMBER')
      for i = 2, #src_items_tb do
        if r.GetMediaTrackInfo_Value(src_items_tb[i][4], 'IP_TRACKNUMBER') < num then
          num = r.GetMediaTrackInfo_Value(src_items_tb[i][4], 'IP_TRACKNUMBER'); topmost_tr = src_items_tb[i][4]
        end
      end

------select and touch the topmost tr with items to copy
      r.SetOnlyTrackSelected(topmost_tr); action(40914)
        
------left_trim

      for i = 1, #src_items_tb do
        if src_items_tb[i][2] < x_r_src then r.SetMediaItemSelected(src_items_tb[i][1], 1) end
      end
      if r.CountSelectedMediaItems(0) > 0 then r.ApplyNudge(0, 1, 1, 1, x_r_src, 0, 0) end

------right_trim

      action(40289) -- Unselect all items

      for i = 1, #src_items_tb do
        if src_items_tb[i][3] > y_r_src then r.SetMediaItemSelected(src_items_tb[i][1], 1) end
      end
      if r.CountSelectedMediaItems(0) > 0 then r.ApplyNudge(0, 1, 3, 1, y_r_src, 0, 0) end

      action(40289) -- Unselect all items


      local items_to_del = {}

      for j = 0, r.CountMediaItems(0)-1 do
        local item = r.GetMediaItem(0,j)
        local pos = r.GetMediaItemInfo_Value(item, 'D_POSITION')
        local len = r.GetMediaItemInfo_Value(item, 'D_LENGTH') 
        for k = 1, #same_names_tb do
          local tr = reaper.GetMediaItem_Track(item)
          for m = 1, #src_items_tb_trm do
            if tr == src_items_tb_trm[m][4] then
              if  (src_items_tb_trm[m][2] -x_r_src < pos+len - same_names_tb[k][1] and src_items_tb_trm[m][2] -x_r_src > pos - same_names_tb[k][1]) or
                  (src_items_tb_trm[m][3] -x_r_src > pos - same_names_tb[k][1] and src_items_tb_trm[m][3] -x_r_src < pos+len - same_names_tb[k][1]) or
                  (src_items_tb_trm[m][2] -x_r_src <= pos - same_names_tb[k][1] and src_items_tb_trm[m][3] -x_r_src >= pos+len - same_names_tb[k][1]) then
                  items_to_del[#items_to_del+1] = {item,tr}
              break end
            end
          end
        end
      end
      for i = 1, #items_to_del do
        r.DeleteTrackMediaItem(items_to_del[i][2], items_to_del[i][1])
      end

      for i = 1, #src_items_tb do r.SetMediaItemSelected(src_items_tb[i][1], 1) end

      action(40698) -- Copy items
      for i = 1, #same_names_tb do
        r.SetEditCurPos(same_names_tb[i][1]+offset, 0, 0)
        action(40058) -- Paste items/tracks
      end


      for i = 1, #src_items_tb do
        action(40289) -- Unselect all items
        local item = src_items_tb[i][1]; local pos = src_items_tb[i][2]; local itend = src_items_tb[i][3]
        if pos < x_r_src and itend > y_r_src then

          r.SetMediaItemSelected(item, 1)

          r.ApplyNudge(0, 1, 1, 1, pos, 0, 0)
          r.ApplyNudge(0, 1, 3, 1, itend, 0, 0)

        elseif pos < x_r_src then
          r.SetMediaItemSelected(item, 1)
          r.ApplyNudge(0, 1, 1, 1, pos, 0, 0)
        elseif itend > y_r_src then
          r.SetMediaItemSelected(item, 1)
          r.ApplyNudge(0, 1, 3, 1, itend, 0, 0)
        end
      end

      RestoreCursorPos(); RestoreSelectedTracks(init_sel_tracks)

      action(40289) -- Unselect all items

      if ripple then if ripple == 1 then action(1155) else action(1155) action(1155) end end

      r.PreventUIRefresh(1); r.Undo_EndBlock('Copy items in region at cursor to regions with the same name', -1)
    else bla() end
  else bla() end
else bla() end
