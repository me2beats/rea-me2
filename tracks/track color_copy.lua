local r = reaper

tr = r.GetSelectedTrack(0, 0)
if not tr then return end

tr_color = r.GetMediaTrackInfo_Value(tr, 'I_CUSTOMCOLOR')

r.DeleteExtState('me2beats_copy-paste', 'tr_color', 0)
r.SetExtState('me2beats_copy-paste', 'tr_color', tr_color, 0)