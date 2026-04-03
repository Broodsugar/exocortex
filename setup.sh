#!/bin/bash

# Exocortex Setup
# Run this once after cloning to make it yours.

set -e

echo ""
echo "Welcome to your exocortex."
echo "Let's set it up. This takes about 5 minutes."
echo ""

# --- Name ---
read -p "What do you want to call your exocortex? (default: exocortex) " NAME
NAME="${NAME:-exocortex}"

# --- Values ---
echo ""
echo "Let's start with your values — the principles that guide your decisions."
echo "These aren't aspirational. They're descriptive. What do you actually optimize for?"
echo ""

VALUES=""
VALUE_NUM=0
while true; do
  read -p "Enter a value (or press Enter when done): " VALUE_NAME
  [ -z "$VALUE_NAME" ] && [ $VALUE_NUM -gt 0 ] && break
  [ -z "$VALUE_NAME" ] && echo "You need at least one value." && continue
  VALUE_NUM=$((VALUE_NUM + 1))
  echo ""
  echo "What does \"$VALUE_NAME\" mean to you? (Press Enter twice when done)"
  VALUE_DESC=""
  while IFS= read -r line; do
    [ -z "$line" ] && break
    VALUE_DESC="${VALUE_DESC}${line}\n"
  done
  VALUES="${VALUES}### ${VALUE_NAME}\n\n${VALUE_DESC}\n"
done

# --- Green day criteria ---
echo ""
echo "Now let's define what a 'green day' looks like for you."
echo "A green day means you showed up. Red means you didn't. No partial credit."
echo ""

CRITERIA=""
CRIT_NUM=0
while true; do
  read -p "Enter a green day criterion (or press Enter when done): " CRITERION
  [ -z "$CRITERION" ] && [ $CRIT_NUM -gt 0 ] && break
  [ -z "$CRITERION" ] && echo "You need at least one criterion." && continue
  CRIT_NUM=$((CRIT_NUM + 1))
  CRITERIA="${CRITERIA}- [ ] ${CRITERION}\n"
done

# --- Goals ---
echo ""
echo "What daily habits do you want to track? These reset every day."
echo ""

DAILY_GOALS=""
while true; do
  read -p "Enter a daily habit (or press Enter when done): " GOAL
  [ -z "$GOAL" ] && break
  DAILY_GOALS="${DAILY_GOALS}| ${GOAL} | 0% | |\n"
done

echo ""
echo "What long-term goals are you working toward?"
echo ""

LONG_GOALS=""
while true; do
  read -p "Enter a long-term goal (or press Enter when done): " GOAL
  [ -z "$GOAL" ] && break
  LONG_GOALS="${LONG_GOALS}| ${GOAL} | 0% | |\n"
done

# --- Attention ---
echo ""
echo "Finally — what are you focused on RIGHT NOW?"
echo "One thing. The constraint is the point."
echo ""
read -p "> " ATTENTION

# --- Write files ---

# values.md
printf "%b" "$VALUES" > values.md

# accountability.md
cat > accountability.md << 'HEADER'
## Green day criteria

All must be true for a green day:

HEADER
printf "%b" "$CRITERIA" >> accountability.md
cat >> accountability.md << 'FOOTER'

## Calendar

Current streak: 0 days
Longest green streak: 0 days

| Date | Status |
|------|--------|
FOOTER

# goals.md
cat > goals.md << 'HEADER'
# Goals

## Daily habits

Things that reset every day. Progress is today's progress.

| Goal | Progress | Last updated |
| ---- | -------- | ------------ |
HEADER
printf "%b" "$DAILY_GOALS" >> goals.md
cat >> goals.md << 'HEADER'

## Long-term goals

Things that accumulate over time.

| Goal | Progress | Last updated |
| ---- | -------- | ------------ |
HEADER
printf "%b" "$LONG_GOALS" >> goals.md

# attention.md
echo "$ATTENTION" > attention.md

# --- Clean up and reinitialize ---
rm -rf .git
git init
git add .
git commit -m "Initialize ${NAME}"

echo ""
echo "Done. Your exocortex '${NAME}' is ready."
echo ""
echo "Next steps:"
echo "  1. Create a repo on GitHub and push this up"
echo "  2. Open a conversation with your AI agent in this directory"
echo "  3. Start working — it'll read your exocortex and keep you on track"
echo ""
