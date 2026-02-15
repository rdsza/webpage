---
title: '2D Template Matching in cisTEM'
date: 2024-06-01
permalink: /posts/2024/06/2d-template-matching/
tags:
  - cryo-EM
  - structural biology
  - signal processing
---

2D Template Matching (2DTM) is a method for detecting and localizing macromolecular complexes directly in cryo-electron microscopy (cryo-EM) micrographs by cross-correlating them with projected templates of a known 3D structure. This approach, implemented in [cisTEM](https://cistem.org/software), bypasses the traditional particle picking and 2D classification steps, enabling detection of targets in situ — including in crowded cellular environments imaged by cryo-electron tomography (cryo-ET).

## The Problem: Finding Molecules in Noisy Images

Cryo-EM micrographs are extremely noisy. The electron dose must be kept low to avoid radiation damage, resulting in signal-to-noise ratios (SNR) that are often well below 1. Traditional particle picking relies on template matching or blob detection followed by 2D classification to filter out false positives. These methods work well for isolated particles but struggle in complex, crowded environments like cells.

2D Template Matching takes a different approach: rather than picking candidate positions and classifying them after the fact, it exhaustively searches over all positions, orientations, and defocus values to find the best match between each image patch and a library of projected templates.

## How 2DTM Works

### Generating Templates

Starting from a known 3D reconstruction (or atomic model), 2DTM generates a set of 2D projections at finely sampled orientations covering $SO(3)$. Each projection simulates what the molecule would look like in the micrograph at a particular orientation.

The angular sampling is typically parameterized by an angular step $\Delta\phi$, producing on the order of $N_{\text{proj}} \sim 4\pi / (\Delta\phi)^2$ templates (for uniform coverage of the sphere).

### Cross-Correlation Search

For each template, the algorithm computes a normalized cross-correlation (NCC) with the micrograph at every pixel position. The NCC between a template $t$ and an image patch $f$ is:

$$\text{NCC} = \frac{\sum_i (f_i - \bar{f})(t_i - \bar{t})}{\sqrt{\sum_i (f_i - \bar{f})^2 \sum_i (t_i - \bar{t})^2}}$$

This is computed efficiently in Fourier space using the correlation theorem:

$$\text{CCF}(\mathbf{r}) = \mathcal{F}^{-1}\left[\mathcal{F}[f]^* \cdot \mathcal{F}[t]\right]$$

The search is performed over a grid of:

- **In-plane positions** $(x, y)$: Every pixel in the micrograph.
- **Euler angles** $(\phi, \theta, \psi)$: Sampling the orientation space.
- **Defocus**: Accounting for sample tilt and local ice thickness variations.

### Signal-to-Noise Ratio as a Detection Statistic

The peak value of the NCC at each search position is converted to a statistical quantity — the **SNR peak** or **matched filter score**. Under the null hypothesis (no particle present), the NCC values follow a known distribution, allowing the computation of statistical significance for each detection.

A detection is reported when:

$$\text{SNR}_{\text{peak}} > \text{threshold}$$

Typical thresholds range from 7 to 9, depending on the target and imaging conditions.

## The Role of CTF

The contrast transfer function (CTF) modulates the image contrast in a defocus-dependent manner. Accurate CTF correction is critical for 2DTM because:

- Templates must be convolved with the CTF matching the local imaging conditions.
- Defocus varies across the micrograph (especially for tilted specimens), requiring per-position defocus estimation.

In cisTEM's implementation, the defocus search is integrated into the template matching pipeline, allowing the algorithm to simultaneously optimize position, orientation, and defocus.

## Advantages of 2DTM

- **No particle picking bias**: Every position and orientation is evaluated; there is no reliance on ad hoc picking criteria.
- **In situ detection**: Can detect targets embedded in cellular tomograms, where traditional methods fail.
- **Orientation determination**: The best-matching template directly provides the 3D orientation of each detected particle.
- **Statistical framework**: The matched-filter formalism provides principled detection statistics.

## Implementation in cisTEM

[cisTEM](https://cistem.org/software) (computational imaging system for transmission electron microscopy) provides a GPU-accelerated implementation of 2DTM. Key features include:

- Efficient Fourier-space correlation using cuFFT.
- Parallelized search over orientations and defocus values.
- Integration with cisTEM's CTF estimation and refinement tools.
- Support for both single-particle micrographs and tomographic tilt series.

## Current Developments

Active development is focused on:

- **Improving sensitivity**: Better noise modeling and whitening filters to push detection limits in low-SNR regimes.
- **Scalability**: Handling the massive search space for large micrographs and fine angular sampling.
- **Tomographic applications**: Extending 2DTM to 3D template matching in reconstructed tomograms for in situ structural biology.
- **Machine learning integration**: Using learned features to complement or accelerate the template matching search.

2D Template Matching represents a shift from heuristic particle picking toward a rigorous, signal-processing-based approach to macromolecular detection in cryo-EM — bringing us closer to the goal of identifying and solving structures of molecules directly within their native cellular context.
