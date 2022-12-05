#!/bin/bash
set -ue

HOME=$(echo $HOME)
PATH_TARGET_ALIAS="$HOME/.my-aliases"

profile_file_path=""

target_folder=$1

help() {
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
  help
  exit 1
fi

if [ ! -d $target_folder ]; then
  echo "> ERROR: ${target_folder} no exists, specify another path"
  exit 1
fi

append_data_to_file() {
  local file_path=$1
  local data_to_append=$2

  echo "${data_to_append}" >>"$file_path"
}

get_profile_file() {
  local files=(.zhrc .bashrc .bash_alias .bash_profile .profile)

  for file in "${files[@]}"; do
    path="${HOME}/${file}"

    if [ -f $path ]; then
      profile_file_path="$HOME/$file"
      break
    fi
  done
}

ensure_path_target_file() {
  if [ ! -d $PATH_TARGET_ALIAS ]; then
    mkdir -p "$PATH_TARGET_ALIAS"
  fi
}

ensure_profile_file() {
  if [ -z $profile_file_path ]; then
    echo "Profile file not present"
    exit 1
  fi
}

has_contains_text() {
  local pattern=$1
  local file_name=$2

  local matches=$(grep -n "${pattern}" $file_name | wc -l)

  if [ $matches == 0 ]; then
    echo false
  else
    echo true
  fi
}

append_path_target_file_to_profile_file() {
  local path_target_alias=$1
  local profile_file_path=$2

  local is_loaded_target_file=$(has_contains_text ". ${path_target_alias}" $profile_file_path)

  if ! $is_loaded_target_file ; then
    append_data_to_file $profile_file_path ". ${path_target_alias}"
  fi
}

add_alias_to_target_file() {
  local path_target_alias=$1
  local alias_name=$2

  loaded_alias=false

  if [ -f $path_target_alias ]; then
    local matches=$(has_contains_text $alias_name $path_target_alias)

    loaded_alias=$matches
  fi

  if ! $loaded_alias; then
    append_data_to_file $path_target_alias "alias $alias_name"
  fi
}

get_profile_file
ensure_profile_file
ensure_path_target_file

filename_target_alias=$(basename $target_folder)
path_target_alias="$PATH_TARGET_ALIAS/$filename_target_alias"

folders=($(ls -d $target_folder/*/))

for folder in "${folders[@]}"; do
  alias_name=$(basename $folder)

  echo "> Creating alias for -> ${alias_name}"

  add_alias_to_target_file $path_target_alias "${alias_name}=${folder}"
done

append_path_target_file_to_profile_file $path_target_alias $profile_file_path

echo
echo "> Alias created in $path_target_alias"
echo "> Run: source $profile_file_path"
echo "> Happy coding :)"
