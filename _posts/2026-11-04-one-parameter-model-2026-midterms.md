---
layout: post
title: "What the Forecasts Missed About the 2026 Midterms"
date: 2026-11-04 16:00:00 -0500
last_modified_at: 2026-11-05
published: true
categories: [data-science, elections, statistics, forecasting]
tags: [midterms-2026, election-forecasting, uniform-swing, polling]
permalink: /one-parameter-model-2026-midterms
description: "An analysis of the 2026 midterms reveals why election forecasts underestimated the scale of Democratic gains, and what a simple model tells us about the limits of prediction."
excerpt: "Democrats were expected to make gains. What surprised many forecasters was how far those gains would reach—and how much of the election could be explained by a single national shift."
image: /assets/midterms-2026/summary-linkedin.png
image_alt: "A 14.3-point median Democratic swing; the same model implies 243 seats with pre-election inputs and 262 using observed results, a 19-seat difference. Its 95.7% classification accuracy is retrospective, not a forecast. Unverified November 4 snapshot."
---

<link rel="stylesheet" href="{{ '/assets/midterms-2026/article.css' | relative_url }}">

*Democrats were expected to make gains. What surprised many forecasters was how far those gains would reach—and how much of the election could be explained by a single national shift.*

> **Dated snapshot, not live results.** This article analyzes the supplied November 4, 2026 dataset. Its election totals and forecast attributions have not been independently corroborated. In particular, the cited DDHQ 84% probability remains unverified. No newer returns have been substituted into the analysis or figures.

The 2026 midterms produced an unusual electoral map. In districts Donald Trump had won by more than 30 percentage points two years earlier, voters moved toward Democrats by roughly 15 points. In districts that had voted comfortably Democratic in 2024, the shift was almost identical.

The differences between those places had hardly disappeared. A Republican stronghold remained a Republican stronghold in many cases. But the direction and size of the movement were strikingly similar. Across much of the country, voters appeared to be responding to something larger than their individual congressional contests.

The election brought Democrats control of both houses of Congress, including Senate victories in states where Republicans had recently seemed secure. The outcome was not entirely unexpected. Most major forecasting models had anticipated a Democratic House majority, and several had also made Democrats favorites to capture the Senate. What many underestimated was the extent of the gains.

Decision Desk HQ's final forecast, published on November 3, gave Democrats an 84% chance of winning the House, with a central estimate of 241 seats. By midday the following day, a preliminary results snapshot showed Democrats had already won 242 seats and were leading in another 17. The final number remained unsettled, but the direction of the discrepancy was becoming clear.

Why had the movement been so much larger than many of the estimates suggested?

To investigate, I examined the election results alongside the 2024 presidential vote, pre-election polling, and congressional race ratings. I also tested a deliberately simple model that treated the election largely as a uniform national shift in support between the parties.

What emerged was an unexpectedly coherent picture of the Democratic gains, along with a useful illustration of the difficulties inherent in political forecasting.

<a href="{{ '/assets/midterms-2026/summary-blog.svg' | relative_url }}"><img class="midterms-summary" src="{{ '/assets/midterms-2026/summary-blog.svg' | relative_url }}" width="1200" height="700" alt="Summary of the unverified November 4 snapshot: 14.3-point median Democratic swing and 95.7% retrospective classification accuracy. Pre-election model inputs imply 243 Democratic seats; observed-swing inputs imply 262. Neither is an official result. State-race polling error is D+5.3."></a>

## A wave that reached almost everywhere

American elections are often explained through the places that distinguish one cycle from another: suburban districts, rural counties, younger voters, college graduates, or particular demographic groups thought to be changing their political allegiances. These distinctions matter, but they can also obscure developments that are taking place across the electorate.

The 2026 results suggest that the national environment was unusually important.

In the November 4 snapshot, the median congressional district had moved approximately 14.3 percentage points toward Democrats compared with its vote in the 2024 presidential election. That figure measures the change in the margin between the two major parties. It is not the same as saying Democrats gained 14.3 percentage points of the total vote.

Consider a district where the Republican presidential candidate won 55% of the two-party vote in 2024, against 45% for the Democrat. That represents a Republican margin of 10 points. A 14-point shift toward Democrats would turn that into a narrow Democratic advantage.

The same arithmetic applied, at least approximately, across districts with very different political histories.

In constituencies that had supported Trump by 30 points or more, the median shift was 14.8 points toward Democrats. In districts that had favored the Democratic presidential candidate by 15 to 30 points, it was 14.5 points. Even seats that had voted comfortably Republican experienced a substantial movement.

There were exceptions. Some of the safest Democratic districts registered smaller shifts, and individual races varied considerably around the national pattern. Local candidates, turnout, campaign spending, and redistricting still mattered. But the relationship between a district's previous partisan leaning and the size of its subsequent swing was surprisingly weak.

This is a significant finding. It suggests that much of the election can be understood as a common movement in the national political environment rather than an assortment of unrelated local developments.

It also helps explain why Republicans lost seats across such different parts of the country. A party can withstand a modest national shift while retaining districts that are comfortably in its column. A movement of 14 or 15 points is another matter. Seats that ordinarily provide a considerable cushion suddenly become competitive.

The Democratic gains were not confined to the House. In the supplied results, the party had flipped seven Senate seats, including contests in Iowa, Kansas, South Carolina, and Texas. Republican advantages that had seemed substantial only two years earlier proved insufficient against the changed political environment.

The breadth of the movement invites a straightforward question: if the change was so widespread, could a very simple model have anticipated it?

<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="District swing figure; use left and right arrow keys to inspect data points">
{% include midterms-2026/uniform-swing.svg %}
</div>
<figcaption><strong>Figure 1.</strong> Each dot is a district. The dashed line adds the observed median swing to the 2024 presidential margin; distance from that line is the local residual. Blue dots indicate Democratic leads or wins, red dots Republican leads or wins; hollow dots are uncalled. Source: companion dashboard, November 4 snapshot, 412 comparable districts.</figcaption>
</figure>

## What a single number can tell us

To examine the pattern, I constructed a model with only one adjustable variable: the national swing toward Democrats.

For every congressional district, the model starts with the 2024 presidential margin and adds the same Democratic shift. If that adjustment produces a Democratic advantage, the model classifies the district as Democratic. Otherwise, it classifies it as Republican.

There is no detailed assessment of individual candidates, campaign finances, demographic changes, or local political controversies. The calculation treats the national environment as the dominant force and leaves everything else out.

Using the 14.3-point median swing observed after the election, this simple rule correctly classified 95.7% of the 392 House races that had been called in the preliminary snapshot. Applied to the full House map, it implied 262 Democratic seats, remarkably close to the 259 seats Democrats had either won or were leading in at that point.

That is an impressive fit for a model with so little information. But there is an important qualification: **it is an explanation of what happened, not evidence that the result could have been predicted with comparable accuracy.**

The model uses the actual election results to determine its most important input. The 14.3-point shift was not known before voters went to the polls.

To see how much that matters, consider what the same model would have produced using information available before Election Day.

Final generic-ballot polling averages had Democrats ahead nationally by approximately 8.7 points. Compared with the Republican advantage of 2.6 points in the 2024 House popular vote, that suggested a Democratic shift of roughly 11.3 points.

Substituting that estimate into the otherwise unchanged model produces 243 Democratic seats.

The difference between the two versions is 19 seats. The formula is identical. The only change is the size of the national movement supplied to it.

The smaller estimate was also close to the published pre-election projections from Decision Desk HQ and Silver Bulletin, at approximately 241 and 240 Democratic seats respectively.

<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="Seat-estimate comparison; use left and right arrow keys to inspect estimates">
{% include midterms-2026/seat-forecasts.svg %}
</div>
<figcaption><strong>Figure 2.</strong> The generic-ballot rule produces an estimate close to the cited pre-election forecasts. The observed-swing rule fits the larger shift after results arrive. The dashed reference marks 259 Democratic seats called or leading, not a final result. The dashboard's non-final August estimate is omitted from this comparison.</figcaption>
</figure>

There is a temptation to conclude that the simple model somehow outperformed the more sophisticated forecasts. It did not. Once given the actual national shift, it described the result extremely well. Before the election, using the best available estimate of that shift, it produced a result much like those of the professional forecasters.

Indeed, its retrospective accuracy is measured on called races, a sample that initially excludes some of the closest contests. That measure may deteriorate as the remaining races are decided.

The more revealing conclusion is that a great deal depended on correctly estimating the national political environment. A difference of only a few points in that assumption was sufficient to change the expected composition of Congress substantially.

## The polls were wrong in a familiar way, but in an unfamiliar direction

Election polling has a complicated recent history. In 2016 and 2020, polling errors in important states tended to favor Republicans: Donald Trump's support was greater than many surveys suggested. The 2022 midterms were considerably more accurate overall, although individual races still produced surprises.

The 2026 election presented a different pattern. In the available state-level comparisons, the polling errors generally favored Democrats.

Across 34 Senate and gubernatorial races with qualifying pre-election polling averages, Democratic candidates exceeded those averages by 5.3 percentage points on average, measured in the margin between the two major parties. They outperformed their polling averages in 30 of the 34 contests.

The pattern appeared in both Senate and gubernatorial races. Senate Democrats exceeded their polling averages by an average of 5.9 points, while Democratic gubernatorial candidates exceeded theirs by 4.6 points.

These figures come from a preliminary, incomplete sample and should not be treated as a definitive measurement of polling performance across the entire election. More than half the state-level contests in the accompanying dataset lacked a qualifying polling average. Nor is the statewide polling error directly interchangeable with the roughly three-point difference between the pre-election national swing estimate and the observed median House swing. The two comparisons use different elections, samples, and baselines.

<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="Polling-error figure; use left and right arrow keys to inspect races">
{% include midterms-2026/polling-error.svg %}
</div>
<figcaption><strong>Figure 3.</strong> Comparing final averages with the November 4 results snapshot makes the direction of the miss visible. Only the 34 races with an established polling average enter this comparison. Hollow dots indicate uncalled races. Source: companion dashboard.</figcaption>
</figure>

Nevertheless, the consistency of the direction is notable.

Polling errors are not always random. When a survey underestimates one candidate in one state, it may be because of circumstances peculiar to that contest. But when surveys across many states underestimate the same party, some common influence becomes a more plausible explanation.

There are several possibilities. Pollsters may have struggled to reach or correctly weight certain groups of voters. The composition of the electorate may have differed from expectations, particularly if turnout rose or fell unevenly between parties. Voters may also have changed their preferences late in the campaign, leaving polls with an outdated picture of the electorate.

The available results do not establish which of these explanations is correct. That would require additional evidence about turnout, individual voting behavior, and the performance of different polling methods.

What they do establish, provisionally, is that the errors tended to point in the same direction. That has consequences extending well beyond the accuracy of any one poll.

## When supposedly safe seats become competitive

Political forecasters do considerably more than publish polling averages. They combine surveys with historical voting patterns, fundraising, candidate assessments, and other information to estimate the likelihood of each party winning.

These assessments are often expressed through familiar categories: Solid Democratic, Likely Democratic, Lean Democratic, Toss-up, Lean Republican, Likely Republican, and Solid Republican.

Such labels serve a useful purpose. They distinguish contests that appear genuinely competitive from those where the outcome is much less uncertain.

In 2026, the categories generally preserved that ordering. Districts rated strongly Democratic were more likely to elect Democrats than those rated strongly Republican. The forecasters had not lost their ability to distinguish favorable territory from unfavorable territory.

But some categories proved much less secure than their descriptions might have suggested.

Among called House races rated Lean Republican, Democrats won seven of nine contests in Cook Political Report's ratings, nine of ten in Sabato's Crystal Ball, and eight of twelve in Decision Desk HQ's ratings. Even a number of contests rated Likely Republican ended in Democratic victories.

These are relatively small samples, and the results remained incomplete. A Lean Republican rating also does not mean that a Republican victory is certain, or even that it carries any particular numerical probability unless the forecaster specifies one. Such ratings describe relative advantages, not guarantees.

<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="House rating calibration; use left and right arrow keys to inspect category probabilities">
{% include midterms-2026/rating-calibration.svg %}
</div>
<figcaption><strong>Figure 4.</strong> Filled dots show observed Democratic win rates in Republican-favored House categories; hollow dots show an analyst-imposed conventional probability mapping, not the raters' published probabilities. All four House raters are included, with called-race sample sizes alongside each row. Small buckets and unfinished counts limit single-cycle conclusions. Source: companion dashboard.</figcaption>
</figure>

Still, the extent to which Democratic candidates prevailed in Republican-favored categories suggests that the national shift affected many of the same contests simultaneously.

This is one of the central difficulties of election forecasting. Congressional elections are decided district by district, but they are not independent events.

A local scandal might damage one candidate without influencing neighboring districts. A change in the national political mood can affect hundreds of candidates at once. If the underlying estimate of that mood is too favorable to one party, many individual forecasts can move in the wrong direction together.

Sophisticated models can account for this dependence by allowing the national environment itself to vary across simulations. The important question is whether they assign enough probability to unusually large changes.

A forecast projecting 241 Democratic seats, for example, is not necessarily a poor forecast because the eventual result is substantially higher. A probabilistic model may regard 241 as its most likely outcome while still allowing a meaningful chance of 260 or more. Judging its performance properly requires examining that range of possibilities, rather than merely comparing a central estimate with the final result.

The 2026 election offers a reason to examine those assumptions closely. It does not, by itself, establish that every forecaster was excessively confident. Some models anticipated a considerably stronger Democratic performance than others.

## Who was responsible for the shift?

The geographical breadth of the Democratic gains does not mean every group of voters behaved alike.

The district-level data suggest some differences in where the movement was strongest. Densely urban districts experienced a median Democratic shift of approximately 18.6 points, compared with 11.3 points in predominantly rural districts.

Areas with smaller non-Hispanic white populations also tended to register larger Democratic swings. Lower median household incomes and lower levels of college attainment were associated with somewhat larger shifts in the simpler statistical comparisons.

Some of these relationships are counterintuitive given the political alignments of recent elections. They may reflect changes in turnout, persuasion among voters who supported Republicans in 2024, or some combination of the two.

But there is a limit to what district-level data can reveal about individual behavior.

A district with a large Hispanic population shifting toward Democrats does not necessarily mean Hispanic voters in that district changed their preferences by the same amount. The shift could reflect turnout among different groups, changes among other voters, or population and electoral differences that cannot be isolated from aggregate results.

The statistical analysis reinforces that caution.

Using 253 districts with unchanged boundaries and complete demographic information, a model incorporating racial composition, education, urbanization, and household income accounted for only about 18% of the variation in the size of the Democratic swing. Including the district's previous presidential voting margin increased that share to about 26%.

<figure class="midterms-figure">
<div class="midterms-chart-scroll" role="region" tabindex="0" aria-label="Demographic association figure; use left and right arrow keys to inspect districts">
{% include midterms-2026/demographics.svg %}
</div>
<figcaption><strong>Figure 5.</strong> Higher non-Hispanic white population share is associated with a smaller Democratic swing. This is an aggregate association, not evidence about individual voters. Source: companion dashboard, 253 unchanged-line districts.</figcaption>
</figure>

Those figures suggest that demographic characteristics were relevant, but far from sufficient to explain why some districts moved more than others.

Much of the election's movement was common to places with very different populations and political histories. That leaves room for demographic differences without making them the principal explanation for the national result.

It also cautions against treating the election as evidence of a simple realignment among any single group of voters. Such claims require more direct evidence than these returns alone can supply.

## The limits of prediction

The 2026 midterms demonstrate both the value and the limitations of election forecasting.

The broad direction of the House contest was not especially mysterious. Democratic control was considered likely by most major models, and the polls anticipated substantial gains. The surprise lay in the size of the movement and the number of seats that consequently became competitive.

The simple national-swing model helps make sense of that outcome. With the benefit of hindsight, a single adjustment to the 2024 electoral map describes the results remarkably well. The apparent complexity of hundreds of individual races is, to a considerable extent, reduced to one shared change in political conditions.

Yet the exercise also shows why a model's ability to explain the past is different from its ability to anticipate the future.

Knowing that a 14.3-point swing produces a close fit is useful. Knowing, before the election, that the swing will be 14.3 points is the difficult part. More elaborate models can incorporate additional information and represent uncertainty more carefully, but they cannot eliminate the difficulty of estimating political conditions that have not yet been observed.

This is not an argument against sophisticated forecasting. A simple national-swing model leaves out too much to serve as a substitute for serious election analysis, and its impressive retrospective accuracy should not be mistaken for a competitive forecasting record.

It does, however, provide a useful test of what the more elaborate methods are adding. If one national variable accounts for much of the result, forecasting that variable—and accurately representing uncertainty around it—deserves at least as much attention as the details of individual races.

For 2026, many models anticipated the winning party. The more difficult task was determining the scale of its victory.

That distinction may seem modest. In an election where a few percentage points of national movement can change the fate of dozens of congressional districts, it is anything but.

## Data and sources

The [companion dashboard](/source_info/midterms-2026-dashboard.html) contains the race-level data and reported estimates. The [extracted snapshot](/assets/midterms-2026/snapshot.json) and [visual generator](/assets/midterms-2026/build-visuals.cjs) reproduce the figures, not the unavailable upstream collection and estimation pipeline. [Download the LinkedIn infographic](/assets/midterms-2026/summary-linkedin.png).

Source attributions supplied with the original analysis include Decision Desk HQ for results, ratings, and its November 3 forecast; Silver Bulletin for its October 29 forecast; RealClearPolling, Silver Bulletin, and Race to the WH for polling averages; Cook Political Report, Sabato's Crystal Ball, Inside Elections, and DDHQ for ratings; and The Downballot, ACS, Census, and FiveThirtyEight for district baselines and demographics. These attributions are not independently verified citations. The FEC publishes the [official 2024 presidential results](https://www.fec.gov/documents/5644/2024presgeresults.pdf) and explains that [states certify election results](https://www.fec.gov/introduction-campaign-finance/election-and-voting-information/); neither link corroborates the supplied 2026 totals.

---

### About the analysis

This article draws on a preliminary November 4, 2026, election-results snapshot and an accompanying analysis of House, Senate, and gubernatorial contests. The district-level comparisons use two-party vote margins, with House results compared against the 2024 presidential vote on comparable district boundaries where available.

The uniform-swing model was fitted retrospectively. Its reported 95.7% classification accuracy applies only to the 392 House races called at the time of the snapshot and is not a measure of pre-election predictive performance. Polling comparisons include only races with qualifying published averages. Demographic findings describe associations at the district level and should not be interpreted as evidence of individual voter behavior.

Election totals remain provisional. The underlying analytical data and some external source attributions have not been independently verified, and the estimates should be updated when more complete results are available.

<script src="{{ '/assets/midterms-2026/article.js' | relative_url }}" defer></script>