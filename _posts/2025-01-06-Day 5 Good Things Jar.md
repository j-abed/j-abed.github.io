---
layout: post
title: "Day 5 - Good Things Jar App"
date: 2025-01-06 10:00:00 +0000
categories: [wordle, python, statistics, react, data science, fundamentals]
permalink: /day-5/
---


## Day 5: Building a Good Things Jar App

Welcome back to Day 5 of our seven-day project series! Today, I’m thrilled to dive into a project that’s both personal and inspiring: the **Good Things Jar App**. This app is rooted in a beautiful idea shared by my friend Ashley Sumner, and it’s become a project that I deeply enjoy. The app takes the timeless practice of gratitude journaling and gives it a digital twist.

The idea is simple: Start the year with an empty jar and add a note each week celebrating something good that happened. By New Year’s Eve, you’ll have a collection of memories to reflect on and cherish. I’ve built a version of this in ReactJS and deployed it via Netlify—you can check it out here: [https://voluble-malasada-268018.netlify.app/](https://voluble-malasada-268018.netlify.app/). The GitHub repository with the code is also available: [https://github.com/j-abed/good-things-jar](https://github.com/j-abed/good-things-jar).

### Why Build It Yourself?

While I’m sharing the code on GitHub, this tutorial is designed to help you build your version of the app step by step. By following along, you’ll not only create something meaningful but also strengthen your skills in ReactJS, JavaScript, and web deployment.

### Inspiration and Skills Recap

Ashley Sumner’s quote perfectly captures the spirit of this project:

> **This January, start the year with an empty jar. Every week you add a note with a good thing that happened. On New Year’s Eve, empty the jar and read about the amazing year you had.**

This project builds upon several skills we’ve explored in earlier projects, such as persistent data storage, but this time we’re focusing on creating a full-fledged web application using **ReactJS**. Deployment is handled via **Netlify**, which simplifies the process of taking your app live.

### Overview of the App

The Good Things Jar app allows users to:
- Add notes about good things that happened.
- View their list of notes.
- Save their data locally, even after refreshing or closing the app (via local storage).

While this version is an MVP (minimum viable product), it’s a solid foundation for more advanced features like database storage and user authentication in the future.

### What is React?

ReactJS is a powerful JavaScript library for building user interfaces. It’s great for single-page applications (SPAs) because it allows developers to create reusable components and manage application state efficiently. React has gained immense popularity due to its simplicity, flexibility, and robust ecosystem. Here’s a closer look at some key concepts:

#### Key Concepts in React:
1. **Components**: React apps are built using components, which are self-contained, reusable pieces of the UI. Components can be functional (simpler, using hooks like `useState`) or class-based.
2. **State and Props**: 
   - **State** manages dynamic data within a component.
   - **Props** allow data to flow from parent components to child components.
3. **Virtual DOM**: React uses a virtual representation of the DOM, which minimizes updates to the real DOM and improves performance.
4. **Routing**: React Router is a popular library used for creating multi-page experiences in SPAs. It allows you to define paths and link components to specific URLs.
5. **Lifecycle Methods**: For class-based components, methods like `componentDidMount` and `componentWillUnmount` handle events during the component’s lifecycle. Functional components use hooks like `useEffect` for similar purposes.

#### Why React is Popular:
- **Declarative Syntax**: React simplifies UI development by focusing on what the UI should look like rather than how it changes.
- **Ecosystem**: Libraries like React Router, Redux, and Next.js offer robust solutions for routing, state management, and server-side rendering.
- **Community**: A massive community ensures excellent support, tutorials, and third-party tools.
- **Performance**: Features like the virtual DOM and efficient updates make React apps fast.

#### React vs. Alternatives:
1. **React vs. Angular**:
   - Angular is a comprehensive framework, while React is a library focused on the view layer.
   - Angular uses TypeScript by default and has a steeper learning curve.
   - React is more flexible and lightweight, allowing developers to choose additional tools.
2. **React vs. Vue.js**:
   - Vue.js is beginner-friendly and provides more out-of-the-box functionality than React.
   - React’s ecosystem is larger, offering more third-party solutions for complex apps.

### What is Netlify?

Netlify is a platform that makes deploying web apps a breeze. With features like continuous deployment, serverless functions, and domain management, it’s perfect for hosting your projects. For the Good Things Jar app, Netlify provides a quick way to make the app accessible to anyone.

### Step-by-Step Guide to Building the App

#### 1. Setting Up the Environment

1. **Install Node.js**: Download and install Node.js from [https://nodejs.org](https://nodejs.org). Node.js includes npm (Node Package Manager), which is essential for managing the libraries and dependencies.
2. **Create a React App**:
   Open your terminal or command prompt and run:
   ```bash
   npx create-react-app good-things-jar
   ```
   This command sets up a new React project with a preconfigured environment.
3. **Navigate to the Project Directory**:
   ```bash
   cd good-things-jar
   ```
4. **Start the Development Server**:
   ```bash
   npm start
   ```
   This will start a local server and open your app in the browser.

#### 2. Understanding the Project Structure

After setting up, your project directory will include:
- `src/` folder: This is where we’ll write our application code.
- `public/` folder: This contains static files like `index.html`.

#### 3. Creating the Components

In React, we build the UI using components. Let’s start with two key components:

1. **AddNote Component**:
   - Navigate to the `src/` folder.
   - Create a new file `AddNote.js`.
   - Add the following code:
     ```javascript
     import React, { useState } from 'react';

     const AddNote = ({ addNote }) => {
       const [note, setNote] = useState('');

       const handleSubmit = (e) => {
         e.preventDefault();
         if (note.trim()) {
           addNote(note);
           setNote('');
         }
       };

       return (
         <form onSubmit={handleSubmit}>
           <input
             type="text"
             placeholder="Add a good thing"
             value={note}
             onChange={(e) => setNote(e.target.value)}
           />
           <button type="submit">Add</button>
         </form>
       );
     };

     export default AddNote;
     ```

2. **NotesList Component**:
   - Create a new file `NotesList.js`.
   - Add the following code:
     ```javascript
     import React from 'react';

     const NotesList = ({ notes }) => {
       return (
         <ul>
           {notes.map((note, index) => (
             <li key={index}>{note}</li>
           ))}
         </ul>
       );
     };

     export default NotesList;
     ```

#### 4. Bringing Components Together in App.js

- Open `src/App.js`.
- Replace the contents with:
  ```javascript
  import React, { useState, useEffect } from 'react';
  import AddNote from './AddNote';
  import NotesList from './NotesList';

  const App = () => {
    const [notes, setNotes] = useState([]);

    // Load notes from local storage
    useEffect(() => {
      const savedNotes = JSON.parse(localStorage.getItem('notes')) || [];
      setNotes(savedNotes);
    }, []);

    // Save notes to local storage
    useEffect(() => {
      localStorage.setItem('notes', JSON.stringify(notes));
    }, [notes]);

    const addNote = (note) => {
      setNotes([...notes, note]);
    };

    return (
      <div>
        <h1>Good Things Jar</h1>
        <AddNote addNote={addNote} />
        <NotesList notes={notes} />
      </div>
    );
  };

  export default App;
  ```

#### 5. Styling the App

1. Open `src/App.css`.
2. Add styles for the container, input field, and list. For example:
   ```css
   body {
     font-family: Arial, sans-serif;
     background-color: #f4f4f4;
     margin: 0;
     padding: 0;
     display: flex;
     justify-content: center;
     align-items: center;
     height: 100vh;
   }

   h1 {
     color: #4CAF50;
   }

   input {
     padding: 8px;
     margin-right: 10px;
     border: 1px solid #ccc;
     border-radius: 4px;
   }

   button {
     background-color: #4CAF50;
     color: white;
     border: none;
     padding: 8px 12px;
     cursor: pointer;
     border-radius: 4px;
   }

   ul {
     list-style: none;
     padding: 0;
   }

   li {
     background: #e0f7fa;
     margin: 5px 0;
     padding: 10px;
     border-radius: 4px;
   }
   ```

#### 6. Testing the App

1. Add some sample notes through the app.
2. Refresh the browser to ensure the notes persist.
3. Test the app on mobile and desktop to ensure it’s responsive.

#### 7. Deploying the App

1. Follow the steps to push the code to GitHub.
2. Deploy using Netlify as outlined earlier.

### Future Improvements

While this version is a functional MVP, there are several features I plan to add:
- Database integration for secure, multi-device access.
- Enhanced UI/UX with animations.
- User authentication to create personalized jars.

### Ashley Sumner’s Substack

Before wrapping up, I’d like to highlight Ashley Sumner’s Substack, *The Liminalist*, which is a fantastic read on wellbeing: [https://ashleyjsumner.substack.com/](https://ashleyjsumner.substack.com/).

### Recap

This app is more than just a coding exercise—it’s a way to cultivate positivity and gratitude throughout the year. I loved creating it, and I hope building it yourself brings you as much joy as it brought me. Watching the app come to life was a reminder of how technology can amplify meaningful practices.

What features would make this app even better? I’d love to hear your ideas in the comments below. Let’s keep building something wonderful together!



