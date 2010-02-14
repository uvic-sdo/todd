def time_period_to_s time_period       
  if time_period < 1
    return "< 1 sec"
  end
 
  out_str = ''
  interval_array = [ [:weeks, 604800], [:days, 86400], [:hours, 3600], [:mins, 60], [:secs, 1] ]
  interval_array.each do |sub|
    if time_period >= sub[1] then
      time_val, time_period = time_period.divmod( sub[1] )
      time_val == 1 ? name = sub[0].to_s.singularize : name = sub[0].to_s
      ( sub[0] != :mins ? out_str += ", " : out_str += " and " ) if out_str != ''
      out_str += time_val.to_s + " #{name}"
    end
  end

  out_str
end
