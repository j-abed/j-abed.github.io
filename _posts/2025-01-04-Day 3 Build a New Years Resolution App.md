---
layout: post
title: "Day 3 - Build a New Years Resolution App"
date: 2025-01-04 10:00:00 +0000
categories: [python, streamlit, intro, dev, webapp, fundamentals]
---


# Day 3 - Building a Resolution Spinner: Combining Python, Web Technologies, and Databases

Welcome to Day 3 of our "7 Days of Projects for the New Year" series! Today, we’re combining Python with web technologies and databases to create a **Resolution Spinner** app. This project not only demonstrates Python’s versatility but also showcases how to build a modern, interactive application by integrating multiple technologies.

---

## Building on Day 1 and Day 2

Before we dive in, let’s quickly reflect on what we’ve learned so far:
- **Day 1**: We covered introductory Python by building a **Guess the Number** game. This introduced core concepts like loops, conditional logic, user input, and randomization—all of which we’ll use today.
- **Day 2**: We built a **Goals Tracker** using HTML, CSS, and JavaScript. This taught us how to design and style a webpage and add interactivity manually.

### Taking the Next Step
In today’s project, we combine these skills to create a more sophisticated app. The **Resolution Spinner** integrates:
1. **Backend Logic**: Python processes user inputs and implements the spinner’s random selection.
2. **Frontend Interface**: Instead of writing HTML/CSS/JS like in Day 2, we use **Streamlit**, a Python library that abstracts much of the complexity of traditional web development.
3. **Persistent Storage**: Using **SQLite3**, we ensure that user resolutions are stored securely and retrievable across sessions.

---

## What is Streamlit, and Why Use It?

In Day 2, we manually created a web app using HTML, CSS, and JavaScript. While this approach gives full control over design and interactivity, it also requires substantial effort to build and maintain (as you may have noticed if you completed Day 2's project). Streamlit simplifies this process by allowing us to build modern web apps using just Python.

Here’s why Streamlit is a game-changer:
1. **Abstraction**: It abstracts away the need for manual HTML, CSS, and JavaScript. Widgets like text inputs and buttons are created with single Python function calls, and the layout is automatically styled for a professional look.
2. **Single Language**: No need to switch between Python for backend and JavaScript for frontend. Everything is done in Python.
3. **Live Feedback**: Streamlit’s development server instantly reflects any changes made to the code, speeding up iteration and debugging.
4. **Data Visualization**: With built-in support for visualizations and interactive widgets, Streamlit is perfect for creating intuitive apps.

---

## Why Not Use Flask (or Django)?

Flask (or Django) is another popular Python framework for web development, and it’s a great choice for building more complex, production-grade applications. However, Streamlit has several advantages for projects like ours:
- **Ease of Use**: Streamlit is designed to be beginner-friendly and eliminates the need to write separate HTML templates or manage complex routing, which Flask requires.
- **Rapid Prototyping**: While Flask is powerful, it demands more setup and boilerplate code. Streamlit allows us to focus on app logic and functionality, making it perfect for smaller projects and prototypes.
- **Built-in Frontend**: Flask typically requires additional tools or libraries (like Jinja2 for templating) to create the frontend. Streamlit includes everything needed for a professional UI out of the box.

For this tutorial, we chose Streamlit because it’s faster to set up, easier to work with, and ideal for interactive projects like the **Resolution Spinner**.

---

## Handling Python Version Issues

Before starting, remember that Python versioning issues can arise, especially on macOS. If you encounter problems, refer to my earlier blog post, [Simplifying Python Setup on macOS](https://j-abed.github.io/python/macos/dev/2025/01/01/simplifying-python-setup.html), for detailed steps on managing Python installations and ensuring compatibility.

---

## Project Overview

The **Resolution Spinner** app lets users:
1. Add resolutions to a database.
2. Spin a virtual wheel to randomly select one.
3. Store resolutions persistently using **SQLite3**.

---

## Step-by-Step Guide

### 1. **Set Up the Project**

Clone the repository to your local machine:

```bash
git clone https://github.com/j-abed/Resolution-Spinner.git
cd Resolution-Spinner
```

Ensure your project structure matches the repository:

```
Resolution-Spinner/
├── app.py               # Main application logic
├── requirements.txt     # Project dependencies
├── resolutions.db       # SQLite3 database (auto-generated)
```

**Install dependencies:**

It's good practice to create a virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

Then, install the required packages:

```bash
pip install -r requirements.txt
```

---

### 2. **Design the User Interface**

In `app.py`, set up the Streamlit interface:

```python
import streamlit as st

st.title("🎯 Resolution Spinner")
st.markdown("Add your resolutions below and let the spinner decide!")
```

---

### 3. **Set Up the Database**

Initialize the SQLite3 database within `app.py`. The database file (`resolutions.db`) will be created automatically when you run the app:

```python
import sqlite3

# Initialize the database
conn = sqlite3.connect('resolutions.db')
cursor = conn.cursor()

# Create the resolutions table if it doesn't exist
cursor.execute('''
    CREATE TABLE IF NOT EXISTS resolutions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        resolution TEXT NOT NULL
    )
''')
conn.commit()
```

---

### 4. **Add Resolutions**

Allow users to input new resolutions:

```python
# Input for new resolution
new_resolution = st.text_input("Enter a new resolution:")

# Button to add the resolution
if st.button("Add Resolution"):
    if new_resolution.strip():
        cursor.execute("INSERT INTO resolutions (resolution) VALUES (?)", (new_resolution.strip(),))
        conn.commit()
        st.success(f"Resolution '{new_resolution}' added successfully!")
    else:
        st.error("Please enter a non-empty resolution.")
```

---

### 5. **View Resolutions**

Display the list of stored resolutions:

```python
# Display stored resolutions
st.header("Your Resolutions")
resolutions = cursor.execute("SELECT id, resolution FROM resolutions").fetchall()

if resolutions:
    for res_id, res_text in resolutions:
        st.write(f"{res_id}. {res_text}")
else:
    st.write("No resolutions added yet.")
```

---

### 6. **Implement the Spinner Logic**

Add functionality to randomly select a resolution:

```python
import random

# Button to spin the wheel
if st.button("Spin the Wheel"):
    resolutions = cursor.execute("SELECT resolution FROM resolutions").fetchall()
    if resolutions:
        selected = random.choice(resolutions)[0]
        st.success(f"Your resolution is: {selected}")
    else:
        st.warning("No resolutions to choose from! Add some first.")
```

---

### 7. **Run the Application**

To see your app in action, run the following command in your terminal from the project directory:

```bash
streamlit run app.py
```

This will launch the Streamlit development server and open your app in your default web browser. If it doesn’t open automatically, you can navigate to the URL provided in the terminal (usually `http://localhost:8501`).

---

## What’s Next?

Here are some ideas to expand this project further:
1. **Categories for Resolutions**: Allow users to organize their resolutions into categories (e.g., Health, Career, Personal).
2. **Completion Tracking**: Add a feature to mark resolutions as completed.
3. **Export Resolutions**: Enable users to export their resolutions as a CSV file for sharing or backup.
4. **Deployment**: Host your app on **Streamlit Cloud** or another platform to make it accessible to others.

---

## Conclusion

Congratulations! You’ve built a fully functional **Resolution Spinner** app that combines the foundational Python skills from Day 1, the web development concepts from Day 2, and the added complexity of persistent data storage with SQLite3. Using **Streamlit**, you’ve created a modern, interactive app without needing to write HTML, CSS, or JavaScript.

While frameworks like Flask are excellent for more complex, production-ready applications, Streamlit is ideal for rapid prototyping and small-scale projects like this one.

If you enjoyed this tutorial, stay tuned for **Day 4**, where we’ll tackle another exciting project that builds on what you’ve learned so far!
