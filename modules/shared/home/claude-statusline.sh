#!/usr/bin/env bash
# Colours are substituted in from the active theme (modules/themes) at build
# time -- see modules/shared/home/claude-code.nix. Do not hardcode hex here.
input=$(cat)

BASE01="@base01@"
BASE02="@base02@"
BASE04="@base04@"
BASE05="@base05@"
BASE08="@accent@"
BASE0A="@warn@"
BASE0B="@ok@"
BASE0C="@info@"
BASE0D="@edge@"
fg() { printf '\033[38;2;%d;%d;%dm' "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }
bg() { printf '\033[48;2;%d;%d;%dm' "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }
R=$'\033[0m'

MODEL=$(jq -r '.model.display_name' <<< "$input")
DIR=$(jq -r '.workspace.current_dir' <<< "$input")
DIRNAME=$(basename "$DIR")
COST=$(jq -r '.cost.total_cost_usd // 0' <<< "$input")
DUR_MS=$(jq -r '.cost.total_duration_ms // 0' <<< "$input")
PCT=$(jq -r '.context_window.used_percentage // 0' <<< "$input" | cut -d. -f1)

GIT_SEG=""
if git -C "$DIR" rev-parse --git-dir >/dev/null 2>&1; then
  BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
  STAGED=$(git -C "$DIR" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  MODIFIED=$(git -C "$DIR" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  GIT_COLOR="$BASE0C"
  { [ "$STAGED" -gt 0 ] || [ "$MODIFIED" -gt 0 ]; } && GIT_COLOR="$BASE0A"
  GIT_SEG="$(bg "$BASE01")$(fg "$GIT_COLOR")  ${BRANCH} +${STAGED} ~${MODIFIED} ${R}"
fi

BAR_COLOR="$BASE0B"
[ "$PCT" -ge 70 ] && BAR_COLOR="$BASE0A"
[ "$PCT" -ge 90 ] && BAR_COLOR="$BASE08"
FILLED=$((PCT / 10))
EMPTY=$((10 - FILLED))
printf -v FILL '%*s' "$FILLED" ''
printf -v EMPT '%*s' "$EMPTY" ''
BAR="${FILL// /█}${EMPT// /░}"

COST_FMT=$(printf '$%.2f' "$COST")
MINS=$((DUR_MS / 60000))
SECS=$(((DUR_MS % 60000) / 1000))

echo -e "$(bg "$BASE02")$(fg "$BASE0D") ${MODEL} ${R}$(bg "$BASE01")$(fg "$BASE05")  ${DIRNAME} ${R}${GIT_SEG}"
echo -e "$(fg "$BAR_COLOR")${BAR}${R} ${PCT}%  $(fg "$BASE0A")${COST_FMT}${R}  $(fg "$BASE04")⏱ ${MINS}m${SECS}s${R}"
