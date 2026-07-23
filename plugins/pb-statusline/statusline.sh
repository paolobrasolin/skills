#!/bin/bash
# UTF-8 locale so ${#var} counts the "·" separators as 1 char in the padding math
export LC_ALL=en_US.UTF-8
input=$(cat)

# single jq pass -> shell vars (@sh quotes each value for safe eval);
# blank the row instead of rendering a stub if jq is missing or input isn't JSON
vars=$(echo "$input" | jq -r 2>/dev/null '
  def num(f): (f // null) | if . == null then "" else (floor | tostring) end;
  @sh "DIR=\(.workspace.current_dir // "")",
  @sh "WTREF=\(.worktree.name // .workspace.git_worktree // "")",
  @sh "MODEL=\(.model.display_name // "?")",
  @sh "AGENT=\(.agent.name // "")",
  @sh "EFFORT=\(.effort.level // "")",
  @sh "PCT=\(num(.context_window.used_percentage))",
  @sh "SIZE=\(.context_window.context_window_size // 200000)",
  @sh "EX200K=\(.exceeds_200k_tokens // false)",
  @sh "FH_PCT=\(num(.rate_limits.five_hour.used_percentage))",
  @sh "FH_RST=\(num(.rate_limits.five_hour.resets_at))",
  @sh "SD_PCT=\(num(.rate_limits.seven_day.used_percentage))",
  @sh "SD_RST=\(num(.rate_limits.seven_day.resets_at))"
') || exit 0
eval "$vars"

NOW=$(date +%s)
countdown() { # $1 = reset epoch -> time left as 2d17h / 1h47m / 34m
  local s=$(( $1 - NOW ))
  [ "$s" -lt 0 ] && s=0
  local d=$(( s / 86400 )) h=$(( s % 86400 / 3600 )) m=$(( s % 3600 / 60 ))
  if [ "$d" -gt 0 ]; then printf '%dd%dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then printf '%dh%02dm' "$h" "$m"
  else printf '%dm' "$m"; fi
}
burn_time() { # $1 = used pct, $2 = reset epoch, $3 = window seconds
  # countdown colored by burn rate: coverage = share of the window the current
  # pace lasts before quota runs out. >=100% plain, then green/yellow/red/fuchsia.
  local txt left elapsed cov col=""
  txt=$(countdown "$2")
  left=$(( $2 - NOW )); [ "$left" -lt 0 ] && left=0; [ "$left" -gt "$3" ] && left=$3
  elapsed=$(( $3 - left ))
  if [ "$1" -gt 0 ] && [ "$elapsed" -gt 0 ]; then
    cov=$(( elapsed * 10000 / ($3 * $1) ))
    if   [ "$cov" -ge 100 ]; then col=""
    elif [ "$cov" -ge 80 ]; then col='\033[32m'
    elif [ "$cov" -ge 60 ]; then col='\033[33m'
    elif [ "$cov" -ge 40 ]; then col='\033[31m'
    else col='\033[95m'; fi
  fi
  if [ -n "$col" ]; then printf "${col}%s\033[0m" "$txt"; else printf '%s' "$txt"; fi
}
pct() { # bold colored percentage: green <50, yellow <80, red >=80
  if [ "$1" -lt 50 ]; then printf '\033[1;32m%s%%\033[0m' "$1"
  elif [ "$1" -lt 80 ]; then printf '\033[1;33m%s%%\033[0m' "$1"
  else printf '\033[1;31m%s%%\033[0m' "$1"; fi
}

# left: <folder>@<ref>
FOLDER=${DIR##*/}
REF=$WTREF
[ -z "$REF" ] && REF=$(git -C "$DIR" branch --show-current 2>/dev/null)
LEFT="$FOLDER${REF:+@$REF}"

# right: <agent:>model effort · ctx%/size · 5h%/left · 7d%/left
if [ "$SIZE" -ge 1000000 ]; then SIZE_FMT="$((SIZE / 1000000))M"; else SIZE_FMT="$((SIZE / 1000))k"; fi
# context colors by tokens, not window share: yellow past 200k, red near the cap
if [ "${PCT:-0}" -ge 80 ]; then CTX_PCT=$(printf '\033[1;31m%s%%\033[0m' "${PCT:-0}")
elif [ "$EX200K" = "true" ]; then CTX_PCT=$(printf '\033[1;33m%s%%\033[0m' "${PCT:-0}")
else CTX_PCT=$(printf '\033[1;32m%s%%\033[0m' "${PCT:-0}"); fi
RIGHT="${AGENT:+$AGENT:}$MODEL${EFFORT:+ $EFFORT}"
RIGHT+=" · $CTX_PCT/$SIZE_FMT"
[ -n "$FH_PCT" ] && RIGHT+=" · $(pct "$FH_PCT")/$(burn_time "$FH_PCT" "$FH_RST" 18000)"
[ -n "$SD_PCT" ] && RIGHT+=" · $(pct "$SD_PCT")/$(burn_time "$SD_PCT" "$SD_RST" 604800)"

# pad to width; MARGIN covers the UI's own indent around the row.
# length math strips ANSI codes so colors don't skew the padding.
MARGIN=4
COLS=$(( ${COLUMNS:-120} - MARGIN ))
strip_ansi() { # $1 = out var name, $2 = string -> assigns $2 minus SGR codes (no forks)
  local s=$2 pre rest
  while [[ $s == *$'\e['* ]]; do
    pre=${s%%$'\e['*}; rest=${s#*$'\e['}
    s=$pre${rest#*m}
  done
  printf -v "$1" '%s' "$s"
}
strip_ansi PLAIN_L "$LEFT"; strip_ansi PLAIN_R "$RIGHT"
PAD=$(( COLS - ${#PLAIN_L} - ${#PLAIN_R} ))
if [ "$PAD" -lt 1 ]; then
  printf '%s %s\n' "$LEFT" "$RIGHT"
else
  printf '%s%*s%s\n' "$LEFT" "$PAD" '' "$RIGHT"
fi
