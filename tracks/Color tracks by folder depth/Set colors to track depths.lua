local r = reaper

r.Undo_BeginBlock()

tr = r.GetSelectedTrack(0,0); if not tr or r.GetTrackDepth(tr) ~= 0 then return end

tr_num = r.GetMediaTrackInfo_Value(tr, 'IP_TRACKNUMBER')

color_str = ''
for i = tr_num-1, r.CountTracks() do
  tr = r.GetTrack(0,i)
  if not tr or (r.GetTrackDepth(tr) == 0 and i ~= tr_num-1) then break end
  color = r.GetTrackColor(tr)
  color_str = color_str..color..' '
end

r.SetExtState("me2beats", "color_tracks_by_dep", color_str, 1)

r.Undo_EndBlock('Set colors to track depths', -1)
