local r = reaper

tr = r.GetSelectedTrack(0, 0)
if not tr then return end

_, tr_name = r.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)

r.DeleteExtState('me2beats_copy-paste', 'track_name', 0)
r.SetExtState('me2beats_copy-paste', 'track_name', tr_name, 0)