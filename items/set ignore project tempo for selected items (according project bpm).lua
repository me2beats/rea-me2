local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end
items = r.CountSelectedMediaItems()
if items > 0 then
  
  r.Undo_BeginBlock()

  for i = 0, items-1 do
    item = r.GetSelectedMediaItem(0,i)
    _, chunk = r.GetItemStateChunk(item, 0, 0)
    new_chunk = chunk:gsub('IGNTEMPO %d %d+','IGNTEMPO 1 '..r.GetProjectTimeSignature2())
    r.SetItemStateChunk(item, new_chunk, 1)
  end
  r.Undo_EndBlock('set ignore project tempo', -1)

else bla() end
