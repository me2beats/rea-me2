local r = reaper

local items = r.CountSelectedMediaItems()

r.Undo_BeginBlock(); r.PreventUIRefresh(1)

if items > 0 then
  for i = 0, items-1 do
    local item = r.GetSelectedMediaItem(0,i)
    if item then
      local take = r.GetActiveTake(item)
      if not take then return end
      chan_mode = r.GetMediaItemTakeInfo_Value(take, 'I_CHANMODE')
      if chan_mode < 4 then chan_mode = chan_mode+1 else chan_mode = 0 end
      r.SetMediaItemTakeInfo_Value(take, 'I_CHANMODE', chan_mode)
    end
  end
else
  tracks = r.CountSelectedTracks()
  if tracks == 0 then return end
  for i = 0, tracks-1 do
    tr = r.GetSelectedTrack(0,i)
    tr_pan_mode = r.GetMediaTrackInfo_Value(tr, 'I_PANMODE')
    if tr_pan_mode < 5 then tr_pan_mode = 5
    elseif tr_pan_mode == 5 then tr_pan_mode = 6
    elseif tr_pan_mode == 6 then tr_pan_mode = -1 end
    r.SetMediaTrackInfo_Value(tr, 'I_PANMODE',tr_pan_mode)
  end
end

r.PreventUIRefresh(-1); r.Undo_EndBlock('set next track pan mode or take channel mode', -1)
