---
title: 'Data Workflow Management with Snakemake'
date: 2024-03-15
permalink: /posts/2024/03/snakemake/
tags:
  - computational tools
  - data science
---

Reproducibility is a cornerstone of good science, yet computational workflows — the chains of scripts, tools, and file transformations that turn raw data into results — are notoriously difficult to reproduce. Snakemake is a workflow management system that brings structure, reproducibility, and scalability to data analysis pipelines.

## Why Workflow Management?

A typical computational project involves dozens of interdependent steps: downloading data, preprocessing, running analyses, and generating figures. Managing this with shell scripts quickly becomes fragile:

- Intermediate files need to be regenerated when upstream inputs change.
- Parallelism is handled manually and error-prone.
- Dependencies are implicit and undocumented.

Workflow managers like Snakemake solve these problems by making the dependency structure explicit and letting the engine handle execution order, parallelism, and re-execution logic.

## Snakemake Fundamentals

Snakemake is inspired by GNU Make but uses Python syntax, making it expressive and accessible. Workflows are defined in a `Snakefile` as a set of **rules**, each describing how to create output files from input files.

### A Simple Rule

```python
rule align_particles:
    input:
        micrograph="data/micrographs/{sample}.mrc",
        template="data/templates/reference.mrc"
    output:
        "results/alignments/{sample}_aligned.star"
    shell:
        "match2d --input {input.micrograph} --template {input.template} --output {output}"
```

Each rule specifies:

- **input**: Files required before the rule can run.
- **output**: Files produced by the rule.
- **shell** (or **run**, **script**): The command or code to execute.

Snakemake uses **wildcards** (like `{sample}`) to generalize rules across many files, automatically inferring which instances to create based on the requested final outputs.

### Defining the Target

The workflow is executed by requesting a target file. Snakemake traces backward through the dependency graph to determine which rules need to run:

```python
rule all:
    input:
        expand("results/alignments/{sample}_aligned.star",
               sample=["dataset_001", "dataset_002", "dataset_003"])
```

### Config Files and Parameterization

Hardcoded paths and parameters can be externalized into a YAML config file:

```yaml
# config.yaml
samples:
  - dataset_001
  - dataset_002
pixel_size: 1.06
threshold: 7.5
```

```python
configfile: "config.yaml"

rule filter_hits:
    input:
        "results/alignments/{sample}_aligned.star"
    output:
        "results/filtered/{sample}_filtered.star"
    params:
        threshold=config["threshold"]
    shell:
        "filter_matches --input {input} --snr {params.threshold} --output {output}"
```

## Key Features

### Automatic Dependency Resolution

Snakemake builds a directed acyclic graph (DAG) of all jobs and determines the minimal set of tasks to run. If an input file changes, only the downstream rules that depend on it are re-executed.

### Parallelism

Snakemake can run independent jobs in parallel:

```bash
snakemake --cores 8
```

It respects resource constraints and can be configured to manage memory, GPU, and other resources per rule.

### Cluster and Cloud Execution

Snakemake natively supports execution on HPC clusters (SLURM, SGE, PBS) and cloud platforms (AWS, Google Cloud):

```bash
snakemake --cluster "sbatch --mem={resources.mem_mb} --cpus-per-task={threads}" --jobs 100
```

This makes it straightforward to scale a workflow from a laptop to a cluster without modifying the logic.

### Conda and Container Integration

Each rule can specify its own software environment via Conda or Singularity/Docker containers, ensuring full reproducibility:

```python
rule reconstruct:
    input:
        "results/filtered/{sample}_filtered.star"
    output:
        "results/reconstructions/{sample}_reconstruction.mrc"
    conda:
        "envs/reconstruct.yaml"
    shell:
        "reconstruct3d --input {input} --output {output}"
```

## Practical Tips

- **Start small**: Begin with a linear pipeline and add complexity incrementally.
- **Use `--dryrun`**: Preview what Snakemake plans to do before executing.
- **Visualize the DAG**: `snakemake --dag | dot -Tpdf > dag.pdf` generates a visual dependency graph.
- **Benchmark rules**: Use the `benchmark` directive to track runtime and memory usage per rule.
- **Log outputs**: Always capture logs with the `log` directive to aid debugging.

## When to Use Snakemake

Snakemake excels when your analysis involves:

- Multiple interdependent processing steps
- Batch processing across many samples or datasets
- A need for reproducibility across machines or over time
- Scaling from local development to cluster/cloud execution

For cryo-EM workflows in particular — where pipelines involve motion correction, CTF estimation, particle picking, 2D classification, and 3D reconstruction — Snakemake provides a clean way to orchestrate the entire processing chain while keeping every step documented and reproducible.
