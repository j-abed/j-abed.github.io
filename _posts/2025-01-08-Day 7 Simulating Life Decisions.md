---
layout: post
title: "Day 7 - Simulating Big Life Decisions"
date: 2025-01-08 07:00:00 +0000
categories: [python, statistics, data science, fundamentals, dev, decision making, modeling]
permalink: /day-7/
---

### **Introduction**

In the first six days of our "7 Apps in 7 Days" challenge, we explored key programming concepts and techniques while building apps that showcased user interactivity, dynamic visualizations, and data-driven insights. From learning how to handle user inputs and create responsive UIs in Streamlit, to leveraging entropy for statistical analysis and visualizing data dynamically, each project built upon the last.

On **Day 7**, we combine these learnings to create a powerful **Life Decision Simulator**. This app will help users analyze decisions using entropy-based scoring and visualize trade-offs using interactive charts. By the end of this post, you’ll have a detailed walkthrough to build this app yourself, complete with reusable code and dynamic features.

---

### **Re-Used Learnings from Previous Days**

- **Entropy and Statistical Models (Day 4)**: We’ll use entropy as a measure of uncertainty to evaluate decision trade-offs.
- **Dynamic Inputs (Day 2/6)**: Sliders will allow users to input and adjust decision factors like risk, reward, and uncertainty.
- **Session State Management (Day 6)**: Persisting user data and toggling between input and output views will enhance interactivity.
- **Data Visualization (Day 6)**: Bar charts and radar plots will present decision scores and trade-offs.

---

### **Understanding Entropy in Decision-Making**

**What is Entropy?**
Entropy measures the randomness or uncertainty in a system. In our app, it quantifies the uncertainty associated with each decision based on its factors.

**Formula:**
\[
H = - \sum p(x) \log_2 p(x)
\]
Where:
- \( p(x) \) is the probability of each factor value normalized across all decisions.
- \( H \) is the entropy value, representing uncertainty.

**Application in the Simulator:**
We’ll calculate entropy for each factor (“Risk,” “Reward,” “Uncertainty”) and combine it with user-defined weights to score decisions.

---

### **Step-by-Step Walkthrough**

#### **Step 1: Setting Up the Environment**

1. **Install Dependencies:**
   ```bash
   pip install streamlit numpy pandas matplotlib plotly mplcursors
   ```

2. **Create Project Structure:**
   ```
   /life_decision_sim
       |-- inputs.py
       |-- life_sim.py
       |-- visualize.py
       |-- main.py
       |-- requirements.txt
   ```

#### **Step 2: Implementing User Input Functions (inputs.py)**

**Code:**
```python
import streamlit as st

def get_decisions():
    """Prompt user to input decision options."""
    decisions_input = st.text_input(
        "Enter decision options (comma-separated, up to 3):", 
        "Take New Job,Stay in Role,Third Option"
    )
    decisions = [decision.strip() for decision in decisions_input.split(",")][:3]
    return decisions

# Explanation:
# - `st.text_input`: Creates a text input field with default values.
# - `.split(",")`: Splits the input string into a list of decisions.
# - `decision.strip()`: Removes leading/trailing spaces from each decision.
# - `[:3]`: Ensures only the first three decisions are kept.

def get_factors(decisions):
    """Prompt user to input scores for each decision using sliders."""
    factors = {"risk": [], "reward": [], "uncertainty": []}
    for decision in decisions:
        st.subheader(f"Scores for {decision}")
        col1, col2, col3 = st.columns(3)
        with col1:
            factors["risk"].append(st.slider(f"Risk (1-10)", 1, 10, 5, key=f"risk_{decision}"))
        with col2:
            factors["reward"].append(st.slider(f"Reward (1-10)", 1, 10, 5, key=f"reward_{decision}"))
        with col3:
            factors["uncertainty"].append(st.slider(f"Uncertainty (1-10)", 1, 10, 5, key=f"uncertainty_{decision}"))
    return factors

# Explanation:
# - `st.columns(3)`: Creates three equal-width columns for layout.
# - `st.slider`: Adds a slider to each column for the respective factor.
# - `factors`: Stores slider values for each decision in a dictionary.
```

#### **Step 3: Managing Weights and Calculations (life_sim.py)**

**Code:**
```python
import streamlit as st
import math

# Initialize weights
def initialize_weights():
    if "weights" not in st.session_state:
        st.session_state.weights = {"risk": 0.3, "reward": 0.5, "uncertainty": 0.2}

# Explanation:
# - `st.session_state`: Saves weights persistently during the app session.
# - `weights`: Default values add up to 1 for proper scoring.

# Validate weights
def validate_weights():
    total_weight = sum(st.session_state.weights.values())
    if total_weight > 1.0:
        st.error("Weights must not exceed 1. Adjust the sliders accordingly.")
        return False
    st.success("Weights are valid!")
    return True

# Explanation:
# - `sum()`: Calculates the total of all weight values.
# - Validation ensures weights are within acceptable limits.

# Calculate entropy
def calculate_entropy(factors):
    entropy = {}
    for key, values in factors.items():
        probabilities = [val / sum(values) for val in values]
        entropy[key] = -sum(p * math.log2(p) for p in probabilities if p > 0)
    return entropy

# Explanation:
# - Normalizes factor values to probabilities using `val / sum(values)`.
# - Computes entropy using the formula \( H = - \sum p(x) \log_2 p(x) \).

# Calculate decision scores
def calculate_scores(factors, weights):
    entropy = calculate_entropy(factors)
    scores = []
    for i in range(len(next(iter(factors.values())))):
        score = sum(entropy[key] * weights[key] * factors[key][i] for key in weights)
        scores.append(score)
    return scores

# Explanation:
# - Iterates over each decision to compute its weighted score.
# - Combines entropy and user-defined weights for each factor.
```

## **Day 7 of 7 Apps in 7 Days: Building a Life Decision Simulator**

### **Introduction**

In the first six days of our "7 Apps in 7 Days" challenge, we explored key programming concepts and techniques while building apps that showcased user interactivity, dynamic visualizations, and data-driven insights. From learning how to handle user inputs and create responsive UIs in Streamlit, to leveraging entropy for statistical analysis and visualizing data dynamically, each project built upon the last.

On **Day 7**, we combine these learnings to create a powerful **Life Decision Simulator**. This app will help users analyze decisions using entropy-based scoring and visualize trade-offs using interactive charts. By the end of this post, you’ll have a detailed walkthrough to build this app yourself, complete with reusable code and dynamic features.

---

### **Step 4: Visualizing Results (visualize.py)**

**Code:**
```python
import streamlit as st
import plotly.graph_objects as go
import numpy as np
import matplotlib.pyplot as plt

def plot_radar_chart(decisions, factors):
    """Visualize trade-offs across decisions with a radar chart."""
    labels = list(factors.keys())
    angles = np.linspace(0, 2 * np.pi, len(labels), endpoint=False).tolist()
    angles += angles[:1]  # Close the radar chart circle

    fig = go.Figure()
    for decision in decisions:
        values = [factors[key][decisions.index(decision)] for key in labels]
        values += values[:1]  # Close the data loop for plotting
        fig.add_trace(go.Scatterpolar(r=values, theta=labels, fill='toself', name=decision))

    fig.update_layout(polar=dict(radialaxis=dict(visible=True)), showlegend=True)
    st.plotly_chart(fig)
```

**Explanation:**
1. **`labels = list(factors.keys())`**: Extracts the factor names (`risk`, `reward`, `uncertainty`).
2. **`np.linspace(0, 2 * np.pi, len(labels), endpoint=False).tolist()`**: Computes angles evenly spaced in a circle for the radar chart.
3. **`angles += angles[:1]`**: Ensures the radar chart closes by repeating the first angle.
4. **Loop through `decisions`**:
   - Extracts values for each decision, ensuring the data wraps around.
   - Uses `go.Scatterpolar` to plot each decision’s values in a radar format.
5. **`fig.update_layout()`**: Customizes layout for better readability and displays the chart in Streamlit.

---

**Code:**
```python
def animate_bar_growth(decisions, scores):
    """Show animated bar chart growth for decision scores."""
    fig = go.Figure()
    fig.add_trace(go.Bar(x=decisions, y=[0] * len(scores), marker_color="skyblue"))

    frames = [
        go.Frame(data=[go.Bar(x=decisions, y=[score * (i / 100) for score in scores])])
        for i in range(1, 101)
    ]
    fig.frames = frames

    fig.update_layout(updatemenus=[{
        "type": "buttons",
        "buttons": [
            {"label": "Play", "method": "animate", "args": [None]},
            {"label": "Pause", "method": "animate", "args": [[None], {"frame": {"duration": 0}}]},
        ]
    }])
    st.plotly_chart(fig)
```

**Explanation:**
1. **`go.Figure()`**: Creates an empty Plotly figure.
2. **`go.Bar(x=decisions, y=[0] * len(scores))`**: Initializes bars with zero height.
3. **Frames Generation**:
   - Iterates from `1 to 100` to gradually increase bar heights.
   - Each frame scales the scores proportionally, creating an animation effect.
4. **`fig.update_layout()`**:
   - Adds play/pause buttons for interactive animation control.
   - Uses `st.plotly_chart(fig)` to render the animated bar chart in Streamlit.

---

### **Step 5: Integrating the App (main.py)**

**Code:**
```python
import streamlit as st
from inputs import get_decisions, get_factors
from life_sim import initialize_weights, validate_weights, calculate_scores
from visualize import plot_radar_chart, animate_bar_growth

def main_app():
    st.title("Life Decision Simulator")

    # Input view
    decisions = get_decisions()
    factors = get_factors(decisions)
    initialize_weights()

    if validate_weights():
        if st.button("Calculate Scores"):
            scores = calculate_scores(factors, st.session_state.weights)
            animate_bar_growth(decisions, scores)
            plot_radar_chart(decisions, factors)

if __name__ == "__main__":
    main_app()
```

**Explanation:**
1. **Imports**:
   - `get_decisions`, `get_factors` for user input handling.
   - `initialize_weights`, `validate_weights`, `calculate_scores` for calculations.
   - `plot_radar_chart`, `animate_bar_growth` for visualization.
2. **`st.title("Life Decision Simulator")`**:
   - Displays the app’s title at the top of the page.
3. **User Input Handling**:
   - Calls `get_decisions()` and `get_factors(decisions)` to retrieve user-defined decisions and factor values.
4. **Weight Initialization & Validation**:
   - Ensures the weight sliders are set and sum up correctly.
5. **Score Calculation & Visualization**:
   - When the "Calculate Scores" button is pressed:
     - `calculate_scores()` computes decision scores using entropy-based weighting.
     - `animate_bar_growth()` animates the resulting scores in a bar chart.
     - `plot_radar_chart()` visualizes trade-offs in decision factors.
6. **`if __name__ == "__main__":`**:
   - Ensures `main_app()` runs when the script is executed directly.

---

### **Conclusion**

The **Life Decision Simulator** marks the culmination of our 7-day coding journey, where we integrated concepts like entropy-based decision modeling, interactive visualizations, and dynamic user input handling to create a powerful decision-making tool.

### **What We Built and Learned Over 7 Days**
Throughout this challenge, we explored:
- **Day 1:** Fundamental input handling and randomness.
- **Day 2:** State persistence and goal tracking.
- **Day 3:** User interactivity with Streamlit components.
- **Day 4:** Entropy-based decision analysis.
- **Day 5:** Personal logging applications and data storage.
- **Day 6:** Advanced data visualization.
- **Day 7:** Combining all elements into a structured, modular application.

### **Ways to continue with and enhance this application**
1. **Multi-User Support:** Enable users to save and compare multiple decision sessions.
2. **Machine Learning Integration:** Use reinforcement learning to predict optimal decisions.
3. **More Decision Factors:** Introduce additional parameters such as cost, time investment, and opportunity cost.
4. **Data Storage and History Tracking:** Implement a database (SQLite or Firebase) to save and review past decisions.
5. **Dynamic Visualization Enhancements:** Use Sankey diagrams, heatmaps, or network graphs to provide deeper insights.

### **Future Project Ideas**
If you enjoyed this challenge, here are a few ideas for future projects:
- **Personal Finance Planner:** Extend the decision simulator for budgeting and financial planning.
- **AI Chatbot Advisor:** Use NLP to generate suggestions based on user-provided decisions.
- **Real-Time Polling System:** Allow multiple users to input decisions and collectively vote on the best outcome.
- **Habit Tracker with AI Insights:** Analyze user behavior and recommend optimized routines.

### **Further Reading & Recommended Resources**
To deepen your understanding of the concepts we explored, check out:
- **Entropy & Decision Science:** *The Elements of Statistical Learning* by Hastie, Tibshirani, and Friedman.
- **Data Visualization:** [Plotly Documentation](https://plotly.com/python/)
- **Machine Learning in Decision Making:** *Artificial Intelligence: A Guide for Thinking Humans* by Melanie Mitchell.
- **Streamlit Advanced Usage:** [Streamlit Official Documentation](https://docs.streamlit.io/)

This concludes our **7 Apps in 7 Days** journey! The full project source code is available on [GitHub](https://github.com/j-abed/life_decision_sim), and a sample app is hosted on [streamlit](https://life-decision-calc.streamlit.app/) Happy coding, and keep building!

Over these 7 days, we’ve learned to:
- Use entropy to model uncertainty.
- Manage user state dynamically with Streamlit.
- Visualize data interactively using animated charts and radar plots.
- Modularize applications for readability and reuse.

### **Further Reading & Project Ideas**
- **Resources**:
  - Learn more about entropy in statistics and machine learning with *The Elements of Statistical Learning*.
  - Explore Plotly’s documentation for advanced data visualizations.
- **Enhancements**:
  - Add multi-user support and allow users to save decision histories.
  - Implement AI-powered decision recommendations based on previous inputs.
  - Extend the visualization features with heatmaps or pie charts for deeper insights.

Please leave any questions or let me know what you'd like to read about next in the comments section. 

- [Next: ]({{ '/decision-making-frameworks/' | relative_url }})


