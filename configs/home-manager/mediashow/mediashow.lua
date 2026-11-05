-- Loop animations and videos shorter than image-display-duration the fewest whole times that keep them on screen that long
mp.register_event("file-loaded", function()
  mp.set_property("loop-file", "no")

  local delay = mp.get_property_number("image-display-duration")
  local duration = mp.get_property_number("duration")
  if mp.get_property_bool("current-tracks/video/image") or not delay or not duration or duration >= delay then
    return
  end

  local plays = math.ceil(delay / duration)
  mp.set_property_number("loop-file", plays - 1)
end)
