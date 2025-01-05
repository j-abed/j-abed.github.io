---
layout: post
title: "Day 1 - Guess the Number App"
date: 2025-01-02 10:00:00 +0000
categories: [Python, dev, intro, fundamentals]
permalink: /day-1/
---

# Day 1: Build a “Guess the Number” Game in Python

**Welcome to Day 1 of our 7 Days of Programming series!** Usually, when people learn a new programming language, they start by writing a small program called **“Hello World.”** This program literally just prints the phrase `"Hello World"` to the screen. It’s a fun way to confirm that the language is installed and working correctly—but it’s not exactly exciting.

Today, we’re going to do something **more interesting**: create a small game called **“Guess the Number.”** You’ll learn how to install Python, set up Visual Studio Code (VS Code), and write a simple, interactive Python program—all at a beginner-friendly pace.

---

## Why This Project?

1. **Immediate Feedback**: You’ll see the results of your code instantly.  
2. **Core Concepts**: You’ll practice **variables**, **loops**, **conditionals**, and **user input**—all essential to any programming language.  
3. **More Fun Than “Hello World”**: Instead of just printing a phrase, you get to **build a tiny game**—making learning much more engaging.

---

## Step 1: Installing Python

### macOS

- **Homebrew** makes installation super easy.

1. Open **Terminal** (press `Cmd + Space` and type “Terminal”).  
2. Install Homebrew if you haven’t already:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. Then install Python:
   ```bash
   brew update
   brew install python
   ```
4. Check your version:
   ```bash
   python3 --version
   ```
   You should see `Python 3.x.x`.

   ** note: newer versions of macOS have deployed System Integrity Protection (SIP) to protect the default install of Python, that Apple users for the system. This is usually out of date. See our guide on best practices for a clean python install on macOS: https://j-abed.github.io/python/macos/dev/2025/01/01/simplifying-python-setup.html

### Windows

1. Go to <https://www.python.org/downloads/> and download the official installer.  
2. **Important**: During the installation, check **“Add Python to PATH.”**  
3. After installation, open **Command Prompt** (or **PowerShell**) and verify:
   ```bash
   python --version
   ```
   You should see something like `Python 3.x.x`.

---

## Step 2: Setting Up VS Code

**Visual Studio Code (VS Code)** is our recommended editor because:

- It’s **lightweight**, **fast**, and **cross-platform**.  
- It has **integrated Git** support and an **official Python extension** that makes coding simpler.

1. Download VS Code from <https://code.visualstudio.com/download>.  
2. Install it on your system:
   - On macOS, drag VS Code to the **Applications** folder.
   - On Windows, run the installer.  
3. Launch VS Code and install the **Python** extension:
   - Click the **Extensions** icon (left sidebar).
   - Search **“Python”** and install the **Microsoft Python** extension.

---

## Step 3: Planning the Game Logic

Before we code, let’s outline what we want:

1. **Generate a random number** between 1 and 100.  
2. **Prompt the user** to guess that number.  
3. If the guess is **too low**, print “Too low!”  
4. If the guess is **too high**, print “Too high!”  
5. If the guess is **correct**, congratulate the user and show how many guesses it took.

Here’s the text-based flowchart to illustrate the program's logic:

```
           +-------------------+
           |      Start        |
           +-------------------+
                    |
                    v
       +-----------------------------+
       |  Generate random number     |
       |      between 1 and 100      |
       +-----------------------------+
                    |
                    v
       +-----------------------------+
       |  Initialize guess_count = 0 |
       +-----------------------------+
                    |
                    v
           +-------------------+
           |   Start Loop      |
           |   (while True)    |
           +-------------------+
                    |
                    v
       +-----------------------------+
       |   Prompt user for guess     |
       +-----------------------------+
                    |
                    v
       +-----------------------------+
       |  Is guess < number_to_guess?|
       +-----------------------------+
           |                |
           | Yes            | No
           v                v
+-------------------+   +-------------------+
|   Print "Too Low" |   | Is guess >        |
|                   |   | number_to_guess?  |
+-------------------+   +-------------------+
                             |            |
                             | Yes        | No
                             v            v
                  +-------------------+   +---------------------------+
                  | Print "Too High"  |   |    Congratulations!       |
                  |                   |   |  (Correct guess + break)  |
                  +-------------------+   +---------------------------+
```

---

## Step 4: Writing the Code

### 4.1 Create a New Python File

1. In VS Code, go to **File > Open Folder** and create/select a folder for your project.  
2. Click **File > New File** and save the file as `guess_the_number.py`.  

### 4.2 Import the Random Module

```python
import random
```

- Python includes a built-in **random** library. By writing `import random`, we’re telling Python we want to use functions (like `randint`) that this library provides.

### 4.3 Generate the Random Number

```python
number_to_guess = random.randint(1, 100)
```

- `random.randint(1, 100)` picks a **whole number** between 1 and 100. We **store** that number in a **variable** called `number_to_guess`.  
- **What is a variable?** A variable is like a **container** in your program where we can keep data. You give each container a name (like `number_to_guess`) so you can easily reference and change it throughout your code.

### 4.4 Keep Track of Guesses

```python
guess_count = 0
```

- **Another variable**! `guess_count` is a container that starts at **0**. Each time the player makes a guess, we’ll increase (increment) this number by 1.  
- Why do we need it? We want to keep track of how many guesses the user takes to get the right number. That way, we can display it at the end of the game.

### 4.5 Create a Loop to Ask for Guesses

```python
while True:
    guess = input("Guess a number between 1 and 100: ")
    guess = int(guess)  # Convert the string to an integer
    guess_count += 1
    
    if guess < number_to_guess:
        print("Too low!")
    elif guess > number_to_guess:
        print("Too high!")
    else:
        print(f"Congratulations! You guessed the number in {guess_count} tries.")
        break
```

---

## Step 5: Running the Game

### Method A: Use the VS Code Terminal

1. Go to **View > Terminal** in VS Code (or press <code>Ctrl+\`</code> on Windows / <code>Cmd+\`</code> on macOS).  
2. Ensure you’re in your project folder.  
3. Run:
   ```bash
   python guess_the_number.py
   ```
   (On macOS, it may be `python3 guess_the_number.py`.)

### Method B: Click the “Run Python File” Button

- With the **Python** extension installed, you can just click the **Run** (or “Play”) icon in the top-right corner of VS Code’s editor window.

---

## Step 6: Possible Enhancements

1. **Guess Limit**  
   - End the game if the user doesn’t guess correctly within 10 tries, and reveal the number.

2. **Difficulty Levels**  
   - Ask the user for “Easy,” “Medium,” or “Hard” before generating the number.  
   - Use a **smaller or larger** range accordingly.

3. **High Score File**  
   - Write the **best score** (fewest guesses) to a text file.  
   - Display it whenever the player starts a new game.

---

## Conclusion & Final Congratulations

**You did it!** You’ve now installed Python, set up and configured your IDE (VS Code), and built your **first Python application**—one that’s **far more interesting** than “Hello World.” Not only have you picked up **core programming concepts** like **variables**, **loops**, **conditionals**, and **user input**, but you’ve also gotten a taste of how to make code **interactive** and **fun**.

Take a moment to celebrate your progress! Stay tuned for **Day 2**, where we’ll tackle another exciting Python project—step by step, just like today.

**Until then, happy coding!**

- [Next: Day 2]({{ '/day-2/' | relative_url }})

Full code can be found in a repo on github:
https://github.com/j-abed/Number-Guess
