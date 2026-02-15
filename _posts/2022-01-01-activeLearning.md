---
title: 'Active Learning'
date: 2022-01-01
permalink: /posts/2022/01/activeLearning/
tags:
  - deep learning
---

Active learning is a machine learning paradigm where the algorithm can interactively query a user (or some other information source) to label new data points. The key idea is that a model can achieve better performance with fewer labeled examples if it is allowed to choose which examples to learn from.

## Why Active Learning?

Labeling data is often the bottleneck in supervised learning. In many domains — medical imaging, cryo-EM analysis, natural language processing — obtaining expert annotations is expensive and time-consuming. Active learning addresses this by strategically selecting the most informative samples for labeling, thereby reducing annotation cost while maximizing model performance.

## The Active Learning Loop

The standard active learning workflow is iterative:

1. **Train** a model on the current labeled dataset $\mathcal{L}$.
2. **Query** the most informative unlabeled samples from a pool $\mathcal{U}$ using an acquisition function.
3. **Annotate** the selected samples (by an oracle/expert).
4. **Add** the newly labeled samples to $\mathcal{L}$ and repeat.

## Query Strategies

The choice of acquisition function determines which samples are selected. Common strategies include:

### Uncertainty Sampling

Select the sample about which the model is most uncertain:

$$x^* = \arg\max_{x \in \mathcal{U}} \, H(y \mid x)$$

where $H(y \mid x)$ is the predictive entropy. For classification, this corresponds to samples near the decision boundary.

### Query-by-Committee (QBC)

Train an ensemble of models (the "committee") and select samples where committee members disagree the most. Disagreement can be measured by vote entropy or KL divergence.

### Expected Model Change

Select samples that would cause the greatest change to the current model parameters if their labels were known. This targets samples that are most likely to improve the model.

### Bayesian Active Learning

Use Bayesian neural networks or Monte Carlo dropout to estimate epistemic uncertainty. The **BALD** (Bayesian Active Learning by Disagreement) criterion selects points that maximize the mutual information between predictions and model parameters:

$$x^* = \arg\max_{x \in \mathcal{U}} \left[ H(y \mid x) - \mathbb{E}_{p(\theta \mid \mathcal{L})} \left[ H(y \mid x, \theta) \right] \right]$$

## Batch Active Learning

In practice, querying one sample at a time is inefficient. Batch active learning selects a set of samples simultaneously, balancing informativeness with diversity to ensure the selected batch covers different parts of the input space.

## Deep Active Learning

With deep neural networks, active learning faces unique challenges:

- **Calibration**: Neural networks are often overconfident, making uncertainty estimates unreliable. Techniques like temperature scaling or ensembles help mitigate this.
- **Representation learning**: The feature representation evolves during training, which affects which samples appear informative.
- **Cold start**: With very few initial labels, deep models may not learn meaningful representations, making early query decisions poor.

## Applications

Active learning has proven valuable in:

- **Medical imaging**: Reducing the annotation burden for pathologists and radiologists.
- **Scientific imaging**: Efficiently labeling particles in cryo-EM micrographs or classifying structural heterogeneity.
- **Natural language processing**: Selecting sentences for annotation in named entity recognition or sentiment analysis.
- **Autonomous driving**: Prioritizing which sensor data frames to label for object detection.
