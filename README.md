# bestbjorn.ash
 A script to tell you what best to use in your buddy bjorn or crown of thrones in Kingdom of Loathing.

## Installation

Run this command in the graphical CLI:
<pre>
svn checkout https://github.com/soolar/bestbjorn.ash/trunk/RELEASE/
</pre>
Will require [a recent build of KoLMafia](http://builds.kolmafia.us/job/Kolmafia/lastSuccessfulBuild/).

## Usage

To simply get a readout of what bjorn drops are best, call `bestbjorn` in the gCLI. Note that this script
includes the value of drops that can only happen a finite number of times in a day, but they will be denoted
with the text "(limited!)" in the readout.

If you want to automate putting the best familiar in your crown/bjorn, include `import&lt;bestbjorn.ash&gt;`
near the beginning of your script, then call either `enthrone_familiar(get_best_bjorn())` for the crown or
`bjornify_familiar(get_best_bjorn())` for the bjorn. If you want to create an alias to do this for you, such
as in part of an unconditional trigger in a mood, simply enter
`alias bjornifybest => ashq import&lt;bestbjorn.ash&gt; bjornify_familiar(get_best_bjorn())` and/or
`alias enthronebest => ashq import&lt;bestbjorn.ash&gt; enthrone_familiar(get_best_bjorn())` in the gCLI,
then call `bjornifybest` or `enthronebest` as appropriate.
