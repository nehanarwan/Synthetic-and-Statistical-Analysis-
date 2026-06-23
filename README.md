Synthetic Data Generation and Distribution Analysis in R
Project Overview
This project demonstrates the generation, analysis, and visualization of synthetic datasets drawn from multiple probability distributions using R. The objective is to explore the statistical characteristics of different distributions, evaluate their behavior under added noise and missing values, and compare them through a variety of graphical and numerical analysis techniques.

The project simulates realistic data imperfections by introducing random noise and missing observations, making it useful for understanding data preprocessing, exploratory data analysis (EDA), and statistical distribution behavior.

Features
Generates synthetic datasets from multiple probability distributions:
Normal Distribution
Uniform Distribution
Poisson Distribution
Binomial Distribution
Gamma Distribution
Simulates real-world data challenges:
Random Gaussian noise
Missing values (NA handling)
Computes descriptive statistical measures:
Minimum and Maximum
Quartiles (Q1, Q3)
Median
Mean
Standard Deviation
Skewness
Kurtosis
Missing Value Count
Creates publication-quality visualizations:
Histograms
Boxplots
Density Plots
Violin Plots
Q-Q Plots
Scatter Plots with Trend Lines
Exports all visualizations as high-resolution PNG files.
Technologies Used
R
ggplot2 – Data visualization
dplyr – Data manipulation and summarization
moments – Statistical moments (Skewness and Kurtosis)
Project Workflow
1. Synthetic Data Generation

A custom function generates datasets from selected probability distributions. Users can configure:

Number of samples
Distribution type
Noise level
Percentage of missing values
2. Data Preparation

Generated datasets are combined into a single master dataset. Missing values are retained for statistical analysis and removed only when required for visualization.

3. Statistical Analysis

For each distribution, the project calculates descriptive statistics to summarize central tendency, spread, shape, and data quality.

4. Data Visualization

Several visualization techniques are applied to compare distributions and identify patterns:

Histogram Analysis

Boxplot Analysis

Density Curves

Violin Plots

Q-Q Plots

Scatter Plots

Output Files

This project demonstrates:

Synthetic data generation techniques
Exploratory Data Analysis (EDA)
Statistical summary reporting
Missing data simulation and handling
Distribution comparison
Data visualization best practices
Interpretation of skewness and kurtosis
Normality assessment using Q-Q plots
