%%
%% This is file `syllabus.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% syllabus.dtx  (with options: `class')
%% This syllabus class is for typesetting syllabus book for RV College of Engineering. 
%% Copyright (C) 2026 by P Narashimaraja <narashimaraja@gmail.com>
\def\fileversion{6.0}
\def\filedate{2026-08-08}
\NeedsTeXFormat{LaTeX2e}[2023-11-01]
\ProvidesClass{syllabus}[\filedate\space v\fileversion\space by Latex Coordinator]
\DeclareOption*{%
	\PassOptionsToClass{\CurrentOption}{article}%
}
\ProcessOptions\relax
\LoadClass{article}
\RequirePackage{ifthen}
\RequirePackage{longtable}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{pgf}
\RequirePackage{pgffor}
\RequirePackage{fancyhdr}
\RequirePackage{textcase} 
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{multirow} 
\RequirePackage{pdflscape}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{mfirstuc}
\RequirePackage{pdfpages}
\RequirePackage{needspace}

\ExplSyntaxOn
\NewDocumentCommand{\uncaseword}{ m }{
	\clist_map_inline:nn { #1 } {
		\MFUnocap{##1}
	}
}

% --- NEW: THE SMART LOWERCASE-FIRST WRAPPER ---
\NewDocumentCommand{\SmartTitleCase}{ m }{
	\tl_set:Nx \l_tmpa_tl { \text_lowercase:n { #1 } }
	\exp_args:NV \capitalisewords \l_tmpa_tl
}
\ExplSyntaxOff

% Default list of words to strictly keep lowercase in titles
\uncaseword{a, an, the, and, but, or, for, nor, on, at, to, from, by, in, of, with, into}

\setlength{\textwidth}{\paperwidth}
\addtolength{\textwidth}{-1.5in}
\setlength{\oddsidemargin}{-0.25in}
\setlength{\evensidemargin}{-0.25in}
\setlength{\headheight}{15pt}
\setlength{\headsep}{15pt}
\setlength{\topmargin}{0in}
\addtolength{\topmargin}{-\headheight}
\addtolength{\topmargin}{-\headsep}
\setlength{\footskip}{18pt}
\setlength{\textheight}{\paperheight}
\addtolength{\textheight}{-1.8in}
\setlength{\marginparwidth}{.5in}
\setlength{\marginparsep}{5pt}

\newif\ifprerequisite
\newif\ifpractice
\newif\ifpracticeel
\newif\iftutorial
\newif\iflecture
\newif\ifpgnumout
\newif\ifenable
\newif\ifstandalone
\newif\ifsyllabus@ready
\newif\ifsyllabus@rerun@warning

\prerequisitefalse
\practicefalse
\practiceelfalse
\tutorialfalse
\lecturefalse
\pgnumoutfalse
\enablefalse
\standalonefalse
\syllabus@readyfalse

\newcounter{latest@course}
\newcounter{numof@courses}
\newcounter{numof@semesters}
\setcounter{numof@semesters}{0}

\newcounter{numof@prerequisites}
\newcounter{numof@lectureunits}
\newcounter{numof@practiceunits}
\newcounter{numof@practiceelunits}
\newcounter{numof@cos}
\newcounter{numof@refs}
\newcounter{temp@counter}

% counters for total L T P calculations per sem
\newcounter{tot@semester@L}
\newcounter{tot@semester@T}
\newcounter{tot@semester@P}

\newcounter{semester@loop@ctr}
\newcounter{semester@temp@ctr}
\newcounter{course@loop@ctr}
\newcounter{course@temp@ctr}
\newwrite\coursefile

\gdef\current@variant@suffix{}
\gdef\lsem{1} 

% 1. Declare the global defaults normally (No \AtBeginDocument needed here)
\gdef\@departmentSF{ECE}
\gdef\@departmentLF{Electronics and Communication Engineering}
\gdef\@graduateLabel{UG}
\gdef\@graduateDegree{B.E.}
\gdef\@graduateCourse{Structural Engineering}
\gdef\@schemeYear{2025}

% 2. Update \department to wait until the .aux file is open
\newcommand*{\department}[2][ECE]{%
	\gdef\@departmentSF{#1}%
	\gdef\@departmentLF{#2}%
	
	\AtBeginDocument{%
		\immediate\write\@mainaux{\string\gdef\string\@departmentSF{#1}}%
		\immediate\write\@mainaux{\string\gdef\string\@departmentLF{#2}}%
	}%
}
\newcommand{\departmentname}{\@departmentLF}

% 2b. Update \DegreeCourse to wait until the .aux file is open
\newcommand*{\DegreeCourse}[2][B.E.]{%
	\gdef\@graduateDegree{#1}%
	\gdef\@graduateCourse{#2}%
	
	\AtBeginDocument{%
		\immediate\write\@mainaux{\string\gdef\string\@graduateDegree{#1}}%
		\immediate\write\@mainaux{\string\gdef\string\@graduateCourse{#2}}%
	}%
}

% 3. Update \schemeYear to wait until the .aux file is open
\newcommand*{\schemeYear}[2][UG]{%
	\gdef\@graduateLabel{#1}%
	\gdef\@schemeYear{#2}%
	
	\AtBeginDocument{%
		\immediate\write\@mainaux{\string\gdef\string\@graduateLabel{#1}}%
		\immediate\write\@mainaux{\string\gdef\string\@schemeYear{#2}}%
	}%
}

\newcommand\checkint[1]{%
	\ifnum#1=\numexpr#1\relax
	\ifnum#1>3\relax
	\ClassError{syllabus}{#1 is not a valid integer}{}%
	\fi
	\else
	\ClassError{syllabus}{#1 is not an integer}{}%
	\fi
}

\def\AC{AC} 
\def\EL{EL} 
\def\lo{LO} 
\def\lt{LT} 
\def\lp{LP} 
\def\po{PO} 
\def\NPTEL{NPTEL}
\def\Proj{Proj}

% \extract@basetype normally reads the first TWO characters of a course
% type as its "base type" (LO/LT/LP/PO) and treats the rest as a variant
% suffix (e.g. "LOb" -> base LO, variant b). NPTEL is a 5-letter base type,
% so we special-case it here: if the first two characters are "NP", check
% whether the next three are "TEL" and, if so, treat the whole 5 letters
% as the base type before falling back to the ordinary 2-letter split.
% Proj is handled the same way: it is a 4-letter base type, so if the
% first two characters are "Pr", check whether the next two are "oj".
\def\extract@basetype#1#2#3\@nil{%
	\def\@nptest{#1#2}%
	\def\@npmarker{NP}%
	\def\@projtest{#1#2}%
	\def\@projmarker{Pr}%
	\ifx\@nptest\@npmarker
	\@extract@nptel#3\@nil
	\else\ifx\@projtest\@projmarker
	\@extract@proj#3\@nil
	\else
	\gdef\course@basetype{#1#2}%
	\gdef\temp@variant{#3}%
	\fi\fi
}
\def\@extract@nptel#1#2#3#4\@nil{%
	\def\@teltest{#1#2#3}%
	\def\@telmarker{TEL}%
	\ifx\@teltest\@telmarker
	\gdef\course@basetype{NPTEL}%
	\gdef\temp@variant{#4}%
	\else
	\gdef\course@basetype{NP}%
	\gdef\temp@variant{#1#2#3#4}%
	\fi
}
\def\@extract@proj#1#2#3\@nil{%
	\def\@ojtest{#1#2}%
	\def\@ojmarker{oj}%
	\ifx\@ojtest\@ojmarker
	\gdef\course@basetype{Proj}%
	\gdef\temp@variant{#3}%
	\else
	\gdef\course@basetype{Pr}%
	\gdef\temp@variant{#1#2#3}%
	\fi
}
\def\clean@variant#1\relax\relax\@nil{\gdef\course@variant{#1}}

\newcommand\checkcoursetype[1]{%
	\edef\coursetypeupper{#1}%
	\expandafter\extract@basetype\coursetypeupper\relax\relax\@nil
	\expandafter\clean@variant\temp@variant\@nil
	
	\ifx\course@basetype\po\relax
	\global\lecturetrue \global\practicetrue \global\tutorialfalse
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@lecturestatus}{1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@practicestatus}{1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@tutorialstatus}{0}}
	\else\ifx\course@basetype\lo\relax
	\global\lecturetrue \global\practicefalse \global\tutorialfalse
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@lecturestatus}{1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@practicestatus}{0}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@tutorialstatus}{0}}
	\else\ifx\course@basetype\lt\relax
	\global\lecturetrue \global\practicefalse \global\tutorialtrue
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@lecturestatus}{1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@practicestatus}{0}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@tutorialstatus}{1}}
	\else\ifx\course@basetype\lp\relax
	\global\lecturetrue \global\practicetrue \global\tutorialfalse
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@lecturestatus}{1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@practicestatus}{1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@tutorialstatus}{0}}
	\else\ifx\course@basetype\NPTEL\relax
	\global\lecturetrue \global\practicefalse \global\tutorialfalse
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@lecturestatus}{1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@practicestatus}{0}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@tutorialstatus}{0}}
	\else\ifx\course@basetype\Proj\relax
	\global\lecturetrue \global\practicefalse \global\tutorialfalse
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@lecturestatus}{1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@practicestatus}{0}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@tutorialstatus}{0}}
	\else\ifx\course@basetype\EL\relax
	\else
	\ClassError{syllabus}{Invalid course type `#1'. Must be PO, LO, LT, LP, NPTEL, or Proj}{}%
	\fi\fi\fi\fi\fi\fi\fi
}

\def\EL{EL}
\newcommand\checkpracticeeltype[1]{%
	\edef\coursetypeupper{#1}%
	\ifx\coursetypeupper\EL\relax \practiceeltrue \else \ClassError{syllabus}{Invalid course type `#1'. Must be EL}{} \fi
}
\newcommand\checkunithour[1]{%
	\ifnum#1=\numexpr#1\relax \typeout{#1 is an integer.} \else \ClassError{syllabus}{#1 is not an integer}{} \fi
}

\def\PgInfo@write#1{%
	\begingroup \edef\reserved@a{\write\@mainaux{\string\PgInfo{#1}{\noexpand\thepage}}} \reserved@a \endgroup
}
\def\PgInfo#1#2{\expandafter\gdef\csname course@sem\lsem @\romannumeral#1@pgnum\endcsname{#2}}
\def\PgInfo@get#1{\csname course@sem\lsem @\romannumeral#1@pgnum\endcsname}

\newtoks\pageinfo@commands%

% --- Page styles moved up from \AtEndDocument so they're available
%     as soon as the class loads (needed for front/back matter that
%     is now typeset via \AtBeginDocument / \AtEndDocument hooks below) ---
\fancypagestyle{mplain}{%%
	\fancyhf{}%%
	\renewcommand{\headrulewidth}{0pt}%%
	\renewcommand{\footrulewidth}{0.2pt}%%
	\pagenumbering{arabic}
	\setcounter{page}{1}
	\setcounter{section}{0}
	\renewcommand{\thesection}{\arabic{section}}
	\fancyfoot[L] {\@departmentLF}%%
	\fancyfoot[R] {\thepage}%%
	\fancyhead[L] {%%
		\begin{minipage}{0.35\textwidth}
			\vspace{-4em}
			\includegraphics[width=0.7\textwidth]{./Images/LogoL}%%
		\end{minipage}%%
	}%%
	\fancyhead[R] {%%
		\begin{minipage}{0.65\textwidth}
			\vspace{-4em}
			\raggedleft\includegraphics[width=5cm]{./Images/LogoR}%%
		\end{minipage}%%
	}%%
}

\fancypagestyle{emptypg}{%%
	\fancyhf{}%%
	\renewcommand{\headrulewidth}{0.2pt}%%
	\renewcommand{\footrulewidth}{0.2pt}%%
	\fancyfoot[R] {}%%
	\fancyhead[C] {RV College of Engineering\textsuperscript{\small\textregistered}, Bengaluru - 560059}%%
}

\fancypagestyle{fplain}{%%
	\fancyhf{}%%
	\renewcommand{\headrulewidth}{0pt}%%
	\renewcommand{\footrulewidth}{0pt}%% <--- Disables the portrait footer line
	\setcounter{page}{1}
	\pagenumbering{roman}
	\fancyfoot[R]{%% <--- Anchors at the bottom-right of the portrait page
		\smash{\raisebox{\dimexpr 0.5\textheight \relax}{%% <--- Shifts to vertical center
				\rlap{%% 
					\hspace{0.2in}%% 
					\rule[-0.5\textheight]{0.2pt}{1.45\textheight}%% 
					\hspace{0.15in}%% 
					\raisebox{0.225\textheight}{\rotatebox[origin=c]{90}{\thepage}}%% 
				}%%
		}}%%
	}%%
}

% --- Customizable hook: runs after the generated tables, before WKs.
%     Redefine this in Main.tex, e.g.:
%       \renewcommand{\aftertables}{\input{FlowChartInsert}}
\newcommand{\aftertables}{}

% --- Front matter: runs at \begin{document}, before any other body
%     content, so it truly lands first in the output ---
\AtBeginDocument{%
	\ifstandalone\else
		\includepdf[pages=-]{FrontCover}
		\pagestyle{mplain}
		\input{Abbreviations}
		\input{PGPrograms}
		\input{DeptVisionMission}
	\fi
} 
\newenvironment{semester}[1]{%
	\xdef\sem{#1}% 
	\addtocounter{numof@semesters}{1}
	\setcounter{numof@courses}{0}
	% --- FIX: these must restart at 1 for EACH semester, since the print
	%     loop (\syllabus@group@toc@loop) looks up semester@sem<N>@eg@i@...,
	%     @eg@ii@..., etc. starting from 1 for every semester. Without this
	%     reset, a second \begin{electivegroup} anywhere later in the WHOLE
	%     document (even in a different semester) keeps incrementing this
	%     counter, so its data gets stored under the wrong (too-high) index
	%     and the per-semester print loop never finds it. ---
	\setcounter{eg@id}{0}%
	\setcounter{ae@id}{0}%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@\roman{numof@semesters}@val}{#1}}
	\fi
	\newenvironment{definecourse}[1]{%
		\addtocounter{numof@courses}{1}
		% --- THE FIX: FORCE UPPERCASE FOR ALL COURSE CODES ---
		\protected@edef\temp@code{##1}%
		\expandafter\uppercase\expandafter{\expandafter\gdef\expandafter\course@code\expandafter{\temp@code}}%
		% -----------------------------------------------------
		\practiceelfalse
		\gdef\temp@category{}%
		\gdef\temp@commonto{}%
		\gdef\temp@stream{}%
		\gdef\temp@bos{}% 
		\def\category####1{\gdef\temp@category{####1}}%
		\def\commonto####1{\gdef\temp@commonto{####1}}%
		\def\stream####1{\gdef\temp@stream{####1}}%
		\def\bos####1{\gdef\temp@bos{####1}}% 
		\def\coursetitle{\process@course}
		\def\process@course{%
			\ifhmode\unskip\unskip \par\fi
			\@docourse
		}
	}
	{
		\edef\@tempa{\temp@category}\def\@tempb{}%
		\ifx\@tempa\@tempb \gdef\final@cat{Category: Professional Core Course}\else
		\def\@tempb{AC}\ifx\@tempa\@tempb \gdef\final@cat{Category: Applied Science Course}\else
		\def\@tempb{BC}\ifx\@tempa\@tempb \gdef\final@cat{Category: Bridge Course}\else
		\def\@tempb{ES}\ifx\@tempa\@tempb \gdef\final@cat{Category: Emerging Science Course}\else
		\def\@tempb{ET}\ifx\@tempa\@tempb \gdef\final@cat{Category: Emerging Technology Course}\else
		\def\@tempb{HS}\ifx\@tempa\@tempb \gdef\final@cat{Category: Humanities and Social Sciences}\else
		\def\@tempb{IE}\ifx\@tempa\@tempb \gdef\final@cat{Category: Institutional Elective}\else
		\def\@tempb{IEC}\ifx\@tempa\@tempb \gdef\final@cat{Category:  Interdisciplinary Elective Course}\else
		\def\@tempb{PC}\ifx\@tempa\@tempb \gdef\final@cat{Category: Professional Core Course}\else
		\def\@tempb{PE}\ifx\@tempa\@tempb \gdef\final@cat{Category: Professional Core Elective}\else
		\def\@tempb{PL}\ifx\@tempa\@tempb \gdef\final@cat{Category: Programming Language Course}\else
		\def\@tempb{SL}\ifx\@tempa\@tempb \gdef\final@cat{Category: Skill Lab}\else
		\gdef\final@cat{Category: \temp@category}\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi
		
		\edef\@tempa{\temp@commonto}\def\@tempb{}%
		\ifx\@tempa\@tempb \gdef\final@com{}\else
		\gdef\final@com{ (\temp@commonto)}\fi
		
		\edef\@tempsem{\sem}% 
		\def\@semone{1}\def\@semtwo{2}%
		\gdef\final@str{}% Default to entirely empty for Semesters > 2
		
		\ifx\@tempsem\@semone \def\@validsem{1}\else
		\ifx\@tempsem\@semtwo \def\@validsem{1}\else
		\def\@validsem{0}\fi\fi
		
		\ifnum\@validsem=1\relax
		\edef\@tempa{\temp@stream}\def\@tempb{}%
		\ifx\@tempa\@tempb \gdef\final@str{}\else 
		\def\@tempb{CS}\ifx\@tempa\@tempb \gdef\final@str{CS}\else
		\def\@tempb{EC}\ifx\@tempa\@tempb \gdef\final@str{EC}\else
		\def\@tempb{ME}\ifx\@tempa\@tempb \gdef\final@str{ME}\else
		\def\@tempb{CV}\ifx\@tempa\@tempb \gdef\final@str{CV}\else
		\gdef\final@str{\temp@stream}\fi\fi\fi\fi\fi 
		\fi
		
		\if@filesw
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@category}{\final@cat}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@commonto}{\final@com}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@stream}{\final@str}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@bos}{\temp@bos}}%
		\fi
		
		% --- THE FIX: SHARED BYPASS FLAG ---
		\def\@skipcoursegen{0}%
		\ifincoregroupstar \def\@skipcoursegen{1} \fi
		\ifinskgroup \def\@skipcoursegen{1} \fi
		
		\ifnum\@skipcoursegen=1\relax
		\if@filesw
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@isstar}{true}}%
		\fi
		\else
		\if@filesw
		\immediate\write\@mainaux{\string\global\string\@namedef{course@originsem@\course@code}{\sem}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@origincidx@\course@code}{\romannumeral\value{numof@courses}}}%
		\fi
		
		\IfFileExists{\course@code.tex}{
		}{
			\expandafter\immediate\openout\coursefile=\course@code.tex
			\immediate\write\coursefile{\@percentchar\@percentchar\@percentchar\@percentchar\space\string You're NOT allowed to touch this part of the code \@percentchar\@percentchar\@percentchar\@percentchar}
			\immediate\write\coursefile{\string\ifdefined\string\ismaindoc}
			\immediate\write\coursefile{\space\string\providecommand{\string\inbpdocument}{}}
			\immediate\write\coursefile{\space\string\providecommand{\string\outbpdocument}{}}
			\immediate\write\coursefile{\string\else}
			\immediate\write\coursefile{\space\string\documentclass{syllabus}}
			\immediate\write\coursefile{\space\string\initstandalone{\sem}{\arabic{numof@courses}}} 
			\immediate\write\coursefile{\space\string\fi}
			\immediate\write\coursefile{\space}
			\immediate\write\coursefile{\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\space\string End of Non-touch zone \@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar\@percentchar}
			\immediate\write\coursefile{\space\string\inbpdocument}
			\immediate\write\coursefile{\@percentchar\@percentchar\@percentchar\@percentchar\space\string You can enter the data in the appropriate commands \@percentchar\@percentchar\@percentchar\@percentchar}
			\immediate\write\coursefile{\space}
			\immediate\write\coursefile{\string\begin{course}{\sem}{\arabic{numof@courses}}} 
				\immediate\write\coursefile{ \@percentchar\string\prerequisites{}}
				\immediate\write\coursefile{ \@percentchar\string\SLduration{}}
				\iflecture
				\ifx\course@basetype\NPTEL
				\immediate\write\coursefile{\space\string\begin{weeks}}
					\immediate\write\coursefile{\space\space\string\week{Content for week 1}}
					\immediate\write\coursefile{\space\space\string\week{Content for week 2}}
				\immediate\write\coursefile{\space\string\end{weeks}}
				\else\ifx\course@basetype\Proj
				\immediate\write\coursefile{\space\string\begin{guidelines}}
					\immediate\write\coursefile{\space\space\string\guideline{Sample guideline point 1}}
					\immediate\write\coursefile{\space\space\string\guideline{Sample guideline point 2}}
				\immediate\write\coursefile{\space\string\end{guidelines}}
				\else
				\immediate\write\coursefile{\space\string\begin{units}}
					\immediate\write\coursefile{\space\space\string\unit[4]{sample}}
				\immediate\write\coursefile{\space\string\end{units}}
				\fi\fi
				\fi
				\ifpractice
				\immediate\write\coursefile{\space\string\begin{practicals}}
					\immediate\write\coursefile{\space\space\string\practicetitle{Hardware experiments}}
					\immediate\write\coursefile{\space\space\string\practiceinstruction{Here you can put your instructions here. If you don't want this instruction, simply comment this line.}}
					\immediate\write\coursefile{\space\space\string\experiment{Design}}
					\immediate\write\coursefile{\space\space\string\practiceeltitle{Innovative Experiments}}
					\immediate\write\coursefile{\space\space\string\experiment[EL]{For EL experiment}}
					\immediate\write\coursefile{\space\string\end{practicals}}
				\fi
				\immediate\write\coursefile{\space\string\begin{courseoutcomes}}
					\immediate\write\coursefile{\space\space\string\co{sample}}
					\immediate\write\coursefile{\space\string\end{courseoutcomes}}
				\immediate\write\coursefile{\space\string\begin{references}}
					\immediate\write\coursefile{ \@percentchar\string Add citation key defined in reference.bib file in the current directory}
					\immediate\write\coursefile{\space\space\string\reference{Razavi2000}}
					\immediate\write\coursefile{\space\string\end{references}}
				\immediate\write\coursefile{\string\end{course}}
			\immediate\write\coursefile{\space}
			
			\ifdefined\course@basetype
			\edef\cfulltype{\course@basetype\course@variant}%
			\immediate\write\coursefile{\space}%
			\@ifundefined{master@\cfulltype @GL@totalcount}{%
			}{%
				\immediate\write\coursefile{ \@percentchar\@percentchar\space --- Editable Guidelines ---}%
				\setcounter{temp@counter}{1}%
				\edef\maxglfileout{\@nameuse{master@\cfulltype @GL@totalcount}}%
				\@whilenum\value{temp@counter}<\numexpr\maxglfileout+1\relax\do{%
					\edef\AlphCount{\Alph{temp@counter}}%
					\immediate\write\coursefile{\string\GLoverride\AlphCount{%
							\@nameuse{master@\cfulltype @GL@\AlphCount @text}}}%
					\stepcounter{temp@counter}%
				}%
				\immediate\write\coursefile{ \@percentchar\@percentchar\space --- End Editable Guidelines ---}%
				\immediate\write\coursefile{\space}%
			}%
			\immediate\write\coursefile{ \@percentchar\@percentchar\space --- Editable CIE Rubrics ---}%
			\@ifundefined{master@\cfulltype @CIE@totalcount}{%
				\immediate\write\coursefile{ \@percentchar\space No CIE rubrics found for \cfulltype}%
			}{%
				\setcounter{temp@counter}{1}%
				\edef\maxfileout{\@nameuse{master@\cfulltype @CIE@totalcount}}%
				\@whilenum\value{temp@counter}<\numexpr\maxfileout+1\relax\do{%
					\edef\AlphCount{\Alph{temp@counter}}%
					\immediate\write\coursefile{\string\CIErubric\AlphCount{%
							\@nameuse{master@\cfulltype @CIE@\AlphCount @text}}}%
					\stepcounter{temp@counter}%
				}%
			}%
			\fi
			
			\immediate\write\coursefile{\space\string\outbpdocument}
			\immediate\closeout\coursefile
			
			% --- AUTO-GENERATE MISSING .BIB FILES ---
			\IfFileExists{\course@code.bib}{
			}{
				\begingroup
				\newlinechar=`\^^J
				\immediate\openout\coursefile=\course@code.bib
				\immediate\write\coursefile{%
					@Book\string{Razavi2000,^^J%
						author = \string{Behzad Razavi\string},^^J%
						title = \string{Design of Analog CMOS Integrated Circuits\string},^^J%
						year = \string{2000\string},^^J%
						publisher = \string{McGraw-Hill Education\string},^^J%
						isbn = \string{978-0072380323\string},^^J%
						\string}}%
				\immediate\closeout\coursefile
				\endgroup
			}
			\ClassWarningNoLine{syllabus}{Created template file \course@code.tex. Edit and rerun.}%
			\syllabus@readyfalse
		}
		\fi
		
		\ifincoregroup
		\def\emptyVal{}%
		\ifx\temp@bos\emptyVal \@ifundefined{@departmentSF}{\def\safe@bos{ECE}}{\edef\safe@bos{\@departmentSF}}\else\edef\safe@bos{\temp@bos}\fi
		
		\ifincoregroupstar
		\edef\origsem{\@ifundefined{course@originsem@\course@code}{1}{\@nameuse{course@originsem@\course@code}}}%
		\edef\origcidx{\@ifundefined{course@origincidx@\course@code}{i}{\@nameuse{course@origincidx@\course@code}}}%
		\edef\newpageval{\noexpand\hyperlink{course\origsem\origcidx}{\noexpand\PgnumOrig{\origsem}{\origcidx}}}%
		\else
		\edef\newpageval{\noexpand\hyperlink{course\sem\romannumeral\value{numof@courses}}{\noexpand\Pgnum{\arabic{numof@courses}}}}%
		\fi
		
		\ifnum\core@leader@index=0\relax
		\xdef\core@leader@index{\arabic{numof@courses}}%
		\xdef\core@acc@codes{\noexpand\MakeTextUppercase{\unexpanded\expandafter{\course@code}}}%
		\xdef\core@acc@titles{\unexpanded\expandafter{\current@course@title}}%
		\xdef\core@acc@boses{\unexpanded\expandafter{\safe@bos}}%
		\xdef\core@acc@pages{\noexpand\hyperlink{course\sem\romannumeral\value{numof@courses}}{\noexpand\Pgnum{\arabic{numof@courses}}}}%
		\if@filesw \immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@role}{leader}}\fi
		\else
		\xdef\core@acc@codes{\unexpanded\expandafter{\core@acc@codes}\space / \noexpand\newline \noexpand\MakeTextUppercase{\unexpanded\expandafter{\course@code}}}%
		\xdef\core@acc@titles{\unexpanded\expandafter{\core@acc@titles}\space / \noexpand\newline \unexpanded\expandafter{\current@course@title}}%
		\xdef\core@acc@boses{\unexpanded\expandafter{\core@acc@boses}\space / \noexpand\newline \unexpanded\expandafter{\safe@bos}}%
		\xdef\core@acc@pages{\unexpanded\expandafter{\core@acc@pages}\space / \noexpand\newline \noexpand\hyperlink{course\sem\romannumeral\value{numof@courses}}{\noexpand\Pgnum{\arabic{numof@courses}}}}%
		\if@filesw \immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@role}{follower}}\fi
		\fi
		\fi
		
		\ifinelectivegroup
		\stepcounter{eg@course@id}%
		\ifnum\value{eg@course@id}=1\relax
		
		\if@filesw 
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@role}{egleader}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@codes}{\eg@common@code}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@titles}{\eg@common@title}}%
		\def\emptyVal{}%
		\ifx\temp@bos\emptyVal \@ifundefined{@departmentSF}{\def\safe@bos{ECE}}{\edef\safe@bos{\@departmentSF}}\else\edef\safe@bos{\temp@bos}\fi
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@boses}{\safe@bos}}%
		\fi
		\else
		
		\if@filesw \immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@role}{follower}}\fi
		\fi
		
		
		\if@filesw
		\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @eg@\roman{eg@id}@course@\romannumeral\value{eg@course@id}@code}{\noexpand\MakeTextUppercase{\unexpanded\expandafter{\course@code}}}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @eg@\roman{eg@id}@course@\romannumeral\value{eg@course@id}@title}{\unexpanded\expandafter{\current@course@title}}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @eg@\roman{eg@id}@course@\romannumeral\value{eg@course@id}@page}{\noexpand\hyperlink{course\sem\romannumeral\value{numof@courses}}{\noexpand\Pgnum{\arabic{numof@courses}}}}}%
		\fi
		\fi
		
		\ifinaegroup
		\stepcounter{ae@course@id}%
		\ifnum\value{ae@course@id}=1\relax
		\if@filesw 
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@role}{egleader}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@codes}{\ae@common@code}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@titles}{AE Course}}%
		\def\emptyVal{}%
		\ifx\temp@bos\emptyVal \@ifundefined{@departmentSF}{\def\safe@bos{ECE}}{\edef\safe@bos{\@departmentSF}}\else\edef\safe@bos{\temp@bos}\fi
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@boses}{\safe@bos}}%
		\fi
		\else
		% Subsequent courses are hidden from Pages 1 and 2
		\if@filesw \immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@role}{follower}}\fi
		\fi
		
		% Write every course data for the Page 3 Group Table
		\if@filesw
		\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @ae@\roman{ae@id}@course@\romannumeral\value{ae@course@id}@code}{\noexpand\MakeTextUppercase{\unexpanded\expandafter{\course@code}}}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @ae@\roman{ae@id}@course@\romannumeral\value{ae@course@id}@title}{\unexpanded\expandafter{\current@course@title}}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @ae@\roman{ae@id}@course@\romannumeral\value{ae@course@id}@page}{\noexpand\hyperlink{course\sem\romannumeral\value{numof@courses}}{\noexpand\Pgnum{\arabic{numof@courses}}}}}%
		\fi
		\fi
		
		% --- NEW: SKGROUP LOGIC INJECTION WITH NEW ROLES ---
		\ifinskgroup
		\stepcounter{sk@course@id}%
		\ifnum\value{sk@course@id}=1\relax
		\if@filesw 
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@role}{skleader}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@codes}{\sk@common@code}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@titles}{Skill Lab Courses}}%
		\def\emptyVal{}%
		\ifx\temp@bos\emptyVal \@ifundefined{@departmentSF}{\def\safe@bos{ECE}}{\edef\safe@bos{\temp@bos}}\else\edef\safe@bos{\temp@bos}\fi
		\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@boses}{\safe@bos}}%
		\fi
		\else
		\if@filesw \immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@cg@role}{skfollower}}\fi
		\fi
		\fi
		% ------------------------------------
		
	} % <--- The closing brace of definecourse
}
{
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @numofcourses}{\arabic{numof@courses}}}% 
	\fi
}


\newcounter{courseindex}

\newtoks\unittok

\DeclareDocumentEnvironment{units}{}{%
	\global\lecturetrue
	\setcounter{numof@lectureunits}{0}%
	\global\unittok={}% 
}{%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@allunits}{\unexpanded\expandafter{\the\unittok}}}%
	\fi
}

\DeclareDocumentCommand{\unit}{ O{} m }{%
	\stepcounter{numof@lectureunits}%
	\edef\romunit{\MakeTextUppercase{\romannumeral\value{numof@lectureunits}}}%
	\def\temphrs{#1}\def\emptyhrs{}%
	\ifx\temphrs\emptyhrs\def\hrs{0}\else\def\hrs{#1}\fi
	
	\edef\tempadd{%
		\noexpand\hline
		\noexpand\multicolumn{6}{|p{\dimexpr 0.61\textwidth + 10\tabcolsep + 5\arrayrulewidth \relax}|}{\noexpand\centering\noexpand\textbf{Unit - \romunit}} & \noexpand\textbf{\hrs\noexpand\quad Hours} \noexpand\\
		\noexpand\hline
		\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{%
			\noexpand\begin{minipage}[t]{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}%
				\noexpand\setlist[itemize]{topsep=4pt,itemsep=0.125em}%
				\unexpanded{#2}% 
				\noexpand\vspace*{0.5ex}%
				\noexpand\end{minipage}%
		} \noexpand\\
	}%
	\global\unittok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\unittok\tempadd}%
}

% --- WEEKS / \week: an NPTEL-style content block, parallel to units/\unit
%     but numbered "Week N" and with no Hours column. It writes into the
%     SAME @allunits aux key that units/\unit uses, so \xpandtable's
%     existing \cAllUnits retrieval/printing logic needs no changes.
\DeclareDocumentEnvironment{weeks}{}{%
	\global\lecturetrue
	\setcounter{numof@lectureunits}{0}%
	\global\unittok={}% 
}{%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@allunits}{\unexpanded\expandafter{\the\unittok}}}%
	\fi
}

\DeclareDocumentCommand{\week}{ m }{%
	\stepcounter{numof@lectureunits}%
	\edef\tempadd{%
		\noexpand\hline
		\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\noexpand\centering\noexpand\textbf{Week \arabic{numof@lectureunits}}} \noexpand\\
		\noexpand\hline
		\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{%
			\noexpand\begin{minipage}[t]{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}%
				\noexpand\setlist[itemize]{topsep=4pt,itemsep=0.125em}%
				\unexpanded{#1}% 
				\noexpand\vspace*{0.5ex}%
				\noexpand\end{minipage}%
		} \noexpand\\
	}%
	\global\unittok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\unittok\tempadd}%
}

% --- GUIDELINES / \guideline: a Proj-type content block, parallel to
%     units/\unit and weeks/\week. Prints a single "Guidelines" header row,
%     followed by each guideline point as a numbered row (no per-point
%     sub-header, no rule between points). It writes into the SAME
%     @allunits aux key that units/\unit uses, so \xpandtable's existing
%     \cAllUnits retrieval/printing logic needs no changes. \guideline is
%     only redefined for the duration of this environment (LaTeX groups
%     environment bodies), so the \guideline{} command used inside
%     \begin{credit}{...} definitions in CreditDefinitions.tex, and its
%     plain default meaning elsewhere, are both left untouched outside
%     \begin{guidelines}.
\DeclareDocumentEnvironment{guidelines}{}{%
	\global\lecturetrue
	\setcounter{numof@lectureunits}{0}%
	\global\unittok={}% 
	\def\guideline##1{%
		\stepcounter{numof@lectureunits}%
		\ifnum\value{numof@lectureunits}=1
			\edef\tempheader{%
				\noexpand\hline
				\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\noexpand\textbf{\noexpand\space Guidelines}} \noexpand\\
				\noexpand\hline
			}%
			\global\unittok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\unittok\tempheader}%
		\fi
		\edef\tempadd{%
			\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{%
				\noexpand\hangindent2em\noexpand\hangafter1
				\noexpand\makebox[2em][l]{\arabic{numof@lectureunits}.}\unexpanded{##1}%
			} \noexpand\\
		}%
		\global\unittok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\unittok\tempadd}%
	}%
}{%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@allunits}{\unexpanded\expandafter{\the\unittok}}}%
	\fi
}

\newcounter{prac@item@ctr}
\newcounter{prac@sub@ctr}
\newtoks\practok 

\def\practicetitle#1{%
	\edef\temprow{\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\noexpand\textbf{#1}} \noexpand\\}%
	\global\practok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\practok\temprow}%
}
\def\practiceeltitle#1{%
	\edef\temprow{\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\noexpand\textbf{#1}} \noexpand\\}%
	\global\practok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\practok\temprow}%
}
\def\practiceinstruction#1{%
	\edef\temprow{\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\unexpanded{#1}} \noexpand\\}%
	\global\practok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\practok\temprow}%
}

\def\experiment{\@ifnextchar[{\@expw}{\@expno}}
\def\@expw[#1]#2{%
	\stepcounter{prac@item@ctr}%
	\edef\temprow{\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\noexpand\hangindent=1.5em \noexpand\hangafter=1 \noexpand\noindent\noexpand\makebox[5.1em][r]{\noexpand\textbf{#1}\space\arabic{prac@item@ctr}:}\noexpand\hspace{0.4em}\unexpanded{#2}} \noexpand\\}%
	\global\practok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\practok\temprow}%
}
\def\@expno#1{%
	\stepcounter{prac@item@ctr}%
	\edef\temprow{\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\noexpand\hangindent=1.5em \noexpand\hangafter=1 \noexpand\noindent\noexpand\makebox[1.1em][r]{\arabic{prac@item@ctr}.}\noexpand\hspace{0.4em}\unexpanded{#1}} \noexpand\\}%
	\global\practok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\practok\temprow}%
}

\def\subexperiment{\@ifnextchar[{\@subexpw}{\@subexpno}}
\def\@subexpw[#1]#2{%
	\stepcounter{prac@sub@ctr}%
	\edef\temprow{\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\noexpand\hangindent=2.6em \noexpand\hangafter=1 \noexpand\noindent\noexpand\hspace*{1.1em}\noexpand\makebox[1.1em][r]{\alph{prac@sub@ctr})}\noexpand\hspace{0.4em}\noexpand\textbf{[#1]} \unexpanded{#2}} \noexpand\\}%
	\global\practok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\practok\temprow}%
}
\def\@subexpno#1{%
	\stepcounter{prac@sub@ctr}%
	\edef\temprow{\noexpand\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\noexpand\hangindent=2.6em \noexpand\hangafter=1 \noexpand\noindent\noexpand\hspace*{1.1em}\noexpand\makebox[1.1em][r]{\alph{prac@sub@ctr})}\noexpand\hspace{0.4em}\unexpanded{#1}} \noexpand\\}%
	\global\practok=\expandafter\expandafter\expandafter{\expandafter\the\expandafter\practok\temprow}%
}

\DeclareDocumentEnvironment{practicals}{}{%
	\global\practicetrue
	\setcounter{numof@practiceunits}{1}%
	\setcounter{prac@item@ctr}{0}%
	\global\practok={}%
}{%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@allpracticals}{\unexpanded\expandafter{\the\practok}}}%
	\fi
}

\DeclareDocumentEnvironment{subpracticals}{}{%
	\setcounter{prac@sub@ctr}{0}%
}{}

\newcommand*{\SLduration}[1]{%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@Sdur}{#1}}%
}

\newenvironment{course}[2]{% 
	\gdef\c@sem{#1}% 
	\setcounter{courseindex}{#2}%
	\global\prerequisitefalse
	\gdef\captured@prerequest{}
	\setcounter{numof@lectureunits}{0}
	\setcounter{numof@practiceunits}{0}
	\setcounter{numof@practiceelunits}{0}
	\setcounter{numof@cos}{0}
	\setcounter{numof@refs}{0}
	
	\def\category##1{\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\romannumeral\value{courseindex}@category}{##1}}}%
	\newcommand*{\commonto}[1]{\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\romannumeral\value{courseindex}@commonto}{##1}}}%
	\newcommand*{\stream}[1]{\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\romannumeral\value{courseindex}@stream}{##1}}}%
	
	\newcommand*{\ciemarks}[1]{}%
	\newcommand*{\seemarks}[1]{}%
	\newcommand*{\seeduration}[1]{}% 
	\newcommand*{\totalhours}[1]{}%
	
	\newcommand*{\prerequisites}[1]{%
		\def\@temp{##1}%
		\def\@spaces{ }%
		\ifx\@temp\@empty
		\global\prerequisitefalse
		\else\ifx\@temp\@spaces
		\global\prerequisitefalse
		\else
		\global\prerequisitetrue
		\gdef\@prerequisites{##1}% <-- Just saves the raw text for the .aux file!
		\fi\fi
	}
	\newenvironment{courseoutcomes}{%
		\def\co{\ifhmode\unskip\unskip \par\fi \@doco}%
	}{}
	\newenvironment{references}{%
		\def\reference{\ifhmode\unskip\unskip \par\fi \@doref}%
	}{}
}
{
	\ifprerequisite\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@prerequisites}{\@prerequisites}}\fi
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@numoflectureunits}{\arabic{numof@lectureunits}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@numofpracticeunits}{\arabic{numof@practiceunits}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@numofpracticeelunits}{\arabic{numof@practiceelunits}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@numofcourseoutcomes}{\arabic{numof@cos}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@numofreferences}{\arabic{numof@refs}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@pgnum}{\thepage}}%
}


\newcounter{coregroup@id}
\newcounter{toc@print@ctr}
\newcounter{main@print@ctr}
\newif\ifincoregroup
\incoregroupfalse
\newif\ifincoregroupstar
\incoregroupstarfalse
\gdef\core@leader@index{0}

\newenvironment{coregroup}{%
	\incoregrouptrue
	\stepcounter{coregroup@id}%
	\gdef\core@acc@codes{}%
	\gdef\core@acc@titles{}%
	\gdef\core@acc@boses{}%
	\gdef\core@acc@pages{}%
	\gdef\core@leader@index{0}%
}{%
	\incoregroupfalse
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\core@leader@index @cg@codes}{\unexpanded\expandafter{\core@acc@codes}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\core@leader@index @cg@titles}{\unexpanded\expandafter{\core@acc@titles}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\core@leader@index @cg@boses}{\unexpanded\expandafter{\core@acc@boses}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\core@leader@index @cg@pages}{\unexpanded\expandafter{\core@acc@pages}}}%
	\fi
}

\newenvironment{coregroup*}{%
	\incoregrouptrue
	\incoregroupstartrue
	\stepcounter{coregroup@id}%
	\gdef\core@acc@codes{}%
	\gdef\core@acc@titles{}%
	\gdef\core@acc@boses{}%
	\gdef\core@acc@pages{}%
	\gdef\core@leader@index{0}%
}{%
	\incoregroupfalse
	\incoregroupstarfalse
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\core@leader@index @cg@codes}{\unexpanded\expandafter{\core@acc@codes}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\core@leader@index @cg@titles}{\unexpanded\expandafter{\core@acc@titles}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\core@leader@index @cg@boses}{\unexpanded\expandafter{\core@acc@boses}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\core@leader@index @cg@pages}{\unexpanded\expandafter{\core@acc@pages}}}%
	\fi
}

\newcounter{eg@id}
\newcounter{eg@course@id}
\newif\ifinelectivegroup
\inelectivegroupfalse

\newenvironment{electivegroup}[3]{%
	\inelectivegrouptrue
	\stepcounter{eg@id}%
	\setcounter{eg@course@id}{0}%
	\gdef\eg@common@code{#1}%
	\gdef\eg@common@title{#2}%
	\gdef\eg@letter{#3}%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @eg@\roman{eg@id}@code}{#1}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @eg@\roman{eg@id}@title}{#2}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @eg@\roman{eg@id}@letter}{#3}}%
	\fi
}{%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @eg@\roman{eg@id}@count}{\arabic{eg@course@id}}}%
	\fi
	\inelectivegroupfalse
}

\newcounter{ae@id}
\newcounter{ae@course@id}
\newif\ifinaegroup
\inaegroupfalse

\newenvironment{aegroup}[1]{%
	\inaegrouptrue
	\stepcounter{ae@id}%
	\setcounter{ae@course@id}{0}%
	\gdef\ae@common@code{#1}%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @ae@\roman{ae@id}@code}{#1}}%
	\fi
}{%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @ae@\roman{ae@id}@count}{\arabic{ae@course@id}}}%
	\fi
	\inaegroupfalse
}

% ==========================================
% MUTUAL EXCLUSION & SKILL LABS ARCHITECTURE
% ==========================================

\newcounter{sklab@print@ctr}
\gdef\sklabtablecontent{}

% --- MUTUAL EXCLUSION FLAGS ---
\newif\if@sklabs@used
\global\@sklabs@usedfalse
\newif\if@skgroup@used
\global\@skgroup@usedfalse

% --- 1. SKLABS ENVIRONMENT ---
\DeclareDocumentEnvironment{sklabs}{}{%
	\if@skgroup@used
	\ClassError{syllabus}{'sklabs' and 'skgroup' are mutually exclusive!}{}%
	\fi
	\global\@sklabs@usedtrue
	
	% ISOLATION FIX: Save the global TOC loops before Semester 0 injects itself
	\let\orig@toc@loop\syllabus@toc@loop
	\let\orig@group@toc@loop\syllabus@group@toc@loop
	
	% Open the semester to inherit the local course commands
	\begin{semester}{0}%
		
		% ISOLATION FIX: Globally restore the TOC loops, instantly erasing the ghost table!
		\global\let\syllabus@toc@loop\orig@toc@loop
		\global\let\syllabus@group@toc@loop\orig@group@toc@loop
		
		% Reset the course index
		\setcounter{courseindex}{0}% 
		
		% Safely hook the END of the course to force SK and PO
		\let\orig@enddefinecourse\enddefinecourse
		\def\enddefinecourse{%
			\edef\croman{\romannumeral\value{courseindex}}%
			\if@filesw
			\immediate\write\@mainaux{\string\global\string\@namedef{course@sem0@\croman @category}{SK}}%
			\immediate\write\@mainaux{\string\global\string\@namedef{course@sem0@\croman @coursetype}{PO}}%
			\fi
			\global\@namedef{course@sem0@\croman @category}{SK}%
			\global\@namedef{course@sem0@\croman @coursetype}{PO}%
			\orig@enddefinecourse
		}%
		
		% Collect the instruction and write it globally to the .aux file
		\def\sklabfootnote##1{%
			\if@filesw
			\immediate\write\@mainaux{\string\gdef\string\global@sklabinstruction{\unexpanded{##1}}}%
			\fi
		}%
	}{%
	\end{semester}%
}

% --- 2. SKGROUP ENVIRONMENT ---
\newcounter{sk@id}
\newcounter{sk@course@id}
\newif\ifinskgroup
\inskgroupfalse

\DeclareDocumentEnvironment{skgroup}{ m }{%
	\if@sklabs@used
	\ClassError{syllabus}{'sklabs' and 'skgroup' are mutually exclusive!}{}%
	\fi
	\ifnum\sem=8\relax\else
	\ClassError{syllabus}{'skgroup' is only permitted in the 8th semester!}{}%
	\fi
	\global\@skgroup@usedtrue
	\inskgrouptrue
	
	\stepcounter{sk@id}%
	\setcounter{sk@course@id}{0}%
	\gdef\sk@common@code{#1}%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @sk@\roman{sk@id}@code}{#1}}%
	\fi
}{%
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{semester@sem\sem @sk@\roman{sk@id}@count}{\arabic{sk@course@id}}}%
	\fi
	\inskgroupfalse
}

% --- 3. SAFE TOKEN-REGISTER SKILL LABS TOC LOOP ---
\newcounter{sklab@toc@ctr}
\gdef\sklabtablecontent{} % Global container to hold the rows

\def\sklabtocloop{%
	\stepcounter{sklab@toc@ctr}%
	\edef\croman{\romannumeral\value{sklab@toc@ctr}}%
	
	% Check if the course exists in memory
	\@ifundefined{course@sem0@\croman @coursecode}{}{%
		
		% Safely extract the exact text into temporary macros so they aren't empty
		\expandafter\let\expandafter\rawccode\csname course@sem0@\croman @coursecode\endcsname
		\expandafter\let\expandafter\ctitle\csname course@sem0@\croman @coursetitle\endcsname
		
		% Append the new row to our global container
		\toks0=\expandafter{\sklabtablecontent}%
		\toks1=\expandafter{\rawccode}%
		\toks2=\expandafter{\ctitle}%
		
		\edef\temp{\the\toks0 \arabic{sklab@toc@ctr} & \noexpand\MakeTextUppercase{\the\toks1} & \the\toks2 & \noexpand\pageref{course0\croman} \noexpand\\ \noexpand\hline}%
		\global\let\sklabtablecontent\temp
		
		% Recursively call for the next course
		\expandafter\sklabtocloop
	}%
}

\newcommand{\printsklabstoc}{%
	% Automatically draws the table if at least the first course ('i') is found
	\@ifundefined{course@sem0@i@coursecode}{}{%
		
		% 1. Build the rows IN THE BACKGROUND first
		\setcounter{sklab@toc@ctr}{0}%
		\gdef\sklabtablecontent{}% Clear previous data
		\sklabtocloop % Run the loop
		
		% 2. Draw the table and instantly dump the pre-built rows
		\noindent
		\begin{longtable}{|>{\centering\arraybackslash}p{0.08\linewidth}|>{\centering\arraybackslash}p{0.18\linewidth}|p{0.55\linewidth}|>{\centering\arraybackslash}p{0.12\linewidth}|}
			\hline
			\multicolumn{4}{|c|}{SKILL LABS}\\
			\hline
			\textbf{Sl.} & \textbf{Course Code} & \multicolumn{1}{c|}{\textbf{Course Title}} & \textbf{Page No.} \\ \hline
			\endfirsthead
			\hline
			\textbf{Sl.} & \textbf{Course Code} & \multicolumn{1}{c|}{\textbf{Course Title}} & \textbf{Page No.} \\ \hline
			\endhead
			\hline
			\endfoot
			
			\sklabtablecontent % Dumps exactly the completed rows. Zero invisible tokens!
			
		\end{longtable}\par
	}
}

% --- 4. PAGE GENERATOR ---
\def\sklabsprintloop{%
	\stepcounter{sklab@print@ctr}%
	\edef\croman{\romannumeral\value{sklab@print@ctr}}%
	\@ifundefined{course@sem0@\croman @coursecode}{}{% 
		\edef\course@code{\@nameuse{course@sem0@\croman @coursecode}}%
		
		\gdef\lsem{0}%
		\gdef\printsemester{0}% 
		
		% --- THE FIX: ISOLATE SKILL LAB CITATIONS ---
		\@ifundefined{c@refsection}{}{%
			\IfFileExists{\course@code.bib}{%
				\begin{refsection}[\course@code.bib]%
				}{%
					\begin{refsection}%
					}%
				}
				
			\IfFileExists{\course@code.tex}{%
				\input{\course@code.tex}%
				
				\expandafter\ifx\csname course@sem0@\croman @category\endcsname\relax
				\expandafter\gdef\csname course@sem0@\croman @category\endcsname{Category Pending}%
				\fi
				\expandafter\ifx\csname course@sem0@\croman @stream\endcsname\relax
				\expandafter\gdef\csname course@sem0@\croman @stream\endcsname{Stream Pending}%
				\fi
				\expandafter\ifx\csname course@sem0@\croman @coursetitle\endcsname\relax
				\expandafter\gdef\csname course@sem0@\croman @coursetitle\endcsname{Course Title Pending}%
				\fi
				\expandafter\ifx\csname course@sem0@\croman @commonto\endcsname\relax
				\expandafter\gdef\csname course@sem0@\croman @commonto\endcsname{Common Pending}%
				\fi
				
				\edef\lecturestatus{\@ifundefined{course@sem0@\croman @lecturestatus}{0}{\@nameuse{course@sem0@\croman @lecturestatus}}}%
				\edef\practicestatus{\@ifundefined{course@sem0@\croman @practicestatus}{0}{\@nameuse{course@sem0@\croman @practicestatus}}}%
				\edef\tutorialstatus{\@ifundefined{course@sem0@\croman @tutorialstatus}{0}{\@nameuse{course@sem0@\croman @tutorialstatus}}}%
				
				\ifnum\lecturestatus=1\relax \global\lecturetrue \else \global\lecturefalse \fi
				\ifnum\practicestatus=1\relax \global\practicetrue \else \global\practicefalse \fi
				\ifnum\tutorialstatus=1\relax \global\tutorialtrue \else \global\tutorialfalse \fi
				
				\edef\nsemester{0}%
				\edef\nlec{\@ifundefined{course@sem0@\croman @numoflectureunits}{1}{\@nameuse{course@sem0@\croman @numoflectureunits}}}%
				\edef\nprac{\@ifundefined{course@sem0@\croman @numofpracticeunits}{1}{\@nameuse{course@sem0@\croman @numofpracticeunits}}}%
				\edef\npel{\@ifundefined{course@sem0@\croman @numofpracticeelunits}{1}{\@nameuse{course@sem0@\croman @numofpracticeelunits}}}%
				\edef\nref{\@ifundefined{course@sem0@\croman @numofreferences}{1}{\@nameuse{course@sem0@\croman @numofreferences}}}%
				\edef\nco{\@ifundefined{course@sem0@\croman @numofcourseoutcomes}{1}{\@nameuse{course@sem0@\croman @numofcourseoutcomes}}}%
				
				\clearpage
				
				\xpandtable{\nsemester}{\thesklab@print@ctr}{\nlec}{\nprac}{\npel}{\nref}{\nco}%
			}{%
				\ClassWarning{syllabus}{SKILL LAB ERROR: Could not find \course@code.tex!}%
			}%
				
		% --- THE FIX: CLOSE REFSECTION ---
		\@ifundefined{c@refsection}{}{\end{refsection}}
	
		\sklabsprintloop
	}%
}

\newcommand{\printsklabspages}{%
	\@ifundefined{course@sem0@i@coursecode}{}{% 
		\setcounter{sklab@print@ctr}{0}%
		\sklabsprintloop
	}%
}

%% Credit Environment

\newif\if@in@definecredits
\@in@definecreditsfalse

\def\definecredits{\global\@in@definecreditstrue
	\gdef\global@hrspercred{30}%
	\gdef\global@wkspercred{15}%
	\gdef\global@Lcredmul{1}%
	\gdef\global@Tcredmul{2}%
	\gdef\global@Pcredmul{2}%
}
\def\enddefinecredits{\global\@in@definecreditsfalse}

\newcommand{\hrspercred}[1]{\gdef\global@hrspercred{#1}}
\newcommand{\wkspercred}[1]{\gdef\global@wkspercred{#1}}
\newcommand{\Lcredmul}[1]{\gdef\global@Lcredmul{#1}}
\newcommand{\Tcredmul}[1]{\gdef\global@Tcredmul{#1}}
\newcommand{\Pcredmul}[1]{\gdef\global@Pcredmul{#1}}

\newcounter{cie@total}
\newcounter{cie@row}
\newcounter{see@total}
\newcounter{see@row}
\newcounter{cie@theory@total}
\newcounter{cie@lab@total}
\newcounter{see@theory@total}
\newcounter{see@lab@total}
\newcounter{cred@L@tot}
\newcounter{cred@T@tot}
\newcounter{cred@P@tot}
\newcounter{master@cie@count}
\newcounter{master@seeB@count}
\newcounter{guideline@count}

\NewDocumentEnvironment{credit}{ m }{%
	\if@in@definecredits
	\begingroup
	\setcounter{cie@theory@total}{0}\setcounter{cie@lab@total}{0}%
	\setcounter{see@theory@total}{0}\setcounter{see@lab@total}{0}%
	\setcounter{cred@L@tot}{0}\setcounter{cred@T@tot}{0}\setcounter{cred@P@tot}{0}%
	\setcounter{master@cie@count}{0}%
	\setcounter{guideline@count}{0}%
	
	\gdef\temp@ciedur{---}\gdef\temp@seedur{3}%
	\gdef\temp@cielmarks{0}\gdef\temp@ciepmarks{0}%
	\gdef\temp@seelmarks{0}\gdef\temp@seepmarks{0}%
	\gdef\temp@guideline{}%
	\gdef\temp@guidelines{}%
	\gdef\temp@commoninstCIE{}%
	\gdef\temp@commoninstSEE{}%
	
	\gdef\current@cred@type{#1}%
	\gdef\current@variant{}%
	\def\variantchar##1{\gdef\current@variant{##1}}%
	\def\Lcredit##1{\setcounter{cred@L@tot}{##1}}%
	\def\Tcredit##1{\setcounter{cred@T@tot}{##1}}%
	\def\Pcredit##1{\setcounter{cred@P@tot}{##1}}%
	\def\CIEduration##1{\gdef\temp@ciedur{##1}}%
	\def\SEEduration##1{\gdef\temp@seedur{##1}}%
	\def\CIEguideline##1{\gdef\temp@guideline{\unexpanded{##1}}}%
	\def\guideline##1{%
		\stepcounter{guideline@count}%
		\edef\GLAlphCount{\Alph{guideline@count}}%
		\edef\fulltype{\current@cred@type\current@variant}%
		\global\expandafter\def\csname master@\fulltype @GL@\GLAlphCount @text\endcsname{\unexpanded{##1}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @GL@\GLAlphCount @text}{\unexpanded{##1}}}%
		\xdef\temp@guidelines{\unexpanded\expandafter{\temp@guidelines}\noexpand\GLrubric{\theguideline@count}{\unexpanded{##1}}}%
	}%
	% --- Common instruction row, inserted right after row 1 of the CIE /
	%     SEE rubric tables (see \@CIEloop and \Srubric/\SrubricB below) ---
	\def\commoninstCIE##1{\gdef\temp@commoninstCIE{\unexpanded{##1}}}%
	\def\commoninstSEE##1{\gdef\temp@commoninstSEE{\unexpanded{##1}}}%
	
	% Nullify old commands if they still exist in older tex files
	\def\LecDuration##1{}%
	\def\TutDuration##1{}%
	\def\PracDuration##1{}%
	
	\def\CIELmarks##1{\gdef\temp@cielmarks{##1}}% 
	\def\CIEPmarks##1{\gdef\temp@ciepmarks{##1}}% 
	\def\SEELmarks##1{\gdef\temp@seelmarks{##1}}% 
	\def\SEEPmarks##1{\gdef\temp@seepmarks{##1}}%
	
	\def\CIErubrics{} \def\endCIErubrics{}%
	
	\RenewDocumentCommand{\Crubric}{ O{L} m m m }{%
		\stepcounter{master@cie@count}%
		\xdef\AlphCount{\Alph{master@cie@count}}%
		\edef\fulltype{\current@cred@type\current@variant}%
		\global\expandafter\def\csname master@\fulltype @CIE@\AlphCount @qno\endcsname{##2}%
		\global\expandafter\def\csname master@\fulltype @CIE@\AlphCount @marks\endcsname{##4}%
		\global\expandafter\def\csname master@\fulltype @CIE@\AlphCount @text\endcsname{\unexpanded{##3}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @CIE@\AlphCount @qno}{##2}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @CIE@\AlphCount @marks}{##4}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @CIE@\AlphCount @text}{\unexpanded{##3}}}%
		\def\arg{##1}\def\labtype{P}%
		\ifx\arg\labtype \addtocounter{cie@lab@total}{##4}%
		\else \addtocounter{cie@theory@total}{##4}\fi
	}%
	
	\RenewDocumentEnvironment{SEE@Theory@rubrics}{ O{THEORY} }{%
		\gdef\current@SEE@arg{##1}%
		\gdef\captured@SEE{}%
		\gdef\SEE@hasPartB{0}%
		\RenewDocumentCommand{\SrubricA}{ m m m }{%
			\addtocounter{see@theory@total}{####3}%
			\xdef\captured@SEE{\unexpanded\expandafter{\captured@SEE}\noexpand\SrubricA{\unexpanded{####1}}{\unexpanded{####2}}{\unexpanded{####3}}}%
		}%
		\RenewDocumentCommand{\SrubricB}{ O{L} m m m }{%
			\def\arg{####1}\def\labtype{P}% 
			\ifx\arg\labtype \addtocounter{see@lab@total}{####4}%
			\else \addtocounter{see@theory@total}{####4}\fi
			\gdef\SEE@hasPartB{1}%
			\xdef\captured@SEE{\unexpanded\expandafter{\captured@SEE}\noexpand\SrubricB[\unexpanded{####1}]{\unexpanded{####2}}{\unexpanded{####3}}{\unexpanded{####4}}}%
		}%
	}{%
		\edef\fulltype{\current@cred@type\current@variant}%
		\global\expandafter\let\csname master@\fulltype @SEE@Theory\endcsname\captured@SEE
		\global\expandafter\let\csname master@\fulltype @SEE@Theory@Arg\endcsname\current@SEE@arg
		\global\expandafter\let\csname master@\fulltype @SEE@hasPartB\endcsname\SEE@hasPartB
		\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @SEE@Theory}{\unexpanded\expandafter{\captured@SEE}}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @SEE@Theory@Arg}{\current@SEE@arg}}%
		\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @SEE@hasPartB}{\SEE@hasPartB}}%
	}
	
	\RenewDocumentEnvironment{SEE@Practical@rubrics}{ }{%
		\gdef\captured@SEE{}%
		\gdef\SEE@hasPartB{0}%
		\RenewDocumentCommand{\Srubric}{ m m m }{%
			\addtocounter{see@lab@total}{####3}%
			\xdef\captured@SEE{\unexpanded\expandafter{\captured@SEE}\noexpand\Srubric{\unexpanded{####1}}{\unexpanded{####2}}{\unexpanded{####3}}}%
		}%
		\RenewDocumentCommand{\SrubricA}{ m m m }{%
			\addtocounter{see@theory@total}{####3}%
			\xdef\captured@SEE{\unexpanded\expandafter{\captured@SEE}\noexpand\SrubricA{\unexpanded{####1}}{\unexpanded{####2}}{\unexpanded{####3}}}%
		}%
		\RenewDocumentCommand{\SrubricB}{ O{L} m m m }{%
			\def\arg{####1}\def\labtype{P}% 
			\ifx\arg\labtype \addtocounter{see@lab@total}{####4}%
			\else \addtocounter{see@theory@total}{####4}\fi
			\gdef\SEE@hasPartB{1}%
			\xdef\captured@SEE{\unexpanded\expandafter{\captured@SEE}\noexpand\SrubricB[\unexpanded{####1}]{\unexpanded{####2}}{\unexpanded{####3}}{\unexpanded{####4}}}%
		}%
	}{%
		\edef\fulltype{\current@cred@type\current@variant}%
		\global\expandafter\let\csname master@\fulltype @SEE@Practical\endcsname\captured@SEE
		\@ifundefined{master@\fulltype @SEE@hasPartB}{%
			\global\expandafter\let\csname master@\fulltype @SEE@hasPartB\endcsname\SEE@hasPartB
			\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @SEE@hasPartB}{\SEE@hasPartB}}%
		}{}%
		\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @SEE@Practical}{\unexpanded\expandafter{\captured@SEE}}}%
	}
	\else
	\par\vspace{1em}\noindent\textbf{Course Credits \& Rubrics (#1)}\par
	\fi
	}{%
	\if@in@definecredits
	\edef\fulltype{\current@cred@type\current@variant}%
	
	% --- MATH CALCULATIONS ---
	\edef\calc@Ldur{\the\numexpr \value{cred@L@tot} * \global@Lcredmul * \global@wkspercred \relax}%
	\edef\calc@Tdur{\the\numexpr \value{cred@T@tot} * \global@Tcredmul * \global@wkspercred \relax}%
	\edef\calc@Pdur{\the\numexpr \value{cred@P@tot} * \global@Pcredmul * \global@wkspercred \relax}%
	\edef\calc@TotalCred{\the\numexpr \value{cred@L@tot} + \value{cred@T@tot} + \value{cred@P@tot} \relax}%
	\edef\calc@BaseTotDur{\the\numexpr \calc@TotalCred * \global@hrspercred \relax}%
	\edef\calc@Sdur{\the\numexpr \calc@BaseTotDur - (\calc@Ldur + \calc@Tdur + \calc@Pdur) \relax}%
	\edef\calc@TotalHrs{\the\numexpr \calc@Ldur + \calc@Tdur + \calc@Pdur + \calc@Sdur \relax}%
	
	\expandafter\xdef\csname master@\fulltype @CIE@totalcount\endcsname{\the\value{master@cie@count}}%
	\expandafter\xdef\csname master@\fulltype @GL@totalcount\endcsname{\the\value{guideline@count}}%
	\expandafter\xdef\csname type@\fulltype @L\endcsname{\the\value{cred@L@tot}}%
	\expandafter\xdef\csname type@\fulltype @T\endcsname{\the\value{cred@T@tot}}%
	\expandafter\xdef\csname type@\fulltype @P\endcsname{\the\value{cred@P@tot}}%
	
	\expandafter\xdef\csname type@\fulltype @Ldur\endcsname{\calc@Ldur}%
	\expandafter\xdef\csname type@\fulltype @Tdur\endcsname{\calc@Tdur}%
	\expandafter\xdef\csname type@\fulltype @Pdur\endcsname{\calc@Pdur}%
	\expandafter\xdef\csname type@\fulltype @Sdur\endcsname{\calc@Sdur}%
	\expandafter\xdef\csname type@\fulltype @TotalHrs\endcsname{\calc@TotalHrs}%
	
	\expandafter\xdef\csname type@\fulltype @CIEL\endcsname{\the\value{cie@theory@total}}%
	\expandafter\xdef\csname type@\fulltype @CIEP\endcsname{\the\value{cie@lab@total}}%
	\expandafter\xdef\csname type@\fulltype @SEEL\endcsname{\the\value{see@theory@total}}%
	\expandafter\xdef\csname type@\fulltype @SEEP\endcsname{\the\value{see@lab@total}}%
	\expandafter\xdef\csname type@\fulltype @CIEdur\endcsname{\temp@ciedur}%
	\expandafter\xdef\csname type@\fulltype @SEEdur\endcsname{\temp@seedur}%
	\expandafter\xdef\csname type@\fulltype @guideline\endcsname{\temp@guideline}%
	\expandafter\xdef\csname type@\fulltype @commoninstCIE\endcsname{\temp@commoninstCIE}%
	\expandafter\xdef\csname type@\fulltype @commoninstSEE\endcsname{\temp@commoninstSEE}%
	\ifx\temp@guidelines\@empty
	\else
		\global\expandafter\let\csname type@\fulltype @guidelines\endcsname\temp@guidelines
	\fi
	
	\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @CIE@totalcount}{\the\value{master@cie@count}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{master@\fulltype @GL@totalcount}{\the\value{guideline@count}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @L}{\the\value{cred@L@tot}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @T}{\the\value{cred@T@tot}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @P}{\the\value{cred@P@tot}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @CIEL}{\the\value{cie@theory@total}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @CIEP}{\the\value{cie@lab@total}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @SEEL}{\the\value{see@theory@total}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @SEEP}{\the\value{see@lab@total}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @CIEdur}{\temp@ciedur}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @SEEdur}{\temp@seedur}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @guideline}{\unexpanded\expandafter{\temp@guideline}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @commoninstCIE}{\unexpanded\expandafter{\temp@commoninstCIE}}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @commoninstSEE}{\unexpanded\expandafter{\temp@commoninstSEE}}}%
	\ifx\temp@guidelines\@empty
	\else
		\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @guidelines}{\unexpanded\expandafter{\temp@guidelines}}}%
	\fi
	
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @Ldur}{\calc@Ldur}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @Tdur}{\calc@Tdur}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @Pdur}{\calc@Pdur}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @Sdur}{\calc@Sdur}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @TotalHrs}{\calc@TotalHrs}}%
	
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @CIELmarks}{\temp@cielmarks}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @CIEPmarks}{\temp@ciepmarks}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @SEELmarks}{\temp@seelmarks}}%
	\immediate\write\@mainaux{\string\global\string\@namedef{type@\fulltype @SEEPmarks}{\temp@seepmarks}}%
	\endgroup
	\fi
	}

\providecommand{\variantchar}[1]{\textbf{Variant:} #1\par}
\providecommand{\Lcredit}[1]{\textbf{L:} #1\quad}
\providecommand{\Tcredit}[1]{\textbf{T:} #1\quad}
\providecommand{\Pcredit}[1]{\textbf{P:} #1\par}
\providecommand{\CIEguideline}[1]{\par#1\par}
\providecommand{\guideline}[1]{\par\textbullet\space#1\par}
\providecommand{\commoninstCIE}[1]{}
\providecommand{\commoninstSEE}[1]{}

%% <--- NEW: Draws all \guideline{} points collected for a credit-type as a
%%      single continuous, numbered table (same visual style as the CIE/SEE
%%      rubric tables) -- one row per guideline point, auto-numbered.
\newcommand{\drawGuidelineTable}[1]{%
	\vspace{0.5em}\noindent
	\begin{longtable}{|>{\centering\arraybackslash}p{0.08\textwidth}|p{\dimexpr0.92\textwidth-4\tabcolsep-4\arrayrulewidth\relax}|}
		\hline
		\multicolumn{2}{|l|}{\textbf{GENERAL GUIDELINES}} \\ \hline
		\endfirsthead
		\hline
		\multicolumn{2}{|l|}{\textbf{GENERAL GUIDELINES (Continued)}} \\ \hline
		\endhead
		\hline
		\endfoot
		\endlastfoot
		#1
	\end{longtable}\par
}

%% <--- FIX: Updated CIE/SEE Rubrics tables to securely stretch to 1.0\textwidth exactly
\NewDocumentEnvironment{CIErubrics}{}{%
	\setcounter{cie@total}{0}%
	\setcounter{cie@row}{0}%
%	\vspace{0.25em}
	\noindent
	\begin{longtable}{|>{\centering\arraybackslash}p{0.08\textwidth}|p{\dimexpr0.83\textwidth-6\tabcolsep-4\arrayrulewidth\relax}|>{\centering\arraybackslash}p{0.09\textwidth}|}
		\hline
		\multicolumn{3}{|l|}{\textbf{RUBRICS FOR THE CONTINUOUS INTERNAL EVALUATION}} \\ \hline
		\textbf{\#} & \multicolumn{1}{c|}{\textbf{COMPONENTS}} & \textbf{MARKS} \\ \hline
		\endfirsthead
		\hline
		\multicolumn{3}{|l|}{\textbf{RUBRICS FOR THE CONTINUOUS INTERNAL EVALUATION (Continued)}} \\ \hline
		\textbf{\#} & \multicolumn{1}{c|}{\textbf{COMPONENTS}} & \textbf{MARKS} \\ \hline
		\endhead
		\hline
		\endfoot
	}{%
		\multicolumn{2}{|r|}{\textbf{MAXIMUM MARKS FOR THE CIE}} & \textbf{\thecie@total} \\ \hline
	\end{longtable}\par
}

\NewDocumentEnvironment{SEE@Theory@rubrics}{O{THEORY}}{%
	\setcounter{see@total}{0}%
	\vspace{0.25em}
	\noindent
	\begin{longtable}{|>{\centering\arraybackslash}p{0.08\textwidth}|p{\dimexpr0.83\textwidth-6\tabcolsep-4\arrayrulewidth\relax}|>{\centering\arraybackslash}p{0.09\textwidth}|}
		\hline
		\multicolumn{3}{|l|}{\textbf{RUBRICS FOR SEMESTER END EXAMINATION (#1)}} \\ \hline%
		\@ifundefined{type@\cfulltype @commoninstSEE}{}{%
			\expandafter\ifx\csname type@\cfulltype @commoninstSEE\endcsname\@empty
			\else
				\multicolumn{3}{|p{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}|}{\csname type@\cfulltype @commoninstSEE\endcsname} \\ \hline
			\fi
		}%
		\textbf{Q.NO.} & \multicolumn{1}{c|}{\textbf{CONTENTS}} & \textbf{MARKS} \\ \hline%
		\endfirsthead
		\hline
		\multicolumn{3}{|l|}{\textbf{RUBRICS FOR SEMESTER END EXAMINATION (#1) (Continued)}} \\ \hline%
		\textbf{Q.NO.} & \multicolumn{1}{c|}{\textbf{CONTENTS}} & \textbf{MARKS} \\ \hline%
		\endhead
		\hline
		\endfoot
	}{%
		\multicolumn{2}{|r|}{\textbf{TOTAL}} & \textbf{\thesee@total} \\ \hline
	\end{longtable}\par
}

\NewDocumentEnvironment{SEE@Practical@rubrics}{}{%
	\setcounter{see@total}{0}%
	\vspace{0.25em}
	\noindent
	\begin{longtable}{|>{\centering\arraybackslash}p{0.08\textwidth}|p{\dimexpr0.83\textwidth-6\tabcolsep-4\arrayrulewidth\relax}|>{\centering\arraybackslash}p{0.09\textwidth}|}
		\hline
		\multicolumn{3}{|l|}{\textbf{RUBRICS FOR SEMESTER END EXAMINATION (LAB)}} \\ \hline
		\@ifundefined{type@\cfulltype @commoninstSEE}{}{%
			\expandafter\ifx\csname type@\cfulltype @commoninstSEE\endcsname\@empty
			\else
				\multicolumn{3}{|p{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}|}{\csname type@\cfulltype @commoninstSEE\endcsname} \\ \hline
			\fi
		}%
		\textbf{Q.NO.} & \multicolumn{1}{c|}{\textbf{CONTENTS}} & \textbf{MARKS} \\ \hline%
		\endfirsthead
		\hline
		\multicolumn{3}{|l|}{\textbf{RUBRICS FOR SEMESTER END EXAMINATION (LAB) (Continued)}} \\ \hline
		\textbf{Q.NO.} & \multicolumn{1}{c|}{\textbf{CONTENTS}} & \textbf{MARKS} \\ \hline%
		\endhead
		\hline
		\endfoot
	}{%
		\multicolumn{2}{|r|}{\textbf{TOTAL}} & \textbf{\thesee@total} \\ \hline
	\end{longtable}\par
}

\newcommand{\Crubric}[3][0]{} 
\newcommand{\Srubric}[3]{%
	#1 & #2 & \textbf{#3} \addtocounter{see@total}{#3} \\ \hline%
}
\newcommand{\SrubricA}[3]{%
	\multicolumn{3}{|c|}{\textbf{PART A}} \\ \hline%
	#1 & #2 & \textbf{#3} \addtocounter{see@total}{#3} \\ \hline%
	\@ifundefined{master@\cfulltype @SEE@hasPartB}{}{%
		\if1\@nameuse{master@\cfulltype @SEE@hasPartB}%
			\multicolumn{3}{|c|}{\textbf{PART B}} \\
			\multicolumn{3}{|c|}{(Maximum of THREE Sub-divisions only)} \\ \hline%
		\fi
	}%
}
\newcommand{\SrubricB}[4][T]{%
	#2 & #3 & \textbf{#4} \addtocounter{see@total}{#4} \\ \hline%
}
%% <--- Renders one guideline point as a full-width row that merges into the
%%      main course-information table (see \xpandtable). No \hline is placed
%%      between individual guideline points -- only the section header and
%%      the table's own top/bottom rules provide separation.
\newcommand{\GLrubric}[2]{%
	\unexpanded{\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\hangindent=1.8em\hangafter=1\noindent\makebox[1.8em][l]{#1.}#2} \\}%
}

\begingroup
\newcounter{def@cmd@ctr}
\setcounter{def@cmd@ctr}{1}
\loop
\edef\AlphCount{\Alph{def@cmd@ctr}}%
\edef\x{\noexpand\gdef\expandafter\noexpand\csname CIErubric\AlphCount\endcsname####1{%
		\noexpand\expandafter\noexpand\gdef\noexpand\csname course@sem\noexpand\c@sem @\noexpand\romannumeral\noexpand\value{courseindex}@CIE@\AlphCount @text\noexpand\endcsname{####1}% 
}}%
\x
\ifnum\value{def@cmd@ctr}<26
\stepcounter{def@cmd@ctr}%
\repeat
\endgroup

% --- Per-course override macros for NPTEL-style Guidelines, mirroring
%     \CIErubricA..Z above. Auto-seeded into each course's .tex file (see
%     the file-generation code) and editable there; \@GLloop checks these
%     before falling back to the credit-type's master guideline text. ---
\begingroup
\newcounter{def@gl@cmd@ctr}
\setcounter{def@gl@cmd@ctr}{1}
\loop
\edef\AlphCount{\Alph{def@gl@cmd@ctr}}%
\edef\x{\noexpand\gdef\expandafter\noexpand\csname GLoverride\AlphCount\endcsname####1{%
		\noexpand\expandafter\noexpand\gdef\noexpand\csname course@sem\noexpand\c@sem @\noexpand\romannumeral\noexpand\value{courseindex}@GL@\AlphCount @text\noexpand\endcsname{####1}% 
}}%
\x
\ifnum\value{def@gl@cmd@ctr}<26
\stepcounter{def@gl@cmd@ctr}%
\repeat
\endgroup

\def\@docourse{\@ifnextchar[{\@readpoints}{\ClassError{syllabus}{Provide Type and Category of the course}{}}}
\def\@dounit{\@ifnextchar[{\@readunits}{\ClassError{syllabus}{Provide Type and Category of the course}{}}}
\def\@dopractice{\@ifnextchar[{\@readpracticeel}{\@readpractice}}

\def\@doco#1{
	\addtocounter{numof@cos}{1}
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@co@\romannumeral\value{numof@cos}@content}{#1}}
	\fi
}
\def\@doref#1{
	\addtocounter{numof@refs}{1}
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@ref@\romannumeral\value{numof@refs}@content}{#1}}
	\fi
}

\def\@readpoints[#1]#2{
	\gdef\@current@type{#1}
	\def\@type{#1}
	\checkcoursetype{\@type}
	
	% --- THE FIX: APPLY SMART TITLE CASE ---
	\gdef\current@course@title{\SmartTitleCase{#2}}% 
	
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@coursesem}{\sem}} 
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@coursecode}{\course@code}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@coursetype}{#1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\sem @\romannumeral\value{numof@courses}@coursetitle}{\noexpand\SmartTitleCase{\unexpanded{#2}}}}
	\fi
}

\def\@readunits[#1]#2{
	\def\@type{#1}
	\checkunithour{\@type}
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@lectureunit@\roman{numof@lectureunits}@hour}{#1}}
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@lectureunit@\roman{numof@lectureunits}@content}{\unexpanded{#2}}}
	\fi
}
\def\@readpracticeel[#1]#2{
	\def\@type{#1}
	\def\@category{#2}
	\checkpracticeeltype{\@type}
	\addtocounter{numof@practiceelunits}{1}
	\global\practiceeltrue
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@practiceelunit@\roman{numof@practiceelunits}@content}{#2}}
	\fi
}
\def\@readpractice#1{
	\addtocounter{numof@practiceunits}{1}
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\c@sem @\roman{courseindex}@practiceunit@\roman{numof@practiceunits}@content}{#1}}
	\fi
}

\newif\ifmainauxfound
\newcommand{\initstandalone}[3][\jobname.bib]{%
	\@ifundefined{ismaindoc}{%
		\makeatletter
		\standalonetrue
		\gdef\standalone@semester@index{#2}% 
		\gdef\standalone@course@index{#3}%
		
		\let\abx@aux@refcontext\@gobble
		\let\abx@aux@cite\@gobbletwo
		\let\abx@aux@segm\@gobblethree
		\let\abx@aux@read@bbl@mdfivesum\@gobble
		\let\abx@aux@numberofbblfiles\@gobble
		\let\abx@aux@refsection\@gobbletwo
		\let\abx@aux@read@bblrerun\relax 
		
		% --- NATIVE OVERLEAF CACHE HUNTER ---
		\mainauxfoundfalse
		\InputIfFileExists{Main.aux}{\mainauxfoundtrue}{%
			\InputIfFileExists{main.aux}{\mainauxfoundtrue}{%
				\InputIfFileExists{build/Main.aux}{\mainauxfoundtrue}{%
					\InputIfFileExists{out/Main.aux}{\mainauxfoundtrue}{}%
				}%
			}%
		}%
		
		\IfFileExists{\jobname.aux}{\input{\jobname.aux}}{}%
		\makeatother
		
		\usepackage[sorting=none, backend=biber,style=ieee]{biblatex}%
		\addbibresource{#1}%
		\renewcommand{\arraystretch}{1.5}%
		
		\def\inbpdocument{\begin{document}}%
			\def\outbpdocument{\end{document}}%
	}{%
		\def\inbpdocument{}%
		\def\outbpdocument{}%
	}%
}

\def\getlectureunithour#1#2{%
	\@ifundefined{course@sem\lsem @\romannumeral#1@lectureunit@\romannumeral#2@hour}%
	{\mbox{\normalfont\bfseries ??}}%
	{\csname course@sem\lsem @\romannumeral#1@lectureunit@\romannumeral#2@hour\endcsname}%
}
\def\getlectureunitcontent#1#2{%
	\@ifundefined{course@sem\lsem @\romannumeral#1@lectureunit@\romannumeral#2@content}%
	{\mbox{\normalfont\bfseries ??}}%
	{\csname course@sem\lsem @\romannumeral#1@lectureunit@\romannumeral#2@content\endcsname}%
}
\def\getpracticeunitcontent#1#2{%
	\@ifundefined{course@sem\lsem @\romannumeral#1@practiceunit@\romannumeral#2@content}%
	{\mbox{\normalfont\bfseries ??}}%
	{\csname course@sem\lsem @\romannumeral#1@practiceunit@\romannumeral#2@content\endcsname}%
}
\def\getpracticeelunitcontent#1#2{%
	\@ifundefined{course@sem\lsem @\romannumeral#1@practiceelunit@\romannumeral#2@content}%
	{\mbox{\normalfont\bfseries ??}}%
	{\csname course@sem\lsem @\romannumeral#1@practiceelunit@\romannumeral#2@content\endcsname}%
}
\def\getcourseco#1#2{%
	\@ifundefined{course@sem\lsem @\romannumeral#1@co@\romannumeral#2@content}%
	{\mbox{\normalfont\bfseries ??}}%
	{\csname course@sem\lsem @\romannumeral#1@co@\romannumeral#2@content\endcsname}%
}
\def\getcourseref#1#2{%
	\@ifundefined{course@sem\lsem @\romannumeral#1@ref@\romannumeral#2@content}%
	{\mbox{\normalfont\bfseries ??}}%
	{{\fullcite{\csname course@sem\lsem @\romannumeral#1@ref@\romannumeral#2@content\endcsname}}}%
}
\def\getpracticetitle#1{%
	\@ifundefined{course@sem\lsem @\romannumeral#1@practicetitle}%
	{\mbox{\normalfont\bfseries ??}}%
	{\csname course@sem\lsem @\romannumeral#1@practicetitle\endcsname}%
}
\def\getpracticeeltitle#1{%
	\@ifundefined{course@sem\lsem @\romannumeral#1@practiceeltitle}%
	{\mbox{\normalfont\bfseries ??}}%
	{\csname course@sem\lsem @\romannumeral#1@practiceeltitle\endcsname}%
}

\newcommand*{\syllabus@group@toc@loop}{%
	\ifnum\value{semester@loop@ctr}<\numexpr\arabic{semester@temp@ctr}+1\relax
	\edef\current@semester{\roman{semester@loop@ctr}}
	\xdef\lsem{\@ifundefined{semester@\current@semester @val}{1}{\@nameuse{semester@\current@semester @val}}}
	\gdef\printsemester{\MakeTextUppercase{\romannumeral\lsem}}
	
	\ifnum\lsem=0\relax
	\else
	\setcounter{eg@id}{1}%
	\@whilesw\ifcsname semester@sem\lsem @eg@\roman{eg@id}@code\endcsname\fi{%
		\PrintElectiveGroupTable{\roman{eg@id}}%
		\vspace{2em}%
		\stepcounter{eg@id}%
	}%
	
	\setcounter{ae@id}{1}%
	\@whilesw\ifcsname semester@sem\lsem @ae@\roman{ae@id}@code\endcsname\fi{%
		\PrintAEGroupTable{\roman{ae@id}}%
		\vspace{2em}%
		\stepcounter{ae@id}%
	}%
	\fi
	
	\stepcounter{semester@loop@ctr}%
	\expandafter\syllabus@group@toc@loop
	\fi
}


\newcommand{\PrintElectiveGroupTable}[1]{%
	\begingroup
	\edef\egcode{\@nameuse{semester@sem\lsem @eg@#1@code}}%
	\edef\egtitle{\@nameuse{semester@sem\lsem @eg@#1@title}}%
	\edef\egletter{\@nameuse{semester@sem\lsem @eg@#1@letter}}%
	\edef\egcount{\@nameuse{semester@sem\lsem @eg@#1@count}}%
	
	\begin{longtable}{|>{\centering\arraybackslash}p{0.08\textwidth}|>{\centering\arraybackslash}p{0.2\textwidth}|>{\raggedright\arraybackslash}p{0.54\textwidth}|>{\centering\arraybackslash}p{0.08\textwidth}|}
		\hline
		\multicolumn{4}{|c|}{\textbf{Semester - \printsemester}} \\ \hline
		\multicolumn{4}{|c|}{\textbf{\egtitle}} \\ \hline
		\multicolumn{4}{|c|}{\textbf{GROUP-\egletter}} \\ \hline
		\textbf{Sl. No.} & \textbf{Course Code} & \multicolumn{1}{c|}{\textbf{Course Title}} & \textbf{Page No.} \\ \hline
		\endfirsthead
		
		\hline
		\multicolumn{4}{|c|}{\textbf{Semester - \printsemester\space (Continued)}} \\ \hline
		\multicolumn{4}{|c|}{\textbf{\egtitle}} \\ \hline
		\multicolumn{4}{|c|}{\textbf{GROUP-\egletter}} \\ \hline
		\textbf{Sl. No.} & \textbf{Course Code} & \multicolumn{1}{c|}{\textbf{Course Title}} & \textbf{Page No.} \\ \hline
		\endhead
		
		\hline
		\endfoot
%		\hline
		\endlastfoot
		
		\ifnum\egcount<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
		{\expandafter\@eg@tocloop\expandafter{\number\numexpr(1)\expandafter\relax\expandafter}{\egcount}{#1}}
	\end{longtable}
	\endgroup
}

\def\@eg@tocloop#1#2#3{%
	\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{%
		\PrintEGTOCRow{#1}{#3}%
		\expandafter\@eg@tocloop\expandafter{\number\numexpr#1+1}{#2}{#3}%
	}%
}

\newcommand{\PrintEGTOCRow}[2]{%
	\@ifundefined{semester@sem\lsem @eg@#2@course@\romannumeral#1@code}{\def\ccode{---}}{\expandafter\let\expandafter\ccode\csname semester@sem\lsem @eg@#2@course@\romannumeral#1@code\endcsname}%
	\@ifundefined{semester@sem\lsem @eg@#2@course@\romannumeral#1@title}{\def\ctitle{---}}{\expandafter\let\expandafter\ctitle\csname semester@sem\lsem @eg@#2@course@\romannumeral#1@title\endcsname}%
	\@ifundefined{semester@sem\lsem @eg@#2@course@\romannumeral#1@page}{\def\cpage{---}}{\expandafter\let\expandafter\cpage\csname semester@sem\lsem @eg@#2@course@\romannumeral#1@page\endcsname}%
	
	\edef\rowout{%
		#1 \noexpand& \unexpanded\expandafter{\ccode} \noexpand& \unexpanded\expandafter{\ctitle} \noexpand& \unexpanded\expandafter{\cpage} \noexpand\\ \noexpand\hline
	}%
	\rowout
}

\newcommand{\PrintAEGroupTable}[1]{%
	\begingroup
	\edef\aecode{\@nameuse{semester@sem\lsem @ae@#1@code}}%
	\edef\aecount{\@nameuse{semester@sem\lsem @ae@#1@count}}%
	
	\begin{longtable}{|>{\centering\arraybackslash}p{0.08\textwidth}|>{\centering\arraybackslash}p{0.2\textwidth}|>{\raggedright\arraybackslash}p{0.54\textwidth}|>{\centering\arraybackslash}p{0.08\textwidth}|}
		\hline
		\multicolumn{4}{|c|}{\textbf{Semester - \printsemester}} \\ \hline
		\multicolumn{4}{|c|}{\textbf{AE Courses}} \\ \hline
		\textbf{Sl. No.} & \textbf{Course Code} & \multicolumn{1}{c|}{\textbf{Course Title}} & \textbf{Page No.} \\ \hline
		\endfirsthead
		
		\hline
		\multicolumn{4}{|c|}{\textbf{Semester - \printsemester\space (Continued)}} \\ \hline
		\multicolumn{4}{|c|}{\textbf{AE Courses}} \\ \hline
		\textbf{Sl. No.} & \textbf{Course Code} & \multicolumn{1}{c|}{\textbf{Course Title}} & \textbf{Page No.} \\ \hline
		\endhead
		
		\hline
		\endfoot
%		\hline
		\endlastfoot
		
		\ifnum\aecount<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
		{\expandafter\@ae@tocloop\expandafter{\number\numexpr(1)\expandafter\relax\expandafter}{\aecount}{#1}}
	\end{longtable}
	\endgroup
}

\def\@sk@tocloop#1#2#3{%
	\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{%
		\PrintSKTOCRow{#1}{#3}%
		\expandafter\@sk@tocloop\expandafter{\number\numexpr#1+1}{#2}{#3}%
	}%
}

\newcommand{\PrintSKTOCRow}[2]{%
	\@ifundefined{semester@sem\lsem @sk@#2@course@\romannumeral#1@code}{\def\ccode{---}}{\expandafter\let\expandafter\ccode\csname semester@sem\lsem @sk@#2@course@\romannumeral#1@code\endcsname}%
	\@ifundefined{semester@sem\lsem @sk@#2@course@\romannumeral#1@title}{\def\ctitle{---}}{\expandafter\let\expandafter\ctitle\csname semester@sem\lsem @sk@#2@course@\romannumeral#1@title\endcsname}%
	\@ifundefined{semester@sem\lsem @sk@#2@course@\romannumeral#1@page}{\def\cpage{---}}{\expandafter\let\expandafter\cpage\csname semester@sem\lsem @sk@#2@course@\romannumeral#1@page\endcsname}%
	
	\edef\rowout{%
		#1 \noexpand& \unexpanded\expandafter{\ccode} \noexpand& \unexpanded\expandafter{\ctitle} \noexpand& \unexpanded\expandafter{\cpage} \noexpand\\ \noexpand\hline
	}%
	\rowout
}

\def\@ae@tocloop#1#2#3{%
	\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{%
		\PrintAETOCRow{#1}{#3}%
		\expandafter\@ae@tocloop\expandafter{\number\numexpr#1+1}{#2}{#3}%
	}%
}

\newcommand{\PrintAETOCRow}[2]{%
	\@ifundefined{semester@sem\lsem @ae@#2@course@\romannumeral#1@code}{\def\ccode{---}}{\expandafter\let\expandafter\ccode\csname semester@sem\lsem @ae@#2@course@\romannumeral#1@code\endcsname}%
	\@ifundefined{semester@sem\lsem @ae@#2@course@\romannumeral#1@title}{\def\ctitle{---}}{\expandafter\let\expandafter\ctitle\csname semester@sem\lsem @ae@#2@course@\romannumeral#1@title\endcsname}%
	\@ifundefined{semester@sem\lsem @ae@#2@course@\romannumeral#1@page}{\def\cpage{---}}{\expandafter\let\expandafter\cpage\csname semester@sem\lsem @ae@#2@course@\romannumeral#1@page\endcsname}%
	
	\edef\rowout{%
		#1 \noexpand& \unexpanded\expandafter{\ccode} \noexpand& \unexpanded\expandafter{\ctitle} \noexpand& \unexpanded\expandafter{\cpage} \noexpand\\ \noexpand\hline
	}%
	\rowout
}

\newcommand*\syllabus@generatetables{%
	\ifstandalone\else
	
	\cleardoublepage
	\pagenumbering{roman}
	\setcounter{page}{1}
	\pagestyle{emptypg} % Standard header for TOC, no footer line
	\setcounter{semester@loop@ctr}{1}%
	\syllabus@toc@loop
	\setcounter{semester@loop@ctr}{0}%
	\printsklabstoc % <--- INJECTED HERE! Automatically draws the table if sklabs was used.
	
	\clearpage
	\pagestyle{fplain}%
	\begin{landscape}
		\setcounter{semester@loop@ctr}{1}%
		\syllabus@index@loop
		\schemefooterflush
	\end{landscape}
	\clearpage
	
	\pagestyle{emptypg}
	\setcounter{semester@loop@ctr}{1}%
	\syllabus@group@toc@loop
	\clearpage
	
	\fi 
	
	\clearpage
	\pagenumbering{arabic}
	\setcounter{page}{1}
	\pagestyle{mplain}%
	\setcounter{semester@loop@ctr}{1}%
	\syllabus@outer@loop
	
	% --- PRINTS THE SKILL LAB PAGES AT THE VERY END ---
	\ifstandalone\else
	\printsklabspages
	\fi
}

\newcommand*{\syllabus@toc@loop}{%
	\ifnum\value{semester@loop@ctr}<\numexpr\arabic{semester@temp@ctr}+1\relax
	\edef\current@semester{\roman{semester@loop@ctr}}
	\xdef\lsem{\@ifundefined{semester@\current@semester @val}{1}{\@nameuse{semester@\current@semester @val}}}
	\gdef\printsemester{\MakeTextUppercase{\romannumeral\lsem}}
	
	\@ifundefined{semester@sem\lsem @numofcourses}{%
		\setcounter{course@temp@ctr}{0}%
	}{%
		\setcounter{course@temp@ctr}{\@nameuse{semester@sem\lsem @numofcourses}}%
	}
	
	% THE FIX: Check the semester number BEFORE drawing the table
	\ifnum\lsem=0\relax
	% Do nothing. Completely skip drawing the TOC table for Skill Labs.
	\else
	\ifnum\value{course@temp@ctr}>0
	\tocindextable{\arabic{course@temp@ctr}}%
	\vspace{2em} 
	\fi
	\fi
	
	\stepcounter{semester@loop@ctr}%
	\expandafter\syllabus@toc@loop % Safely continue looping
	\fi
}


\newcommand*{\syllabus@index@loop}{%
	\ifnum\value{semester@loop@ctr}<\numexpr\arabic{semester@temp@ctr}+1\relax
	\edef\current@semester{\roman{semester@loop@ctr}}
	\xdef\lsem{\@ifundefined{semester@\current@semester @val}{1}{\@nameuse{semester@\current@semester @val}}}
	\gdef\printsemester{\MakeTextUppercase{\romannumeral\lsem}}
	
	\@ifundefined{semester@sem\lsem @numofcourses}{%
		\global\syllabus@rerun@warningtrue
		\setcounter{course@temp@ctr}{0}%
	}{%
		\setcounter{course@temp@ctr}{\@nameuse{semester@sem\lsem @numofcourses}}%
	}
	
	% THE SHIELD: Prevents the landscape credit table from drawing for Semester 0
	\ifnum\lsem=0\relax
	% Skip main index table for Skill Labs
	\else
	\ifnum\value{course@temp@ctr}>0
	\mainindextable{\arabic{course@temp@ctr}}%
	\fi
	\fi
	
	\stepcounter{semester@loop@ctr}%
	\expandafter\syllabus@index@loop
	\fi
}


\newcommand*{\syllabus@outer@loop}{%
	\ifnum\value{semester@loop@ctr}<\numexpr\arabic{semester@temp@ctr}+1\relax
	
	\ifstandalone
	\xdef\lsem{\standalone@semester@index}% 
	\else
	\edef\current@semester{\roman{semester@loop@ctr}}%
	\xdef\lsem{\@ifundefined{semester@\current@semester @val}{1}{\@nameuse{semester@\current@semester @val}}}%
	\fi
	
	\gdef\printsemester{\MakeTextUppercase{\romannumeral\lsem}}%
	
	\ifstandalone
	\setcounter{course@temp@ctr}{\standalone@course@index}% Forces the loop to reach the target course
	\else
	\@ifundefined{semester@sem\lsem @numofcourses}{%
		\setcounter{course@temp@ctr}{0}%
	}{%
		\setcounter{course@temp@ctr}{\@nameuse{semester@sem\lsem @numofcourses}}%
	}
	\fi
	
	% THE SHIELD: Prevents duplicate pages, but allows Standalone Skill Labs
	\ifnum\lsem=0\relax
	\ifstandalone
	\setcounter{course@loop@ctr}{1}%
	\syllabus@inner@loop
	\fi
	\else
	\setcounter{course@loop@ctr}{1}%
	\syllabus@inner@loop
	\fi
	
	\ifstandalone
	\setcounter{semester@loop@ctr}{\numexpr\value{semester@temp@ctr}+1\relax}%
	\else
	\stepcounter{semester@loop@ctr}%
	\fi
	\expandafter\syllabus@outer@loop
	\fi
}

\newcommand*{\syllabus@inner@loop}{%
	\ifnum\value{course@loop@ctr}<\numexpr\arabic{course@temp@ctr}+1\relax
	
	\ifstandalone
	\setcounter{course@loop@ctr}{\standalone@course@index}%
	\edef\currentcoursenum{\standalone@course@index}%
	\else
	\edef\currentcoursenum{\the\value{course@loop@ctr}}%
	\fi
	
	\expandafter\ifx\csname course@sem\lsem @\roman{course@loop@ctr}@coursecode\endcsname\relax
	\expandafter\gdef\csname course@sem\lsem @\roman{course@loop@ctr}@coursecode\endcsname{missing-file-placeholder}%
	\fi
	\edef\course@code{\csname course@sem\lsem @\roman{course@loop@ctr}@coursecode\endcsname}%
	
	% --- CHECK IF IT IS A STARRED (COPIED) COURSE ---
	\edef\isstar{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@isstar}{false}{\@nameuse{course@sem\lsem @\roman{course@loop@ctr}@isstar}}}%
	\def\true@str{true}%
	
	\ifx\isstar\true@str
	% SKIP typesetting entirely, it's just a copied entry for the tables!
	\else
	\ifstandalone
	\else
	\@ifundefined{c@refsection}{}{%
		\IfFileExists{\course@code.bib}{%
			\begin{refsection}[\course@code.bib]%
			}{%
				\begin{refsection}%
				}%
			}
			\IfFileExists{\course@code.tex}{\input{\course@code.tex}}{}%
			\fi
			
			\expandafter\ifx\csname course@sem\lsem @\roman{course@loop@ctr}@category\endcsname\relax
			\expandafter\gdef\csname course@sem\lsem @\roman{course@loop@ctr}@category\endcsname{Category Pending}%
			\fi
			\expandafter\ifx\csname course@sem\lsem @\roman{course@loop@ctr}@stream\endcsname\relax
			\expandafter\gdef\csname course@sem\lsem @\roman{course@loop@ctr}@stream\endcsname{Stream Pending}%
			\fi
			\expandafter\ifx\csname course@sem\lsem @\roman{course@loop@ctr}@coursetitle\endcsname\relax
			\expandafter\gdef\csname course@sem\lsem @\roman{course@loop@ctr}@coursetitle\endcsname{Course Title Pending}%
			\fi
			
			\edef\lecturestatus{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@lecturestatus}{0}{\csname course@sem\lsem @\roman{course@loop@ctr}@lecturestatus\endcsname}}%
			\edef\practicestatus{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@practicestatus}{0}{\csname course@sem\lsem @\roman{course@loop@ctr}@practicestatus\endcsname}}%
			\edef\tutorialstatus{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@tutorialstatus}{0}{\csname course@sem\lsem @\roman{course@loop@ctr}@tutorialstatus\endcsname}}%
			
			\ifnum\lecturestatus=1\relax \global\lecturetrue \else \global\lecturefalse \fi
			\ifnum\practicestatus=1\relax \global\practicetrue \else \global\practicefalse \fi
			\ifnum\tutorialstatus=1\relax \global\tutorialtrue \else \global\tutorialfalse \fi
			
			\edef\nsemester{\value{semester@loop@ctr}}%
			\edef\nlec{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@numoflectureunits}{1}{\csname course@sem\lsem @\roman{course@loop@ctr}@numoflectureunits\endcsname}}%
			\edef\nprac{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@numofpracticeunits}{1}{\csname course@sem\lsem @\roman{course@loop@ctr}@numofpracticeunits\endcsname}}%
			\edef\npel{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@numofpracticeelunits}{1}{\csname course@sem\lsem @\roman{course@loop@ctr}@numofpracticeelunits\endcsname}}%
			\edef\nref{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@numofreferences}{1}{\csname course@sem\lsem @\roman{course@loop@ctr}@numofreferences\endcsname}}%
			\edef\nco{\@ifundefined{course@sem\lsem @\roman{course@loop@ctr}@numofcourseoutcomes}{1}{\csname course@sem\lsem @\roman{course@loop@ctr}@numofcourseoutcomes\endcsname}}%
			
			\clearpage
			\checkcourseconsistency{\roman{course@loop@ctr}}{\course@code}%
			
			\ifsyllabus@rerun@warning
			\global\def\syllabus@master@rerun@required{}%
			\vspace*{5cm}
			\begin{center}
				\setlength{\fboxsep}{1em}
				\fbox{\textsf{\textbf{\Large [Syllabus Notice: Course Data Updating]}}}
				\vspace{1.5em}
				{\large Processing memory mappings for: \texttt{\detokenize\expandafter{\course@code}.tex}}
				\vspace{1em}
				{\bfseries Please RERUN PDFLaTeX on \texttt{Main.tex} now to load all tables.}
			\end{center}
			\global\syllabus@rerun@warningfalse
			\else
			
			% --- VISUAL DEBUGGER FOR STANDALONE MODE ---
			\ifstandalone
			\ifmainauxfound
			\edef\cTitleCheck{\@nameuse{course@sem\lsem @\roman{course@loop@ctr}@coursetitle}}%
			\def\cPendingStr{Course Title Pending}%
			\ifx\cTitleCheck\cPendingStr
			\begin{center}\fbox{\parbox{0.8\textwidth}{\centering\bfseries
						[ERROR: Main.aux was found, but it is OUTDATED or EMPTY!]\\
						Please recompile Main.tex, download the new Main.aux, and upload it again.
			}}\end{center}\vspace{1em}
			\fi
			\else
			\begin{center}\fbox{\parbox{0.8\textwidth}{\centering\bfseries
						[CRITICAL ERROR: Main.aux was NOT FOUND by the compiler!]\\
						Overleaf hides files from other compiles. You must manually UPLOAD Main.aux into your project file tree so this file can see it.
			}}\end{center}\vspace{1em}
			\fi
			\fi
			
			\xpandtable{\nsemester}{\currentcoursenum}{\nlec}{\nprac}{\npel}{\nref}{\nco}%
			\fi
			
			\ifstandalone
			\else
			\@ifundefined{c@refsection}{}{\end{refsection}}
		\fi
		\fi % <--- CLOSES \isstar
		
		\ifstandalone
		\setcounter{course@loop@ctr}{\numexpr\value{course@temp@ctr}+1\relax}%
		\else
		\stepcounter{course@loop@ctr}%
		\fi
		
	\expandafter\syllabus@inner@loop
	\fi
}

\newcommand{\checkcourseconsistency}[2]{%
	\makeatletter
	\edef\current@course@hash{%
		\@ifundefined{course@sem\lsem @#1@category}{X}{\@nameuse{course@sem\lsem @#1@category}}|%
		\@ifundefined{course@sem\lsem @#1@lecturestatus}{X}{\@nameuse{course@sem\lsem @#1@lecturestatus}}|%
		\@ifundefined{course@sem\lsem @#1@practicestatus}{X}{\@nameuse{course@sem\lsem @#1@practicestatus}}%
	}%
	\edef\previous@course@hash{\@ifundefined{course@sem\lsem @#1@hash@track}{NEW}{\@nameuse{course@sem\lsem @#1@hash@track}}}%
	\ifx\current@course@hash\previous@course@hash\else\global\syllabus@rerun@warningtrue\fi
	\if@filesw
	\immediate\write\@mainaux{\string\global\string\@namedef{course@sem\lsem @#1@hash@track}{\current@course@hash}}%
	\fi
	\makeatother
}

\newcounter{draw@ctr}
\newcounter{gl@draw@ctr}

\def\@CIEloop#1#2#3#4{%
	\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi
	{%
		\edef\AlphCount{\Alph{draw@ctr}}%
		\edef\themarks{\@nameuse{master@#4@CIE@\AlphCount @marks}}%
		\edef\theqno{\@nameuse{master@#4@CIE@\AlphCount @qno}}% <--- FETCH CUSTOM Q.NO
		\addtocounter{cie@total}{\themarks}%
		\@ifundefined{course@sem\lsem @#3@CIE@\AlphCount @text}{% 
			\edef\textcmd{master@#4@CIE@\AlphCount @text}%
		}{%
			\edef\textcmd{course@sem\lsem @#3@CIE@\AlphCount @text}%
		}%
		% v--- INJECT CUSTOM Q.NO HERE
		\edef\temprow{\theqno \noexpand& \noexpand\@nameuse{\textcmd} \noexpand& \noexpand\textbf{\themarks} \noexpand\\ \noexpand\hline}%
		\xdef\CIEtablebody{\unexpanded\expandafter{\CIEtablebody}\unexpanded\expandafter{\temprow}}%
		\stepcounter{draw@ctr}%
		\expandafter\@CIEloop\expandafter{\number\numexpr#1+1\relax}{#2}{#3}{#4}%
	}%
}

% --- Mirrors \@CIEloop, but for Guideline points: #1=running index (1..),
%     #2=total count, #3=course roman numeral (for course-specific override
%     lookup), #4=credit fulltype (for master default lookup). Checks the
%     course's own \GLoverride<Letter>{} text first, else falls back to the
%     credit-type's master \guideline{} text -- same override pattern CIE
%     rubrics use, so this can be synced by the same kind of external tool. ---
\def\@GLloop#1#2#3#4{%
	\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi
	{%
		\setcounter{gl@draw@ctr}{#1}%
		\edef\GLAlphCount{\Alph{gl@draw@ctr}}%
		\@ifundefined{course@sem\lsem @#3@GL@\GLAlphCount @text}{%
			\edef\gltextcmd{master@#4@GL@\GLAlphCount @text}%
		}{%
			\edef\gltextcmd{course@sem\lsem @#3@GL@\GLAlphCount @text}%
		}%
		\edef\temprow{\noexpand\GLrubric{#1}{\unexpanded\expandafter{\csname\gltextcmd\endcsname}}}%
		\xdef\GLtablebody{\unexpanded\expandafter{\GLtablebody}\unexpanded\expandafter{\temprow}}%
		\expandafter\@GLloop\expandafter{\number\numexpr#1+1\relax}{#2}{#3}{#4}%
	}%
}

\newcommand{\drawCIEtable}[1]{%
	\edef\croman{\romannumeral#1}%
	\edef\ctype{\@ifundefined{course@sem\lsem @\croman @coursetype}{UNKNOWN}{\@nameuse{course@sem\lsem @\croman @coursetype}}}% 
	\expandafter\extract@basetype\ctype\relax\relax\@nil
	\expandafter\clean@variant\temp@variant\@nil
	\edef\cfulltype{\course@basetype\course@variant}%
	%
	\ifx\course@basetype\NPTEL
	% --- General Guidelines are now merged directly into the main
	%     course-information table by \xpandtable; nothing to draw here. ---
	\else
	\@ifundefined{master@\cfulltype @CIE@totalcount}{}{%
		\setcounter{cie@total}{0}%
		\gdef\CIEtablebody{}%
		\setcounter{draw@ctr}{1}%
		\edef\maxrows{\@nameuse{master@\cfulltype @CIE@totalcount}}%
		\@CIEloop{1}{\maxrows}{\croman}{\cfulltype}%
		%
		\vspace{0.5em}\noindent
		\begin{longtable}{|>{\centering\arraybackslash}p{0.08\textwidth}|p{\dimexpr0.83\textwidth-6\tabcolsep-4\arrayrulewidth\relax}|>{\centering\arraybackslash}p{0.09\textwidth}|}
			\hline
			\multicolumn{3}{|l|}{\textbf{RUBRICS FOR THE CONTINUOUS INTERNAL EVALUATION}} \\ \hline
			\@ifundefined{type@\cfulltype @commoninstCIE}{}{%
				\expandafter\ifx\csname type@\cfulltype @commoninstCIE\endcsname\@empty
				\else
					\multicolumn{3}{|p{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}|}{\csname type@\cfulltype @commoninstCIE\endcsname} \\ \hline
				\fi
			}%
			\textbf{\#} & \multicolumn{1}{c|}{\textbf{COMPONENTS}} & \textbf{MARKS} \\ \hline
			\endfirsthead
			\hline
			\multicolumn{3}{|l|}{\textbf{RUBRICS FOR THE CONTINUOUS INTERNAL EVALUATION (Continued)}} \\ \hline
			\textbf{\#} & \multicolumn{1}{c|}{\textbf{COMPONENTS}} & \textbf{MARKS} \\ \hline
			\endhead
			\hline
			\endfoot
			\multicolumn{2}{|r|}{\textbf{MAXIMUM MARKS FOR THE CIE}} & \textbf{\thecie@total} \\ \hline
			\endlastfoot
			\CIEtablebody
		\end{longtable}\par
	}%
	\fi
}

\newcommand{\drawSEEtable}[1]{%
	\edef\croman{\romannumeral#1}%
	\edef\ctype{\@ifundefined{course@sem\lsem @\croman @coursetype}{UNKNOWN}{\@nameuse{course@sem\lsem @\croman @coursetype}}}% 
	\expandafter\extract@basetype\ctype\relax\relax\@nil
	\expandafter\clean@variant\temp@variant\@nil
	\edef\cfulltype{\course@basetype\course@variant}%
	% --- NPTEL: no separate SEE rubric table; the guideline printed by
	%     \drawCIEtable already covers both CIE and SEE for this type ---
	\ifx\course@basetype\NPTEL
	\else
	% --- BC CATEGORY OVERRIDE (SKIP SEE RUBRICS) ---
	\edef\checkCat{\@ifundefined{course@sem\lsem @\croman @category}{}{\@nameuse{course@sem\lsem @\croman @category}}}%
	\def\targetCat{Category: Bridge Course}%
	\ifx\checkCat\targetCat
	% Do nothing, BC has no SEE components
	\else
	%
	\@ifundefined{master@\cfulltype @SEE@Theory}{}{%
		\begin{SEE@Theory@rubrics}[\@nameuse{master@\cfulltype @SEE@Theory@Arg}]%
			\@nameuse{master@\cfulltype @SEE@Theory}%
		\end{SEE@Theory@rubrics}%
	}%
	\@ifundefined{master@\cfulltype @SEE@Practical}{}{%
		\begin{SEE@Practical@rubrics}%
			\@nameuse{master@\cfulltype @SEE@Practical}%
		\end{SEE@Practical@rubrics}%
	}%
	\fi
	\fi
}

\gdef\fmtM#1{\ifnum#1=0 ---\else#1\fi}

\newcommand{\xpandtable}[7]{%
	\edef\ctype{\@ifundefined{course@sem\lsem @\romannumeral#2@coursetype}{UNKNOWN}{\@nameuse{course@sem\lsem @\romannumeral#2@coursetype}}}%
	\expandafter\extract@basetype\ctype\relax\relax\@nil
	\expandafter\clean@variant\temp@variant\@nil
	
	\@ifundefined{type@\ctype @L}{\def\cL{0}}{\edef\cL{\@nameuse{type@\ctype @L}}}%
	\@ifundefined{type@\ctype @T}{\def\cT{0}}{\edef\cT{\@nameuse{type@\ctype @T}}}%
	\@ifundefined{type@\ctype @P}{\def\cP{0}}{\edef\cP{\@nameuse{type@\ctype @P}}}%
	
	\@ifundefined{type@\ctype @Ldur}{\def\cLdur{0}}{\edef\cLdur{\@nameuse{type@\ctype @Ldur}}}%
	\@ifundefined{type@\ctype @Tdur}{\def\cTdur{0}}{\edef\cTdur{\@nameuse{type@\ctype @Tdur}}}%
	\@ifundefined{type@\ctype @Pdur}{\def\cPdur{0}}{\edef\cPdur{\@nameuse{type@\ctype @Pdur}}}%
	\@ifundefined{course@sem\c@sem @\roman{courseindex}@Sdur}{%
		\@ifundefined{type@\ctype @Sdur}{\def\cSdur{0}}{\edef\cSdur{\@nameuse{type@\ctype @Sdur}}}%
	}{%
		\edef\cSdur{\@nameuse{course@sem\c@sem @\roman{courseindex}@Sdur}}%
	}%
	\edef\cTotCreds{\the\numexpr \cL + \cT + \cP \relax}%
	
	\@ifundefined{type@\ctype @CIEdur}{\def\cCIEDur{---}}{\edef\cCIEDur{\@nameuse{type@\ctype @CIEdur}}}%
	\@ifundefined{type@\ctype @SEEdur}{\def\cSEEDur{---}}{\edef\cSEEDur{\@nameuse{type@\ctype @SEEdur}}}%
	
	\edef\cCIEL{\@ifundefined{type@\ctype @CIELmarks}{\@ifundefined{type@\ctype @CIEL}{0}{\@nameuse{type@\ctype @CIEL}}}{\@nameuse{type@\ctype @CIELmarks}}}%
	\edef\cCIEP{\@ifundefined{type@\ctype @CIEPmarks}{\@ifundefined{type@\ctype @CIEP}{0}{\@nameuse{type@\ctype @CIEP}}}{\@nameuse{type@\ctype @CIEPmarks}}}%
	\edef\cSEEL{\@ifundefined{type@\ctype @SEELmarks}{\@ifundefined{type@\ctype @SEEL}{0}{\@nameuse{type@\ctype @SEEL}}}{\@nameuse{type@\ctype @SEELmarks}}}%
	\edef\cSEEP{\@ifundefined{type@\ctype @SEEPmarks}{\@ifundefined{type@\ctype @SEEP}{0}{\@nameuse{type@\ctype @SEEP}}}{\@nameuse{type@\ctype @SEEPmarks}}}%
	
	\def\zeroval{0}%
	\ifx\cCIEP\zeroval \edef\cCIEDisplay{\cCIEL} \else \edef\cCIEDisplay{ \cCIEP} \fi
	\ifx\cSEEP\zeroval \edef\cSEEDisplay{\cSEEL} \else \edef\cSEEDisplay{\cSEEP} \fi
	
	% --- Build the Guidelines table body (if this credit type has any
	%     \guideline{} points), resolving per-course \GLoverride<Letter>{}
	%     text over the credit-type's master text, same override pattern as
	%     CIE rubrics. Done here (normal execution) rather than inside the
	%     \expanded{} block below, so \GLrubric's internal \unexpanded{}
	%     protection works the same way \CIEtablebody's does. ---
	\gdef\GLtablebody{}%
	\@ifundefined{master@\ctype @GL@totalcount}{}{%
		\edef\maxglrows{\@nameuse{master@\ctype @GL@totalcount}}%
		\@GLloop{1}{\maxglrows}{\romannumeral#2}{\ctype}%
	}%
	
	\def\cCIEMarksLabel{\space Marks} % <--- Default state
	\def\cSEEMarksLabel{\space Marks} % <--- Default state
	\def\cSEEHrsLabel{\space Hours} % <--- Default state
	% --- BRIDGE COURSE OVERRIDE ---
	\edef\checkCat{\@ifundefined{course@sem\lsem @\romannumeral#2@category}{}{\@nameuse{course@sem\lsem @\romannumeral#2@category}}}%
	\def\targetCat{Category: Bridge Course}%
	\ifx\checkCat\targetCat
	\def\cSEEDisplay{---}%
	\def\cSEEDur{---}%
	\def\cSEEMarksLabel{} % <--- Empties the word "Marks" for Bridge Courses
	\def\cSEEHrsLabel{} % <--- Empties the word "Marks" for Bridge Courses
	\fi
	% ------------------------------
	% --- NPTEL OVERRIDE: CIE marks are always shown as NA. SEE marks, CIE/SEE
	%     durations, credits, and pedagogical hours are taken as-is from the
	%     credit definitions file (no override). ---
	\ifx\course@basetype\NPTEL
	\def\cCIEDisplay{NA}%
	\def\cCIEMarksLabel{} % <--- Empties the word "Marks" so CIE shows as plain NA
	\fi
	% ------------------------------
	
	\edef\cStr{\@ifundefined{course@sem\lsem @\romannumeral#2@stream}{}{\@nameuse{course@sem\lsem @\romannumeral#2@stream}}}%
	\edef\cCommon{\@ifundefined{course@sem\lsem @\romannumeral#2@commonto}{}{\@nameuse{course@sem\lsem @\romannumeral#2@commonto}}}%
	\def\emptyVal{}%
	
	\ifx\cStr\emptyVal
	\ifx\cCommon\emptyVal
	\def\CombinedStr{}%
	\else
	\edef\CombinedStr{\cCommon}%
	\fi
	\else
	\ifx\cCommon\emptyVal
	\edef\CombinedStr{Stream: \cStr}%
	\else
	\edef\CombinedStr{Stream: \cStr\quad\cCommon}%
	\fi
	\fi
	
	\ifx\CombinedStr\emptyVal
	\def\CombinedRowOut{}%
	\else
	\def\CombinedRowOut{% 
		\unexpanded{\\[-0.5em] \multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}}%
		{\unexpanded{\centering}{\unexpanded{\textbf}{\unexpanded\expandafter{\CombinedStr}}}}%
	}%
	\fi
	
	\def\cTypeStr{}%
	\ifx\course@basetype\lo \def\cTypeStr{(Theory)}\fi
	\ifx\course@basetype\lt \def\cTypeStr{(Theory)}\fi
	\ifx\course@basetype\po \def\cTypeStr{(Practical)}\fi
	\ifx\course@basetype\lp \def\cTypeStr{(Theory \& Practical)}\fi
	\ifx\course@basetype\NPTEL \def\cTypeStr{(Theory-MooC)}\fi
	
	\edef\checkCat{\@ifundefined{course@sem\lsem @\romannumeral#2@category}{}{\@nameuse{course@sem\lsem @\romannumeral#2@category}}}%
	\def\targetAE{Category: AE}%
	\ifx\checkCat\targetAE \def\PrintCat{Category: AE Course}\else\let\PrintCat\checkCat\fi
	
	\ifx\cTypeStr\emptyVal
	\def\TypeRowOut{}%
	\else
	\def\TypeRowOut{% 
		\unexpanded{\\[-0.5em] \multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}}%
		{\unexpanded{\centering}{\unexpanded{\textbf}{\unexpanded\expandafter{\cTypeStr}}}}%
	}%
	\fi
	
	\@ifundefined{course@sem\lsem @\romannumeral#2@allunits}{\def\cAllUnits{}}{\expandafter\let\expandafter\cAllUnits\csname course@sem\lsem @\romannumeral#2@allunits\endcsname}%
	\@ifundefined{course@sem\lsem @\romannumeral#2@allpracticals}{\def\cAllPracs{\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{\textbf{??}} \\ }}{\expandafter\let\expandafter\cAllPracs\csname course@sem\lsem @\romannumeral#2@allpracticals\endcsname}%
	
	% --- NEW: DYNAMIC PREREQUISITE ROW BUILDER ---
	\@ifundefined{course@sem\lsem @\romannumeral#2@prerequisites}{%
		\def\captured@prerequest{}%
	}{%
		\expandafter\let\expandafter\cPrereq\csname course@sem\lsem @\romannumeral#2@prerequisites\endcsname
		
		% --- THE FIX: SAFELY BUILD THE ROW USING TOKENS ---
		\toks0={\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}}%
		\toks1={\textbf{Pre-Requisites: } }%
		\toks2=\expandafter{\cPrereq}%
		
		\edef\captured@prerequest{%
			\the\toks0 {\the\toks1 \the\toks2} \unexpanded{ \\ }%
		}%
	}%
	% ---------------------------------------------
	
	\hypertarget{course\lsem\romannumeral#2}{}% 
	\label{course\lsem\romannumeral#2}%
	\begingroup
	\def\@scartchlectable##1{%%
		\unexpanded{%
			\hline
			\multicolumn{6}{|p{\dimexpr 0.71\textwidth + 10\tabcolsep + 5\arrayrulewidth \relax}|}%%
		}
		{\unexpanded{
				\centering
			}%%
			{\unexpanded{\textbf{\unexpanded{Unit - \MakeTextUppercase}{\romannumeral##1}}}}
		}%% multicolumn
		\unexpanded{%%
			&%%
			\textbf
		}{%%
			\unexpanded{\expandafter{\getlectureunithour{#2}{##1}}\quad Hours}%%
		}
		\unexpanded{%%
			\\%%
			\hline
			\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}%%
		}{%%
			\unexpanded{\begin{minipage}[t]{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}}
				\unexpanded{\setlist[itemize]{topsep=4pt,itemsep=0.125em}}
				\unexpanded{\expandafter{\getlectureunitcontent{#2}{##1}}}
				\unexpanded{\vspace*{0.5ex}}
				\unexpanded{\end{minipage}}
		}%%
		\unexpanded{%
			\\%%
		}%%
	}%% End of scartctable
	\def\@scartchpraceltable##1{%%
		\unexpanded{%%
			\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{%
				\setlength{\leftskip}{1.5em}\noindent\hspace*{-1.5em}\makebox[1.1em][r]{##1.}\hspace{0.4em}{\getpracticeelunitcontent{#2}{##1}}\par
			} \\
		}%%
	}%% End of scartctable
	\def\@scartchoutcometable##1{%%
		\unexpanded{%%
			\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{%
				\setlength{\leftskip}{1.5em}\noindent\hspace*{-0.5em}\makebox[1.1em][r]{CO##1:}\hspace{0.4em}{\getcourseco{#2}{##1}}\par
			} \\
		}%%
	}%% End of scartctable
	\def\@scartchreftable##1{%%
		\unexpanded{%%
			\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}{%
				\setlength{\leftskip}{2.2em}\noindent\hspace*{-2.2em}\makebox[1.8em][r]{[##1]}\hspace{0.4em}{\getcourseref{#2}{##1}}\par
			} \\
		}%%
	}%% End of scartctable
	
	% --- NEW: CONDITIONAL SEMESTER ROW ---
	\def\zeroVal{0}%
	\ifx\lsem\zeroVal
	\def\SemesterRowOut{}% Removes row if lsem is 0
	\else
	\def\SemesterRowOut{%
		\unexpanded{\multicolumn{7}{|c|}{\textbf{Semester - \printsemester}} \\ \hline}%
	}%
	\fi
	
	\expanded{%%
		\endgroup
		\unexpanded{%%
			\vspace*{-2.5em}
			\begin{longtable}{|p{0.32\textwidth}|p{0.01\textwidth}|p{0.12\textwidth}p{0.02\textwidth}|p{0.18\textwidth}|p{0.01\textwidth}|p{0.15\textwidth}|}%%
				\hline
				\endfirsthead
				\hline
				\endhead
				\hline
				\endfoot
				\hline
				\endlastfoot
			}%
			\SemesterRowOut
			\unexpanded{%%
				\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}%
			}%
			{
				\unexpanded{
					\centering
				}%%
				{
					\unexpanded{
						\textbf
					}
					{\unexpanded\expandafter{\csname course@sem\lsem @\romannumeral#2@coursetitle\endcsname}}
				}%% centering
			}%% for multicolumn
			\unexpanded{%%
				\\[-0.5em]%%
				\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}%%
			}%%
			{
				\unexpanded{
					\centering
				}%%
				{
					\unexpanded{
						\textbf
					}
					{\unexpanded\expandafter{\PrintCat}}
				}%% centering
			}%% for multicolumn
			\CombinedRowOut
			\TypeRowOut
			\unexpanded{%%
				\\%%
				\hline%%
				\textbf{Course Code}&\textbf{:}&\space\MakeTextUppercase{\csname course@sem\lsem @\romannumeral#2@coursecode\endcsname} & & \textbf{CIE} & \textbf{:}&\space}\cCIEDisplay\unexpanded\expandafter{\cCIEMarksLabel}\unexpanded{\\%%
				\hline%%
				\textbf{Credit distribution L:T:P}&\textbf{:}&\space}\cL:\cT:\cP\unexpanded{ & & \textbf{SEE} & \textbf{:}&\space}\cSEEDisplay\unexpanded\expandafter{\cSEEMarksLabel}\unexpanded{\\%%
				\hline%%
				\textbf{Pedagogical Hours (L:T:P:S)}&\textbf{:}&\space}\cLdur:\cTdur:\cPdur:\cSdur\unexpanded{ & & \textbf{CIE Duration} & \textbf{:}&\space}\cCIEDur\unexpanded{\space Hours\\%%
				\hline%%
				\textbf{Total credits:}& \textbf{:}&\space}\cTotCreds\unexpanded{ & & \textbf{SEE Duration} & \textbf{:}&\space}\cSEEDur\unexpanded\expandafter{\cSEEHrsLabel}\unexpanded{\\%%
				\hline%%
			}
			\unexpanded\expandafter{\captured@prerequest}
			\iflecture%%
			\ifnum#3<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
			{
				\unexpanded\expandafter{\cAllUnits}%% 
			}
			\fi
			\ifpractice%%
			\ifnum#4<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
			{
				\unexpanded{\hline}
				\unexpanded\expandafter{\cAllPracs}%% 
			}
			\fi
			\ifpracticeel%%
			\ifnum#5<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
			{
				\unexpanded{%%
					\hline
					\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}%%
				}
				{
					\unexpanded{
						\textbf
					}%%
					{\unexpanded{\expandafter{\space\csname course@sem\lsem @\romannumeral#2@practiceeltitle\endcsname}}}
				}%% multicolumn
				\unexpanded{%%
					\\ \hline
				}
				\expandafter\@pracelloop\expandafter{\number\numexpr(1)\expandafter\relax\expandafter}{\number\numexpr(#5)\relax}%%
			}
			\fi
			\ifnum#7<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
			{
				\unexpanded{%%
					\hline
					\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}%%
				}
				{
					\unexpanded{
						\textbf
					}%%
					{\unexpanded{\space Course Outcomes: After completing the course, the students will be able to:}}
				}%% multicolumn
				\unexpanded{%%
					\\ \hline
				}
				\expandafter\@outcomeloop\expandafter{\number\numexpr(1)\expandafter\relax\expandafter}{\number\numexpr(#7)\relax}%%
			}
			\ifnum#6<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
			{
				\unexpanded{%%
					\hline
					\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}%%
				}
				{
					\unexpanded{
						\textbf
					}%%
					{\unexpanded{\space References}}
				}%% multicolumn
				\unexpanded{%%
					\\ \hline
				}
				\expandafter\@refloop\expandafter{\number\numexpr(1)\expandafter\relax\expandafter}{\number\numexpr(#6)\relax}%%
			}
			% --- NPTEL: General Guidelines merged into this same table ---
			\ifx\course@basetype\NPTEL
			\unexpanded{%%
				\hline
				\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}%%
			}
			{
				\unexpanded{
					\textbf
				}%%
				{\unexpanded{\space General Guidelines}}
			}%% multicolumn
			\unexpanded{%%
				\\ \hline
			}
			\@ifundefined{master@\ctype @GL@totalcount}{%
				% --- Older credit definitions with no per-letter master data yet:
				%     fall back to the combined-list / single-paragraph forms ---
				\@ifundefined{type@\ctype @guidelines}{%
					\@ifundefined{type@\ctype @guideline}{}{%
						\unexpanded{%%
							\multicolumn{7}{|p{\dimexpr 0.8\textwidth + 12\tabcolsep + 6\arrayrulewidth \relax}|}%%
						}
						{
							\unexpanded\expandafter{\csname type@\ctype @guideline\endcsname}
						}%% multicolumn
						\unexpanded{%%
							\\
						}
					}%
				}{%
					\@nameuse{type@\ctype @guidelines}%
				}%
			}{%
				% --- One or more \guideline{} points, one row each, no rule
				%     between them, with per-course \GLoverride<Letter>{}
				%     overrides already resolved by \@GLloop above. ---
				\GLtablebody
			}%
			\fi
			\unexpanded{
				\hline
			\end{longtable}%%
		}
		\unexpanded{%
			\drawCIEtable{#2}%
			\drawSEEtable{#2}%
		}
		
		\unexpanded{
			\pagebreak
		}
	}%%
}

\def\@lecloop#1#2{\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{\@scartchlectable{#1}\expandafter\@lecloop\expandafter{\number\numexpr#1+1}{#2}}}
\def\@pracloop#1#2{\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{\@scartchpractable{#1}\expandafter\@pracloop\expandafter{\number\numexpr#1+1}{#2}}}
\def\@pracelloop#1#2{\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{\@scartchpraceltable{#1}\expandafter\@pracelloop\expandafter{\number\numexpr#1+1}{#2}}}
\def\@refloop#1#2{\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{\@scartchreftable{#1}\expandafter\@refloop\expandafter{\number\numexpr#1+1}{#2}}}
\def\@outcomeloop#1#2{\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{\@scartchoutcometable{#1}\expandafter\@outcomeloop\expandafter{\number\numexpr#1+1}{#2}}}

%% --- PAGE NUMBER EXTRACTION ---
\def\Pgnum#1{%%
	\@ifundefined{course@sem\lsem @\romannumeral#1@pgnum}%%
	{\mbox{\normalfont\bfseries ??}}%%
	{\csname course@sem\lsem @\romannumeral#1@pgnum\endcsname}
}

\def\PgnumOrig#1#2{%%
	\@ifundefined{course@sem#1@#2@pgnum}%%
	{\mbox{\normalfont\bfseries ??}}%%
	{\csname course@sem#1@#2@pgnum\endcsname}
}

\gdef\toctablecontent{} % <--- Initializes the empty container

\newcommand{\tocindextable}[1]{%%
	\begingroup
	\setcounter{toc@print@ctr}{0}%
	\gdef\toctablecontent{}% <--- Empties the container for the new table
	
	% --- RUN THE LOOP HERE (OUTSIDE THE TABLE) ---
	\ifnum#1<1 \expandafter\@gobble\else\expandafter\@firstofone\fi
	{\expandafter\@tocloop\expandafter{\number\numexpr(1)\expandafter\relax\expandafter}{#1}}
	
%	\begin{longtable}{|>{\centering\arraybackslash}p{0.08\textwidth}|>{\centering\arraybackslash}p{0.2\textwidth}|>{\raggedright\arraybackslash}p{0.54\textwidth}|>{\centering\arraybackslash}p{0.08\textwidth}|}
	\begin{longtable}{|>{\centering\arraybackslash}p{0.08\linewidth}|>{\centering\arraybackslash}p{0.18\linewidth}|p{0.55\linewidth}|>{\centering\arraybackslash}p{0.12\linewidth}|}
		\hline
		\multicolumn{4}{|c|}{\textbf{Semester - \printsemester}} \\ \hline
		\textbf{Sl. No.} & \textbf{Course Code} & \multicolumn{1}{c|}{\textbf{Course Title}} & \textbf{Page No.} \\ \hline
		\endfirsthead
		
		\hline
		\multicolumn{4}{|c|}{\textbf{Semester - \printsemester\space (Continued)}} \\ \hline
		\textbf{Sl. No.} & \textbf{Course Code} & \multicolumn{1}{c|}{\textbf{Course Title}} & \textbf{Page No.} \\ \hline
		\endhead
		
		\hline
		\endfoot
		
		\endlastfoot
		
		\toctablecontent % <--- DROP THE CLEAN, PRE-BUILT ROWS HERE
		
	\end{longtable}
	\endgroup
}

\def\@tocloop#1#2{\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{\PrintTOCRow{#1}\expandafter\@tocloop\expandafter{\number\numexpr#1+1}{#2}}}

\newcommand{\PrintTOCRow}[1]{%
	\edef\croman{\romannumeral#1}%
	\edef\cgrole{\@ifundefined{course@sem\lsem @\croman @cg@role}{none}{\@nameuse{course@sem\lsem @\croman @cg@role}}}%
	\def\rolef{follower}%
	\def\roleskf{skfollower}%
	\def\roleskl{skleader}%
	\ifx\cgrole\rolef
	\else\ifx\cgrole\roleskf
	\else\ifx\cgrole\roleskl
	\else
	\stepcounter{toc@print@ctr}%
	
	\def\rolel{leader}%
	\def\roleegl{egleader}%
	\ifx\cgrole\rolel
	\expandafter\let\expandafter\ccode\csname course@sem\lsem @\croman @cg@codes\endcsname
	\expandafter\let\expandafter\ctitle\csname course@sem\lsem @\croman @cg@titles\endcsname
	\else\ifx\cgrole\roleegl
	\expandafter\let\expandafter\rawccode\csname course@sem\lsem @\croman @cg@codes\endcsname
	\edef\ccode{\noexpand\MakeTextUppercase{\unexpanded\expandafter{\rawccode}}}%
	\expandafter\let\expandafter\ctitle\csname course@sem\lsem @\croman @cg@titles\endcsname
	\else
	\@ifundefined{course@sem\lsem @\croman @coursecode}{\def\ccode{---}}{\expandafter\let\expandafter\rawccode\csname course@sem\lsem @\croman @coursecode\endcsname \edef\ccode{\noexpand\MakeTextUppercase{\unexpanded\expandafter{\rawccode}}}}%
	\@ifundefined{course@sem\lsem @\croman @coursetitle}{\def\ctitle{---}}{\expandafter\let\expandafter\ctitle\csname course@sem\lsem @\croman @coursetitle\endcsname}%
	\fi\fi
	
	% --- THE LOOK-AHEAD PAGE NUMBER LOGIC (UP TO 3 COURSES) ---
	\def\true@str{true}%
	\edef\isstar{\@ifundefined{course@sem\lsem @\croman @isstar}{false}{\@nameuse{course@sem\lsem @\croman @isstar}}}%
	\ifx\isstar\true@str
	\edef\rawleadercode{\@nameuse{course@sem\lsem @\croman @coursecode}}%
	\edef\origsem{\@ifundefined{course@originsem@\rawleadercode}{1}{\@nameuse{course@originsem@\rawleadercode}}}%
	\edef\origcidx{\@ifundefined{course@origincidx@\rawleadercode}{i}{\@nameuse{course@origincidx@\rawleadercode}}}%
	\edef\cpage{\noexpand\pageref{course\origsem\origcidx}}%
	\else
	\edef\cpage{\noexpand\pageref{course\lsem\croman}}%
	\fi
	
	\ifx\cgrole\rolel
	\edef\nextroman{\romannumeral\numexpr#1+1\relax}%
	\edef\nextrole{\@ifundefined{course@sem\lsem @\nextroman @cg@role}{none}{\@nameuse{course@sem\lsem @\nextroman @cg@role}}}%
	
	\ifx\nextrole\rolef
	\edef\nextisstar{\@ifundefined{course@sem\lsem @\nextroman @isstar}{false}{\@nameuse{course@sem\lsem @\nextroman @isstar}}}%
	\ifx\nextisstar\true@str
	\edef\rawnextcode{\@nameuse{course@sem\lsem @\nextroman @coursecode}}%
	\edef\origsemnext{\@ifundefined{course@originsem@\rawnextcode}{1}{\@nameuse{course@originsem@\rawnextcode}}}%
	\edef\origcidxnext{\@ifundefined{course@origincidx@\rawnextcode}{i}{\@nameuse{course@origincidx@\rawnextcode}}}%
	\edef\cpage{\cpage\space / \noexpand\pageref{course\origsemnext\origcidxnext}}%
	\else
	\edef\cpage{\cpage\space / \noexpand\pageref{course\lsem\nextroman}}%
	\fi
	
	\edef\thirdroman{\romannumeral\numexpr#1+2\relax}%
	\edef\thirdrole{\@ifundefined{course@sem\lsem @\thirdroman @cg@role}{none}{\@nameuse{course@sem\lsem @\thirdroman @cg@role}}}%
	
	\ifx\thirdrole\rolef
	\edef\thirdisstar{\@ifundefined{course@sem\lsem @\thirdroman @isstar}{false}{\@nameuse{course@sem\lsem @\thirdroman @isstar}}}%
	\ifx\thirdisstar\true@str
	\edef\rawthirdcode{\@nameuse{course@sem\lsem @\thirdroman @coursecode}}%
	\edef\origsemthird{\@ifundefined{course@originsem@\rawthirdcode}{1}{\@nameuse{course@originsem@\rawthirdcode}}}%
	\edef\origcidxthird{\@ifundefined{course@origincidx@\rawthirdcode}{i}{\@nameuse{course@origincidx@\rawthirdcode}}}%
	\edef\cpage{\cpage\space / \noexpand\pageref{course\origsemthird\origcidxthird}}%
	\else
	\edef\cpage{\cpage\space / \noexpand\pageref{course\lsem\thirdroman}}%
	\fi
	\fi
	\fi
	\fi
	
	\toks0=\expandafter{\toctablecontent}%
	\toks1=\expandafter{\ccode}%
	\toks2=\expandafter{\ctitle}%
	\edef\temp{\the\toks0 \arabic{toc@print@ctr} & \noexpand\MakeTextUppercase{\the\toks1} & \the\toks2 & \cpage \noexpand\\ \noexpand\hline}%
	\global\let\toctablecontent\temp
	\fi\fi\fi
}

\newcounter{tot@semester@credits}
\def\@calcCrdloop#1#2{\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{\CalcCourseRow{#1}\expandafter\@calcCrdloop\expandafter{\number\numexpr#1+1}{#2}}}

\newcommand{\CalcCourseRow}[1]{%
	\edef\croman{\romannumeral#1}%
	\edef\cgrole{\@ifundefined{course@sem\lsem @\croman @cg@role}{none}{\@nameuse{course@sem\lsem @\croman @cg@role}}}%
	\def\rolef{follower}%
	\def\roleskf{skfollower}%
	\ifx\cgrole\rolef
	\else\ifx\cgrole\roleskf
	\else
	\@ifundefined{course@sem\lsem @\croman @coursetype}{\def\ctype{UNKNOWN}}{\edef\ctype{\@nameuse{course@sem\lsem @\croman @coursetype}}}% 
	\@ifundefined{type@\ctype @L}{\def\cL{0}}{\edef\cL{\@nameuse{type@\ctype @L}}}%
	\@ifundefined{type@\ctype @T}{\def\cT{0}}{\edef\cT{\@nameuse{type@\ctype @T}}}%
	\@ifundefined{type@\ctype @P}{\def\cP{0}}{\edef\cP{\@nameuse{type@\ctype @P}}}%
	
	\edef\checkCat{\@ifundefined{course@sem\lsem @\croman @category}{}{\@nameuse{course@sem\lsem @\croman @category}}}%
	\def\targetCat{Category: Bridge Course}%
	\ifx\checkCat\targetCat
	% Skip adding credits for BC
	\else
	\global\addtocounter{tot@semester@credits}{\cL}%
	\global\addtocounter{tot@semester@credits}{\cT}%
	\global\addtocounter{tot@semester@credits}{\cP}%
	\fi
	\fi\fi
}

\gdef\maintablecontent{}

\gdef\maintablecontent{}
\newif\ifschemetablestarted
\schemetablestartedfalse
\newif\ifschemefooterpending
\schemefooterpendingfalse
\gdef\hasaudit{0}

% --- Prints the college logo block. Called once per PAGE (not once per
%     semester), right when a fresh page actually starts. ---
\newcommand{\schemelogoblock}{%
	\vspace*{-0.6in}%
	\begin{longtable}{|>{\centering\arraybackslash}p{0.03\linewidth}|>{\centering\arraybackslash}p{0.1\linewidth}|>{\centering\arraybackslash}p{0.28\linewidth}|>{\centering\arraybackslash}p{0.04\linewidth}|>{\centering\arraybackslash}p{0.02\linewidth}|>{\centering\arraybackslash}p{0.02\linewidth}|>{\centering\arraybackslash}p{0.02\linewidth}|>{\centering\arraybackslash}p{0.03\linewidth}|>{\centering\arraybackslash}p{0.09\linewidth}|>{\centering\arraybackslash}p{0.065\linewidth}|>{\centering\arraybackslash}p{0.05\linewidth}|>{\centering\arraybackslash}p{0.05\linewidth}|>{\centering\arraybackslash}p{0.065\linewidth}|>{\centering\arraybackslash}p{0.05\linewidth}|>{\centering\arraybackslash}p{0.05\linewidth}|}
		\multicolumn{15}{c}{%
			\begin{minipage}{\linewidth}
				\begin{minipage}[c]{0.15\linewidth}
					\includegraphics[height=1.5cm]{./Images/LogoL}
				\end{minipage}\hfill
				\begin{minipage}[c]{0.95\linewidth}
					\raggedleft\includegraphics[height=1.5cm]{./Images/LogoR}
				\end{minipage}
			\end{minipage}
		} \\[2ex]
	\end{longtable}
}

% --- Prints the "Note: 1 Credit = ..." block (plus the audit-star note and
%     any sklab instruction), pushed to the bottom of the page via \vfill.
%     Called once per PAGE (not once per semester) -- specifically, right
%     before a page actually ends (either because the next semester's
%     table is moving to a fresh page, or because we've reached the very
%     last semester overall). \ifschemefooterpending guards against
%     printing it twice or printing an empty one when nothing is pending. ---
\newcommand{\schemefooterflush}{%
	\ifschemefooterpending
		\begingroup
		\small
		\vfill % Pushes everything below this to the very bottom of the page
		\noindent\makebox[\linewidth][l]{%
			\raisebox{-0.4cm}[0pt][0pt]{%
				\begin{minipage}{\linewidth}
					\noindent\rule{5cm}{0.2pt}\par\vspace{0.25em}
					\noindent\textbf{Note:}\space
					\edef\valL{\the\numexpr \global@Lcredmul * \global@wkspercred \relax}%
					\edef\valT{\the\numexpr \global@Tcredmul * \global@wkspercred \relax}%
					\edef\valP{\the\numexpr \global@Pcredmul * \global@wkspercred \relax}%
					1 Credit = \valT\ hrs (L:T:P)\par\vspace{0.5em}
					\ifnum\hasaudit=1
					\noindent $^{\star}$ Audit\par\vspace{0.25em}
					\fi
					\@ifundefined{global@sklabinstruction}{}{%
						\ifx\global@sklabinstruction\@empty\else
						\par\vspace{0.5em}\noindent
						\global@sklabinstruction
						\fi
					}%
				\end{minipage}%
			}%
		}\par
		\global\schemefooterpendingfalse
		\gdef\hasaudit{0}%
		\endgroup
	\fi
}

\newcommand{\mainindextable}[1]{%%
	\setcounter{tot@semester@credits}{0}%
	\setcounter{tot@semester@L}{0}%
	\setcounter{tot@semester@T}{0}%
	\setcounter{tot@semester@P}{0}%
	\setcounter{main@print@ctr}{0}%
	\gdef\maintablecontent{}%
	
	\ifnum#1<1\relax\else
	\@calcCrdloop{1}{#1}%
	\@mainloop{1}{#1}%
	\fi
	
	\begingroup
	\small
	\setlength{\tabcolsep}{3pt}% 
	\setlength{\LTleft}{-1cm}% 
	\setlength{\LTright}{0pt plus 1fill}%
	\renewcommand{\thefootnote}{\ensuremath{\star}}% 
	
	\pagestyle{fancy} %
	\ifschemetablestarted
		% Not the first semester's scheme table: fit it on the current page
		% if there's room for it, otherwise move to a fresh page. The
		% estimate is roughly 1 line of overhead (title/header rows) per
		% course row, plus a fixed overhead for the logo block and column
		% headers. Compared directly against remaining page space rather
		% than via \needspace, which can misjudge the space right before
		% a longtable.
		\edef\schemeneededlines{\number\numexpr 10+1*#1\relax}%
		\ifdim\dimexpr\pagegoal-\pagetotal\relax<\schemeneededlines\baselineskip
			% Doesn't fit: flush the outgoing page's footer (Note/audit/
			% instruction block) before leaving it, then start fresh.
			\schemefooterflush
			\clearpage
			\schemelogoblock
		\fi
	\else
		\clearpage
		\global\schemetablestartedtrue
		\schemelogoblock
	\fi
	\begin{longtable}{|>{\centering\arraybackslash}p{0.03\linewidth}|>{\centering\arraybackslash}p{0.1\linewidth}|>{\centering\arraybackslash}p{0.28\linewidth}|>{\centering\arraybackslash}p{0.04\linewidth}|>{\centering\arraybackslash}p{0.02\linewidth}|>{\centering\arraybackslash}p{0.02\linewidth}|>{\centering\arraybackslash}p{0.02\linewidth}|>{\centering\arraybackslash}p{0.03\linewidth}|>{\centering\arraybackslash}p{0.09\linewidth}|>{\centering\arraybackslash}p{0.065\linewidth}|>{\centering\arraybackslash}p{0.05\linewidth}|>{\centering\arraybackslash}p{0.05\linewidth}|>{\centering\arraybackslash}p{0.065\linewidth}|>{\centering\arraybackslash}p{0.05\linewidth}|>{\centering\arraybackslash}p{0.05\linewidth}|}
		\hline
		\multicolumn{15}{|c|}{\textbf{\@schemeYear\space Scheme template -- \@graduateLabel\space Programs}} \\ \hline
		\multicolumn{15}{|c|}{\textbf{\@graduateDegree$~$in \@graduateCourse--Department of \@departmentLF\space (\@departmentSF)}} \\ \hline
		\multicolumn{15}{|c|}{\textbf{\printsemester\space SEMESTER}} \\ \hline
		
		\multirow{2}{*}{\textbf{Sl.}} & 
		\multirow{2}{*}{\textbf{Course Code}} & 
		\multirow{2}{*}{\textbf{Course Title}} & 
		\multirow{2}{*}{\textbf{BoS}} & 
		\multicolumn{4}{c|}{\textbf{Credit Allocation}} & 
		\multirow{2}{*}{\textbf{Category}} & 
		\multirow{2}{*}{\shortstack{\textbf{CIE}\\\textbf{Duration}\\\textbf{(Hrs)}}} & 
		\multicolumn{2}{c|}{\textbf{Max Marks CIE}} & 
		\multirow{2}{*}{\shortstack{\textbf{SEE}\\\textbf{Duration}\\\textbf{(Hrs)}}} & 
		\multicolumn{2}{c|}{\textbf{Max Marks SEE}} \\ \cline{5-8} \cline{11-12} \cline{14-15}
		
		& & & & \textbf{L} & \textbf{T} & \textbf{P} & \textbf{Total} & & & \textbf{Theory} & \textbf{Lab} & & \textbf{Theory} & \textbf{Lab} \\ \hline
		\endfirsthead
		
		\hline
		\multicolumn{15}{|c|}{\textbf{\printsemester\space SEMESTER (Continued)}} \\ \hline
		\multirow{2}{*}{\textbf{Sl.}} & 
		\multirow{2}{*}{\textbf{Course Code}} & 
		\multirow{2}{*}{\textbf{Course Title}} & 
		\multirow{2}{*}{\textbf{BoS}} & 
		\multicolumn{4}{c|}{\textbf{Credit Allocation}} & 
		\multirow{2}{*}{\textbf{Category}} & 
		\multirow{2}{*}{\shortstack{\textbf{CIE}\\\textbf{Duration}\\\textbf{(H)}}} & 
		\multicolumn{2}{c|}{\textbf{Max Marks CIE}} & 
		\multirow{2}{*}{\shortstack{\textbf{SEE}\\\textbf{Duration}\\\textbf{(Hrs)}}} & 
		\multicolumn{2}{c|}{\textbf{Max Marks SEE}} \\ \cline{5-8} \cline{11-12} \cline{14-15}
		
		& & & & \textbf{L} & \textbf{T} & \textbf{P} & \textbf{Total} & & & \textbf{Theory} & \textbf{Lab} & & \textbf{Theory} & \textbf{Lab} \\ \hline
		\endhead
		
		\hline
		\multicolumn{15}{|l|}{\footnotesize\textbf{Note:} 1 Credit = \the\numexpr\global@Tcredmul*\global@wkspercred\relax\ hrs (L:T:P)\ifnum\hasaudit=1\space $^{\star}$\space Audit\fi} \\ \hline
		\endfoot
		\endlastfoot
		
		\maintablecontent
		
		\multicolumn{4}{|r|}{\textbf{Total}} & \textbf{\arabic{tot@semester@L}} & \textbf{\arabic{tot@semester@T}} & \textbf{\arabic{tot@semester@P}} & \textbf{\arabic{tot@semester@credits}} & \multicolumn{7}{c|}{} \\ \hline
	\end{longtable}
	
	% This page now has content waiting for its one-time footer; the
	% footer itself is printed later by \schemefooterflush, either when
	% the next semester needs a fresh page or at the very end of the
	% scheme-table section.
	\global\schemefooterpendingtrue
	
	\normalsize
	\endgroup
}

\def\@mainloop#1#2{\ifnum#1>#2 \expandafter\@gobble\else\expandafter\@firstofone\fi{\PrintCourseRow{#1}\expandafter\@mainloop\expandafter{\number\numexpr#1+1}{#2}}}

\newcommand{\PrintCourseRow}[1]{%
	\edef\croman{\romannumeral#1}%
	\edef\cgrole{\@ifundefined{course@sem\lsem @\croman @cg@role}{none}{\@nameuse{course@sem\lsem @\croman @cg@role}}}%
	\def\rolef{follower}%
	\def\roleskf{skfollower}%
	\ifx\cgrole\rolef
	\else\ifx\cgrole\roleskf
	\else
	\stepcounter{main@print@ctr}%
	\@ifundefined{course@sem\lsem @\croman @coursetype}{\def\ctype{UNKNOWN}}{\edef\ctype{\@nameuse{course@sem\lsem @\croman @coursetype}}}% 
	
	\@ifundefined{type@\ctype @L}{\def\cL{0}}{\edef\cL{\@nameuse{type@\ctype @L}}}%
	\@ifundefined{type@\ctype @T}{\def\cT{0}}{\edef\cT{\@nameuse{type@\ctype @T}}}%
	\@ifundefined{type@\ctype @P}{\def\cP{0}}{\edef\cP{\@nameuse{type@\ctype @P}}}%
	
	\addtocounter{tot@semester@L}{\cL}%
	\addtocounter{tot@semester@T}{\cT}%
	\addtocounter{tot@semester@P}{\cP}%
	
	\@ifundefined{type@\ctype @CIELmarks}{\@ifundefined{type@\ctype @CIEL}{\def\cCIEL{0}}{\edef\cCIEL{\@nameuse{type@\ctype @CIEL}}}}{\edef\cCIEL{\@nameuse{type@\ctype @CIELmarks}}}%
	\@ifundefined{type@\ctype @CIEPmarks}{\@ifundefined{type@\ctype @CIEP}{\def\cCIEP{0}}{\edef\cCIEP{\@nameuse{type@\ctype @CIEP}}}}{\edef\cCIEP{\@nameuse{type@\ctype @CIEPmarks}}}%
	\@ifundefined{type@\ctype @SEELmarks}{\@ifundefined{type@\ctype @SEEL}{\def\cSEEL{0}}{\edef\cSEEL{\@nameuse{type@\ctype @SEEL}}}}{\edef\cSEEL{\@nameuse{type@\ctype @SEELmarks}}}%
	\@ifundefined{type@\ctype @SEEPmarks}{\@ifundefined{type@\ctype @SEEP}{\def\cSEEP{0}}{\edef\cSEEP{\@nameuse{type@\ctype @SEEP}}}}{\edef\cSEEP{\@nameuse{type@\ctype @SEEPmarks}}}%
	
	\@ifundefined{type@\ctype @CIEdur}{\def\cCIEDur{---}}{\edef\cCIEDur{\@nameuse{type@\ctype @CIEdur}}}%
	\@ifundefined{type@\ctype @SEEdur}{\def\cSEEDur{---}}{\edef\cSEEDur{\@nameuse{type@\ctype @SEEdur}}}%
	
	% --- DYNAMIC CATEGORY DETECTION ---
	\ifnum\cP>0
	\ifnum\cL>0 \def\CatStr{Theory+Lab}\else \def\CatStr{Lab}\fi
	\else
	\def\CatStr{Theory}%
	\fi
	\ifx\ctype\NPTEL \def\CatStr{Theory (MooC)}\fi
	
	% --- ZERO TO STAR CONVERSION ---
	\def\zeroval{0}%
	\ifx\cCIEL\zeroval \def\cCIELstr{***}\else\def\cCIELstr{\cCIEL}\fi
	\ifx\cCIEP\zeroval \def\cCIEPstr{***}\else\def\cCIEPstr{\cCIEP}\fi
	\ifx\cSEEL\zeroval \def\cSEELstr{***}\else\def\cSEELstr{\cSEEL}\fi
	\ifx\cSEEP\zeroval \def\cSEEPstr{***}\else\def\cSEEPstr{\cSEEP}\fi
	
	\edef\checkCat{\@ifundefined{course@sem\lsem @\croman @category}{}{\@nameuse{course@sem\lsem @\croman @category}}}%
	\def\targetCat{Category: Bridge Course}%
	\ifx\checkCat\targetCat
	\def\cTot{0\unexpanded{\ensuremath{^{\star}}}}%
	\gdef\hasaudit{1}% <--- Triggers the Audit flag for the footnote block!
	\def\cSEELstr{***}%
	\def\cSEEPstr{***}%
	\def\cSEEDur{---}% 
	\else
	\edef\cTot{\the\numexpr\cL+\cT+\cP\relax}%
	\fi
	
	\def\rolel{leader}%
	\def\roleegl{egleader}%
	\def\roleskl{skleader}%
	\ifx\cgrole\rolel
	\expandafter\let\expandafter\ccode\csname course@sem\lsem @\croman @cg@codes\endcsname
	\expandafter\let\expandafter\ctitle\csname course@sem\lsem @\croman @cg@titles\endcsname
	\expandafter\let\expandafter\cBoS\csname course@sem\lsem @\croman @cg@boses\endcsname
	\else\ifx\cgrole\roleegl
	\expandafter\let\expandafter\rawccode\csname course@sem\lsem @\croman @cg@codes\endcsname
	\edef\ccode{\noexpand\MakeTextUppercase{\unexpanded\expandafter{\rawccode}}}%
	\expandafter\let\expandafter\ctitle\csname course@sem\lsem @\croman @cg@titles\endcsname
	\expandafter\let\expandafter\tempBoS\csname course@sem\lsem @\croman @cg@boses\endcsname
	\def\emptyBoS{}%
	\ifx\tempBoS\emptyBoS \edef\cBoS{\cDept}\else \expandafter\let\expandafter\cBoS\csname course@sem\lsem @\croman @cg@boses\endcsname\fi
	\else\ifx\cgrole\roleskl
	\expandafter\let\expandafter\rawccode\csname course@sem\lsem @\croman @cg@codes\endcsname
	\edef\ccode{\noexpand\MakeTextUppercase{\unexpanded\expandafter{\rawccode}}}%
	\expandafter\let\expandafter\ctitle\csname course@sem\lsem @\croman @cg@titles\endcsname
	\expandafter\let\expandafter\tempBoS\csname course@sem\lsem @\croman @cg@boses\endcsname
	\def\emptyBoS{}%
	\ifx\tempBoS\emptyBoS \edef\cBoS{\cDept}\else \expandafter\let\expandafter\cBoS\csname course@sem\lsem @\croman @cg@boses\endcsname\fi
	\else
	\@ifundefined{@departmentSF}{\def\cDept{ECE}}{\edef\cDept{\@departmentSF}}%
	\@ifundefined{course@sem\lsem @\croman @bos}{\edef\cBoS{\cDept}}{%
		\expandafter\let\expandafter\tempBoS\csname course@sem\lsem @\croman @bos\endcsname
		\def\emptyBoS{}%
		\ifx\tempBoS\emptyBoS \edef\cBoS{\cDept}\else \expandafter\let\expandafter\cBoS\csname course@sem\lsem @\croman @bos\endcsname\fi
	}%
	\@ifundefined{course@sem\lsem @\croman @coursecode}{\def\ccode{---}}{\expandafter\let\expandafter\rawccode\csname course@sem\lsem @\croman @coursecode\endcsname \edef\ccode{\noexpand\MakeTextUppercase{\unexpanded\expandafter{\rawccode}}}}%
	\@ifundefined{course@sem\lsem @\croman @coursetitle}{\def\ctitle{---}}{\expandafter\let\expandafter\ctitle\csname course@sem\lsem @\croman @coursetitle\endcsname}%
	\fi\fi\fi
	
	\toks0=\expandafter{\maintablecontent}%
	\toks1=\expandafter{\ccode}%
	\toks2=\expandafter{\ctitle}%
	\toks3=\expandafter{\cBoS}%
	\toks4=\expandafter{\cTot}%
	\edef\temp{\the\toks0 \arabic{main@print@ctr} & \noexpand\MakeTextUppercase{\the\toks1} & \the\toks2 & \the\toks3 & \cL & \cT & \cP & \the\toks4 & \CatStr & \cCIEDur & \cCIELstr & \cCIEPstr & \cSEEDur & \cSEELstr & \cSEEPstr \noexpand\\ \noexpand\hline}%
	\global\let\maintablecontent\temp
	\fi\fi
}

\AtEndDocument{

	\ifstandalone
	\setcounter{semester@temp@ctr}{1}
	\setcounter{course@temp@ctr}{1}
	\else
	\setcounter{semester@temp@ctr}{\value{numof@semesters}}
	\setcounter{course@temp@ctr}{\value{numof@courses}}
	\fi
	
	\syllabus@generatetables
	\aftertables
	
	\ifdefined\syllabus@master@rerun@required
	\GenericWarning{(syllabus)\space\space\space\space\space}{*** LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right ***}%
	\typeout{^^J========================================================================^^J%
		\space\space SYLLABUS SYSTEM MESSAGE: Run complete. Missing or new items generated.^^J%
		\space\space PLEASE RERUN pdflatex on Main.tex now to stabilize all tables.^^J%
		========================================================================^^J}%
	\global\undef\syllabus@master@rerun@required
	\fi
	
	\ClassWarningNoLine{syllabus}{^^J
		>>> SYLLABUS CLASS COMPILED SUCCESSFULLY <<<^^J
	}
	\ClassWarningNoLine{syllabus}{
		Architected & Lead Developed by:^^J
		LaTeX Coordinator, RV College of Engineering, Bengaluru - 560059^^J
	}
		\typeout{This >>> SYLLABUS CLASS COMPILED SUCCESSFULLY <<<}
	\typeout{\space Architected & Lead Developed by:}
	\typeout{\space LaTeX Coordinator, RV College of Engineering, Bengaluru - 560059}
	\typeout{\space}
	\typeout{**********************************************************************}
}%% EndDocument

% --- Back matter: registered after the block above, so these fire
%     after \syllabus@generatetables has produced the tables ---
\AtEndDocument{\ifstandalone\else\input{FlowChartInsert}\fi} 
\AtEndDocument{\ifstandalone\else\includepdf[pages=-]{BackCover}\fi}

\endinput