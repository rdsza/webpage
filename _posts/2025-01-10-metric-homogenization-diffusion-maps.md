---
title: 'Metric Homogenization for Arbitrarily Rotated Manifolds in Diffusion Maps'
date: 2025-01-10
permalink: /posts/2025/01/metric-homogenization-diffusion-maps/
tags:
  - machine learning
  - manifold learning
---

Diffusion maps are a powerful nonlinear dimensionality reduction technique that uses the eigendecomposition of a diffusion operator to embed high-dimensional data into a low-dimensional space. However, when the data manifold is observed under arbitrary rotations — as is the case in cryo-EM, where each particle image corresponds to an unknown 3D orientation — the standard diffusion map framework can produce distorted embeddings. Metric homogenization addresses this problem by correcting for the non-uniform geometry induced by the rotation group action.

## Background: Diffusion Maps

Given data points $\{x_i\}_{i=1}^n$ sampled from a manifold $\mathcal{M}$, the diffusion maps algorithm proceeds as follows:

1. **Kernel construction**: Build a kernel matrix

$$K_{ij} = \exp\left(-\frac{\|x_i - x_j\|^2}{\epsilon}\right)$$

2. **Normalization**: Normalize $K$ to obtain a Markov matrix $P$ representing transition probabilities of a random walk on the data.

3. **Eigendecomposition**: The diffusion map coordinates are given by

$$\Psi_t(x_i) = (\lambda_1^t \psi_1(x_i), \lambda_2^t \psi_2(x_i), \ldots, \lambda_k^t \psi_k(x_i))$$

where $\psi_j$ and $\lambda_j$ are the eigenvectors and eigenvalues of $P$.

The **diffusion distance** between points approximates the geodesic distance on the manifold, making diffusion maps naturally adapted to the intrinsic geometry of the data.

## The Problem: Rotational Ambiguity

In many scientific imaging settings, the objects of interest are observed under arbitrary rotations from the group $SO(3)$ (or $SO(2)$ for in-plane rotations). For example, in single-particle cryo-EM:

- Each 2D image is a noisy projection of a 3D molecule at an unknown orientation.
- The "conformational manifold" (parameterizing structural variability) is entangled with the "rotational manifold" (parameterizing viewing directions).

When constructing the pairwise distance matrix $\|x_i - x_j\|^2$ directly from the images, the measured distances conflate conformational differences with rotational differences. This leads to a distorted diffusion map where the rotational degrees of freedom dominate the embedding, obscuring the biologically relevant conformational variability.

## Metric Homogenization

The key insight of metric homogenization is to replace the naive Euclidean distance with a **rotationally invariant distance** that has been corrected for the non-uniform sampling density induced by the rotation group.

### Step 1: Rotationally Invariant Distances

Instead of comparing images directly, we compare them over all possible relative rotations and take the minimum (or an optimized) distance:

$$d_{\text{inv}}(x_i, x_j) = \min_{R \in SO(3)} \|x_i - R \cdot x_j\|$$

In practice, this can be computed using angular correlation functions. For 2D images, the rotational alignment can be performed efficiently in Fourier space by comparing the bispectrum or other rotation-invariant features.

### Step 2: Density Correction

Even with rotationally invariant distances, the sampling density on the conformational manifold is typically non-uniform. The density $q(x)$ of the data affects the diffusion operator and can bias the embedding toward high-density regions.

The standard $\alpha$-normalization in diffusion maps corrects for this:

$$\tilde{K}_{ij} = \frac{K_{ij}}{(q_i q_j)^\alpha}$$

where $q_i = \sum_j K_{ij}$ estimates the local density. Setting $\alpha = 1$ recovers the Laplace-Beltrami operator on the manifold, effectively removing the density bias.

### Step 3: Metric Correction

The central challenge is that the rotation group $SO(3)$ acts on the data in a way that **warps the intrinsic metric** of the conformational manifold. Different conformations may be represented by different numbers of similar-looking projections (depending on the molecular symmetry at that conformation), causing some regions of the conformational manifold to appear denser or sparser than they actually are.

Metric homogenization corrects for this by estimating and compensating for the local distortion introduced by the group action. The corrected kernel takes the form:

$$K^{\text{hom}}_{ij} = \frac{1}{\text{vol}(G_i) \cdot \text{vol}(G_j)} \int_{G} \exp\left(-\frac{\|g \cdot x_i - x_j\|^2}{\epsilon}\right) dg$$

where $G$ is the rotation group and $\text{vol}(G_i)$ accounts for the local volume element of the group orbit at $x_i$.

## Why This Matters

Without metric homogenization, the diffusion map embedding reflects a mixture of:

- The true conformational degrees of freedom (what we want).
- Artifacts from the rotational sampling geometry (what we don't want).

With proper homogenization, the embedding faithfully represents the **intrinsic conformational manifold**, enabling:

- Accurate energy landscape reconstruction from cryo-EM snapshots.
- Correct identification of minimum free-energy pathways between conformational states.
- Unbiased clustering of conformational states.

## Connection to Cryo-EM Analysis

In cryo-EM, each particle image is a 2D projection at an unknown orientation of a molecule in an unknown conformation. The full data space is the product manifold:

$$\mathcal{M}_{\text{data}} = \mathcal{M}_{\text{conf}} \times SO(3)$$

The goal is to recover $\mathcal{M}_{\text{conf}}$ — the conformational manifold — from the observed data. Metric homogenization is essential for disentangling the conformational and rotational degrees of freedom, ensuring that the resulting diffusion map coordinates parameterize genuine structural variability rather than viewing-direction artifacts.

This is directly relevant to the energy landscape approach to cryo-EM, where the aim is to map the free-energy surface governing biomolecular conformational dynamics from collections of single-particle snapshots.

## Practical Considerations

- **Computational cost**: The integration over the rotation group adds significant computational overhead. Approximations using spherical harmonics or invariant features can reduce this.
- **Choice of $\epsilon$**: The kernel bandwidth must be chosen carefully — too small and the graph becomes disconnected, too large and fine-scale structure is washed out.
- **Noise sensitivity**: At the low SNR typical of cryo-EM, the rotationally invariant distance estimates become noisy and may require regularization or denoising as a preprocessing step.
