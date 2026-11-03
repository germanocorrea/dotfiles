#!/usr/bin/env bash
# Claude Code status line, two lines:
#   model | effort | context | usage limits
#   directory | git branch | PR
input=$(cat)

RESET=$'\033[0m'; DIM=$'\033[2m'
CYAN=$'\033[36m'; MAGENTA=$'\033[35m'; BLUE=$'\033[34m'
GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RED=$'\033[31m'

# One jq pass; unit separator keeps empty fields from collapsing in `read`.
IFS=$'\x1f' read -r MODEL EFFORT CTX_PCT DIR PR_NUM PR_URL PR_STATE PR_KIND \
  FIVE_PCT FIVE_RESET WEEK_PCT WEEK_RESET SPEND_PCT SPEND_RESET < <(
  jq -r '[
    .model.display_name // "?",
    .effort.level // "",
    .context_window.used_percentage // "",
    .workspace.current_dir // .cwd // "",
    .pr.number // "",
    .pr.url // "",
    .pr.review_state // "",
    .pr.kind // "",
    .rate_limits.five_hour.used_percentage // "",
    .rate_limits.five_hour.resets_at // "",
    .rate_limits.seven_day.used_percentage // "",
    .rate_limits.seven_day.resets_at // "",
    .rate_limits.spend_limit.used_percentage // "",
    .rate_limits.spend_limit.resets_at // ""
  ] | map(tostring) | join("\u001f")' <<<"$input"
)

# Green below 50%, yellow below 80%, red from there on.
pct_color() {
  if   (( $1 >= 80 )); then printf '%s' "$RED"
  elif (( $1 >= 50 )); then printf '%s' "$YELLOW"
  else                      printf '%s' "$GREEN"
  fi
}

# Time left until an epoch timestamp, e.g. "2h14m" or "3d5h".
time_left() {
  local s=$(( ${1%.*} - $(date +%s) ))
  (( s <= 0 )) && { printf 'now'; return; }
  local d=$(( s / 86400 )) h=$(( s % 86400 / 3600 )) m=$(( s % 3600 / 60 ))
  if   (( d > 0 )); then printf '%dd%dh' "$d" "$h"
  elif (( h > 0 )); then printf '%dh%02dm' "$h" "$m"
  else                   printf '%dm' "$m"
  fi
}

# "<label> <pct>% (<time left>)" for one limit window; nothing when absent.
limit() {
  local label=$1 pct=$2 reset=$3
  [[ -z $pct ]] && return
  pct=$(printf '%.0f' "$pct")
  printf '%s%s%s %s%d%%%s' "$DIM" "$label" "$RESET" "$(pct_color "$pct")" "$pct" "$RESET"
  [[ -n $reset ]] && printf ' %s(%s)%s' "$DIM" "$(time_left "$reset")" "$RESET"
}

# Line 1: Claude session (model, effort, context, usage limits).
claude=("${CYAN}${MODEL}${RESET}")

[[ -n $EFFORT ]] && claude+=("${MAGENTA}${EFFORT}${RESET}")

# Share of the current context window in use (null before the first API call).
[[ -n $CTX_PCT ]] && claude+=("$(limit ctx "$CTX_PCT" "")")

usage=()
for l in "$(limit 5h "$FIVE_PCT" "$FIVE_RESET")" \
         "$(limit 7d "$WEEK_PCT" "$WEEK_RESET")" \
         "$(limit spend "$SPEND_PCT" "$SPEND_RESET")"; do
  [[ -n $l ]] && usage+=("$l")
done
(( ${#usage[@]} )) && claude+=("${usage[*]}")

# Line 2: project (directory, git branch, PR).
project=()
[[ -n $DIR ]] && project+=("${YELLOW}${DIR/#$HOME/\~}${RESET}")

if [[ -n $DIR ]] && git -C "$DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
  # Detached HEAD: fall back to the short commit hash.
  [[ -z $BRANCH ]] && BRANCH=$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null)
  if [[ -n $BRANCH ]]; then
    DIRTY=""
    [[ -n $(git -C "$DIR" --no-optional-locks status --porcelain 2>/dev/null | head -n1) ]] && DIRTY="*"
    project+=("${BLUE}${BRANCH}${DIRTY}${RESET}")

    if [[ -n $PR_NUM ]]; then
      if [[ $PR_KIND == mr ]]; then LABEL="MR !${PR_NUM}"; else LABEL="PR #${PR_NUM}"; fi
      case $PR_STATE in
        approved)          PR_COLOR=$GREEN;  STATE=" approved" ;;
        changes_requested) PR_COLOR=$RED;    STATE=" changes requested" ;;
        pending)           PR_COLOR=$YELLOW; STATE=" pending review" ;;
        draft)             PR_COLOR=$DIM;    STATE=" draft" ;;
        *)                 PR_COLOR=$GREEN;  STATE="" ;;
      esac
      # OSC 8 hyperlink so the PR is clickable in terminals that support it.
      [[ -n $PR_URL ]] && LABEL=$'\033]8;;'"${PR_URL}"$'\a'"${LABEL}"$'\033]8;;\a'
      project+=("${PR_COLOR}${LABEL}${STATE}${RESET}")
    else
      project+=("${DIM}no PR${RESET}")
    fi
  fi
fi

SEP=" ${DIM}|${RESET} "
join() {
  local out="" p
  for p in "$@"; do out+="${out:+$SEP}$p"; done
  printf '%s' "$out"
}

printf '%s\n' "$(join "${claude[@]}")"
if (( ${#project[@]} )); then printf '%s\n' "$(join "${project[@]}")"; fi
