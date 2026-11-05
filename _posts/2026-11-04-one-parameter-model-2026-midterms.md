---
layout: post
title: "What the Forecasts Missed About the 2026 Midterms"
date: 2026-11-04 16:00:00 -0500
last_modified_at: 2026-11-05
published: true
substack: true
categories: [data-science, elections, statistics, forecasting]
tags: [midterms-2026, election-forecasting, uniform-swing, polling]
permalink: /one-parameter-model-2026-midterms
description: "A preliminary November 4 snapshot shows how national-swing assumptions change House seat estimates, and why retrospective fit is not a pre-election forecast."
excerpt: "A preliminary results snapshot suggests that the national environment mattered more than local differences, and that estimating its size was the difficult part."
image: /assets/midterms-2026/summary-linkedin.png
image_alt: "A 14.3-point median Democratic swing; the same model implies 243 seats with pre-election inputs and 262 using observed results, a 19-seat difference. Its 95.7% classification accuracy is retrospective, not a forecast. Unverified November 4 snapshot."
---

<link rel="stylesheet" href="{{ '/assets/midterms-2026/article.css' | relative_url }}">

*A preliminary results snapshot suggests that the national environment mattered more than local differences, and that estimating its size was the difficult part.*

In districts Donald Trump had won by more than 30 percentage points two years earlier, voters moved toward Democrats by roughly 15 points. In districts that had voted comfortably Democratic in 2024, the shift was almost identical. Those places still had very different politics: many Republican strongholds remained Republican. Yet the supplied November 4 returns suggest that hundreds of congressional contests were moving with the same national current.

That uniformity helps explain the breadth of the gains recorded in the dataset. Its House tally has Democrats winning 242 seats and leading in another 17, with 43 contests uncalled. The accompanying forecast table lists pre-election estimates near 240 Democratic seats. These are different kinds of numbers, and neither calls nor leads should be mistaken for a completed result. Nevertheless, their distance apart raises a useful question about what an election model needs to get right.

<p class="midterms-editorial-note"><em>Editor's note: This analysis uses the preliminary November 4, 2026 snapshot. Source details and limitations appear below.</em></p>

To examine the discrepancy, I compared the House returns with the 2024 presidential vote, pre-election polls, and race ratings. I also tested a model with just one adjustable number: a common shift toward Democrats, applied to every district. Given the movement observed after voting, it described the supplied results remarkably well. With an estimate of that movement drawn from pre-election information, it produced a much smaller Democratic majority.

The difference matters because it locates the difficulty of prediction. Hundreds of local assessments can look reasonable while sharing the same mistaken assumption about the national environment. A simpler model can expose that dependence without demonstrating that it would have anticipated the outcome. The exercise is most useful as an explanation of the reported pattern, not as evidence that electoral uncertainty can be engineered away.

<a href="{{ '/assets/midterms-2026/summary-blog.svg' | relative_url }}"><img class="midterms-summary" src="{{ '/assets/midterms-2026/summary-blog.svg' | relative_url }}" width="1200" height="700" alt="Summary of the unverified November 4 snapshot: 14.3-point median Democratic swing and 95.7% retrospective classification accuracy. Pre-election model inputs imply 243 Democratic seats; observed-swing inputs imply 262. Neither is an official result. State-race polling error is D+5.3."></a>

## A wave that reached almost everywhere

Across 412 districts with comparable results, the median movement was 14.3 percentage points toward Democrats relative to the 2024 presidential election. This measures a change in the margin between the two major parties, not an increase of 14.3 points in the Democratic vote share. A district won by the Republican presidential candidate with 55% against 45%, for example, starts with a Republican margin of ten points. A 14-point movement would give its Democratic House candidate an advantage of about four points.

The movement was similar across much of the partisan map. Districts Trump had carried by at least 30 points shifted by a median of 14.8 points; those that had favored the Democratic presidential candidate by 15 to 30 points shifted by 14.5. Local differences did not disappear, but a district's previous partisan leaning had surprisingly little relationship with the size of its subsequent swing. That makes a national explanation more plausible than a collection of unrelated local ones.

Some of the safest Democratic districts moved less, and individual contests departed considerably from the general pattern. Turnout, candidates, spending, and district boundaries can all matter. Nor does a presidential-to-congressional comparison isolate a single change in public opinion: different candidates and electorates are involved. The median is a useful description of the supplied map, not a direct measurement of how any individual voter changed allegiance.

Even with those qualifications, a shift of this size has obvious consequences for seats. A party can retain comfortable districts through a modest deterioration in national support. As that deterioration grows, more of its apparent cushion disappears at once. The important feature of the chart is therefore not that every dot follows a line exactly, but that one shared adjustment brings politically different districts much closer to their reported outcomes.

<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="District swing: each dot is a district; arrow keys inspect results">
{% include midterms-2026/uniform-swing.svg %}
</div>
<figcaption><strong>Figure 1.</strong> Each dot is a district; the dashed line applies the same 14.3-point shift to each district's 2024 presidential margin. Blue and red indicate Democratic and Republican leads or wins; hollow dots are uncalled. Source: supplied November 4 snapshot, 412 comparable districts.</figcaption>
</figure>

### A Wave With Historical Precedents

Large midterm reversals have precedents. The president's party lost 54 House seats in 1994, 30 in 2006, 63 in 2010, and 41 in 2018, using the American Presidency Project's series. House and Senate outcomes can diverge: Republicans gained two Senate seats in 2018 despite their House losses. Clinton's House gain in 1998 and George W. Bush's gains in both chambers in 2002 also warn against treating midterms as automatic defeats.

The table's 2026 row is not a completed election result. It records 37 Democratic House flips minus two Republican flips, with 43 contests uncalled; the Senate balance is likewise provisional. Neither figure establishes a final historical ranking. Seat changes also differ from national popular-vote swings. Those compare successive House elections, whereas this article's 14.3-point figure is a median district-level change from presidential to House margins.

In a [November 4 comparison](https://nymag.com/intelligencer/article/this-2026-midterm-wave-was-one-for-the-history-books.html), Intelligencer's Ed Kilgore reported approximate national House-vote margin shifts of 11.6 points toward Republicans in 1994, 10.6 toward Democrats in 2006, and 17.4 toward Republicans in 2010. His roughly 16-point Democratic estimate for 2026 is preliminary, not a certified result or this article's district median.

<div class="article-table-scroll" role="region" tabindex="0" aria-label="How Recent Midterms Compare">
{% include midterms-2026/historical-table.html %}
</div>

<p class="midterms-source-note">Signs refer to the sitting president's party. Historical rows are completed election totals from the <a href="https://www.presidency.ucsb.edu/statistics/data/seats-congress-gainedlost-the-presidents-party-mid-term-elections">American Presidency Project</a>. For 2026, −35 means 35 net Democratic House flips called (37 Democratic minus two Republican), a Republican loss. Both 2026 entries are preliminary called-flip balances, not final seat changes.</p>

## What a single number can tell us

The model starts with each district's 2024 presidential margin and adds the same Democratic shift. If the adjusted margin favors Democrats, it classifies the seat as Democratic; otherwise, Republican. It makes no separate allowance for candidate quality, spending, incumbency, or local controversies. Its purpose is to test how far a common movement can take the explanation before those complications enter.

Using the observed median swing, the rule correctly classified 375 of the 392 called House races, or 95.7%. Applied across the full map, it implied 262 Democratic seats, close to the snapshot's 259 called or leading. That fit deserves attention, but its meaning is limited: the crucial input was estimated from the same election the model is being asked to explain. The 14.3-point movement was unavailable before voting, and the called-race sample initially leaves out many close contests.

To see the importance of that input, hold the formula fixed and supply an estimate based on pre-election polling. The accompanying analysis reports a final generic-ballot average of Democratic support ahead by 8.7 points. Against its reported Republican advantage of 2.6 points in the 2024 House vote, that gives an estimated movement of 11.3 points toward Democrats. Applying that adjustment produces 243 Democratic seats, nineteen fewer than the retrospective version.

This calculation translates a national House polling indicator onto presidential district margins, a simplifying assumption rather than a fully specified forecasting method. Differences in turnout, congressional candidates, and the distribution of support can all affect that translation. Nevertheless, the comparison is revealing because the map and rule do not change between the two runs. A relatively modest difference in the assumed national movement changes the apparent fate of nineteen seats.

<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="Seat-estimate comparison; use left and right arrow keys to inspect estimates">
{% include midterms-2026/seat-forecasts.svg %}
</div>
<figcaption><strong>Figure 2.</strong> The same rule implies 243 Democratic seats with pre-election inputs and 262 with the observed swing. These are model estimates, not official results. Source: supplied snapshot and its national-swing calculations.</figcaption>
</figure>

Decision Desk HQ's [final November 3 announcement](https://x.com/DecisionDeskHQ/status/2117672806678741256) gave Democrats an 84% probability of winning the House and a 241-seat projection. The supplied table separately attributes 240 seats to Silver Bulletin; that exact estimate has not been independently corroborated here. DDHQ's proximity to 243 does not establish that it used this simple rule, or that the retrospective model beat its forecast. A fair comparison would require the published uncertainty ranges and the information available when each forecast was issued.

## The polls missed in the same direction

The state-level polling comparisons offer a second view of the discrepancy. In 30 of 34 Senate and gubernatorial contests with qualifying polling averages, Democrats performed better than the polls suggested. Their average advantage over the polling margin was 5.3 points. The miss appeared in both kinds of race: 5.9 points in Senate contests and 4.6 in governors' races. A set of errors leaning so consistently in one direction warrants more attention than a few isolated surprises.

The distribution below makes that pattern visible without implying that every poll failed equally. Each dot represents a race, with positive values indicating that polls understated the Democratic margin. Several contests moved much farther than the average, while four went the other way. The mean is a summary of these comparisons, not a correction that should automatically be added to every future poll.

Selection matters. More than half the state contests in the supplied dataset lack a qualifying average, and some results remained unsettled. These 34 races therefore do not constitute a complete national audit of polling. Their 5.3-point mean error is also not interchangeable with the difference between the 11.3-point national input and the 14.3-point median House swing. Those quantities describe different contests, samples, and baselines; combining them would create an appearance of precision the evidence does not support.

<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="Distribution of polling errors; arrow keys inspect races">
{% include midterms-2026/polling-error.svg %}
</div>
<figcaption><strong>Figure 3.</strong> Each dot is one state race, grouped in polling-error bands. Positive errors mean polls understated Democrats; hollow dots are uncalled races. Source: supplied November 4 snapshot, 34 qualifying Senate and governor contests.</figcaption>
</figure>

What might produce shared errors? Pollsters could misjudge turnout, struggle to reach particular voters, or miss a late change in preferences. Different surveys may share similar assumptions or difficulties even when conducted separately. The returns alone cannot identify which explanation is right. They do suggest why treating local polling misses as independent accidents would be risky: a common error can affect many contests simultaneously, just as a common political movement can.

## When supposedly safe seats become competitive

Race ratings illustrate the same vulnerability. In the supplied comparisons, Democrats won seven of nine called House contests rated Lean Republican by Cook Political Report and nine of ten in Sabato's Crystal Ball. Some Likely Republican seats also changed hands. Those outcomes suggest that a shared movement could unsettle assessments across otherwise different districts; they do not mean the labels were intended as guarantees.

The samples are small, and a category such as Lean Republican has no universal numerical probability. The detailed calibration chart in the appendix uses an analyst-imposed probability mapping, not the raters' published odds. It is useful for examining the pattern, but cannot by itself establish that a forecasting organization was overconfident. Assessments of calibration require more than a handful of outcomes from a single unfinished election.

The same caution applies to seat forecasts. An estimate near 240 is not necessarily contradicted by a result above 260 if the forecast assigned a meaningful probability to that outcome. A model's central estimate and its distribution of possible outcomes answer different questions. The evidence here makes the national assumption worth scrutinizing; it does not supply the published distributions needed to judge whether each forecaster allowed enough uncertainty. That is a more demanding test than comparing two headline numbers.

## What demographics can tell us

The common movement did not make every district alike. Densely urban districts had a median Democratic shift of 18.6 points, against 11.3 in predominantly rural ones. In 253 districts with unchanged boundaries and complete information, a regression using racial composition, education, urbanization, and income accounted for about 18% of the variation in swing. Adding previous presidential voting margins increased that figure to about 26%. These are reported associations within the snapshot, not a reconstruction of individual voting decisions.

They cannot tell us whether particular groups switched parties, stayed home, or voted in greater numbers. A district with a large Hispanic population moving toward Democrats, for example, does not identify which residents changed their behavior. The regressions concern differences between districts, and their limited explanatory power does not establish a cause for the national movement. The detailed chart belongs in the appendix rather than serving as evidence for a sweeping claim of demographic realignment.

## The limits of prediction

The useful lesson is about where forecasting effort belongs. If hundreds of contests depend heavily on one national assumption, refining local detail cannot compensate for getting that assumption wrong. Models need to represent plausible shared movements as well as district-specific uncertainty, and readers need to know how much of a seat estimate rests on each.

The simple rule provides a benchmark for that work, not a replacement for it. It fits the supplied returns after the decisive input is known; it offers no independent proof that the input could have been predicted. A convincing forecasting record would require a rule fixed before voting, contemporaneous inputs, and evaluation across elections. Until then, the nineteen-seat difference is best understood as a measure of sensitivity: a small change in the national picture can have a large effect on the map.

## Data and sources

The [companion dashboard]({{ '/source_info/midterms-2026-dashboard.html' | relative_url }}) contains the race-level inputs. The [extracted snapshot]({{ '/assets/midterms-2026/snapshot.json' | relative_url }}) and [visual generator]({{ '/assets/midterms-2026/build-visuals.cjs' | relative_url }}) reproduce the charts, not the unavailable upstream collection or regression pipeline. All three main figures use that fixed snapshot. [LinkedIn infographic]({{ '/assets/midterms-2026/summary-linkedin.png' | relative_url }}).

**Historical records checked:** the [American Presidency Project's midterm series](https://www.presidency.ucsb.edu/statistics/data/seats-congress-gainedlost-the-presidents-party-mid-term-elections) confirms the historical House and Senate seat changes, citing [House party divisions](https://history.house.gov/Institution/Party-Divisions/Party-Divisions/) and [Senate party divisions](https://www.senate.gov/history/partydiv.htm). Its convention is used consistently; independently caucusing members and changes during a Congress can produce differences from other published series. It does not corroborate the supplied 2026 row.

**National vote comparison:** [Ed Kilgore's November 4 Intelligencer analysis](https://nymag.com/intelligencer/article/this-2026-midterm-wave-was-one-for-the-history-books.html) compares national House popular-vote movements with the preceding House elections. Its roughly 16-point 2026 swing uses a preliminary Democratic national lead of 13-14 points, also described by [G. Elliott Morris on November 4](https://www.gelliottmorris.com/p/democrats-win-us-house-senate-in). These are attributed estimates, not an independently recomputed national vote series. They do not replace the supplied district margins or establish a final historical ranking.

**Forecast and results checks:** DDHQ's [dated final forecast announcement](https://x.com/DecisionDeskHQ/status/2117672806678741256), linking to its [2026 forecast](https://votes.decisiondeskhq.com/forecast/2026), confirms the 84% House-control probability and 241-seat projection. [The New York Times' November 4 reporting](https://www.nytimes.com/live/2026/11/04/us/midterm-election-results-democrats), using Associated Press race calls, corroborates Democratic control of both chambers and seven Democratic Senate flips. Its later House totals have not been substituted into this snapshot. Neither source independently validates every supplied race, polling average, rating, or regression output. The [Silver Bulletin forecast landing page](https://www.natesilver.net/p/nate-silver-2026-midterm-election-polls-model) confirms a November 3 final update, but not the exact 240-seat figure in its accessible text. The [FEC explains certification](https://www.fec.gov/introduction-campaign-finance/election-results-and-voting-information/); these preliminary calls and estimates are not certified totals.

---

### About the analysis

The supplied snapshot combines state races read approximately 1-8am Eastern on November 4 with House counts read approximately noon-3pm. It has 435 House races, 392 called and 43 uncalled. The swing plot uses 412 comparable presidential-to-House margins. Classification accuracy uses recorded winners in all 392 called races, including 14 without a comparable House result margin; blank margins are not treated as zero. The rule classifies 375 correctly. Its 95.7% accuracy is retrospective, in-sample, and subject to called-race selection, not a pre-election forecasting score.

Polling comparisons use only 34 state races with qualifying averages and numeric result margins, excluding PollCheck-source entries. Errors are result minus poll in Democratic two-party-margin points; a positive error means Democrats exceeded the poll. The displayed mean of 5.3 points is the supplied rounded summary. The demographic regressions and their 18% and 26% explanatory shares are reported outputs, not independently re-estimated here. District aggregates cannot identify individual persuasion or turnout.

No newer returns or replacement forecast inputs have been substituted. Any later update must recalculate dependent model estimates, samples, error summaries, and figures together. The original source file is retained for audit, including historical estimates superseded by the verified seat-change table. The <a href="#technical-appendix">technical appendix</a> preserves the supporting charts outside the main reading flow.

<details class="midterms-appendix" id="technical-appendix">
<summary>Technical appendix</summary>

<h3>Different meanings of swing</h3>
<p>The main district statistic is the median of 2026 House Democratic two-party margins minus 2024 presidential Democratic two-party margins. A national House-to-House margin change would instead subtract the previous House election's national party margin from the current one. Both elections must use the same denominator, whether all votes or only Democratic and Republican votes. A change in two-party vote share is half the corresponding change in two-party margin. These definitions are not interchangeable with seat gains or with an unweighted median of districts.</p>

<h3>Historical seat changes</h3>
<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="Supplementary historical seat comparison; 2026 is incomplete">
{% include midterms-2026/historical-seats.svg %}
</div>
<figcaption><strong>Appendix A.</strong> The earlier seven-election comparison is retained for reference. The hatched 2026 bar represents net called flips only, not a final result or a projection. Sources: American Presidency Project for historical elections; supplied snapshot for 2026.</figcaption>
</figure>

<h3>Race-rating calibration</h3>
<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="Supplementary rating calibration; arrow keys inspect categories">
{% include midterms-2026/rating-calibration.svg %}
</div>
<figcaption><strong>Appendix B.</strong> Filled dots are observed Democratic win rates among called races; hollow dots are analyst-imposed category probabilities, not raters' published odds. All four House raters and their small category samples are retained. Source: supplied snapshot.</figcaption>
</figure>

<h3>District demographics</h3>
<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="Supplementary demographic association; arrow keys inspect districts">
{% include midterms-2026/demographics.svg %}
</div>
<figcaption><strong>Appendix C.</strong> Non-Hispanic white population share and Democratic district swing are negatively associated in these 253 unchanged-boundary districts. This plot does not identify individual voter behavior or establish causation. Source: supplied snapshot.</figcaption>
</figure>

</details>

<script src="{{ '/assets/midterms-2026/article.js' | relative_url }}" defer></script>