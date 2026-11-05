/* See LICENSE file for copyright and license details. */

/* appearance */
static unsigned int borderpx        = 2;        /* border pixel of windows */
static unsigned int snap            = 0;        /* snap pixel */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const unsigned int gappih    = 10;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static int showbar                  = 1;        /* 0 means no bar */
static int topbar                   = 1;        /* 0 means bottom bar */
static char font[]                  = "JetBrainsMono Nerd Font:style=Bold:size=8:antialias=true:autohint=true";
static char dmenufont[]             = "JetBrainsMono Nerd Font:style=Bold:size=8:antialias=true:autohint=true";
static const char *fonts[]          = { font };
static char normbgcolor[]           = "#222222";
static char normbordercolor[]       = "#444444";
static char normfgcolor[]           = "#bbbbbb";
static char selfgcolor[]            = "#eeeeee";
static char selbordercolor[]        = "#005577";
static char selbgcolor[]            = "#005577";
static const unsigned int baralpha  = 0xd0;
static const unsigned int borderalpha = OPAQUE;
static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
       [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
};

static const unsigned int alphas[][3]      = {
    /*               fg      bg        border*/
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	  [SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};

typedef struct {
	const char *name;
	const void *cmd;
} Sp;
const char *spcmd1[] = {"st", "-n", "spterm", "-g", "120x35", NULL };
const char *spcmd2[] = {"st", "-n", "spfiles", "-g", "144x40", "-e", "ranger", NULL };
const char *spcmd3[] = {"st", "-n", "spmusic", "-g", "150x40", "-e", "ncmpcpp", NULL };
const char *spcmd4[] = {"st", "-n", "spnews", "-g", "145x50", "-e", "newsraft", NULL };
const char *spcmd5[] = {"st", "-n", "spvol", "-g", "144x41", "-e", "pulsemixer", NULL };
const char *spcmd6[] = {"obs", NULL };
const char *spcmd7[] = {"qalculate-gtk", NULL };
static Sp scratchpads[] = {
	/* name          cmd  */
	{"spterm",     spcmd1},
	{"spfiles",    spcmd2},
	{"spmusic",    spcmd3},
	{"spnews",     spcmd4},
	{"spvol",      spcmd5},
	{"obs",        spcmd6},
	{"qalc",       spcmd7},
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                 instance       title         tags mask    isfloating  isterminal  noswallow  monitor */
	{ "Gimp",                 NULL,          NULL,           0,           1,          0,          -1,        -1 },
	{ "Brave-browser",            NULL,          NULL,           0,           0,          0,          -1,        -1 },
	{ "St",                   NULL,          NULL,           0,           0,          1,          -1,        -1 },
	{ "Pcmanfm",              NULL,          NULL,           0,           0,          1,          -1,        -1 },
  { "Qalculate-gtk",        NULL,          NULL,           0,           1,          0,           1,        -1 },
  { NULL,		            "spterm",	         NULL,	  SPTAG(0),	          1,			    1,           1,        -1 },
	{ NULL,		           "spfiles",	       	 NULL,	  SPTAG(1),		        1,			    1,           1,        -1 },
	{ NULL,		           "spmusic",	         NULL,	  SPTAG(2),	          1,			    1,           1,        -1 },
	{ NULL,		            "spnews",	         NULL,	  SPTAG(3),	          1,			    1,           1,        -1 },
	{ NULL,		             "spvol",	         NULL,	  SPTAG(4),	          1,			    1,           1,        -1 },
	{ NULL,		               "obs",	         NULL,	  SPTAG(5),	          1,			    1,           1,        -1 },
	{ NULL,		              "qalc",	         NULL,	  SPTAG(6),	          1,			    0,           1,        -1 },
	{ NULL,		               "mpv",	         NULL,	         0,           1,			    0,           1,        -1 },
};

/* layout(s) */
static float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static int nmaster     = 1;    /* number of clients in master area */
static int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int attachdirection = 0;    /* 0 default, 1 above, 2 aside, 3 below, 4 bottom, 5 top */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define STATUSBAR "dwmblocks"

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]   =   { "dmenu_run", "-l", "20", NULL };
static const char *xmenucmd[]   =   { "menu", NULL };
static const char *termcmd[]    =   { "st", NULL };
static const char *screenshot[] =   { "screenshot", NULL };
static const char *fullshot[]   =   { "flameshot", "full", NULL };
static const char *slock[]      =   { "slock", NULL };
static const char *wall[]       =   { "wallpick", NULL };
static const char *clip[]       =   { "clipmenu", NULL };
static const char *dfiles[]     =   { "dfiles", NULL };
static const char *dots[]       =   { "dots", NULL };
static const char *night[]      =   { "nightmode", NULL };


/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
  { "color4",             STRING,   &normbordercolor},
  { "color14",            STRING,   &selbordercolor},
  { "color0",             STRING,   &normbgcolor},
  { "color12",            STRING,   &normfgcolor},
  { "color7",             STRING,   &selfgcolor},
  { "color0",             STRING,   &selbgcolor},
	{ "font",               STRING,   &font },
	{ "dmenufont",          STRING,   &dmenufont },
	{ "normbgcolor",        STRING,   &normbgcolor },
	{ "normbordercolor",    STRING,   &normbordercolor },
	{ "normfgcolor",        STRING,   &normfgcolor },
	{ "selbgcolor",         STRING,   &selbgcolor },
	{ "selbordercolor",     STRING,   &selbordercolor },
	{ "selfgcolor",         STRING,   &selfgcolor },
	{ "borderpx",          	INTEGER,  &borderpx },
	{ "snap",          		  INTEGER,  &snap },
	{ "showbar",          	INTEGER,  &showbar },
	{ "topbar",           	INTEGER,  &topbar },
	{ "nmaster",           	INTEGER,  &nmaster },
	{ "resizehints",       	INTEGER,  &resizehints },
	{ "mfact",      	 	    FLOAT,    &mfact },
};

#include "movestack.c"
#include "exitdwm.c"

static const Key keys[] = {
	/* modifier                     key            function           argument */
	{ MODKEY,                       XK_p,          spawn,             {.v = dmenucmd } },
	{ MODKEY,                       XK_Return,     spawn,             {.v = termcmd } },
  { 0,                            XK_Print,      spawn,             {.v = screenshot } },
  { MODKEY,                       XK_Print,      spawn,             {.v = fullshot } },
  { MODKEY,                       XK_F11,        spawn,             {.v = slock } },
  { 0,                            0x1008ff13,    spawn,             SHCMD("statusvolume up") },
  { 0,                            0x1008ff11,    spawn,             SHCMD("statusvolume down") },
  { 0,                            0x1008ff12,    spawn,             SHCMD("statusvolume mute") },
  { Mod1Mask,                     XK_F2,         spawn,             SHCMD("statusmic down") },
  { Mod1Mask,                     XK_F3,         spawn,             SHCMD("statusmic up") },
  { Mod1Mask,                     XK_z,          spawn,             SHCMD("statusmic mute") },
  { 0,                            0x1008ff02,    spawn,             SHCMD("statusbrightness up") },
  { 0,                            0x1008ff03,    spawn,             SHCMD("statusbrightness down") },
  { MODKEY|ShiftMask,             XK_n,          spawn,             {.v = night} },
  { MODKEY|ShiftMask,             XK_y,          spawn,             {.v = clip} },
  { MODKEY|ShiftMask,             XK_e,          spawn,             {.v = wall} },
  { MODKEY|ShiftMask,             XK_s,          spawn,             {.v = dfiles} },
  { MODKEY|ShiftMask,             XK_d,          spawn,             {.v = dots} },
	{ MODKEY,                       XK_b,          togglebar,         {0} },
	{ MODKEY,                       XK_Left,       focusstack,        {.i = +1 } },
	{ MODKEY,                       XK_Right,      focusstack,        {.i = -1 } },
	{ MODKEY,                       XK_i,          incnmaster,        {.i = +1 } },
	{ MODKEY,                       XK_d,          incnmaster,        {.i = -1 } },
	{ MODKEY,                       XK_h,          setmfact,          {.f = -0.05} },
	{ MODKEY,                       XK_l,          setmfact,          {.f = +0.05} },
	{ MODKEY,                       XK_j,          setcfact,          {.f = +0.25} },
	{ MODKEY,                       XK_k,          setcfact,          {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,          setcfact,          {.f =  0.00} },
  { MODKEY|ShiftMask,             XK_Right,      movestack,         {.i = +1 } },
  { MODKEY|ShiftMask,             XK_Left,       movestack,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_Return,     zoom,              {0} },
  { MODKEY,                       XK_equal,      incrogaps,         {.i = +1 } },
  { MODKEY,                       XK_minus,      incrogaps,         {.i = -1 } },
  { MODKEY|ShiftMask,             XK_equal,      incrohgaps,        {.i = +1 } },
  { MODKEY|ShiftMask,             XK_minus,      incrohgaps,        {.i = -1 } },
  { MODKEY|ControlMask,           XK_equal,      incrovgaps,        {.i = +1 } },
  { MODKEY|ControlMask,           XK_minus,      incrovgaps,        {.i = -1 } },
  { MODKEY|Mod1Mask,              XK_equal,      incrigaps,         {.i = +1 } },
  { MODKEY|Mod1Mask,              XK_minus,      incrigaps,         {.i = -1 } },
  { MODKEY|Mod1Mask|ShiftMask,    XK_equal,      incrgaps,          {.i = +1 } },
  { MODKEY|Mod1Mask|ShiftMask,    XK_minus,      incrgaps,          {.i = -1 } },
  { MODKEY|Mod1Mask,              XK_8,          incrihgaps,        {.i = +1 } },
  { MODKEY|Mod1Mask|ShiftMask,    XK_8,          incrihgaps,        {.i = -1 } },
  { MODKEY|Mod1Mask,              XK_9,          incrivgaps,        {.i = +1 } },
  { MODKEY|Mod1Mask|ShiftMask,    XK_9,          incrivgaps,        {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_0,          togglegaps,        {0} },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_0,          defaultgaps,       {0} },
	{ MODKEY,                       XK_Tab,        view,              {0} },
	{ MODKEY|ShiftMask,             XK_q,          killclient,        {0} },
	{ MODKEY,                       XK_t,          setlayout,         {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,          setlayout,         {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,          setlayout,         {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,      setlayout,         {0} },
	{ MODKEY|ShiftMask,             XK_space,      togglefloating,    {0} },
	{ MODKEY,                       XK_0,          view,              {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,          tag,               {.ui = ~0 } },
	{ MODKEY,                       XK_comma,      focusmon,          {.i = -1 } },
	{ MODKEY,                       XK_period,     focusmon,          {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,      tagmon,            {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,     tagmon,            {.i = +1 } },
  { MODKEY|ShiftMask,             XK_Return,     togglescratch,     {.ui = 0 } },
	{ MODKEY,            	      		XK_F1,	       togglescratch,     {.ui = 1 } },
	{ MODKEY,            		      	XK_F2,	       togglescratch,     {.ui = 2 } },
  { MODKEY,            		      	XK_F3,	       togglescratch,     {.ui = 3 } },
  { MODKEY,            		      	XK_F4,	       togglescratch,     {.ui = 4 } },
  { MODKEY,            		      	XK_F5,	       togglescratch,     {.ui = 5 } },
  { MODKEY,            		      	XK_F6,	       togglescratch,     {.ui = 6 } },
  { MODKEY,            		      	XK_F7,	       togglescratch,     {.ui = 7 } },
	TAGKEYS(                        XK_1,                             0)
	TAGKEYS(                        XK_2,                             1)
	TAGKEYS(                        XK_3,                             2)
	TAGKEYS(                        XK_4,                             3)
	TAGKEYS(                        XK_5,                             4)
	TAGKEYS(                        XK_6,                             5)
	TAGKEYS(                        XK_7,                             6)
	TAGKEYS(                        XK_8,                             7)
	TAGKEYS(                        XK_9,                             8)
	{ MODKEY|ShiftMask,             XK_r,      quit,                  {0} },
	{ MODKEY|ShiftMask,             XK_p,      exitdwm,               {0} },

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
  { ClkRootWin,           0,              Button3,        spawn,          {.v = xmenucmd } },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
  { ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
  { ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
  { ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
  { ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
  { ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },
  { ClkStatusText,        ShiftMask,      Button1,        sigstatusbar,   {.i = 6} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button1,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

