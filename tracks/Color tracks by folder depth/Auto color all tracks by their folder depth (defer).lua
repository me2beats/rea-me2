local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

function auto_color_tracks_by_depth()
--  r.PreventUIRefresh(1)

  for i = 0, r.CountTracks() do
    tr = r.GetTrack(0,i); if not tr then break end
    dep = r.GetTrackDepth(tr)
    if t[dep+1] then
      r.SetTrackColor(tr, t[dep+1])
    end
  end
  
--  r.PreventUIRefresh(-1)
end


function main()
  local ch_count = r.GetProjectStateChangeCount()

  if not last_ch_count or last_ch_count ~= ch_count then

    auto_color_tracks_by_depth()

  end

  last_ch_count = ch_count
  r.defer(main)
end

----------------------------------------------------------------------------------------------------
function SetButtonON()
  r.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  r.RefreshToolbar2( sec, cmd )
  main()
end

----------------------------------------------------------------------------------------------------
function SetButtonOFF()
  r.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  r.RefreshToolbar2( sec, cmd ) 
end
----------------------------------------------------------------------------------------------------

_, _, sec, cmd = r.get_action_context()


tr = r.GetSelectedTrack(0,0); if not tr then bla() return end

color_str = r.GetExtState("me2beats", "color_tracks_by_dep")
if color_str == '' then bla() return end

t = {}
for color in color_str:gmatch'%S+' do t[#t+1] = tonumber(color) end

tr_num = r.GetMediaTrackInfo_Value(tr, 'IP_TRACKNUMBER')


SetButtonON()
r.atexit(SetButtonOFF)

