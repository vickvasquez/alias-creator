#!/bin/bash
set -e

HOME=$(echo $HOME)
FILENAME_TO_SAVE_ALIAS="$HOME/.my-aliases"

file_to_export_alias=""

target_folder=$1

Help() {
  echo
  echo "Alias Creator for UNIX system"
  echo
  echo "Usage: alias-creator.sh ~/path-folder/"
  echo
  echo "Example:"
  echo "  alias-creator.sh ~/Documents/"
}

if [ -z $target_folder ]; then
  echo "> ERROR: Specify the path of the containing folder to set the aliases"
  Help
  exit 1
fi

if [ ! -d $target_folder ]; then
  echo "> ERROR: ${target_folder} no exists, specify another path"
  exit 1
fi

function getFileToCreateAlias() {
  local files=(.zshrc .bashrc .bash_alias .bash_profile .profile)

  for file in $files; do
    if [ ! -z "$HOME/$file" ]; then
      file_to_export_alias="$HOME/$file"
      break
    fi
  done
}

getFileToCreateAlias

folders=($(ls -d $target_folder/*/))

echo "> Creating alias .....\n"

for folder in "${folders[@]}"; do
  alias_name=$(basename $folder)

  echo "> Creating alias for -> ${alias_name}"

  echo "alias $alias_name=$folder" >>$FILENAME_TO_SAVE_ALIAS
done

echo ". $FILENAME_TO_SAVE_ALIAS" >>$file_to_export_alias

echo "\n> Alias created in $FILENAME_TO_SAVE_ALIAS"
echo "> Run: source $file_to_export_alias"
echo "> Happy coding :)"
