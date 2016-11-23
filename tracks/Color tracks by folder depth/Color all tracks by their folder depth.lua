local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

tr = r.GetSelectedTrack(0,0); if not tr then bla() return end

color_str = r.GetExtState("me2beats", "color_tracks_by_dep")
if color_str == '' then bla() return end

t = {}
for color in color_str:gmatch'%S+' do t[#t+1] = tonumber(color) end

tr_num = r.GetMediaTrackInfo_Value(tr, 'IP_TRACKNUMBER')

r.Undo_BeginBlock()

for i = 0, r.CountTracks() do
  tr = r.GetTrack(0,i); if not tr then break end
  dep = r.GetTrackDepth(tr)
  if t[dep+1] then
    r.SetTrackColor(tr, t[dep+1])
  end
end

r.Undo_EndBlock('Color tracks by their folder depth', -1)
