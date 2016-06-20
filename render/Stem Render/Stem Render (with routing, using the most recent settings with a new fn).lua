function nothing() end

function Save_Solo_Mute ()
  t_sm = {}
  for i = 0, reaper.CountTracks(0)-1 do
    tr_sm = reaper.GetTrack(0,i)
    t_sm[#t_sm+1] = {tr_sm, reaper.GetMediaTrackInfo_Value(tr_sm, 'B_MUTE'), reaper.GetMediaTrackInfo_Value(tr_sm, 'I_SOLO')}
  end
end

function Restore_Solo_Mute ()
  for i = 1, #t_sm do
    tr_sm = t_sm[i][1]
    reaper.SetMediaTrackInfo_Value(tr_sm, 'B_MUTE', t_sm[i][2])
    reaper.SetMediaTrackInfo_Value(tr_sm, 'I_SOLO', t_sm[i][3])
  end
end

init_sel_tracks = {}
local function SaveSelectedTracks (table)
  for i = 0, reaper.CountSelectedTracks(0)-1 do table[i+1] = reaper.GetSelectedTrack(0, i) end
end

local function RestoreSelectedTracks (table)
  reaper.Main_OnCommand(40297, 0) -- unselect all tracks
  for _, track in ipairs(table) do reaper.SetTrackSelected(track, true) end
end

sel = reaper.CountSelectedTracks(0)

if sel > 0 then
  reaper.Undo_BeginBlock()
  SaveSelectedTracks(init_sel_tracks)
  t_sel = {}
  for i = 0, reaper.CountSelectedTracks(0)-1 do
    tr_t = reaper.GetSelectedTrack(0,i)
    t_sel[#t_sel+1] = tr_t
  end
  Save_Solo_Mute ()
  for s = 1, #t_sel do
    reaper.Main_OnCommand(40340, 0) -- unsolo all tracks
    tr = t_sel[s]
    reaper.SetOnlyTrackSelected(tr,0)
    reaper.Main_OnCommand(40728, 0) -- solo tracks
    reaper.Main_OnCommand(41855, 0) -- render project using recent settings
  end
  RestoreSelectedTracks(init_sel_tracks)
  Restore_Solo_Mute ()
  reaper.Undo_EndBlock('Stem Render (with routing, using the most recent settings with a new fn)', -1)
else reaper.defer(nothing) end
