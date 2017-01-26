local r = reaper

tr = r.GetSelectedTrack(0, 0)
if not tr then return end

tr_pan = r.GetMediaTrackInfo_Value(tr, 'D_PAN')

r.DeleteExtState('me2beats_copy-paste', 'tr_pan', 0)
r.SetExtState('me2beats_copy-paste', 'tr_pan', tr_pan, 0)