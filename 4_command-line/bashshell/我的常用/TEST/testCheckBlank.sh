#!/bin/bash

error_log="error.log"

has_param_blank(){
  echo "params count : $#"
  if [ "$#" -eq 0 ]; then
      echo "Error: params is zero" >> "$error_log"
      return 1
  fi
  
  local paramIndex=1
  for param in "$@"; do
    if [ -z "${param+x}" ] || [ -z "$param" ]; then
      echo "Error: param $paramIndex is not set or is empty" >> "$error_log"
      return 1
    fi
  done
  paramIndex=$((paramIndex + 1))
  return 0
}

package_sris_greenc_aw_boot(){
  set -x
  
  local firstDir="$1"
  local subdir="$2"
  local item="$3"

  if ! has_param_blank "$@"; then
    echo "Error: params has blank" >> "$error_log"
    return 1
  fi
  echo "all params are set and not empty"
  
  set +x
}

package_sris_greenc_aw_boot ""

