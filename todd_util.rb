require 'pp'

def needs file
  begin
    require file
  rescue LoadError => e
    warn "Cannot find module %s, perhaps you need to install it?" % file
    exit
  end
end

def time_period_to_s time_period
  time_period = time_period.to_i

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

def to_minimal_time_s time_period
  time_period = time_period.to_i

  out_str = ''
  interval_array = [60, 1]
  interval_array.each do |sub|
    if time_period >= sub then
      time_val, time_period = time_period.divmod(sub)
      out_str += "%02d" % time_val
    else
      out_str += "00"
    end
    out_str += ":" if sub != interval_array[-1]
  end

  out_str
end

def format_bundle bundle, formatting = "minimal"
  case formatting
    when "table"
      needs 'terminal-table/import'
      return format_to_table bundle
    when "minimal"
      return format_minimal bundle
    when "ruby_obj"
      return PP.pp(bundle,'')
    when "json"
      needs 'json'
      return bundle.to_json
    else
      puts "ERROR: Cannot format bundle to #{formatting}"
      exit
  end
end

def format_to_table stack, ret_table = true
  stack = [stack] unless stack.class == [].class
  rows = []

  while item = stack.pop
    case item[:type]
      when :todolist
        return "" if item[:categories] == []
        stack =  item[:categories]
      when :category
        return "" if item[:task] == []
        rows << ['Category:',item[:name],'','']
        rows << :separator
        rows += format_to_table item[:tasks], false
        rows << :separator unless stack.empty?
      when :task
        running = item[:active]
        rows << [
          item[:id],
          item[:title],
          running ? time_period_to_s(item[:session_time]) : 'Not Running',
          item[:total_time].to_i > 0.1 ? time_period_to_s(item[:total_time].to_i) : 'Never Run'
        ]
      else
        puts "ERROR: Bundle type #{bundle[:type]} not recognized"
        exit
    end
  end

  return rows unless ret_table

  table(["ID", "Task", "Session Time", "Total Time"], *rows)
end

def format_minimal stack, ret_string = true
  stack = [stack] unless stack.class == [].class
  rows = []

  while item = stack.pop
    case item[:type]
      when :todolist
        return "" if item[:categories] == []
        stack =  item[:categories]
      when :category
        return "" if item[:task] == []
        rows << "+ #{item[:name]}"
        rows += format_minimal item[:tasks], false
        rows << " " unless stack.empty?
      when :task
        rows << [
          item[:id],
          item[:active] ? 'x' : ' ',
          to_minimal_time_s(item[:session_time]),
          to_minimal_time_s(item[:total_time]),
          item[:title]
        ].map { |e|
          "[%s]" % e
        } * " "
      else
        puts "ERROR: Bundle type #{bundle[:type]} not recognized"
        exit
    end
  end

  return rows unless ret_string

  rows << "\n"
  rows * "\n"
end
