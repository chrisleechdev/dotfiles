function prompt_privileges() {
  local PRIVILEGES_STATE=$(privilegescli --status 2>&1 | awk -F ' ' '{print $4}')
  if [[ $PRIVILEGES_STATE == "admin" ]]
  then
      p10k segment -r -b white -f red -i 'LOCK_ICON' -t 'admin'
  elif [[ $PRIVILEGES_STATE == "standard" ]]
  then
      p10k segment -r -b white -f green -i 'OK_ICON' -t 'standard'
  fi
}
