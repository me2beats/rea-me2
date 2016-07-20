--------------- fade in settings (change it!)
local in_len = 0.02 
local in_curve = ''
local in_shape = ''
--------------- fade out settings (change it!)
local out_len = 0.02
local out_curve = ''
local out_shape = ''
--------------------------------
local  in_len, in_curve, in_shape = tonumber(in_len), tonumber(in_curve), tonumber(in_shape)
local out_len, out_curve, out_shape = tonumber(out_len), tonumber(out_curve), tonumber(out_shape)

local r = reaper
function main()
  local ch_count = r.GetProjectStateChangeCount(0)

  if not last_ch_count or last_ch_count ~= ch_count then
    local items = r.CountMediaItems(0)
    for i = 0, items-1 do
      local x = nil
      local item = r.GetMediaItem(0,i)
      local in_len_item = r.GetMediaItemInfo_Value(item, 'D_FADEINLEN')
      local out_len_item = r.GetMediaItemInfo_Value(item, 'D_FADEOUTLEN')
      if in_len_item == 0 then
        if in_len and in_len > 0 then r.SetMediaItemInfo_Value(item, 'D_FADEINLEN', in_len); x = 1 end
        if in_curve and in_curve >= -1 and in_curve <= 1 then r.SetMediaItemInfo_Value(item, 'D_FADEINDIR', in_curve); x = 1 end
--        r.SetMediaItemInfo_Value(item, 'D_FADEINLEN_AUTO', in_auto)
        if in_shape then r.SetMediaItemInfo_Value(item, 'C_FADEINSHAPE', in_shape); x = 1 end
      end
      if out_len_item == 0 then
        if out_len and out_len > 0 then r.SetMediaItemInfo_Value(item, 'D_FADEOUTLEN', out_len); x = 1 end
        if out_curve and out_curve >= -1 and out_curve <= 1 then r.SetMediaItemInfo_Value(item, 'D_FADEOUTDIR', out_curve); x = 1 end
--        r.SetMediaItemInfo_Value(item, 'D_FADEOUTLEN_AUTO', out_auto)
        if out_shape then r.SetMediaItemInfo_Value(item, 'C_FADEOUTSHAPE', out_shape); x = 1 end
      end
      if x then r.UpdateItemInProject(item) end
    end
--    r.UpdateArrange()
  end

  last_ch_count = ch_count
  r.defer(main)
end

-----------------------------------------------

function SetButtonON()
  r.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  r.RefreshToolbar2( sec, cmd )
  main()
end

-----------------------------------------------

function SetButtonOFF()
  r.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  r.RefreshToolbar2( sec, cmd ) 
end

-----------------------------------------------

  _, _, sec, cmd = r.get_action_context()
  SetButtonON()
  r.atexit(SetButtonOFF)
