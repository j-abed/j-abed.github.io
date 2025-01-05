---
layout: post
title: "Day 2 - Build a 2025 Goal Tracker"
date: 2025-01-03 10:00:00 +0000
categories: [HTML, CSS, intro, dev, webdev, fundamentals]
permalink: /day-2/
---

# Day 2: Build a 2025 Goals Tracker

## Introduction

Welcome to **Day 2 of 7 Days of Projects for the New Year**! 🎉 Today, we’ll create a simple yet interactive **2025 Goals Tracker** using **HTML**, **CSS**, and **JavaScript**. This project will teach you the fundamentals of how websites work and guide you step-by-step through building a functional web app.

By the end of this tutorial, your app will:
- Let users add, complete, and remove goals.
- Use drag-and-drop functionality to reorder goals.
- Celebrate achievements with fireworks animations.
- Save goals persistently using **localStorage**.

Note: 
All of the code for this app is on github: 
https://github.com/j-abed/2025-goals

A live sample is available on the project page:
https://j-abed.github.io/2025-goals/

As always please feel free to reach out with any questions!
---

## How Does a Website Work?

A website consists of three main technologies that work together to deliver structure, style, and interactivity:

## Step 1: Setting Up the Project

### What is a Web Application?

A web application is a combination of three main technologies:

1. **HTML (HyperText Markup Language)**:
   - Provides the structure of a webpage using **tags**.
   - Think of it as the skeleton of the website.

2. **CSS (Cascading Style Sheets)**:
   - Adds styling and layout to the page.
   - Makes your app visually appealing with colors, fonts, spacing, and responsiveness.

3. **JavaScript**:
   - Adds interactivity to the app.
   - Handles user actions, updates content dynamically, and enables complex functionalities like drag-and-drop.

---

### Create the Project Files

1. Open **VS Code**.
2. Create a folder named `2025-goals`.
3. Inside the folder, create these files:
   - **index.html**: Contains the HTML structure.
   - **styles.css**: Contains the CSS styling.
   - **script.js**: Contains the JavaScript functionality.

---

## Part 1: Building the HTML

### What is HTML?

HTML defines the structure of your webpage. It uses **tags** to represent elements like headings, buttons, input fields, and lists.

- **HTML is the skeleton of your website.**
- It determines the layout and hierarchy of elements.
- Example of a heading:
  ```html
  <h1>Welcome to My Website</h1>
  ```
- Example of an input field:
  ```html
  <input type="text" placeholder="Enter your goal">
  ```


---

### Basic HTML Tags

| Tag        | Purpose                          | Example                         |
|------------|----------------------------------|---------------------------------|
| `<h1>`     | Main heading                     | `<h1>Goals Tracker</h1>`        |
| `<input>`  | Input field for user input       | `<input type="text">`           |
| `<button>` | Button for user interaction      | `<button>Add Goal</button>`     |
| `<ul>`     | Unordered list for displaying data| `<ul><li>Item</li></ul>`       |

---

### HTML Structure

Paste the following code into **index.html**:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>2025 Goals Tracker</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>2025 Goals Tracker</h1>
    <div id="app">
        <input type="text" id="goal-input" placeholder="Enter your goal">
        <button id="add-goal">Add Goal</button>
        <ul id="goal-list"></ul>
    </div>
    <canvas id="fireworks-canvas"></canvas>
    <script src="script.js"></script>
</body>
</html>
```

---

### 2. CSS (Cascading Style Sheets)

CSS is used to style your webpage and improve its visual appeal. It controls the colors, fonts, layout, and responsiveness of your website.

#### What Does CSS Do?

CSS makes your website look polished and professional. It applies visual rules to HTML elements to control their appearance and placement.

#### Key Concept: The Cascading Nature of CSS
CSS rules are applied in a specific order of priority:

1. **Inline Styles**: Written directly inside the HTML element using the `style` attribute.
   ```html
   <h1 style="color: red;">This is red text</h1>
   ```
2. **Internal Stylesheets**: CSS defined in a `<style>` tag inside the `<head>` of your HTML file.
   ```html
   <style>
       h1 { color: blue; }
   </style>
   ```
3. **External Stylesheets**: CSS written in a separate file (e.g., `styles.css`) and linked using `<link>`.
   ```html
   <link rel="stylesheet" href="styles.css">
   ```

**Priority Order**:
- Inline styles override internal styles, and internal styles override external styles.

---

### CSS Selectors

| Selector Type  | Matches                          | Example CSS                 | Example HTML                     |
|----------------|----------------------------------|-----------------------------|----------------------------------|
| `element`      | All elements of a specific type | `button {}`                 | `<button>Click Me</button>`      |
| `#id`          | Element with a specific ID      | `#header {}`                | `<div id="header"></div>`        |
| `.class`       | All elements with a specific class | `.container {}`          | `<div class="container"></div>` |

---

### Styling the Goals Tracker

Paste the following code into **goals.css**:

```css
body {
    font-family: Arial, sans-serif;
    background: #f4f4f9;
    text-align: center;
    margin: 0;
    padding: 20px;
}

#app {
    max-width: 600px;
    margin: auto;
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

input, button {
    margin: 5px;
    padding: 10px;
    border-radius: 4px;
    border: 1px solid #ccc;
}

button {
    background: #007bff;
    color: white;
    cursor: pointer;
}

button:hover {
    background: #0056b3;
}
```

---

## Part 3: Adding Interactivity with JavaScript

JavaScript is the **brain of your website.** It enables interactivity, dynamic content updates, and advanced features like animations and data handling.

#### What Can JavaScript Do?

JavaScript allows you to:

- Respond to user actions, like clicks and keyboard input.
- Update and manipulate HTML elements dynamically.
- Store data, fetch APIs, and create animations.

#### Key Concept: The DOM (Document Object Model)

The DOM is a tree-like representation of your HTML document. JavaScript interacts with the DOM to modify content, styles, and structure dynamically.

For example:

```javascript
document.getElementById("goal-input"); // Access an element by ID
```


### Adding Functionality

Let’s start adding functionality using JavaScript. These functions will make your app interactive.

#### Add a Goal to the List

This code allows users to add a goal by typing it into the input field and clicking the "Add Goal" button.


Paste the following code into **goals.js**:

```javascript
const input = document.getElementById("goal-input");
const button = document.getElementById("add-goal");
const list = document.getElementById("goal-list");

// Add a new goal
button.addEventListener("click", () => {
    const goal = input.value.trim();
    if (goal) {
        const li = document.createElement("li");
        li.textContent = goal;

        // Allow goal removal on click
        li.addEventListener("click", () => li.remove());

        list.appendChild(li);
        input.value = ""; // Clear input field
    }
});
```

This code:
1. Adds functionality to the “Add Goal” button.
2. Creates a new list item (`<li>`) for each goal.
3. Enables removing goals by clicking on them.

## Step 5: Matching CSS Selectors

Here’s how your CSS matches your HTML:

| HTML Element                          | CSS Selector       | Purpose                             |
|---------------------------------------|--------------------|-------------------------------------|
| `<body>`                              | `body`             | Styles the entire page              |
| `<div id="app">`                      | `#app`             | Styles the main container           |
| `<input type="text" id="goal-input">` | `input` and `#goal-input` | Styles the input field      |
| `<button id="add-goal">`              | `button` and `#add-goal` | Styles the "Add Goal" button |
| `<ul id="goal-list">`                 | `#goal-list`       | Styles the goals list container     |

Each CSS rule is tied to a specific **selector** and applies styles to the corresponding element in the HTML. This creates a clear link between your HTML structure and the visual design.

---

## Step 6: Final Touches

Now that your **HTML**, **CSS**, and **JavaScript** are functional, let’s add final enhancements to elevate the app's experience.


# Integrating Advanced Functionality

### Focus on Advanced Features

In this section, we will focus on integrating advanced functionality into our **2025 Goals Tracker** app. Some of the advanced features we'll be adding include:

- **Persistent data storage using localStorage**: We have already discussed how to store data locally, but now we'll focus on making this feature more robust.
- **Drag-and-drop functionality**: Making the app interactive by allowing users to move items around the screen.
- **Celebration animations (e.g., fireworks)**: To make the app more engaging and fun.

### Hex Color Values

Before we dive into some advanced JavaScript functionality, let’s briefly go over **hex color values**, which we’ll be using to style the goals in our app.

---

### What Are Hex Color Values?

Hexadecimal color values are a way to represent colors in **CSS**. They are based on the **RGB model** (Red, Green, Blue), where each color is represented by a six-character code prefixed with `#`. 

#### Format: `#RRGGBB`

- **RR**: Red intensity (00 to FF, where FF is the highest intensity).
- **GG**: Green intensity (00 to FF).
- **BB**: Blue intensity (00 to FF).

#### Examples:
- `#FF0000` – Pure Red (255, 0, 0 in RGB).
- `#00FF00` – Pure Green (0, 255, 0 in RGB).
- `#0000FF` – Pure Blue (0, 0, 255 in RGB).
- `#FFFFFF` – White (255, 255, 255 in RGB).
- `#000000` – Black (0, 0, 0 in RGB).

---

### How Do Hex Color Values Work in CSS?

In **CSS**, you can use hex color values to style elements. For example:

```css
/* Background color */
body {
    background-color: #FFDDC1;  /* Light pink color */
}

/* Text color */
h1 {
    color: #333333;  /* Dark gray */
}
```

This allows us to set precise colors for various elements of our website or web app, providing a polished and consistent look.

---


#### 1. Drag-and-Drop Functionality

#### How Drag-and-Drop Works

Drag-and-drop functionality involves three core steps:

1. **Capturing the Mouse Position (mousedown)**: We begin by capturing the mouse's position when the user clicks on a goal.
2. **Updating the Element Position (mousemove)**: As the user moves the mouse, we update the position of the dragged element.
3. **Releasing the Drag (mouseup)**: When the user releases the mouse button, we place the element in its new position.

Drag-and-drop allows users to reorder their goals.

#### Implementation

To implement drag-and-drop, we will need to set up event listeners for mouse events (`mousedown`, `mousemove`, and `mouseup`). We will use **JavaScript** to capture the dragging process and move the goal elements dynamically.

Add this to **goals.js**:

```javascript
let draggingElement = null;

// Step 1: Capture Mouse Position (mousedown)
list.addEventListener("dragstart", (e) => {
    draggingElement = e.target;
    draggingElement.style.position = "absolute";
    document.body.appendChild(draggingElement);
});

// Step 2: Update Element Position (mousemove)
document.addEventListener("mousemove", (e) => {
    if (draggingElement) {
        draggingElement.style.left = `${e.pageX}px`;
        draggingElement.style.top = `${e.pageY}px`;
    }
});

// Step 3: Release the Drag (mouseup)
document.addEventListener("mouseup", () => {
    if (draggingElement) {
        list.appendChild(draggingElement);
        draggingElement.style.position = "relative";
        draggingElement.style.left = "0";
        draggingElement.style.top = "0";
        draggingElement = null;
    }
});
```

With this code, users can click and drag goals, and their positions will be updated dynamically on the page.

---

#### 2. Enhance Persistence with localStorage

--

### **Adding Persistent Storage with localStorage**

**localStorage** is a great tool for saving small amounts of data on the client side. It allows your application to retain data even after the page is refreshed or the browser is closed and reopened. Let’s integrate **localStorage** into our goals app so that users can persist their goals across sessions.

#### **What Is localStorage?**

localStorage is part of the Web Storage API and provides a simple way to store key-value pairs in a web browser. The stored data is saved in plain text and can persist even when the user navigates away from your page or closes the browser. Unlike cookies, localStorage does not automatically send data to the server with every HTTP request.

---

### **How to Use localStorage in JavaScript**

localStorage provides several methods to interact with stored data:

- `setItem(key, value)` – Stores a key-value pair.
- `getItem(key)` – Retrieves the value associated with a key.
- `removeItem(key)` – Removes a key-value pair.
- `clear()` – Clears all data stored in localStorage.

Here’s a simple example of how to use it:

```javascript
// Saving a goal
localStorage.setItem("goal1", "Learn JavaScript");

// Retrieving a goal
const goal1 = localStorage.getItem("goal1");
console.log(goal1); // Outputs: "Learn JavaScript"

// Removing a goal
localStorage.removeItem("goal1");

// Clearing all data
localStorage.clear();
```

---

### **Integrating localStorage into Our 2025 Goals Tracker**

Now, let's integrate **localStorage** into our app. We’ll store the goals in the browser’s local storage and retrieve them when the page is loaded.

#### **Storing Goals in localStorage**

Each time a goal is added, we'll save the goals to localStorage so they persist across sessions.

```javascript
const input = document.getElementById("goal-input");
const button = document.getElementById("add-goal");
const list = document.getElementById("goal-list");

// Add a new goal
button.addEventListener("click", () => {
    const goal = input.value.trim();
    if (goal) {
        const li = document.createElement("li");
        li.textContent = goal;

        // Allow goal removal on click
        li.addEventListener("click", () => li.remove());

        list.appendChild(li);
        input.value = ""; // Clear input field

        saveGoals(); // Save goals to localStorage
    }
});

// Save goals to localStorage
function saveGoals() {
    const goals = Array.from(list.children).map(li => li.textContent);
    localStorage.setItem("goals", JSON.stringify(goals));
}
```

---

### **Loading Goals from localStorage**

Now, when the page is loaded, we will check if there are any goals stored in **localStorage** and add them to the list.

```javascript
// Load saved goals from localStorage
function loadGoals() {
    const storedGoals = JSON.parse(localStorage.getItem("goals") || "[]");
    storedGoals.forEach(goal => {
        const li = document.createElement("li");
        li.textContent = goal;
        li.addEventListener("click", () => li.remove());
        list.appendChild(li);
    });
}

window.addEventListener("load", loadGoals);
```

---

### **Why Use localStorage?**

- **Persistence**: localStorage allows the goals to persist between sessions and page reloads, making the app more user-friendly.

- **Simple API**: It provides a simple API for storing and retrieving data without needing a backend server.

- **Offline Availability**: Since it works client-side, your app can work even when the user is offline, as long as the data has been stored in localStorage.

---

### **Limitations of localStorage**

While **localStorage** is great for storing small amounts of data, there are some important limitations:

| **Limitation**                 | **Details**                                                                 |
|--------------------------------|-----------------------------------------------------------------------------|
| **Size Constraints**           | Limited to about 5MB of data per domain (varies by browser).               |
| **Security Risks**             | Data is stored in plain text, which makes it vulnerable to cross-site scripting (XSS) attacks. |
| **Data Availability**          | Data is not automatically shared between devices or browsers.             |
| **No Built-in Expiration**     | Data stays in localStorage until manually removed.                         |

---

### **localStorage vs. Databases**

While **localStorage** is great for small-scale applications, it does have some limitations that become evident as your app grows. Here’s a comparison between **localStorage** and using a **server-side database**:

| **Feature**               | **localStorage**                          | **Database (e.g., SQL)**                    |
|---------------------------|-------------------------------------------|---------------------------------------------|
| **Storage Location**      | Browser (client-side).                    | Server (backend-side).                      |
| **Data Retention**        | Persistent until explicitly cleared.      | Persistent and globally accessible.         |
| **Capacity**              | Limited (5–10 MB).                        | Virtually unlimited.                        |
| **Security**              | Vulnerable to plain-text access.          | Secured with authentication and encryption. |
| **Use Case**              | Small client-side data storage.           | Complex, large-scale, shared data.          |
| **Synchronization**       | None.                                     | Accessible across devices and platforms.    |


### **In the Future: Databases**

In upcoming tutorials, we’ll discuss the benefits of using a **server-side database**. Databases allow us to store large and complex datasets that can be accessed and manipulated by multiple users across different devices.

Unlike localStorage, which only stores data on a single device, **databases** can synchronize data across all devices, enable complex queries, and ensure data security.

We’ll explore how to connect your app to a database and leverage its full capabilities as your project grows.

---


#### 3. Celebrate with Fireworks

Add celebratory fireworks animations when a new goal is added.

To make the app more engaging, we can add a **fireworks animation** that triggers every time a new goal is added to the list. Fireworks create a visual cue to celebrate the user’s progress and bring a sense of accomplishment.

#### Fireworks Animation Implementation

We can use **canvas** and **JavaScript** to create a simple fireworks animation. When a user adds a new goal, the fireworks animation will trigger in the center of the screen.

Here’s the updated **goals.js**:

```javascript
const canvas = document.getElementById("fireworks-canvas");
const ctx = canvas.getContext("2d");
canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

// Function to create fireworks
function firework(x, y, color) {
    const particles = [];
    for (let i = 0; i < 50; i++) {
        particles.push({
            x,
            y,
            dx: Math.random() * 4 - 2,
            dy: Math.random() * 4 - 2,
            color,
            life: 100
        });
    }

    const interval = setInterval(() => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        particles.forEach(p => {
            if (p.life > 0) {
                p.x += p.dx;
                p.y += p.dy;
                ctx.fillStyle = p.color;
                ctx.fillRect(p.x, p.y, 2, 2);
                p.life--;
            }
        });
        if (!particles.some(p => p.life > 0)) clearInterval(interval);
    }, 16);
}

// Trigger fireworks on "Add Goal" button click
button.addEventListener("click", () => {
    firework(canvas.width / 2, canvas.height / 2, "red");
});
```

This code sets up a **canvas** for the fireworks, and when the "Add Goal" button is clicked, it triggers a **fireworks animation** in the center of the screen.

---

### Your App Is Now Feature-Complete! 🎉

With these enhancements, your **2025 Goals Tracker** now includes:

1. Adding, removing, and reordering goals.
2. Persistent storage with **localStorage**.
3. Celebratory fireworks for every new goal.


# Finalizing the 2025 Goals Tracker Guide

Congratulations! 🎉 You've successfully built your **2025 Goals Tracker**. 

---

### Summary of Key Features

Here’s a summary of the features you’ve integrated into your Goals Tracker app:

1. **Adding Goals**: Users can type in a goal and click the "Add Goal" button to add it to the list.

2. **Removing Goals**: Users can click on a goal to remove it from the list.

3. **Drag-and-Drop Functionality**: Users can click and drag goals to reorder them in the list.

4. **Persistence with localStorage**: Goals persist between page reloads using **localStorage**, so users don’t lose their progress.

5. **Celebration with Fireworks**: Every time a goal is added, a fireworks animation is triggered to celebrate.

6. **Styling**: The app is styled using **CSS**, including the use of **hex color values** to give it a modern and visually appealing look.

---

### Additional Challenges

While the app is complete for now, there are a few additional steps you can take to enhance your project:

1. **Optimize for Mobile**: Ensure that your app looks great on mobile devices by using **media queries** in your CSS. This can help adjust the layout for smaller screens.
2. **Error Handling**: You might want to add error handling to ensure that only valid input is added as a goal. For example, prevent adding empty goals or duplicate goals.
3. **User Authentication**: In future tutorials, we will explore user authentication and how you can save data in a backend database, allowing users to sign in and manage their goals across different devices.
4. **Deployment**: You can deploy your app to the web using services like **GitHub Pages** or **Netlify**, making it accessible to everyone.

---

### Reflection

Building this **2025 Goals Tracker** was a great introduction to web development. You learned how to:

- Create structure using **HTML**.
- Style your app using **CSS**, including color values and layout techniques.
- Add interactivity and functionality with **JavaScript**, including **localStorage** for data persistence and **event listeners** for user interaction.

You also added advanced functionality, such as **drag-and-drop** and **fireworks animations**, making your app more engaging and interactive.

---

### What's Next?

Now that you have a functional app, you're ready to dive into more complex topics! In upcoming tutorials, we’ll explore:

- **Backend Databases**: We'll learn about storing data on a database instead of local storage

- **APIs**: We’ll see how to fetch and display data from external sources

- **Frameworks**: We’ll introduce you to popular frameworks 

By the end of the **7 Days of Projects**, you will have built a variety of apps, each focusing on different aspects of development, and gained a solid foundation for building more advanced projects.

---

### Final Thoughts

Take a moment to celebrate your success! 🎉 You've completed the **2025 Goals Tracker** and learned the fundamental building blocks of web development. Whether you want to continue improving this app or start a new project, you're well on your way to becoming a proficient web developer.

- [Next: Day 3]({{ '/day-3/' | relative_url }})


