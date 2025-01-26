---
layout: post
title: " Understanding Decision-Making Frameworks in AI/ML"
date: 2025-01-26 06:00:00 +0000
categories: [AI, ML, statistics, probability, data science, fundamentals, decision-making]
permalink: /decision-making-frameworks/
---

## Introduction

In our daily lives, we constantly interact with systems and technologies that leverage certain deciion-making frameworks or logic paradigms. The frameworks can be categorized by three primary categories: deterministic, probabilistic, and non-probabilistic. Whether it’s a navigation app providing the fastest route, a streaming service recommending movies, or an autonomous vehicle making decisions in real-time, these paradigms are at play. Understanding how AI/ML systems use these decision-making frameworks not only enhances our appreciation for the technology but also helps us navigate their limitations and strengths.

For example:
- A deterministic system like a calendar app always calculates dates and times predictably.
- Probabilistic systems, such as weather forecasts, provide likelihoods instead of certainties.
- Non-probabilistic systems like clustering algorithms group similar items without relying on randomness.

By exploring these categories and their overlaps, we can better understand how AI and ML systems function and why certain approaches are more suited to specific tasks. In this blog post we will delve into these classifications, their theoretical foundations, and real-world applications.

---

## Theoretical Foundations

### Deterministic Systems

Deterministic systems guarantee the same output for a given input. They follow fixed rules or algorithms without randomness.

- **Mathematical Basis:**
  A deterministic system is often described by functions like:

  Here, the output for a given input is always consistent.

- **Applications in AI/ML:**

  - **Rule-based Expert Systems:** Systems with predefined rules, such as medical diagnostic tools.
  - **Classical Algorithms:** Sorting algorithms like mergesort or quicksort.

- **Strengths and Weaknesses:**

  - Strength: Predictable and explainable outcomes.
  - Weakness: Limited adaptability to dynamic environments.

---

### Probabilistic Systems

Probabilistic systems incorporate uncertainty and randomness, producing outcomes based on likelihoods rather than fixed rules.

- **Statistical Foundations:**
  Probabilistic models use concepts such as Bayes' theorem and probability distributions. For instance:

- **Applications in AI/ML:**

  - **Bayesian Networks:** Models that estimate the likelihood of events.
  - **Generative Models:** Variational Autoencoders (VAEs) and GANs for image synthesis.
  - **Probabilistic Classifiers:** Logistic regression for predicting probabilities.

- **Strengths and Weaknesses:**

  - Strength: Effective in handling uncertainty.
  - Weakness: Computationally intensive and data-hungry.

---

### Non-Probabilistic Systems

Non-probabilistic systems do not involve randomness or probabilities, but they may allow multiple outcomes based on fixed rules.

- **Mathematical Basis:**
  These systems often employ iterative algorithms or heuristics.

- **Applications in AI/ML:**

  - **Support Vector Machines (SVMs):** Models for deterministic classification.
  - **K-Means Clustering:** Assigns points to clusters based on fixed criteria.

- **Strengths and Weaknesses:**

  - Strength: Simpler to implement compared to probabilistic methods.
  - Weakness: Less robust in uncertain environments.

---

## Visualizing the Relationships

To better understand the relationships, consider the following placeholder where a Venn diagram should be added:

![AI Decision Making Venn-Diagram](/assets/ai_ml%20decision%20making%20vd.png)

### Explanation of the Diagram:

- **Deterministic Only:** Represents models like sorting algorithms and rule-based expert systems, where outcomes are predictable and fixed.
- **Probabilistic Only:** Highlights models like Bayesian networks and generative adversarial networks (GANs), which rely on probabilities for handling uncertainty.
- **Non-Probabilistic Only:** Focuses on approaches like support vector machines (SVMs) and K-means clustering, which follow fixed logical rules without randomness.
- **Overlaps:**
  - Deterministic & Non-Probabilistic: Decision trees, which use fixed rules but may have non-deterministic paths.
  - Deterministic & Probabilistic: Ensemble models that aggregate deterministic processes with probabilistic decision layers.
  - Probabilistic & Non-Probabilistic: Hybrid approaches combining logical rules with probabilistic outcomes.
  - All Three: Rare, theoretical systems combining elements of all categories for niche applications.

---

## Applications in AI/ML

### Deterministic Applications

- **Image Processing:** Classical edge detection algorithms like Sobel filters.
  - **Example 1:** Classical edge detection algorithms like Sobel filters use deterministic calculations to identify edges in images, always producing the same result for identical inputs.
  - **Example 2:** Sorting algorithms, such as quicksort, ensure repeatable sorting order for the same dataset.

- **Search Algorithms:** Pathfinding in deterministic environments (e.g., Dijkstra's algorithm).
  - **Example 1:** Pathfinding algorithms like Dijkstra's use deterministic methods to find the shortest path in navigation systems.
  - **Example 2:** Deterministic neural networks for specific optimization problems.

### Probabilistic Applications

- **Natural Language Processing (NLP):** Language models like GPT use probabilistic methods to predict text.
  - **Example 1:** ChatGPT generates responses based on statistical probabilities derived from training data, predicting the next word in a sentence given prior context.
  - **Example 2:** Google's BERT model predicts masked words in a sentence using probabilistic methods, improving search engine results and language understanding tasks.

- **Recommendation Systems:** Collaborative filtering predicts user preferences based on probabilities.
  - **Example 1:** Netflix's recommendation engine uses user viewing history and similarities among users to probabilistically suggest movies.
  - **Example 2:** Amazon’s product recommendations leverage probabilistic techniques to predict items a user is likely to purchase based on browsing and buying behaviors.

### Non-Probabilistic Applications

- **Feature Selection:** SVMs and similar deterministic methods for selecting the best features in datasets.
  - **Example 1:** In cancer diagnosis models, SVMs are used to classify whether a tumor is malignant or benign by selecting the most relevant biological features (e.g., size, density).
  - **Example 2:** Facial recognition systems employ feature selection techniques to extract critical facial attributes like the distance between eyes or the shape of the jaw.

- **Clustering:** Hard clustering methods for grouping data points.
  - **Example 1:** Customer segmentation in marketing uses K-means clustering to group customers based on purchasing behavior.
  - **Example 2:** Image segmentation tasks use clustering to partition an image into regions of interest, such as separating foreground objects from the background.

### Hybrid Applications

- **Autonomous Vehicles:** Combine deterministic path-planning with probabilistic decision-making for dynamic environments.
  - **Example 1:** Tesla’s autopilot system uses deterministic algorithms for route navigation and probabilistic models for obstacle detection and risk assessment.
  - **Example 2:** Waymo’s self-driving cars use probabilistic models to predict pedestrian behavior while relying on deterministic systems for adhering to traffic rules.

- **Financial Forecasting:** Probabilistic models for uncertainty combined with deterministic algorithms for baseline predictions.
  - **Example 1:** Stock market prediction systems use probabilistic models to estimate price fluctuations combined with deterministic trend analysis for long-term forecasting.
  - **Example 2:** Risk management tools in banking combine deterministic rules for compliance checks with probabilistic methods to predict loan default probabilities.

---

## Conclusion

Deterministic, probabilistic, and non-probabilistic models offer unique strengths and limitations. While deterministic systems provide predictability, probabilistic models handle uncertainty, and non-probabilistic systems balance simplicity with deterministic logic. Selecting the right approach depends on the application and its requirements. As AI/ML continues to evolve, hybrid systems leveraging these concepts will increasingly dominate.

---

## Further Reading

1. Murphy, K. P. (2012). **Machine Learning: A Probabilistic Perspective**. MIT Press.
2. Bishop, C. M. (2006). **Pattern Recognition and Machine Learning**. Springer.
3. Goodfellow, I., Bengio, Y., & Courville, A. (2016). **Deep Learning**. MIT Press.

---

If you’d like a more interactive experience, explore our [interactive Venn diagram](/assets/interactive_venn_ai_ml.html) to dive deeper into specific models and their use cases.
