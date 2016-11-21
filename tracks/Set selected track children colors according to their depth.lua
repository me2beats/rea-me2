local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

tr = r.GetSelectedTrack(0,0)
if not tr then bla() return end
tr_num = r.GetMediaTrackInfo_Value(tr, 'IP_TRACKNUMBER')
next_tr = r.GetTrack(0,tr_num)

if not next_tr or r.GetTrackDepth(next_tr) == 0 then bla() return end

color = r.GetTrackColor(tr)
_r,_g,_b = r.ColorFromNative(color)


max_dep = 0
for i = tr_num, r.CountTracks() do
  tr = r.GetTrack(0,i)
  if not tr then break end
  dep = r.GetTrackDepth(tr)
  if dep > max_dep then max_dep = dep end
  if dep == 0 then break end
end

x = math.floor(_r/(max_dep))
y = math.floor(_g/(max_dep))
z = math.floor(_b/(max_dep))

r.Undo_BeginBlock()

for i = tr_num, r.CountTracks() do
  tr = r.GetTrack(0,i)
  if not tr then break end
  dep = r.GetTrackDepth(tr)
  if dep == 0 then break end
  r.SetTrackColor(tr, r.ColorToNative(_r-x*dep, _g, _b))
end

r.Undo_EndBlock('Set selected track children colors according to their depth', -1)
