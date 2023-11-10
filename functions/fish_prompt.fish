function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

# Show fish as... sleeping on command error
function _fish_eye
  if test $status -ne 0
    echo "x"
  else
    echo "*"
  end
end

function _init_colors
  set -g blue (set_color -o blue)
  set -g green (set_color -o green)
  set -g red (set_color -o red)
  set -g yellow (set_color -o yellow)

  set -g orange_fish (set_color -o FFA500)
  set -g yellow_fish (set_color -o FFB732)
  set -g red_fish (set_color -o FF725A)
  set -g black_fish (set_color -o 3F3F3F)

  set_color $fish_color_cwd
end

function _maybe_draw_ssh_conn
  if test -n "$SSH_CONNECTION"
    printf '%s | ' (hostname | head -c 10)
  end
end

function _draw_current_dir
  if test "$HOME" = (pwd)
    printf "$red~"
  else
    printf (prompt_pwd)
  end
end

function _maybe_draw_git_branch
  set -l branch_name (_git_branch_name)

  if test -n "$branch_name"
    switch "$branch_name"
      case 'main' 'master'
        printf "$red{[%s]}" (string upper $branch_name)
      case '*'
        printf "$red{[%s]}" "$branch_name"
    end
  end
end

function _draw_fish
  set -l fish_eye (_fish_eye)
  set -l branch_name (_git_branch_name)

  # git dir = false
  if not test -n "$branch_name"
      printf "$blue><}}$fish_eye> "
  end

  # git dir = true
  if test -n "$branch_name" ; and -n (_is_git_dirty)
    printf "$orange_fish><$yellow_fish}}$black_fish$fish_eye$red_fish< "
  end
  
  if test -b "$branch_name" ; and not -n (_is_git_dirty)
    printf "$orange_fish><$yellow_fish}}$black_fish$fish_eye$orange_fish> "
  end
end

function fish_prompt
  _init_colors

  _maybe_draw_ssh_conn

  _draw_current_dir

  printf "$blue ─> "

  _maybe_draw_git_branch

  printf "\n"

  _draw_fish
end
