function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

# Show fish as... sleeping on command error
function _fish_eye
  if test $status -ne 0
    return "x"
  else
    return "*"
  end
end

function fish_prompt
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l red (set_color -o red)
  set -l yellow (set_color -o yellow)

  set -l orange_fish (set_color -o FFA500)
  set -l yellow_fish (set_color -o FFB732)
  set -l red_fish (set_color -o FF725A)
  set -l black_fish (set_color -o 3F3F3F)

  set_color $fish_color_cwd

  if [ -n "$SSH_CONNECTION" ]
    printf '%s | ' (hostname | head -c 10)
  end

  if [ "$HOME" = (pwd) ]
    printf "$red~"
  else
    printf (prompt_pwd)
  end

  printf "$blue ─> "

  # Draw git branch
  if [ (_git_branch_name) ]
    if test (_git_branch_name) = "main" || test (_git_branch_name) = "master"
      printf "$red{$(string upper $(_git_branch_name))}"
    else
      printf "$red{"(_git_branch_name)"}"
    end
  end

  # Add new line
  printf "\n"

  # Draw fish
  if not [ (_git_branch_name) ]
      printf "$blue><}}$(_fish_eye)> "
    else
      printf "$red><}}$(_fish_eye)> "
  end

  # Draw fish when git dir
  if [ (_git_branch_name) ] and [ (_is_git_dirty) ]
    printf "$orange_fish><$yellow_fish}}$black_fish$(_fish_eye)$red_fish< "
  else
    printf "$orange_fish><$yellow_fish}}$black_fish$(_fish_eye)$orange_fish> "
  end
end
