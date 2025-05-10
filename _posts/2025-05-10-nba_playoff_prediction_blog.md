---
layout: post
title: "Can We Predict the NBA Playoffs? A Hands-On Guide"
date: 2025-05-09 06:00:00 +0000
categories: [nba data-science python]
permalink: /What-Happened-to-Alpha
---

What if you could simulate the NBA Playoffs 10,000 times before a single tip-off?

Every year, basketball fans debate who’s going to take home the title. But what if, instead of gut feelings or hot takes, you had a Python script and a little math on your side?

This guide walks through a simple, tweakable prediction model that uses:
- **Elo ratings** to measure team strength,
- **Monte Carlo simulation** to run thousands of "what if" playoff scenarios,
- And just enough Python to make you feel like the GM of a stats-savvy franchise.

If you’re curious about how probability and data science apply to sports — and want to run your own playoff predictions — you’re in the right place.

## 2. The Data Behind the Madness

The first ingredient in any prediction model is a way to compare team strength. That’s where **Elo ratings** come in.

Originally developed for chess rankings, Elo ratings have become a staple in sports analytics. They work like this:

- Every team starts with a base Elo (usually around 1500).
- After each game, the winner takes Elo points from the loser.
- The number of points transferred depends on how surprising the result was.

A 100-point Elo edge gives about a **64% chance to win**. That’s the win probability we feed into our simulation. For mathematical clarity, the win probability can be calculated using the following formula:

```
P(A) = 1 / (1 + 10^((Elo_B - Elo_A) / 400))
```

Where:
- `P(A)` is the probability of Team A winning,
- `Elo_A` and `Elo_B` are the Elo ratings of Team A and Team B, respectively.

This formula ensures that stronger teams (higher Elo) have a better chance of winning, while still allowing for upsets.
A 100-point Elo edge gives about a **64% chance to win**. That’s the win probability we feed into our simulation.

## 3. Monte Carlo: Predicting the Unpredictable

Instead of predicting a single outcome, Monte Carlo simulation shows you what could happen across thousands of simulated playoffs. It’s like rolling a (biased) die for every game, thousands of times.

Each series:
- Simulates one game at a time based on Elo-derived win probability
- Repeats until one team reaches 4 wins
- Repeats the entire series simulation thousands of times to compute how often each team advances

This gives us a **probabilistic forecast** — a map of likely outcomes.

## 4. Modeling a Best-of-7 Series

In Python:

```python
def series_sim(team_a, team_b, home_court_team, elo_dict, n_sim=10000):
    a_wins, b_wins = 0, 0
    while a_wins < 4 and b_wins < 4:
        p_a = expected_score(elo_dict[team_a], elo_dict[team_b],
                             hca=(HCA if home_court_team==team_a else -HCA))
        if np.random.rand() < p_a:
            a_wins += 1
        else:
            b_wins += 1
    return team_a if a_wins == 4 else team_b
```

This simulates one series. We run this thousands of times to get our results.

## 5. Predicting the Entire Bracket

We simulate all first-round matchups, advance the winners, and repeat. For example:

```python
remaining_series = {
    'First Round East': ('BOS', 'MIA', 'BOS'),
    'First Round West': ('DEN', 'NOP', 'DEN'),
}

sims = defaultdict(int)
for i in range(10000):
    for matchup, (a, b, hc) in remaining_series.items():
        winner = series_sim(a, b, hc, team_elos)
        sims[winner] += 1
```

We can then calculate each team's chance to reach the Finals or win the championship.

## 6. Running It Yourself

### Option 1: Locally

```bash
git clone https://github.com/j-abed/nba_playoffs_prediction.git
cd nba_playoffs_prediction
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
jupyter notebook
```

Then open the `nba_playoffs_prediction_template.ipynb` notebook.

### Option 2: In the Cloud

Use Binder to run it without installing anything:

[![Launch Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/j-abed/nba_playoffs_prediction/HEAD)

## 7. Tweaking the Model

Some fun ideas:
- Update Elo after each round
- Factor in injuries
- Try single-elimination or best-of-5 formats
- Tune home-court advantage

## 8. What We Learned

You can't predict the future. But you can explore it — and data can show you just how uncertain the "favorites" really are. Whether you're modeling upset potential or estimating your team's title odds, simulations give you a smart way to engage with the madness.

## 9. Explore the Code

Check it out on GitHub:  
👉 [github.com/j-abed/nba_playoffs_prediction](https://github.com/j-abed/nba_playoffs_prediction)

