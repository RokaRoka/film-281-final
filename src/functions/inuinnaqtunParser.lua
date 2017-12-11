local parser = function(line, inuinnaqtun, textcolor1, textcolor2)
  --function here
  local count2 = 1
  local coloredString = {}
  local count = 1
  local stringChunks = {}
  local wordCount = 1
  local wordInfo = {}

  stringChunks[count] = line
  coloredString[count2] = textcolor1
  coloredString[count2+1] = stringChunks[count]

  for _, word in ipairs(inuinnaqtun.keys) do
    for m in string.gmatch(line, word) do
      --find char positions in string
      local start_i, end_i = string.find(line, m)
      local current_start_i = string.find(line, stringChunks[count])
      hudebug.updateMsg(1, count+2, "Match found. Match chars start at "..start_i.." and end at "..end_i)

      --create first string of split
      stringChunks[count] = string.sub(line, current_start_i, start_i-1)
      coloredString[count2] = textcolor1
      coloredString[count2+1] = stringChunks[count]
      hudebug.updateMsg(1, count+3, "Match "..m.." found. Splitting into "..stringChunks[count])

      count = count + 1
      count2 = count2 + 2
      stringChunks[count] = m
      coloredString[count2] = textcolor2
      coloredString[count2+1] = m
      hudebug.updateMsg(1, count+3, "And next part into "..stringChunks[count])
      --spawn word info
      wordInfo[wordCount] = {}
      wordInfo[wordCount].charIndex = start_i
      wordInfo[wordCount].word = m
      wordInfo[wordCount].info = inuinnaqtun[m]
      wordCount = wordCount + 1

      count = count + 2
      count2 = count2 + 2
      stringChunks[count] = string.sub(line, end_i+1, line:len())
      coloredString[count2] = textcolor1
      coloredString[count2+1] = stringChunks[count]
      hudebug.updateMsg(1, count+3, "And next part into "..stringChunks[count])
    end
  end

  return coloredString, wordInfo
end

return parser
