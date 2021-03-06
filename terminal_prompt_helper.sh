# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color)    color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

# assuming that we __have__ a color prompt, do something fun with it!
# If in a git repo (that is not your home dir itself):
# + display branch as green if you're all good
# + display branch as yellow if branch is not the same as origin/remote
# + display branch as red if you have uncommitted changes
if [ "$color_prompt" = yes ]; then
    #  SETUP CONSTANTS
    #  Bunch-o-predefined colors.  Makes reading code easier than escape sequences.
    Color_Off="\[\033[0m\]"       # Text Reset
    # Regular Colors
    Black="\[\033[0;30m\]"        # Black
    Red="\[\033[0;31m\]"          # Red
    Green="\[\033[0;32m\]"        # Green
    Yellow="\[\033[0;33m\]"       # Yellow
    Blue="\[\033[0;34m\]"         # Blue
    Purple="\[\033[0;35m\]"       # Purple
    Cyan="\[\033[0;36m\]"         # Cyan
    White="\[\033[0;37m\]"        # White
    # Bold
    BBlack="\[\033[1;30m\]"       # Black
    BRed="\[\033[1;31m\]"         # Red
    BGreen="\[\033[1;32m\]"       # Green
    BYellow="\[\033[1;33m\]"      # Yellow
    BBlue="\[\033[1;34m\]"        # Blue
    BPurple="\[\033[1;35m\]"      # Purple
    BCyan="\[\033[1;36m\]"        # Cyan
    BWhite="\[\033[1;37m\]"       # White
    # Underline
    UBlack="\[\033[4;30m\]"       # Black
    URed="\[\033[4;31m\]"         # Red
    UGreen="\[\033[4;32m\]"       # Green
    UYellow="\[\033[4;33m\]"      # Yellow
    UBlue="\[\033[4;34m\]"        # Blue
    UPurple="\[\033[4;35m\]"      # Purple
    UCyan="\[\033[4;36m\]"        # Cyan
    UWhite="\[\033[4;37m\]"       # White
    # Background
    On_Black="\[\033[40m\]"       # Black
    On_Red="\[\033[41m\]"         # Red
    On_Green="\[\033[42m\]"       # Green
    On_Yellow="\[\033[43m\]"      # Yellow
    On_Blue="\[\033[44m\]"        # Blue
    On_Purple="\[\033[45m\]"      # Purple
    On_Cyan="\[\033[46m\]"        # Cyan
    On_White="\[\033[47m\]"       # White
    # High Intensty
    IBlack="\[\033[0;90m\]"       # Black
    IRed="\[\033[0;91m\]"         # Red
    IGreen="\[\033[0;92m\]"       # Green
    IYellow="\[\033[0;93m\]"      # Yellow
    IBlue="\[\033[0;94m\]"        # Blue
    IPurple="\[\033[0;95m\]"      # Purple
    ICyan="\[\033[0;96m\]"        # Cyan
    IWhite="\[\033[0;97m\]"       # White
    # Bold High Intensty
    BIBlack="\[\033[1;90m\]"      # Black
    BIRed="\[\033[1;91m\]"        # Red
    BIGreen="\[\033[1;92m\]"      # Green
    BIYellow="\[\033[1;93m\]"     # Yellow
    BIBlue="\[\033[1;94m\]"       # Blue
    BIPurple="\[\033[1;95m\]"     # Purple
    BICyan="\[\033[1;96m\]"       # Cyan
    BIWhite="\[\033[1;97m\]"      # White
    # High Intensty backgrounds
    On_IBlack="\[\033[0;100m\]"   # Black
    On_IRed="\[\033[0;101m\]"     # Red
    On_IGreen="\[\033[0;102m\]"   # Green
    On_IYellow="\[\033[0;103m\]"  # Yellow
    On_IBlue="\[\033[0;104m\]"    # Blue
    On_IPurple="\[\033[10;95m\]"  # Purple
    On_ICyan="\[\033[0;106m\]"    # Cyan
    On_IWhite="\[\033[0;107m\]"   # White

    # Various variables you might want for your PS1 prompt instead
    Time12h="\T"
    Time12a="\@"
    PathShort="\w"
    PathFull="\W"
    NewLine="\n"
    Jobs="\j"
    CmdStatus='`if [ $? = 0 ]; then echo "\[\e[32m\][✔]"; else echo "\[\e[31m\][✗]"; fi`'
    CurUser="\u"
    CurHost="\h"

    # Set PS1 to appropriate (and colored) prompt with branch (if present)
    export PS1=$CmdStatus$IBlack$Time12h' '$UCyan$CurUser@$CurHost$Color_Off:$IBlack$PathShort$Color_Off'$(which git &>/dev/null; \
    if [ $? -eq 0 ]; then \
      if [ "$(git rev-parse --show-toplevel 2>/dev/null)" == "$HOME" ]; then \
        # @2 - Prompt when not in GIT repo
        echo "'$BGreen'\$ '$Color_Off'"; \
      else \
        echo "$(echo `git status 2>/dev/null` | grep "nothing to commit" > /dev/null 2>&1; \
        if [ "$?" -eq "0" ]; then \
          echo "$(echo `git status` | grep "branch.*\(is \(behind\|ahead\)\|have diverged\)" > /dev/null 2>&1; \
          if [ "$?" -eq "0" ]; then \
            # @3 - Branch is behind or ahead
            echo "'$Yellow'"$(parse_git_branch "{%s}"); \
          else
            # @4 - Clean repository - nothing to commit
            echo "'$Green'"$(parse_git_branch "{%s}"); \
          fi)"; \
        else \
          # @5 - Changes to working tree
          echo "'$IRed'"$(parse_git_branch "{%s}"); \
        fi)'$BGreen'\$ '$Color_Off'"; \
      fi \
    else \
      # @1 - Prompt when no git
      echo "'$BGreen'\$ '$Color_Off'"; \
    fi)'
    
    # Git Branch Parsing
    parse_git_branch ()
    {
            # Figure out the current branch, wrap in brackets and return it
            local BRANCH=`git branch 2>/dev/null | sed -n '/^\*/s/^\* //p'`
            if [ -n "$BRANCH" ]; then
                echo -e "($BRANCH)"
            fi
    }
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt