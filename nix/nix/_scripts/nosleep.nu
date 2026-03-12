def main [duration?: duration] {
  if ($duration == null) {
    print "Keeping awake indefinitely... (Press Ctrl+C to stop)"
    try {
      if $nu.os-info.name == "macos" {
        ^caffeinate -disum
      } else {
        ^systemd-inhibit --what=idle:sleep:handle-lid-switch --who="nosleep" --why="User requested" --mode=block sleep infinity
      }
    } catch {
      print "\nKeep awake stopped."
    }

    return
  }

  let end_time = ((date now) + $duration)

  print $"Keeping awake for ($duration)..."

  let duration_seconds = (
      $duration |
      format duration sec |
      parse "{time} {unit}" |
      get time |
      last
  )

  job spawn {
    if $nu.os-info.name == "macos" {
      ^caffeinate -disum -t $duration_seconds
    } else {
      ^systemd-inhibit --what=idle:sleep:handle-lid-switch --who="nosleep" --why="User requested" --mode=block sleep $duration_seconds
    }
  }

  print -n (ansi cursor_off)

  try {
    loop {
      let left = ($end_time - (date now))
      if $left <= 0sec { break }

      let left_fmt = (
        $left |
        into string |
        split row ' ' |
        first 2 |
        str join ' '
      )

      print -n $"\rTime remaining: ($left_fmt)   "

      sleep 25ms
    }
  } catch {
    print "\nStopped by user."
  }

  print -n $"\rTime remaining: 0s               "

  print -n (ansi cursor_on)
  print "\nDone."
}
