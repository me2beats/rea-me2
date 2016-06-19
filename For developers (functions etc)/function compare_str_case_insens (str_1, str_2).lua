function compare_str_case_insens (str_1, str_2)
  capture = ''
  if str_1 and str_2 then
    for w in str_1:gmatch('.') do capture = capture..'['..w:lower()..','..w:upper()..']' end
    if str_2:match(capture) then return true end
  end
end
