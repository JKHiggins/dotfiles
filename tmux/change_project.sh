#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

project_directories=($(ls -1d ~/projects/*/ | xargs -n1 basename))

# Oh so dirty cuz of the cmds having hardcoded "~/projects"...
project_directories+=("../.config/")

menu_items=(
)

editor_cd_cmd='send-keys -t std-dev:editor.0 ":cd ~/projects'
# tasklist_cd_cmd='send-keys -t std-dev:tasklist.1 "cd ~/projects'
shell_cd_cmd='send-keys -t std-dev:shell.0 "cd ~/projects'

for i in "${!project_directories[@]}"
do
    cmd="$editor_cd_cmd/${project_directories[$i]}\" Enter;"
    # cmd+="$tasklist_cd_cmd/${project_directories[$i]}\" Enter; send-keys -t std-dev:tasklist.1 \"uldef\" Enter;"
    cmd+="$shell_cd_cmd/${project_directories[$i]}\" Enter; send-keys -t std-dev:shell.0 \"git status\" Enter"

    menu_item="'${project_directories[$i]}' $i '$cmd'"

    menu_items+=("$menu_item")
done

printf '%s\n' "${menu_items[@]}" \
    | xargs tmux display-menu \
     -T "#[align=centre] Pick a Directory"
