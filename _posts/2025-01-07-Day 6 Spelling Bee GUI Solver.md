---
layout: post
title: "Day 6 - Cracking NYT’s Spelling Bee with a GUI-Powered Solver"
date: 2025-01-07 10:00:00 +0000
categories: [spelling bee, python, statistics, Tkinter, data science, fundamentals, dev]
permalink: /day-6/
---

## Introduction

Welcome back to Day 6 of our "7 Apps in 7 Days" challenge! It seems people really enjoyed Wordle solver post earlier in the series,so in this post we're returning to another fan-favorite New York Times word game: Spelling Bee. Today, we’ll build a solver that predicts the most likely words using statistical techniques such as bimodal and trimodal distributions. Up until now we've focused on web application, so in this article we’ll also introduce you to building a desktop application with a graphical user interface (GUI) using Python’s Tkinter library.

This article focuses on two main topics:

1. How bimodal and trimodal distributions work conceptually and how we use them to predict high-scoring words.
2. Step-by-step instructions to build the desktop GUI application, complete with the Python logic required to make it functional.


---

## Part 1: Understanding Bimodal and Trimodal Distributions

Before diving into Spelling Bee predictions, let’s explore the concepts of bimodal and trimodal distributions. These statistical methods analyze how data clusters around specific values or groups.

- **Bimodal Distribution:**
   - Represents data with two distinct peaks or clusters.
   - For example, in word games, one peak might correspond to vowels, which are essential for most words, and the other to common consonants like T, R, and S.

- **Trimodal Distribution:**
   - Extends this concept by adding a third cluster.
   - For Spelling Bee, this cluster could represent rare letters like J, Q, X, and Z. These letters are less frequent but can contribute significantly to scoring potential.

By analyzing these patterns, we can identify which words balance these clusters effectively and are more likely to score well.

---

## Part 2: Using Distributions to Predict the Best Words

The New York Times’ Spelling Bee challenges players to form words using seven given letters, with the center letter being mandatory. Points are awarded based on word length, with a special bonus for pangrams (words that use all seven letters). Our solver focuses on ranking words using bimodal and trimodal distributions to predict which are most likely to be valuable in the game.

### How We Use Bimodal and Trimodal Distributions in Word Ranking

The solver ranks words using the following steps:

1. **Calculate Ratios for Each Cluster:**
   - **Vowel Ratio:** Proportion of vowels in the word.
   - **Common Consonant Ratio:** Proportion of frequently used consonants.
   - **Rare Letter Ratio:** Proportion of rare letters like J, Q, X, or Z.

2. **Apply Weighted Scores:**
   Using weights ( \( w_1, w_2, w_3 \) ) for each cluster, the solver calculates:
   
   ```
   Trimodal Score = w_1 · Vowel Ratio + w_2 · Common Consonant Ratio + w_3 · Rare Letter Ratio
   ```

3. **Combine with Other Factors:**
   The final score for a word includes its length, pangram bonus, and trimodal score:
   
   ```
   Final Score = Length + Trimodal Score + Pangram Bonus
   ```

4. **Normalize Scores to a 0–100 Range:**
   To make the results more intuitive, scores are normalized:
   
   ```
   Normalized Score = ((Raw Score - Min Raw Score) / (Max Raw Score - Min Raw Score)) · 100
   ```

### Example: Scoring the Word "tattoo"

Let’s break it down:

- **Length:** 6
- **Vowel Ratio:** 2/6 = 0.33 (A and O)
- **Common Consonant Ratio:** 2/6 = 0.33 (T)
- **Rare Letter Ratio:** 0/6 = 0.0 (no rare letters)
- **Weights:** \( w_1 = 2, w_2 = 1, w_3 = 3 \)

```
Trimodal Score = (2 · 0.33) + (1 · 0.33) + (3 · 0.0) = 0.99
Final Raw Score = 6 + 0.99 + 0 = 6.99
```

If the raw scores in the dataset range from 5.0 to 10.0, the normalized score would be:

```
Normalized Score = ((6.99 - 5.0) / (10.0 - 5.0)) · 100 = 39.8
```

---

## Part 3: Step-by-Step Guide to Building the Tkinter App

Now let’s build the desktop application step by step. The following code snippets will walk you through setting up Tkinter, building a graphical user interface (GUI), and  implementing the logic that powers the solver. The full implementation can also be found in the [GitHub repository](https://github.com/j-abed/spelling-bee/tree/main). Since the primary focus of this article is meant to be on the statistical scoring, and the GUI portions of the application - feel free to use this code for the rest of the functionality.

---

### Step 1: Setting Up Tkinter

Tkinter comes pre-installed with Python, so you can start immediately. Create a new Python file and import the necessary libraries:

```python
import tkinter as tk
from tkinter import filedialog
from collections import Counter
import csv
```

---

### Step 2: Designing the Main Window

Create the main application window with a title and size:

```python
root = tk.Tk()
root.title("Spelling Bee Solver")
root.geometry("500x600")
root.configure(bg="yellow")
```

---

### Step 3: Adding Input Fields

Add input fields for the dictionary file path, center letter, and other letters:

```python
tk.Label(root, text="Dictionary Path:").pack()
dictionary_path = tk.Entry(root, width=50)
dictionary_path.insert(0, "words_alpha.txt")
dictionary_path.pack()

tk.Label(root, text="Center Letter:").pack()
center_letter = tk.Entry(root, width=10)
center_letter.pack()

tk.Label(root, text="Other Letters:").pack()
other_letters = tk.Entry(root, width=20)
other_letters.pack()
```

---

### Step 4: Adding Buttons

Add buttons for checking words and exporting results:

```python
def run_solver():
    results_box.delete("1.0", tk.END)  # Clear the results box
    center = center_letter.get().strip().lower()
    others = other_letters.get().strip().lower()
    path = dictionary_path.get().strip()
    if not center or not others:
        results_box.insert(tk.END, "Please provide the center letter and other letters.")
        return

    results = solve_spelling_bee(path, center, others)
    for word, score in results:
        results_box.insert(tk.END, f"{word} (Score: {score:.2f})\n")

def export_results():
    filepath = filedialog.asksaveasfilename(defaultextension=".csv",
                                            filetypes=[("CSV files", "*.csv")])
    if filepath:
        with open(filepath, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["Word", "Score"])
            for word, score in solve_spelling_bee(dictionary_path.get(), center_letter.get(), other_letters.get()):
                writer.writerow([word, score])

tk.Button(root, text="Check Words", command=run_solver).pack()
tk.Button(root, text="Export to File", command=export_results).pack()
```

---

### Step 5: Adding a Results Display

Use a `tk.Text` widget to display results dynamically:

```python
results_box = tk.Text(root, height=15, width=50)
results_box.pack()
results_box.insert("1.0", "Results will appear here...")
```

---

### Step 6: Implementing the Solver Logic

Here’s the Python logic for solving the Spelling Bee puzzle:

```python
def solve_spelling_bee(dictionary_path, center, others):
    with open(dictionary_path, "r") as f:
        words = f.read().splitlines()

    valid_words = []
    for word in words:
        if len(word) < 4 or center not in word:
            continue
        if all(letter in center + others for letter in word):
            valid_words.append(word)

    def calculate_score(word):
        length_score = len(word)
        pangram_bonus = 7 if set(word) == set(center + others) else 0
        bimodal_score = sum(Counter(word).get(letter, 0) for letter in center + others)
        return length_score + pangram_bonus + bimodal_score

    scored_words = [(word, calculate_score(word)) for word in valid_words]
    scored_words.sort(key=lambda x: x[1], reverse=True)
    return scored_words
```

---

### Step 7: Running the App

Finally, start the Tkinter event loop to launch the app:

```python
root.mainloop()
```

---

### Screenshot of the Console Application

![Console Version](/assets/Screenshot%202025-01-25%20at%2021.48.21.png)

### Screenshot of the GUI Application

![GUI Version](/assets/Screenshot%202025-01-25%20at%2021.46.50.png)

---

## Closing Thoughts

Today, we’ve built an application that tackles two major objectives: predicting high-scoring words in Spelling Bee using statistical methods and designing a desktop GUI application with Tkinter. We started by understanding the concepts of bimodal and trimodal distributions and how they guide the solver in ranking words based on vowel, consonant, and rare letter ratios. Then, we walked through the technical implementation, creating a functional GUI and connecting it with the solver logic.

Looking ahead, there are several ways you could enhance this app further. For example, you could:

- **Add Customizable Scoring Weights:** Let users adjust the importance of vowels, consonants, and rare letters.
- **Implement a Leaderboard:** Display the highest-scoring words in a separate, sortable list.
- **Allow Multiple Dictionaries:** Support custom word lists or languages by letting users upload their own dictionaries.

We’d love to hear your ideas and see how you improve upon this project! Share your feedback, questions, or enhancements in the comments or contribute directly via the [GitHub repository](https://github.com/j-abed/spelling-bee/tree/main).

In our next article we'll build our final python application, pulling from various learnings in days 1-6!

- [Next: ]({{ 'day-7' | relative_url }})