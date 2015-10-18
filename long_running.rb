def long_running(seconds_until_progress_printed = 1, &proc)
  t = Thread.new(&proc)
  unless t.join(seconds_until_progress_printed)
    t[:print_progress] = true
    t.join
    puts if t[:progress_printed]
  end
  t.value
end

def long_running_progress(output = ".")
  if Thread.current[:print_progress]
    print output
    Thread.current[:progress_printed] = true
  end
end
