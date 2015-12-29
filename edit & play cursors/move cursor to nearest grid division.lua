pos = reaper.GetCursorPosition()
newpos = reaper.BR_GetClosestGridDivision(pos)
reaper.SetEditCurPos(newpos, false, false)