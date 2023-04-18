#!/usr/bin/env bash
# vim: ft=bash ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for BASH
#
# (Converted from ZSH theme by Kenny Root)
# https://gist.github.com/kruton/8345450
#
# Updated & fixed by Erik Selberg erik@selberg.org 1/14/17
# Tested on MacOSX, Ubuntu, Amazon Linux
# Bash v3 and v4
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
# I recommend: https://github.com/powerline/fonts.git
# > git clone https://github.com/powerline/fonts.git fonts
# > cd fonts
# > install.sh

# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.

# Install:

# I recommend the following:
# $ cd home
# $ mkdir -p .bash/themes/agnoster-bash
# $ git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash

# then add the following to your .bashrc:

# export THEME=$HOME/.bash/themes/agnoster-bash/agnoster.bash
# if [[ -f $THEME ]]; then
#     export DEFAULT_USER=`whoami`
#     source $THEME
# fi

#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

# Generally speaking, this script has limited support for right
# prompts (ala powerlevel9k on zsh), but it's pretty problematic in Bash.
# The general pattern is to write out the right prompt, hit \r, then
# write the left. This is problematic for the following reasons:
# - Doesn't properly resize dynamically when you resize the terminal
# - Changes to the prompt (like clearing and re-typing, super common) deletes the prompt
# - Getting the right alignment via columns / tput cols is pretty problematic (and is a bug in this version)
# - Bash prompt escapes (like \h or \w) don't get interpolated
#
# all in all, if you really, really want right-side prompts without a
# ton of work, recommend going to zsh for now. If you know how to fix this,
# would appreciate it!

# note: requires bash v4+... Mac users - you often have bash3.
# 'brew install bash' will set you free
PROMPT_DIRTRIM=2 # bash4 and above

######################################################################
DEBUG=0
debug() {
    if [[ ${DEBUG} -ne 0 ]]; then
        >&2 echo -e $*
    fi
}

######################################################################
### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
CURRENT_RBG='NONE'
SEGMENT_SEPARATOR=''
RIGHT_SEPARATOR=''
LEFT_SUBSEG=''
RIGHT_SUBSEG=''

COLOR_0=''
COLOR_1=''
COLOR_2=''
COLOR_3=''
COLOR_LINE_0=''
COLOR_LINE_1=''
COLOR_LINE_2=''
COLOR_LINE_3=''
# Define the function with four variables as arguments



text_effect() {
    case "$1" in
        reset)      echo 0;;
        bold)       echo 1;;
        underline)  echo 4;;
    esac
}

# to add colors, see
# http://bitmote.com/index.php?post/2012/11/19/Using-ANSI-Color-Codes-to-Colorize-Your-Bash-Prompt-on-Linux
# under the "256 (8-bit) Colors" section, and follow the example for orange below
fg_color() {
    case "$1" in
        black)       echo 30;;
        red)         echo 31;;
        green)       echo 32;;
        yellow)      echo 33;;
        blue)        echo 34;;
        magenta)     echo 35;;
        cyan)        echo 36;;
        white)       echo 37;;
        orange)      echo 38\;5\;166;;
	### VERT
	## VERT - 01
	ForestGreenUser0)  echo 38\;2\;34\;49\;29;;
        ForestGreenUser1)  echo 38\;2\;48\;69\;41;;		
        ForestGreenUser2)  echo 38\;2\;55\;79\;47;;	
        ForestGreenUser3)  echo 38\;2\;63\;90\;54;;
	ForestGreenUser4)  echo 38\;2\;74\;103\;65;;
	ForestGreenLine0)  echo 38\;2\;177\;201\;161;;
	ForestGreenLine1)  echo 38\;2\;211\;221\;206;;
	ForestGreenLine2)  echo 38\;2\;226\;222\;224;;
	ForestGreenLine3)  echo 38\;2\;239\;238\;232;;
	ForestGreenLine4)  echo 38\;2\;249\;248\;242;;
	## VERT - 02
	LimeGreenUser0)  echo 38\;2\;6\;59\;0;;
        LimeGreenUser1)  echo 38\;2\;10\;93\;0;;		
        LimeGreenUser2)  echo 38\;2\;8\;144\;0;;	
        LimeGreenUser3)  echo 38\;2\;31\;198\;0;;
	LimeGreenUser4)  echo 38\;2\;14\;255\;0;;
	LimeGreenLine0)  echo 38\;2\;177\;201\;161;;
	LimeGreenLine1)  echo 38\;2\;211\;221\;206;;
	LimeGreenLine2)  echo 38\;2\;226\;222\;224;;
	LimeGreenLine3)  echo 38\;2\;239\;238\;232;;
	LimeGreenLine4)  echo 38\;2\;249\;248\;242;;
	## VERT - 03
	EmeraldForestUser0)  echo 38\;2\;1\;45\;33;;
        EmeraldForestUser1)  echo 38\;2\;8\;84\;47;;		
        EmeraldForestUser2)  echo 38\;2\;29\;129\;62;;	
        EmeraldForestUser3)  echo 38\;2\;80\;204\;96;;
	EmeraldForestUser4)  echo 38\;2\;150\;238\;137;;
	EmeraldForestLine0)  echo 38\;2\;177\;201\;161;;
	EmeraldForestLine1)  echo 38\;2\;211\;221\;206;;
	EmeraldForestLine2)  echo 38\;2\;226\;222\;224;;
	EmeraldForestLine3)  echo 38\;2\;239\;238\;232;;
	EmeraldForestLine4)  echo 38\;2\;239\;238\;232;;
	## VERT - 04
	YellowGreenUser0)  echo 38\;2\;103\;125\;57;;
        YellowGreenUser1)  echo 38\;2\;110\;136\;67;;		
        YellowGreenUser2)  echo 38\;2\;120\;155\;61;;	
        YellowGreenUser3)  echo 38\;2\;118\;166\;51;;
	YellowGreenUser4)  echo 38\;2\;112\;183\;15;;
	YellowGreenLine0)  echo 38\;2\;177\;201\;161;;
	YellowGreenLine1)  echo 38\;2\;211\;221\;206;;
	YellowGreenLine2)  echo 38\;2\;226\;222\;224;;
	YellowGreenLine3)  echo 38\;2\;239\;238\;232;;
	YellowGreenLine4)  echo 38\;2\;239\;238\;232;;
	## VERT - 05
	FoggyForestDarkUser0)  echo 38\;2\;28\;38\;38;;
        FoggyForestDarkUser1)  echo 38\;2\;41\;48\;43;;		
        FoggyForestDarkUser2)  echo 38\;2\;57\;65\;48;;	
        FoggyForestDarkUser3)  echo 38\;2\;72\;76\;50;;
	FoggyForestDarkUser4)  echo 38\;2\;90\;81\;54;;
	FoggyForestDarkLine0)  echo 38\;2\;177\;201\;161;;
	FoggyForestDarkLine1)  echo 38\;2\;211\;221\;206;;
	FoggyForestDarkLine2)  echo 38\;2\;226\;222\;224;;
	FoggyForestDarkLine3)  echo 38\;2\;239\;238\;232;;
	FoggyForestDarkLine4)  echo 38\;2\;239\;238\;232;;
	### BLEU
	## BLEU - 01
	BeautifulBluesUser0)  echo 38\;2\;1\;31\;75;;
        BeautifulBluesUser1)  echo 38\;2\;3\;57\;108;;		
        BeautifulBluesUser2)  echo 38\;2\;0\;91\;150;;	
        BeautifulBluesUser3)  echo 38\;2\;100\;151\;177;;
	BeautifulBluesUser4)  echo 38\;2\;179\;205\;224;;
	BeautifulBluesLine0)  echo 38\;2\;177\;201\;161;;
	BeautifulBluesLine1)  echo 38\;2\;211\;221\;206;;
	BeautifulBluesLine2)  echo 38\;2\;226\;222\;224;;
	BeautifulBluesLine3)  echo 38\;2\;239\;238\;232;;
	BeautifulBluesLine4)  echo 38\;2\;249\;248\;242;;
	## BLEU - 02
	ShadesofTealUser0)  echo 38\;2\;0\;76\;76;;
        ShadesofTealUser1)  echo 38\;2\;0\;102\;102;;		
        ShadesofTealUser2)  echo 38\;2\;0\;128\;128;;	
        ShadesofTealUser3)  echo 38\;2\;102\;178\;178;;
	ShadesofTealUser4)  echo 38\;2\;178\;216\;216;;
	ShadesofTealLine0)  echo 38\;2\;177\;201\;161;;
	ShadesofTealLine1)  echo 38\;2\;211\;221\;206;;
	ShadesofTealLine2)  echo 38\;2\;226\;222\;224;;
	ShadesofTealLine3)  echo 38\;2\;239\;238\;232;;
	ShadesofTealLine4)  echo 38\;2\;239\;238\;232;;
	## BLEU - 03
	TechnologyUser0)  echo 38\;2\;0\;76\;76;;
        TechnologyUser1)  echo 38\;2\;0\;102\;102;;		
        TechnologyUser2)  echo 38\;2\;0\;128\;128;;	
        TechnologyUser3)  echo 38\;2\;102\;178\;178;;
	TechnologyUser4)  echo 38\;2\;178\;216\;216;;
	TechnologyLine0)  echo 38\;2\;177\;201\;161;;
	TechnologyLine1)  echo 38\;2\;211\;221\;206;;
	TechnologyLine2)  echo 38\;2\;226\;222\;224;;
	TechnologyLine3)  echo 38\;2\;239\;238\;232;;
	TechnologyLine4)  echo 38\;2\;239\;238\;232;;
	## BLEU - 04
	BluesUser0)  echo 38\;2\;51\;102\;255;;
        BluesUser1)  echo 38\;2\;85\;136\;255;;		
        BluesUser2)  echo 38\;2\;119\;170\;255;;	
        BluesUser3)  echo 38\;2\;153\;204\;255;;
	BluesUser4)  echo 38\;2\;187\;238\;255;;
	BluesLine0)  echo 38\;2\;177\;201\;161;;
	BluesLine1)  echo 38\;2\;211\;221\;206;;
	BluesLine2)  echo 38\;2\;226\;222\;224;;
	BluesLine3)  echo 38\;2\;239\;238\;232;;
	BluesLine4)  echo 38\;2\;239\;238\;232;;
	## BLEU - 05
	ArcDarkUser0)  echo 38\;2\;56\;60\;74;;
        ArcDarkUser1)  echo 38\;2\;64\;69\;82;;		
        ArcDarkUser2)  echo 38\;2\;75\;81\;98;;	
        ArcDarkUser3)  echo 38\;2\;124\;129\;140;;
	ArcDarkUser4)  echo 38\;2\;82\;148\;226;;
	ArcDarkLine0)  echo 38\;2\;177\;201\;161;;
	ArcDarkLine1)  echo 38\;2\;211\;221\;206;;
	ArcDarkLine2)  echo 38\;2\;226\;222\;224;;
	ArcDarkLine3)  echo 38\;2\;239\;238\;232;;
	ArcDarkLine4)  echo 38\;2\;249\;248\;242;;
	### ROSE
	## ROSE - 01
	PrincessPinkUser0)  echo 38\;2\;255\;8\;74;;
        PrincessPinkUser1)  echo 38\;2\;252\;52\;104;;		
        PrincessPinkUser2)  echo 38\;2\;255\;98\;137;;	
        PrincessPinkUser3)  echo 38\;2\;255\;147;\;172;;
	PrincessPinkUser4)  echo 38\;2\;255\;194\;205;;
	PrincessPinkLine0)  echo 38\;2\;177\;201\;161;;
	PrincessPinkLine1)  echo 38\;2\;211\;221\;206;;
	PrincessPinkLine2)  echo 38\;2\;226\;222\;224;;
	PrincessPinkLine3)  echo 38\;2\;239\;238\;232;;
	PrincessPinkLine4)  echo 38\;2\;249\;248\;242;;
	## ROSE - 02
	ItsPinkUser0)  echo 38\;2\;75\;24\;48;;
        ItsPinkUser1)  echo 38\;2\;141\;43\;81;;		
        ItsPinkUser2)  echo 38\;2\;204\;64\;113;;	
        ItsPinkUser3)  echo 38\;2\;255\;134;\;158;;
	ItsPinkUser4)  echo 38\;2\;255\;207\;214;;
	ItsPinkLine0)  echo 38\;2\;177\;201\;161;;
	ItsPinkLine1)  echo 38\;2\;211\;221\;206;;
	ItsPinkLine2)  echo 38\;2\;226\;222\;224;;
	ItsPinkLine3)  echo 38\;2\;239\;238\;232;;
	ItsPinkLine4)  echo 38\;2\;249\;248\;242;;
	## ROSE - 03
	SkinAndLipsUser0)  echo 38\;2\;227\;93\;106;;
        SkinAndLipsUser1)  echo 38\;2\;201\;130\;118;;		
        SkinAndLipsUser2)  echo 38\;2\;210\;153\;133;;	
        SkinAndLipsUser3)  echo 38\;2\;219\;172;\;152;;
	SkinAndLipsUser4)  echo 38\;2\;238\;193\;173;;
	SkinAndLipsLine0)  echo 38\;2\;177\;201\;161;;
	SkinAndLipsLine1)  echo 38\;2\;211\;221\;206;;
	SkinAndLipsLine2)  echo 38\;2\;226\;222\;224;;
	SkinAndLipsLine3)  echo 38\;2\;239\;238\;232;;
	SkinAndLipsLine4)  echo 38\;2\;249\;248\;242;;
	## ROSE - 04
	LightlyTanSkinUser0)  echo 38\;2\;189\;137\;102;;
        LightlyTanSkinUser1)  echo 38\;2\;211\;153\;114;;		
        LightlyTanSkinUser2)  echo 38\;2\;235\;171\;127;;	
        LightlyTanSkinUser3)  echo 38\;2\;247\;193;\;155;;
	LightlyTanSkinUser4)  echo 38\;2\;252\;198\;160;;
	LightlyTanSkinLine0)  echo 38\;2\;177\;201\;161;;
	LightlyTanSkinLine1)  echo 38\;2\;211\;221\;206;;
	LightlyTanSkinLine2)  echo 38\;2\;226\;222\;224;;
	LightlyTanSkinLine3)  echo 38\;2\;239\;238\;232;;
	LightlyTanSkinLine4)  echo 38\;2\;249\;248\;242;;
	## ROSE - 05
	PeachUser0)  echo 38\;2\;246\;161\;146;;
        PeachUser1)  echo 38\;2\;246\;176\;146;;		
        PeachUser2)  echo 38\;2\;246\;196\;146;;	
        PeachUser3)  echo 38\;2\;246\;207;\;146;;
	PeachUser4)  echo 38\;2\;246\;217\;146;;
	PeachLine0)  echo 38\;2\;177\;201\;161;;
	PeachLine1)  echo 38\;2\;211\;221\;206;;
	PeachLine2)  echo 38\;2\;226\;222\;224;;
	PeachLine3)  echo 38\;2\;239\;238\;232;;
	PeachLine4)  echo 38\;2\;249\;248\;242;;
	### MARRON
	## MARRON -01
	DarkSkinTonesUser0)  echo 38\;2\;111\;79\;29;;
        DarkSkinTonesUser1)  echo 38\;2\;124\;80\;26;;		
        DarkSkinTonesUser2)  echo 38\;2\;135\;97\;39;;	
        DarkSkinTonesUser3)  echo 38\;2\;146\;106;\;45;;
	DarkSkinTonesUser4)  echo 38\;2\;156\;114\;72;;
	DarkSkinTonesLine0)  echo 38\;2\;177\;201\;161;;
	DarkSkinTonesLine1)  echo 38\;2\;211\;221\;206;;
	DarkSkinTonesLine2)  echo 38\;2\;226\;222\;224;;
	DarkSkinTonesLine3)  echo 38\;2\;239\;238\;232;;
	DarkSkinTonesLine4)  echo 38\;2\;249\;248\;242;;
	## MARRON - 02
	BeautifulBrownUser0)  echo 38\;2\;131\;80\;46;;
        BeautifulBrownUser1)  echo 38\;2\;150\;97\;61;;		
        BeautifulBrownUser2)  echo 38\;2\;189\;126\;74;;	
        BeautifulBrownUser3)  echo 38\;2\;206\;139;\;84;;
	BeautifulBrownUser4)  echo 38\;2\;210\;165\;109;;
	BeautifulBrownLine0)  echo 38\;2\;177\;201\;161;;
	BeautifulBrownLine1)  echo 38\;2\;211\;221\;206;;
	BeautifulBrownLine2)  echo 38\;2\;226\;222\;224;;
	BeautifulBrownLine3)  echo 38\;2\;239\;238\;232;;
	BeautifulBrownLine4)  echo 38\;2\;249\;248\;242;;
	## MARRON - 03
	CreamCoffeeUser0)  echo 38\;2\;56\;34\;15;;
        CreamCoffeeUser1)  echo 38\;2\;99\;72\;50;;		
        CreamCoffeeUser2)  echo 38\;2\;150\;114\;89;;	
        CreamCoffeeUser3)  echo 38\;2\;219\;193;\;172;;
	CreamCoffeeUser4)  echo 38\;2\;236\;224\;229;;
	CreamCoffeeLine0)  echo 38\;2\;177\;201\;161;;
	CreamCoffeeLine1)  echo 38\;2\;211\;221\;206;;
	CreamCoffeeLine2)  echo 38\;2\;226\;222\;224;;
	CreamCoffeeLine3)  echo 38\;2\;239\;238\;232;;
	CreamCoffeeLine4)  echo 38\;2\;249\;248\;242;;
	## MARRON -04
	ShadesOfMaroonUser0)  echo 38\;2\;86\;36\;36;;
        ShadesOfMaroonUser1)  echo 38\;2\;109\;54\;54;;		
        ShadesOfMaroonUser2)  echo 38\;2\;146\;68\;68;;	
        ShadesOfMaroonUser3)  echo 38\;2\;169\;76;\;76;;
	ShadesOfMaroonUser4)  echo 38\;2\;193\;113\;113;;
	ShadesOfMaroonLine0)  echo 38\;2\;177\;201\;161;;
	ShadesOfMaroonLine1)  echo 38\;2\;211\;221\;206;;
	ShadesOfMaroonLine2)  echo 38\;2\;226\;222\;224;;
	ShadesOfMaroonLine3)  echo 38\;2\;239\;238\;232;;
	ShadesOfMaroonLine4)  echo 38\;2\;249\;248\;242;;
	## MARRON - 05
	ChesnutBrownHairSwatchesUser0)  echo 38\;2\;48\;22\;6;;
        ChesnutBrownHairSwatchesUser1)  echo 38\;2\;65\;30\;2;;		
        ChesnutBrownHairSwatchesUser2)  echo 38\;2\;80\;40\;7;;	
        ChesnutBrownHairSwatchesUser3)  echo 38\;2\;100\;51;\;2;;
	ChesnutBrownHairSwatchesUser4)  echo 38\;2\;112\;61\;12;;
	ChesnutBrownHairSwatchesLine0)  echo 38\;2\;177\;201\;161;;
	ChesnutBrownHairSwatchesLine1)  echo 38\;2\;211\;221\;206;;
	ChesnutBrownHairSwatchesLine2)  echo 38\;2\;226\;222\;224;;
	ChesnutBrownHairSwatchesLine3)  echo 38\;2\;239\;238\;232;;
	ChesnutBrownHairSwatchesLine4)  echo 38\;2\;249\;248\;242;;
	### JAUNE
	## JAUNE -01
	Dark2BrightYellowUser0)  echo 38\;2\;111\;101\;0;;
        Dark2BrightYellowUser1)  echo 38\;2\;137\;124\;0;;		
        Dark2BrightYellowUser2)  echo 38\;2\;180\;154\;0;;	
        Dark2BrightYellowUser3)  echo 38\;2\;214\;184;\;0;;
	Dark2BrightYellowUser4)  echo 38\;2\;255\;206\;0;;
	Dark2BrightYellowLine0)  echo 38\;2\;177\;201\;161;;
	Dark2BrightYellowLine1)  echo 38\;2\;211\;221\;206;;
	Dark2BrightYellowLine2)  echo 38\;2\;226\;222\;224;;
	Dark2BrightYellowLine3)  echo 38\;2\;239\;238\;232;;
	Dark2BrightYellowLine4)  echo 38\;2\;249\;248\;242;;
	## JAUNE - 02
	YellowTherePeopleUser0)  echo 38\;2\;180\;162\;4;;
        YellowTherePeopleUser1)  echo 38\;2\;191\;173\;11;;		
        YellowTherePeopleUser2)  echo 38\;2\;204\;185\;8;;	
        YellowTherePeopleUser3)  echo 38\;2\;221\;200;\;2;;
	YellowTherePeopleUser4)  echo 38\;2\;234\;213\;8;;
	YellowTherePeopleLine0)  echo 38\;2\;177\;201\;161;;
	YellowTherePeopleLine1)  echo 38\;2\;211\;221\;206;;
	YellowTherePeopleLine2)  echo 38\;2\;226\;222\;224;;
	YellowTherePeopleLine3)  echo 38\;2\;239\;238\;232;;
	YellowTherePeopleLine4)  echo 38\;2\;249\;248\;242;;
        ## JAUNE - 03
	24KGoldUser0)  echo 38\;2\;166\;124\;0;;
        24KGoldUser1)  echo 38\;2\;191\;155\;48;;		
        24KGoldUser2)  echo 38\;2\;255\;191\;0;;	
        24KGoldUser3)  echo 38\;2\;255\;207;\;64;;
	24KGoldUser4)  echo 38\;2\;255\;220\;115;;
	24KGoldLine0)  echo 38\;2\;177\;201\;161;;
	24KGoldLine1)  echo 38\;2\;211\;221\;206;;
	24KGoldLine2)  echo 38\;2\;226\;222\;224;;
	24KGoldLine3)  echo 38\;2\;239\;238\;232;;
	24KGoldLine4)  echo 38\;2\;249\;248\;242;;
        ## JAUNE - 04
	GoldRodUser0)  echo 38\;2\;121\;78\;29;;
        GoldRodUser1)  echo 38\;2\;174\;111\;39;;		
        GoldRodUser2)  echo 38\;2\;182\;126\;45;;	
        GoldRodUser3)  echo 38\;2\;199\;142;\;33;;
	GoldRodUser4)  echo 38\;2\;212\;176\;54;;
	GoldRodLine0)  echo 38\;2\;177\;201\;161;;
	GoldRodLine1)  echo 38\;2\;211\;221\;206;;
	GoldRodLine2)  echo 38\;2\;226\;222\;224;;
	GoldRodLine3)  echo 38\;2\;239\;238\;232;;
	GoldRodLine4)  echo 38\;2\;249\;248\;242;;
        ## JAUNE - 05
	ShineLikeGoldUser0)  echo 38\;2\;255\;135\;44;;
        ShineLikeGoldUser1)  echo 38\;2\;255\;157\;44;;		
        ShineLikeGoldUser2)  echo 38\;2\;255\;178\;46;;	
        ShineLikeGoldUser3)  echo 38\;2\;255\;199;\;44;;
	ShineLikeGoldUser4)  echo 38\;2\;255\;221\;44;;
	ShineLikeGoldLine0)  echo 38\;2\;177\;201\;161;;
	ShineLikeGoldLine1)  echo 38\;2\;211\;221\;206;;
	ShineLikeGoldLine2)  echo 38\;2\;226\;222\;224;;
	ShineLikeGoldLine3)  echo 38\;2\;239\;238\;232;;
	ShineLikeGoldLine4)  echo 38\;2\;249\;248\;242;;
	### ROUGE
	## ROUGE - 01
	DarkRedRootUser0)  echo 38\;2\;86\;13\;13;;
        DarkRedRootUser1)  echo 38\;2\;92\;16\;16;;		
        DarkRedRootUser2)  echo 38\;2\;111\;0\;0;;	
        DarkRedRootUser3)  echo 38\;2\;148\;0;\;0;;
	DarkRedRootUser4)  echo 38\;2\;195\;1\;1;;
	DarkRedRootLine0)  echo 38\;2\;177\;201\;161;;
	DarkRedRootLine1)  echo 38\;2\;211\;221\;206;;
	DarkRedRootLine2)  echo 38\;2\;226\;222\;224;;
	DarkRedRootLine3)  echo 38\;2\;239\;238\;232;;
	DarkRedRootLine4)  echo 38\;2\;249\;248\;242;;
	## ROUGE - 02
	CrimsonWaveRootUser0)  echo 38\;2\;71\;0\;0;;
        CrimsonWaveRootUser1)  echo 38\;2\;99\;0\;0;;		
        CrimsonWaveRootUser2)  echo 38\;2\;120\;0\;0;;	
        CrimsonWaveRootUser3)  echo 38\;2\;141\;0;\;0;;
	CrimsonWaveRootUser4)  echo 38\;2\;159\;0\;0;;
	CrimsonWaveRootLine0)  echo 38\;2\;177\;201\;161;;
	CrimsonWaveRootLine1)  echo 38\;2\;211\;221\;206;;
	CrimsonWaveRootLine2)  echo 38\;2\;226\;222\;224;;
	CrimsonWaveRootLine3)  echo 38\;2\;239\;238\;232;;
	CrimsonWaveRootLine4)  echo 38\;2\;249\;248\;242;;
	### VIOLET
	## VIOLET- 01
	BlogPurpleUser0)  echo 38\;2\;53\;32\;78;;
        BlogPurpleUser1)  echo 38\;2\;72\;53\;94;;		
        BlogPurpleUser2)  echo 38\;2\;95\;76\;117;;	
        BlogPurpleUser3)  echo 38\;2\;122\;106;\;141;;
	BlogPurpleUser4)  echo 38\;2\;157\;146\;170;;
	BlogPurpleLine0)  echo 38\;2\;177\;201\;161;;
	BlogPurpleLine1)  echo 38\;2\;211\;221\;206;;
	BlogPurpleLine2)  echo 38\;2\;226\;222\;224;;
	BlogPurpleLine3)  echo 38\;2\;239\;238\;232;;
	BlogPurpleLine4)  echo 38\;2\;249\;248\;242;;
	## VIOLET- 02
	PurpleDreamsUser0)  echo 38\;2\;93\;0\;159;;
        PurpleDreamsUser1)  echo 38\;2\;110\;18\;176;;		
        PurpleDreamsUser2)  echo 38\;2\;135\;52\;195;;	
        PurpleDreamsUser3)  echo 38\;2\;155\;89;\;201;;
	PurpleDreamsUser4)  echo 38\;2\;174\;127\;208;;
	PurpleDreamsLine0)  echo 38\;2\;177\;201\;161;;
	PurpleDreamsLine1)  echo 38\;2\;211\;221\;206;;
	PurpleDreamsLine2)  echo 38\;2\;226\;222\;224;;
	PurpleDreamsLine3)  echo 38\;2\;239\;238\;232;;
	PurpleDreamsLine4)  echo 38\;2\;249\;248\;242;;
	## VIOLET- 03
	Purples1User0)  echo 38\;2\;184\;94\;230;;
        Purples1User1)  echo 38\;2\;193\;114\;233;;		
        Purples1User2)  echo 38\;2\;202\;134\;236;;	
        Purples1User3)  echo 38\;2\;228\;194;\;245;;
	Purples1User4)  echo 38\;2\;237\;214\;248;;
	Purples1Line0)  echo 38\;2\;177\;201\;161;;
	Purples1Line1)  echo 38\;2\;211\;221\;206;;
	Purples1Line2)  echo 38\;2\;226\;222\;224;;
	Purples1Line3)  echo 38\;2\;239\;238\;232;;
	Purples1Line4)  echo 38\;2\;249\;248\;242;;
	## VIOLET- 04
	SarahsPurpleUser0)  echo 38\;2\;61\;14\;111;;
        SarahsPurpleUser1)  echo 38\;2\;83\;33\;135;;		
        SarahsPurpleUser2)  echo 38\;2\;109\;55\;165;;	
        SarahsPurpleUser3)  echo 38\;2\;143\;93;\;195;;
	SarahsPurpleUser4)  echo 38\;2\;178\;136\;221;;
	SarahsPurpleLine0)  echo 38\;2\;177\;201\;161;;
	SarahsPurpleLine1)  echo 38\;2\;211\;221\;206;;
	SarahsPurpleLine2)  echo 38\;2\;226\;222\;224;;
	SarahsPurpleLine3)  echo 38\;2\;239\;238\;232;;
	SarahsPurpleLine4)  echo 38\;2\;249\;248\;242;;
	## VIOLET- 05
	AestheticUser0)  echo 38\;2\;102\;84\;94;;
        AestheticUser1)  echo 38\;2\;163\;145\;147;;		
        AestheticUser2)  echo 38\;2\;170\;111\;115;;	
        AestheticUser3)  echo 38\;2\;138\;169;\;144;;
	AestheticUser4)  echo 38\;2\;246\;224\;181;;
	AestheticLine0)  echo 38\;2\;177\;201\;161;;
	AestheticLine1)  echo 38\;2\;211\;221\;206;;
	AestheticLine2)  echo 38\;2\;226\;222\;224;;
	AestheticLine3)  echo 38\;2\;239\;238\;232;;
	AestheticLine4)  echo 38\;2\;249\;248\;242;;
        ## GRIS
        GrayUser0) echo 38\;2\;48\;48\;48;;
        GrayUser1) echo 38\;2\;81\;81\;81;;
	GrayUser2) echo 38\;2\;99\;99\;99;;
        GrayUser3) echo 38\;2\;119\;119\;119;;
        GrayUser4) echo 38\;2\;131\;131\;131;;
	GrayUser4) echo 38\;2\;159\;159\;159;;
        GrayLine0) echo 38\;2\;240\;240\;240;;
	GrayLine1) echo 38\;2\;235\;235\;235;;
	GrayLine2) echo 38\;2\;230\;230\;230;;
	GrayLine3) echo 38\;2\;225\;225\;225;;
	GrayLine4) echo 38\;2\;225\;225\;225;;
    esac
}

bg_color() {
    case "$1" in
        black)       echo 40;;
        red)         echo 41;;
        green)       echo 42;;
        yellow)      echo 43;;
        blue)        echo 44;;
        magenta)     echo 45;;
        cyan)        echo 46;;
        white)       echo 47;;
        orange)      echo 48\;2\;166;;
        ### VERT
	## VERT - 01
	ForestGreenUser0)  echo 48\;2\;34\;49\;29;;
        ForestGreenUser1)  echo 48\;2\;48\;69\;41;;		
        ForestGreenUser2)  echo 48\;2\;55\;79\;65;;
	ForestGreenLine0)  echo 48\;2\;177\;201\;161;;
	ForestGreenLine1)  echo 48\;2\;211\;221\;206;;
	ForestGreenLine2)  echo 48\;2\;226\;222\;224;;
	ForestGreenLine3)  echo 48\;2\;239\;238\;232;;
	ForestGreenLine4)  echo 48\;2\;249\;248\;242;;
	## VERT - 02
	LimeGreenUser0)  echo 48\;2\;6\;59\;0;;
        LimeGreenUser1)  echo 48\;2\;10\;93\;0;;		
        LimeGreenUser2)  echo 48\;2\;8\;144\;0;;	
        LimeGreenUser3)  echo 48\;2\;31\;198\;0;;
	LimeGreenUser4)  echo 48\;2\;14\;255\;0;;
	LimeGreenLine0)  echo 48\;2\;177\;201\;161;;
	LimeGreenLine1)  echo 48\;2\;211\;221\;206;;
	LimeGreenLine2)  echo 48\;2\;226\;222\;224;;
	LimeGreenLine3)  echo 48\;2\;239\;238\;232;;
	LimeGreenLine4)  echo 48\;2\;249\;248\;242;;
	## VERT - 03
	EmeraldForestUser0)  echo 48\;2\;1\;45\;33;;
        EmeraldForestUser1)  echo 48\;2\;8\;84\;47;;		
        EmeraldForestUser2)  echo 48\;2\;29\;129\;62;;	
        EmeraldForestUser3)  echo 48\;2\;80\;204\;96;;
	EmeraldForestUser4)  echo 48\;2\;150\;238\;137;;
	EmeraldForestLine0)  echo 48\;2\;177\;201\;161;;
	EmeraldForestLine1)  echo 48\;2\;211\;221\;206;;
	EmeraldForestLine2)  echo 48\;2\;226\;222\;224;;
	EmeraldForestLine3)  echo 48\;2\;239\;238\;232;;
	EmeraldForestLine4)  echo 48\;2\;239\;238\;232;;
	## VERT - 04
	YellowGreenUser0)  echo 48\;2\;103\;125\;57;;
        YellowGreenUser1)  echo 48\;2\;110\;136\;67;;		
        YellowGreenUser2)  echo 48\;2\;120\;155\;61;;	
        YellowGreenUser3)  echo 48\;2\;118\;166\;51;;
	YellowGreenUser4)  echo 48\;2\;112\;183\;15;;
	YellowGreenLine0)  echo 48\;2\;177\;201\;161;;
	YellowGreenLine1)  echo 48\;2\;211\;221\;206;;
	YellowGreenLine2)  echo 48\;2\;226\;222\;224;;
	YellowGreenLine3)  echo 48\;2\;239\;238\;232;;
	YellowGreenLine4)  echo 48\;2\;239\;238\;232;;
	## VERT - 05
	FoggyForestDarkUser0)  echo 48\;2\;28\;38\;38;;
        FoggyForestDarkUser1)  echo 48\;2\;41\;48\;43;;		
        FoggyForestDarkUser2)  echo 48\;2\;57\;65\;48;;	
        FoggyForestDarkUser3)  echo 48\;2\;72\;76\;50;;
	FoggyForestDarkUser4)  echo 48\;2\;90\;81\;54;;
	FoggyForestDarkLine0)  echo 48\;2\;177\;201\;161;;
	FoggyForestDarkLine1)  echo 48\;2\;211\;221\;206;;
	FoggyForestDarkLine2)  echo 48\;2\;226\;222\;224;;
	FoggyForestDarkLine3)  echo 48\;2\;239\;238\;232;;
	FoggyForestDarkLine4)  echo 48\;2\;239\;238\;232;;
	### BLEU
	## BLEU - 01
	BeautifulBluesUser0)  echo 48\;2\;1\;31\;75;;
        BeautifulBluesUser1)  echo 48\;2\;3\;57\;108;;		
        BeautifulBluesUser2)  echo 48\;2\;0\;91\;150;;	
        BeautifulBluesUser3)  echo 48\;2\;100\;151\;177;;
	BeautifulBluesUser4)  echo 48\;2\;179\;205\;224;;
	BeautifulBluesLine0)  echo 48\;2\;177\;201\;161;;
	BeautifulBluesLine1)  echo 48\;2\;211\;221\;206;;
	BeautifulBluesLine2)  echo 48\;2\;226\;222\;224;;
	BeautifulBluesLine3)  echo 48\;2\;239\;238\;232;;
	BeautifulBluesLine4)  echo 48\;2\;249\;248\;242;;
	## BLEU - 02
	ShadesofTealUser0)  echo 48\;2\;0\;76\;76;;
        ShadesofTealUser1)  echo 48\;2\;0\;102\;102;;		
        ShadesofTealUser2)  echo 48\;2\;0\;128\;128;;	
        ShadesofTealUser3)  echo 48\;2\;102\;178\;178;;
	ShadesofTealUser4)  echo 48\;2\;178\;216\;216;;
	ShadesofTealLine0)  echo 48\;2\;177\;201\;161;;
	ShadesofTealLine1)  echo 48\;2\;211\;221\;206;;
	ShadesofTealLine2)  echo 48\;2\;226\;222\;224;;
	ShadesofTealLine3)  echo 48\;2\;239\;238\;232;;
	ShadesofTealLine4)  echo 48\;2\;239\;238\;232;;
	## BLEU - 03
	TechnologyUser0)  echo 48\;2\;0\;76\;76;;
        TechnologyUser1)  echo 48\;2\;0\;102\;102;;		
        TechnologyUser2)  echo 48\;2\;0\;128\;128;;	
        TechnologyUser3)  echo 48\;2\;102\;178\;178;;
	TechnologyUser4)  echo 48\;2\;178\;216\;216;;
	TechnologyLine0)  echo 48\;2\;177\;201\;161;;
	TechnologyLine1)  echo 48\;2\;211\;221\;206;;
	TechnologyLine2)  echo 48\;2\;226\;222\;224;;
	TechnologyLine3)  echo 48\;2\;239\;238\;232;;
	TechnologyLine4)  echo 48\;2\;239\;238\;232;;
	## BLEU - 04
	BluesUser0)  echo 48\;2\;51\;102\;255;;
        BluesUser1)  echo 48\;2\;85\;136\;255;;		
        BluesUser2)  echo 48\;2\;119\;170\;255;;	
        BluesUser3)  echo 48\;2\;153\;204\;255;;
	BluesUser4)  echo 48\;2\;187\;238\;255;;
	BluesLine0)  echo 48\;2\;177\;201\;161;;
	BluesLine1)  echo 48\;2\;211\;221\;206;;
	BluesLine2)  echo 48\;2\;226\;222\;224;;
	BluesLine3)  echo 48\;2\;239\;238\;232;;
	BluesLine4)  echo 48\;2\;239\;238\;232;;
	## BLEU - 05
	ArcDarkUser0)  echo 48\;2\;56\;60\;74;;
        ArcDarkUser1)  echo 48\;2\;64\;69\;82;;		
        ArcDarkUser2)  echo 48\;2\;75\;81\;98;;	
        ArcDarkUser3)  echo 48\;2\;124\;129\;140;;
	ArcDarkUser4)  echo 48\;2\;82\;148\;226;;
	ArcDarkLine0)  echo 48\;2\;177\;201\;161;;
	ArcDarkLine1)  echo 48\;2\;211\;221\;206;;
	ArcDarkLine2)  echo 48\;2\;226\;222\;224;;
	ArcDarkLine3)  echo 48\;2\;239\;238\;232;;
	ArcDarkLine4)  echo 48\;2\;249\;248\;242;;
	### ROSE
	## ROSE - 01
	PrincessPinkUser0)  echo 48\;2\;255\;8\;74;;
        PrincessPinkUser1)  echo 48\;2\;252\;52\;104;;		
        PrincessPinkUser2)  echo 48\;2\;255\;98\;137;;	
        PrincessPinkUser3)  echo 48\;2\;255\;147;\;172;;
	PrincessPinkUser4)  echo 48\;2\;255\;194\;205;;
	PrincessPinkLine0)  echo 48\;2\;177\;201\;161;;
	PrincessPinkLine1)  echo 48\;2\;211\;221\;206;;
	PrincessPinkLine2)  echo 48\;2\;226\;222\;224;;
	PrincessPinkLine3)  echo 48\;2\;239\;238\;232;;
	PrincessPinkLine4)  echo 48\;2\;249\;248\;242;;
	## ROSE - 02
	ItsPinkUser0)  echo 48\;2\;75\;24\;48;;
        ItsPinkUser1)  echo 48\;2\;141\;43\;81;;		
        ItsPinkUser2)  echo 48\;2\;204\;64\;113;;	
        ItsPinkUser3)  echo 48\;2\;255\;134;\;158;;
	ItsPinkUser4)  echo 48\;2\;255\;207\;214;;
	ItsPinkLine0)  echo 48\;2\;177\;201\;161;;
	ItsPinkLine1)  echo 48\;2\;211\;221\;206;;
	ItsPinkLine2)  echo 48\;2\;226\;222\;224;;
	ItsPinkLine3)  echo 48\;2\;239\;238\;232;;
	ItsPinkLine4)  echo 48\;2\;249\;248\;242;;
	## ROSE - 03
	SkinAndLipsUser0)  echo 48\;2\;227\;93\;106;;
        SkinAndLipsUser1)  echo 48\;2\;201\;130\;118;;		
        SkinAndLipsUser2)  echo 48\;2\;210\;153\;133;;	
        SkinAndLipsUser3)  echo 48\;2\;219\;172;\;152;;
	SkinAndLipsUser4)  echo 48\;2\;238\;193\;173;;
	SkinAndLipsLine0)  echo 48\;2\;177\;201\;161;;
	SkinAndLipsLine1)  echo 48\;2\;211\;221\;206;;
	SkinAndLipsLine2)  echo 48\;2\;226\;222\;224;;
	SkinAndLipsLine3)  echo 48\;2\;239\;238\;232;;
	SkinAndLipsLine4)  echo 48\;2\;249\;248\;242;;
	## ROSE - 04
	LightlyTanSkinUser0)  echo 48\;2\;189\;137\;102;;
        LightlyTanSkinUser1)  echo 48\;2\;211\;153\;114;;		
        LightlyTanSkinUser2)  echo 48\;2\;235\;171\;127;;	
        LightlyTanSkinUser3)  echo 48\;2\;247\;193;\;155;;
	LightlyTanSkinUser4)  echo 48\;2\;252\;198\;160;;
	LightlyTanSkinLine0)  echo 48\;2\;177\;201\;161;;
	LightlyTanSkinLine1)  echo 48\;2\;211\;221\;206;;
	LightlyTanSkinLine2)  echo 48\;2\;226\;222\;224;;
	LightlyTanSkinLine3)  echo 48\;2\;239\;238\;232;;
	LightlyTanSkinLine4)  echo 48\;2\;249\;248\;242;;
	## ROSE - 05
	PeachUser0)  echo 48\;2\;246\;161\;146;;
        PeachUser1)  echo 48\;2\;246\;176\;146;;		
        PeachUser2)  echo 48\;2\;246\;196\;146;;	
        PeachUser3)  echo 48\;2\;246\;207;\;146;;
	PeachUser4)  echo 48\;2\;246\;217\;146;;
	PeachLine0)  echo 48\;2\;177\;201\;161;;
	PeachLine1)  echo 48\;2\;211\;221\;206;;
	PeachLine2)  echo 48\;2\;226\;222\;224;;
	PeachLine3)  echo 48\;2\;239\;238\;232;;
	PeachLine4)  echo 48\;2\;249\;248\;242;;
	### MARRON
	## MARRON -01
	DarkSkinTonesUser0)  echo 48\;2\;111\;79\;29;;
        DarkSkinTonesUser1)  echo 38\;2\;124\;80\;26;;		
        DarkSkinTonesUser2)  echo 48\;2\;135\;97\;39;;	
        DarkSkinTonesUser3)  echo 48\;2\;146\;106;\;45;;
	DarkSkinTonesUser4)  echo 48\;2\;156\;114\;72;;
	DarkSkinTonesLine0)  echo 48\;2\;177\;201\;161;;
	DarkSkinTonesLine1)  echo 48\;2\;211\;221\;206;;
	DarkSkinTonesLine2)  echo 48\;2\;226\;222\;224;;
	DarkSkinTonesLine3)  echo 48\;2\;239\;238\;232;;
	DarkSkinTonesLine4)  echo 48\;2\;249\;248\;242;;
	## MARRON - 02
	BeautifulBrownUser0)  echo 48\;2\;131\;80\;46;;
        BeautifulBrownUser1)  echo 48\;2\;150\;97\;61;;		
        BeautifulBrownUser2)  echo 48\;2\;189\;126\;74;;	
        BeautifulBrownUser3)  echo 48\;2\;210\;165\;109;;
	BeautifulBrownLine0)  echo 48\;2\;177\;201\;161;;
	BeautifulBrownLine1)  echo 48\;2\;211\;221\;206;;
	BeautifulBrownLine2)  echo 48\;2\;226\;222\;224;;
	BeautifulBrownLine3)  echo 48\;2\;239\;238\;232;;
	BeautifulBrownLine4)  echo 48\;2\;249\;248\;242;;
	## MARRON - 03
	CreamCoffeeUser0)  echo 48\;2\;56\;34\;15;;
        CreamCoffeeUser1)  echo 48\;2\;99\;72\;50;;		
        CreamCoffeeUser2)  echo 48\;2\;150\;114\;89;;	
        CreamCoffeeUser3)  echo 48\;2\;219\;193;\;172;;
	CreamCoffeeUser4)  echo 48\;2\;236\;224\;229;;
	CreamCoffeeLine0)  echo 48\;2\;177\;201\;161;;
	CreamCoffeeLine1)  echo 48\;2\;211\;221\;206;;
	CreamCoffeeLine2)  echo 48\;2\;226\;222\;224;;
	CreamCoffeeLine3)  echo 48\;2\;239\;238\;232;;
	CreamCoffeeLine4)  echo 48\;2\;249\;248\;242;;
	## MARRON -04
	ShadesOfMaroonUser0)  echo 48\;2\;86\;36\;36;;
        ShadesOfMaroonUser1)  echo 48\;2\;109\;54\;54;;		
        ShadesOfMaroonUser2)  echo 48\;2\;146\;68\;68;;	
        ShadesOfMaroonUser3)  echo 48\;2\;169\;76;\;76;;
	ShadesOfMaroonUser4)  echo 48\;2\;193\;113\;113;;
	ShadesOfMaroonLine0)  echo 48\;2\;177\;201\;161;;
	ShadesOfMaroonLine1)  echo 48\;2\;211\;221\;206;;
	ShadesOfMaroonLine2)  echo 48\;2\;226\;222\;224;;
	ShadesOfMaroonLine3)  echo 48\;2\;239\;238\;232;;
	ShadesOfMaroonLine4)  echo 48\;2\;249\;248\;242;;
	## MARRON - 05
	ChesnutBrownHairSwatchesUser0)  echo 48\;2\;48\;22\;6;;
        ChesnutBrownHairSwatchesUser1)  echo 48\;2\;65\;30\;2;;		
        ChesnutBrownHairSwatchesUser2)  echo 48\;2\;80\;40\;7;;	
        ChesnutBrownHairSwatchesUser3)  echo 48\;2\;100\;51;\;2;;
	ChesnutBrownHairSwatchesUser4)  echo 48\;2\;112\;61\;12;;
	ChesnutBrownHairSwatchesLine0)  echo 48\;2\;177\;201\;161;;
	ChesnutBrownHairSwatchesLine1)  echo 48\;2\;211\;221\;206;;
	ChesnutBrownHairSwatchesLine2)  echo 48\;2\;226\;222\;224;;
	ChesnutBrownHairSwatchesLine3)  echo 48\;2\;239\;238\;232;;
	ChesnutBrownHairSwatchesLine4)  echo 48\;2\;249\;248\;242;;
	### JAUNE
	## JAUNE -01
	Dark2BrightYellowUser0)  echo 48\;2\;111\;101\;0;;
        Dark2BrightYellowUser1)  echo 48\;2\;137\;124\;0;;		
        Dark2BrightYellowUser2)  echo 48\;2\;180\;154\;0;;	
        Dark2BrightYellowUser3)  echo 48\;2\;214\;184;\;0;;
	Dark2BrightYellowUser4)  echo 48\;2\;255\;206\;0;;
	Dark2BrightYellowLine0)  echo 48\;2\;177\;201\;161;;
	Dark2BrightYellowLine1)  echo 48\;2\;211\;221\;206;;
	Dark2BrightYellowLine2)  echo 48\;2\;226\;222\;224;;
	Dark2BrightYellowLine3)  echo 48\;2\;239\;238\;232;;
	Dark2BrightYellowLine4)  echo 48\;2\;249\;248\;242;;
	## JAUNE - 02
	YellowTherePeopleUser0)  echo 48\;2\;180\;162\;4;;
        YellowTherePeopleUser1)  echo 48\;2\;191\;173\;11;;		
        YellowTherePeopleUser2)  echo 48\;2\;204\;185\;8;;	
        YellowTherePeopleUser3)  echo 48\;2\;221\;200;\;2;;
	YellowTherePeopleUser4)  echo 48\;2\;234\;213\;8;;
	YellowTherePeopleLine0)  echo 48\;2\;177\;201\;161;;
	YellowTherePeopleLine1)  echo 48\;2\;211\;221\;206;;
	YellowTherePeopleLine2)  echo 48\;2\;226\;222\;224;;
	YellowTherePeopleLine3)  echo 48\;2\;239\;238\;232;;
	YellowTherePeopleLine4)  echo 48\;2\;249\;248\;242;;
        ## JAUNE - 03
	24KGoldUser0)  echo 48\;2\;166\;124\;0;;
        24KGoldUser1)  echo 48\;2\;191\;155\;48;;		
        24KGoldUser2)  echo 48\;2\;255\;191\;0;;	
        24KGoldUser3)  echo 48\;2\;255\;207;\;64;;
	24KGoldUser4)  echo 48\;2\;255\;220\;115;;
	24KGoldLine0)  echo 48\;2\;177\;201\;161;;
	24KGoldLine1)  echo 48\;2\;211\;221\;206;;
	24KGoldLine2)  echo 48\;2\;226\;222\;224;;
	24KGoldLine3)  echo 48\;2\;239\;238\;232;;
	24KGoldLine4)  echo 48\;2\;249\;248\;242;;
        ## JAUNE - 04
	GoldRodUser0)  echo 48\;2\;121\;78\;29;;
        GoldRodUser1)  echo 48\;2\;174\;111\;39;;		
        GoldRodUser2)  echo 48\;2\;182\;126\;45;;	
        GoldRodUser3)  echo 48\;2\;199\;142;\;33;;
	GoldRodUser4)  echo 48\;2\;212\;176\;54;;
	GoldRodLine0)  echo 48\;2\;177\;201\;161;;
	GoldRodLine1)  echo 48\;2\;211\;221\;206;;
	GoldRodLine2)  echo 48\;2\;226\;222\;224;;
	GoldRodLine3)  echo 48\;2\;239\;238\;232;;
	GoldRodLine4)  echo 48\;2\;249\;248\;242;;
        ## JAUNE - 05
	ShineLikeGoldUser0)  echo 48\;2\;255\;135\;44;;
        ShineLikeGoldUser1)  echo 48\;2\;255\;157\;44;;		
        ShineLikeGoldUser2)  echo 48\;2\;255\;178\;46;;	
        ShineLikeGoldUser3)  echo 48\;2\;255\;199;\;44;;
	ShineLikeGoldUser4)  echo 48\;2\;255\;221\;44;;
	ShineLikeGoldLine0)  echo 48\;2\;177\;201\;161;;
	ShineLikeGoldLine1)  echo 48\;2\;211\;221\;206;;
	ShineLikeGoldLine2)  echo 48\;2\;226\;222\;224;;
	ShineLikeGoldLine3)  echo 48\;2\;239\;238\;232;;
	ShineLikeGoldLine4)  echo 48\;2\;249\;248\;242;;
	### ROUGE
	## ROUGE - 01
	DarkRedRootUser0)  echo 48\;2\;86\;13\;13;;
        DarkRedRootUser1)  echo 48\;2\;92\;16\;16;;		
        DarkRedRootUser2)  echo 48\;2\;111\;0\;0;;	
        DarkRedRootUser3)  echo 48\;2\;148\;0;\;0;;
	DarkRedRootUser4)  echo 48\;2\;195\;1\;1;;
	DarkRedRootLine0)  echo 48\;2\;177\;201\;161;;
	DarkRedRootLine1)  echo 48\;2\;211\;221\;206;;
	DarkRedRootLine2)  echo 48\;2\;226\;222\;224;;
	DarkRedRootLine3)  echo 48\;2\;239\;238\;232;;
	DarkRedRootLine4)  echo 48\;2\;249\;248\;242;;
	## ROUGE - 02
	CrimsonWaveRootUser0)  echo 48\;2\;71\;0\;0;;
        CrimsonWaveRootUser1)  echo 48\;2\;99\;0\;0;;		
        CrimsonWaveRootUser2)  echo 48\;2\;120\;0\;0;;	
        CrimsonWaveRootUser3)  echo 48\;2\;141\;0;\;0;;
	CrimsonWaveRootUser4)  echo 48\;2\;159\;0\;0;;
	CrimsonWaveRootLine0)  echo 48\;2\;177\;201\;161;;
	CrimsonWaveRootLine1)  echo 48\;2\;211\;221\;206;;
	CrimsonWaveRootLine2)  echo 48\;2\;226\;222\;224;;
	CrimsonWaveRootLine3)  echo 48\;2\;239\;238\;232;;
	CrimsonWaveRootLine4)  echo 48\;2\;249\;248\;242;;
	### VIOLET
	## VIOLET- 01
	BlogPurpleUser0)  echo 48\;2\;53\;32\;78;;
        BlogPurpleUser1)  echo 48\;2\;72\;53\;94;;		
        BlogPurpleUser2)  echo 48\;2\;95\;76\;117;;	
        BlogPurpleUser3)  echo 48\;2\;122\;106;\;141;;
	BlogPurpleUser4)  echo 48\;2\;157\;146\;170;;
	BlogPurpleLine0)  echo 48\;2\;177\;201\;161;;
	BlogPurpleLine1)  echo 48\;2\;211\;221\;206;;
	BlogPurpleLine2)  echo 48\;2\;226\;222\;224;;
	BlogPurpleLine3)  echo 48\;2\;239\;238\;232;;
	BlogPurpleLine4)  echo 48\;2\;249\;248\;242;;
	## VIOLET- 02
	PurpleDreamsUser0)  echo 48\;2\;93\;0\;159;;
        PurpleDreamsUser1)  echo 48\;2\;110\;18\;176;;		
        PurpleDreamsUser2)  echo 48\;2\;135\;52\;195;;	
        PurpleDreamsUser3)  echo 48\;2\;155\;89;\;201;;
	PurpleDreamsUser4)  echo 48\;2\;174\;127\;208;;
	PurpleDreamsLine0)  echo 48\;2\;177\;201\;161;;
	PurpleDreamsLine1)  echo 48\;2\;211\;221\;206;;
	PurpleDreamsLine2)  echo 48\;2\;226\;222\;224;;
	PurpleDreamsLine3)  echo 48\;2\;239\;238\;232;;
	PurpleDreamsLine4)  echo 48\;2\;249\;248\;242;;
	## VIOLET- 03
	Purples1User0)  echo 48\;2\;184\;94\;230;;
        Purples1User1)  echo 48\;2\;193\;114\;233;;		
        Purples1User2)  echo 48\;2\;202\;134\;236;;	
        Purples1User3)  echo 48\;2\;228\;194;\;245;;
	Purples1User4)  echo 48\;2\;237\;214\;248;;
	Purples1Line0)  echo 48\;2\;177\;201\;161;;
	Purples1Line1)  echo 48\;2\;211\;221\;206;;
	Purples1Line2)  echo 48\;2\;226\;222\;224;;
	Purples1Line3)  echo 48\;2\;239\;238\;232;;
	Purples1Line4)  echo 48\;2\;249\;248\;242;;
	## VIOLET- 04
	SarahsPurpleUser0)  echo 48\;2\;61\;14\;111;;
        SarahsPurpleUser1)  echo 48\;2\;83\;33\;135;;		
        SarahsPurpleUser2)  echo 48\;2\;109\;55\;165;;	
        SarahsPurpleUser3)  echo 48\;2\;143\;93;\;195;;
	SarahsPurpleUser4)  echo 48\;2\;178\;136\;221;;
	SarahsPurpleLine0)  echo 48\;2\;177\;201\;161;;
	SarahsPurpleLine1)  echo 48\;2\;211\;221\;206;;
	SarahsPurpleLine2)  echo 48\;2\;226\;222\;224;;
	SarahsPurpleLine3)  echo 48\;2\;239\;238\;232;;
	SarahsPurpleLine4)  echo 48\;2\;249\;248\;242;;
	## VIOLET- 05
	AestheticUser0)  echo 48\;2\;102\;84\;94;;
        AestheticUser1)  echo 48\;2\;163\;145\;147;;		
        AestheticUser2)  echo 48\;2\;170\;111\;115;;	
        AestheticUser3)  echo 48\;2\;138\;169;\;144;;
	AestheticUser4)  echo 48\;2\;246\;224\;181;;
	AestheticLine0)  echo 48\;2\;177\;201\;161;;
	AestheticLine1)  echo 48\;2\;211\;221\;206;;
	AestheticLine2)  echo 48\;2\;226\;222\;224;;
	AestheticLine3)  echo 48\;2\;239\;238\;232;;
	AestheticLine4)  echo 48\;2\;249\;248\;242;;
        ## GRIS
        GrayUser0) echo 48\;2\;48\;48\;48;;
        GrayUser1) echo 48\;2\;81\;81\;81;;
	GrayUser2) echo 48\;2\;99\;99\;99;;
        GrayUser3) echo 48\;2\;119\;119\;119;;
        GrayUser4) echo 48\;2\;131\;131\;131;;
	GrayUser4) echo 48\;2\;159\;159\;159;;
        GrayLine0) echo 48\;2\;240\;240\;240;;
	GrayLine1) echo 48\;2\;235\;235\;235;;
	GrayLine2) echo 48\;2\;230\;230\;230;;
	GrayLine3) echo 48\;2\;225\;225\;225;;
	GrayLine4) echo 48\;2\;225\;225\;225;;
    esac;
}

# TIL: declare is global not local, so best use a different name
# for codes (mycodes) as otherwise it'll clobber the original.
# this changes from BASH v3 to BASH v4.
ansi() {
    local seq
    declare -a mycodes=("${!1}")

    debug "ansi: ${!1} all: $* aka ${mycodes[@]}"

    seq=""
    for ((i = 0; i < ${#mycodes[@]}; i++)); do
        if [[ -n $seq ]]; then
            seq="${seq};"
        fi
        seq="${seq}${mycodes[$i]}"
    done
    debug "ansi debug:" '\\[\\033['${seq}'m\\]'
    echo -ne '\[\033['${seq}'m\]'
    # PR="$PR\[\033[${seq}m\]"
}

ansi_single() {
    echo -ne '\[\033['$1'm\]'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
    local bg fg
    declare -a codes

    debug "Prompting $1 $2 $3"

    # if commented out from kruton's original... I'm not clear
    # if it did anything, but it messed up things like
    # prompt_status - Erik 1/14/17

    #    if [[ -z $1 || ( -z $2 && $2 != default ) ]]; then
    codes=("${codes[@]}" $(text_effect reset))
    #    fi
    if [[ -n $1 ]]; then
        bg=$(bg_color $1)
        codes=("${codes[@]}" $bg)
        debug "Added $bg as background to codes"
    fi
    if [[ -n $2 ]]; then
        fg=$(fg_color $2)
        codes=("${codes[@]}" $fg)
        debug "Added $fg as foreground to codes"
    fi

    debug "Codes: "
    # declare -p codes

    if [[ $CURRENT_BG != NONE && $1 != $CURRENT_BG ]]; then
        declare -a intermediate=($(fg_color $CURRENT_BG) $(bg_color $1))
        debug "pre prompt " $(ansi intermediate[@])
        PR="$PR $(ansi intermediate[@])$SEGMENT_SEPARATOR"
        debug "post prompt " $(ansi codes[@])
        PR="$PR$(ansi codes[@]) "
    else
        debug "no current BG, codes is $codes[@]"
        PR="$PR$(ansi codes[@]) "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && PR="$PR$3"
}

# End the prompt, closing any open segments
prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
        declare -a codes=($(text_effect reset) $(fg_color $CURRENT_BG))
        PR="$PR $(ansi codes[@])$SEGMENT_SEPARATOR"
    fi
    declare -a reset=($(text_effect reset))
    PR="$PR $(ansi reset[@])"
    CURRENT_BG=$1
}

### virtualenv prompt
prompt_virtualenv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        color=cyan
        prompt_segment $color $PRIMARY_FG
        prompt_segment $color white "$(basename $VIRTUAL_ENV)"
    fi
}


### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
    local user=`whoami`

    if [[ $user == $DEFAULT_USER || $user != $DEFAULT_USER || -n $SSH_CLIENT ]]; then
        prompt_segment "$COLOR_2" "$COLOR_LINE_2" '\u' #"Adel" #"$user@\h"
    fi
}

# prints history followed by HH:MM, useful for remembering what
# we did previously
prompt_histdt() {
    prompt_segment black default "\! [\A]"
}


git_status_dirty() {
    dirty=$(git status -s 2> /dev/null | tail -n 1)
    [[ -n $dirty ]] && echo " ●"
}

git_stash_dirty() {
    stash=$(git stash list 2> /dev/null | tail -n 1)
    [[ -n $stash ]] && echo " ⚑"
}

# Git: branch/detached head, dirty status
prompt_git() {
    local ref dirty
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        ZSH_THEME_GIT_PROMPT_DIRTY='±'
        dirty=$(git_status_dirty)
        stash=$(git_stash_dirty)
        ref=$(git symbolic-ref HEAD 2> /dev/null) \
            || ref="➦ $(git describe --exact-match --tags HEAD 2> /dev/null)" \
            || ref="➦ $(git show-ref --head -s --abbrev | head -n1 2> /dev/null)"
        if [[ -n $dirty ]]; then
            prompt_segment yellow black
        else
            prompt_segment green black
        fi
        PR="$PR${ref/refs\/heads\// }$stash$dirty"
    fi
}

# Mercurial: clean, modified and uncomitted files
prompt_hg() {
    local rev st branch
    if $(hg id >/dev/null 2>&1); then
        if $(hg prompt >/dev/null 2>&1); then
            if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
                # if files are not added
                prompt_segment red white
                st='±'
            elif [[ -n $(hg prompt "{status|modified}") ]]; then
                # if any modification
                prompt_segment yellow black
                st='±'
            else
                # if working copy is clean
                prompt_segment green black $CURRENT_FG
            fi
            PR="$PR$(hg prompt "☿ {rev}@{branch}") $st"
        else
            st=""
            rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
            branch=$(hg id -b 2>/dev/null)
            if `hg st | grep -q "^\?"`; then
                prompt_segment red white
                st='±'
            elif `hg st | grep -q "^[MA]"`; then
                prompt_segment yellow black
                st='±'
            else
                prompt_segment green black $CURRENT_FG
            fi
            PR="$PR☿ $rev@$branch $st"
        fi
    fi
}
# Host: current Hostname (useful for ssh)
prompt_host() {
    prompt_segment "$COLOR_1" "$COLOR_LINE_1" '\h'
}

# Dir: current working directory
prompt_dir() {
    prompt_segment "$COLOR_3" "$COLOR_LINE_3" '\w'
}


# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
    local symbols
    symbols=()
    [[ $RETVAL -ne 0 ]] && symbols+="$(ansi_single $(fg_color red))✘"
    [[ $UID != 0 ]] && symbols+="$(ansi_single $(fg_color $COLOR_LINE_0))$"
    [[ $UID -eq 0 ]] && symbols+="$(ansi_single $(fg_color $COLOR_LINE_0))⚡"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="$(ansi_single $(fg_color cyan))⚙"

    [[ -n "$symbols" ]] && prompt_segment "$COLOR_0" "$COLOR_LINE_0" "$symbols"
}

change_colors() {
# Get the result of whoami command and redirect output to /dev/null
if [[ $(whoami 2>/dev/null) = "root" ]]; then
	COLOR_0="CrimsonWaveRootUser0"
	COLOR_1="CrimsonWaveRootUser1"
	COLOR_2="CrimsonWaveRootUser2"
	COLOR_3="CrimsonWaveRootUser3"
	COLOR_4="CrimsonWaveRootUser4"
	COLOR_LINE_0="CrimsonWaveRootLine0"
	COLOR_LINE_1="CrimsonWaveRootLine1"
	COLOR_LINE_2="CrimsonWaveRootLine2"
	COLOR_LINE_3="CrimsonWaveRootLine3"
	COLOR_LINE_4="CrimsonWaveRootLine2"
else
	local user=$(hostname 2>/dev/null)
	
	case $user in
	supervision)
	COLOR_0="ForestGreenUser0"
	COLOR_1="ForestGreenUser1"
	COLOR_2="ForestGreenUser2"
	COLOR_3="ForestGreenUser3"
	COLOR_4="ForestGreenUser4"
	COLOR_LINE_0="ForestGreenUser0"
	COLOR_LINE_1="ForestGreenUser1"
	COLOR_LINE_2="ForestGreenUser2"
	COLOR_LINE_3="ForestGreenUser3"
	COLOR_LINE_4="ForestGreenUser4"
	;;
	webserver1)
	COLOR_0="PrincessPinkUser0"
	COLOR_1="PrincessPinkUser1"
	COLOR_2="PrincessPinkUser2"
	COLOR_3="PrincessPinkUser3"
	COLOR_4="PrincessPinkUser4"
	COLOR_LINE_0="PrincessPinkLine0"
	COLOR_LINE_0="PrincessPinkLine1"
	COLOR_LINE_0="PrincessPinkLine2"
	COLOR_LINE_0="PrincessPinkLine3"
	COLOR_LINE_0="PrincessPinkLine4"
	;;
	webserver2)
	COLOR_0="ItsPinkUser0"
	COLOR_1="ItsPinkPinkUser1"
	COLOR_2="ItsPinkPinkUser2"
	COLOR_3="ItsPinkPinkUser3"
	COLOR_4="ItsPinkPinkUser4"
	COLOR_LINE_0="ItsPinkPinkLine0"
	COLOR_LINE_0="ItsPinkPinkLine1"
	COLOR_LINE_0="ItsPinkPinkLine2"
	COLOR_LINE_0="ItsPinkPinkLine3"
	COLOR_LINE_0="ItsPinkPinkLine4"	
	;;
	dbserver1)
	COLOR_0="24KGoldUser0"
	COLOR_1="24KGoldUser1"
	COLOR_2="24KGoldUser2"
	COLOR_3="24KGoldUser3"
	COLOR_4="24KGoldUser4"
	COLOR_LINE_0="24KGoldLine0"
	COLOR_LINE_1="24KGoldLine1"
	COLOR_LINE_2="24KGoldLine2"
	COLOR_LINE_3="24KGoldLine3"
	COLOR_LINE_4="24KGoldLine4"
	;;
	dbserver2)
	COLOR_0="GoldRodUser0"
	COLOR_1="GoldRodUser1"
	COLOR_2="GoldRodUser2"
	COLOR_3="GoldRodUser3"
	COLOR_4="GoldRodUser4"
	COLOR_LINE_0="GoldRodLine0"
	COLOR_LINE_1="GoldRodLine1"
	COLOR_LINE_2="GoldRodLine2"
	COLOR_LINE_3="GoldRodLine3"
	COLOR_LINE_4="GoldRodLine4"
	;;
	client)
	COLOR_0="CreamCoffeeUser0"
	COLOR_1="CreamCoffeeUser1"
	COLOR_2="CreamCoffeeUser2"
	COLOR_3="CreamCoffeeUser3"
	COLOR_3="CreamCoffeeUser4"
	COLOR_LINE_0="CreamCoffeeLine0"
	COLOR_LINE_1="CreamCoffeeLine1"
	COLOR_LINE_2="CreamCoffeeLine2"
	COLOR_LINE_3="CreamCoffeeLine3"
	COLOR_LINE_4="CreamCoffeeLine4"
	;;
	haproxyserver)
	COLOR_0="ArcDarkUser0"
	COLOR_1="ArcDarkUser1"
	COLOR_2="ArcDarkUser2"
	COLOR_3="ArcDarkUser3"
	COLOR_4="ArcDarkUser4"
	COLOR_LINE_0="ArcDarkLine0"
	COLOR_LINE_1="ArcDarkLine1"
	COLOR_LINE_2="ArcDarkLine2"
	COLOR_LINE_3="ArcDarkLine3"
	COLOR_LINE_4="ArcDarkLine4"
	;;
	root)
	COLOR_0="RedUser0"
	COLOR_1="RedUser1"
	COLOR_2="RedUser2"
	COLOR_3="RedUser3"
	COLOR_LINE_0="RedLine0"
	COLOR_LINE_1="RedLine1"
	COLOR_LINE_2="RedLine2"
	COLOR_LINE_3="RedLine3"
	;;
	*)
	COLOR_0="GrayUser0"
	COLOR_1="GrayUser1"
	COLOR_2="GrayUser2"	
	COLOR_3="GrayUser3"
	COLOR_3="GrayUser4"
	COLOR_LINE_0="GrayLine0"
	COLOR_LINE_1="GrayLine1"
	COLOR_LINE_2="GrayLine2"
	COLOR_LINE_3="GrayLine3"
	COLOR_LINE_4="GrayLine4"
	;;
	esac
fi
}

######################################################################
#
# experimental right prompt stuff
# requires setting prompt_foo to use PRIGHT vs PR
# doesn't quite work per above

rightprompt() {
    printf "%*s" $COLUMNS "$PRIGHT"
}

# quick right prompt I grabbed to test things.
__command_rprompt() {
    local times= n=$COLUMNS tz
    for tz in ZRH:Europe/Zurich PIT:US/Eastern \
              MTV:US/Pacific TOK:Asia/Tokyo; do
        [ $n -gt 40 ] || break
        times="$times ${tz%%:*}\e[30;1m:\e[0;36;1m"
        times="$times$(TZ=${tz#*:} date +%H:%M)\e[0m"
        n=$(( $n - 10 ))
    done
    [ -z "$times" ] || printf "%${n}s$times\\r" ''
}
# PROMPT_COMMAND=__command_rprompt

# this doens't wrap code in \[ \]
ansi_r() {
    local seq
    declare -a mycodes2=("${!1}")

    debug "ansi: ${!1} all: $* aka ${mycodes2[@]}"

    seq=""
    for ((i = 0; i < ${#mycodes2[@]}; i++)); do
        if [[ -n $seq ]]; then
            seq="${seq};"
        fi
        seq="${seq}${mycodes2[$i]}"
    done
    debug "ansi debug:" '\\[\\033['${seq}'m\\]'
    echo -ne '\033['${seq}'m'
    # PR="$PR\[\033[${seq}m\]"
}

# Begin a segment on the right
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_right_segment() {
    local bg fg
    declare -a codes

    debug "Prompt right"
    debug "Prompting $1 $2 $3"

    # if commented out from kruton's original... I'm not clear
    # if it did anything, but it messed up things like
    # prompt_status - Erik 1/14/17

    #    if [[ -z $1 || ( -z $2 && $2 != default ) ]]; then
    codes=("${codes[@]}" $(text_effect reset))
    #    fi
    if [[ -n $1 ]]; then
        bg=$(bg_color $1)
        codes=("${codes[@]}" $bg)
        debug "Added $bg as background to codes"
    fi
    if [[ -n $2 ]]; then
        fg=$(fg_color $2)
        codes=("${codes[@]}" $fg)
        debug "Added $fg as foreground to codes"
    fi

    debug "Right Codes: "
    # declare -p codes

    # right always has a separator
    # if [[ $CURRENT_RBG != NONE && $1 != $CURRENT_RBG ]]; then
    #     $CURRENT_RBG=
    # fi
    declare -a intermediate2=($(fg_color $1) $(bg_color $CURRENT_RBG) )
    # PRIGHT="$PRIGHT---"
    debug "pre prompt " $(ansi_r intermediate2[@])
    PRIGHT="$PRIGHT$(ansi_r intermediate2[@])$RIGHT_SEPARATOR"
    debug "post prompt " $(ansi_r codes[@])
    PRIGHT="$PRIGHT$(ansi_r codes[@]) "
    # else
    #     debug "no current BG, codes is $codes[@]"
    #     PRIGHT="$PRIGHT$(ansi codes[@]) "
    # fi
    CURRENT_RBG=$1
    [[ -n $3 ]] && PRIGHT="$PRIGHT$3"
}

######################################################################
## Emacs prompt --- for dir tracking
# stick the following in your .emacs if you use this:

# (setq dirtrack-list '(".*DIR *\\([^ ]*\\) DIR" 1 nil))
# (defun dirtrack-filter-out-pwd-prompt (string)
#   "dirtrack-mode doesn't remove the PWD match from the prompt.  This does."
#   ;; TODO: support dirtrack-mode's multiline regexp.
#   (if (and (stringp string) (string-match (first dirtrack-list) string))
#       (replace-match "" t t string 0)
#     string))
# (add-hook 'shell-mode-hook
#           #'(lambda ()
#               (dirtrack-mode 1)
#               (add-hook 'comint-preoutput-filter-functions
#                         'dirtrack-filter-out-pwd-prompt t t)))

prompt_emacsdir() {
    # no color or other setting... this will be deleted per above
    PR="DIR \w DIR$PR"
}

######################################################################
## Main prompt
change_colors
build_prompt() {
    [[ ! -z ${AG_EMACS_DIR+x} ]] && prompt_emacsdir
    prompt_status
    #[[ -z ${AG_NO_HIST+x} ]] && prompt_histdt
    [[ -z ${AG_NO_CONTEXT+x} ]] && 
	prompt_virtualenv
	prompt_host
        prompt_context
        prompt_dir
        prompt_git
        prompt_hg
        prompt_end
}

# from orig...
# export PS1='$(ansi_single $(text_effect reset)) $(build_prompt) '
# this doesn't work... new model: create a prompt via a PR variable and
# use that.

set_bash_prompt() {
    RETVAL=$?
    PR=""
    PRIGHT=""
    CURRENT_BG=NONE
    PR="$(ansi_single $(text_effect reset))"
    build_prompt

    # uncomment below to use right prompt
    #     PS1='\[$(tput sc; printf "%*s" $COLUMNS "$PRIGHT"; tput rc)\]'$PR
    PS1=$PR
}

PROMPT_COMMAND=set_bash_prompt
