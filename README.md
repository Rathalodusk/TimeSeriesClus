
# TimeSeriesClus

This repository contains R scripts for clustering analysis of ATAC-seq data using different clustering algorithms: **K-Means**, **Hierarchical Clustering**, and **Gaussian Mixture Models (GMM)**. The goal is to identify distinct groups of chromatin accessibility patterns and visualize them effectively.

---

## Files in the Repository

### 1. **`knn.R`** (K-Means Clustering)
- **Purpose**: Performs K-Means clustering on ATAC-seq data to group samples based on chromatin accessibility.
- **Key Features**:
  - Uses the `kmeans()` function for clustering.
  - Visualizes clusters through time series plots and metaplots using `ggplot2` and `highcharter`.
  - Allows interactive visualization of individual clusters.
  - Saves the clustering results to a file (`clustered_data.txt`).
- **Dependencies**:
  - `tidyr`, `dplyr`, `ggplot2`, `highcharter`, `tidyverse`

---

### 2. **`hierarchical.R`** (Hierarchical Clustering)
- **Purpose**: Applies hierarchical clustering to the ATAC-seq data to create a dendrogram and group samples.
- **Key Features**:
  - Uses the `hclust()` function with the `ward.D2` method to generate a hierarchy of clusters.
  - Visualizes the dendrogram and identifies clusters by cutting the tree into a specified number of groups.
  - Generates metaplots and time series plots for the clusters.
  - Saves cluster summaries to `clustered_data.txt`.
- **Dependencies**:
  - `cluster`, `tidyr`, `dplyr`, `ggplot2`, `highcharter`

---

### 3. **`gmm.R`** (Gaussian Mixture Model Clustering)
- **Purpose**: Leverages Gaussian Mixture Models (GMM) to identify probabilistic clusters in the ATAC-seq data.
- **Key Features**:
  - Uses the `Mclust()` function from the `mclust` package for clustering.
  - Automatically determines the optimal number of clusters.
  - Provides time series plots and interactive cluster visualizations.
  - Saves clustering results in `clustered_data.txt`.
- **Dependencies**:
  - `mclust`, `tidyr`, `dplyr`, `ggplot2`, `highcharter`

---

## Usage Instructions

### Prerequisites
1. Ensure R is installed on your system.
2. Install the required R packages by running:
   ```R
   install.packages(c("tidyr", "dplyr", "ggplot2", "highcharter", "tidyverse", "cluster", "mclust"))
   ```

### Input Data
- The scripts require an input file named `Sample.txt`.
- The file should be a tab-delimited text file with rows representing genomic regions and columns representing chromatin accessibility values or metadata.

### Running the Scripts
1. Open one of the script files in RStudio or another R environment.
2. Adjust parameters (e.g., the number of clusters or columns to include) as needed.
3. Run the script to generate clustering results and visualizations.

### Outputs
- **Clustered Data**: A text file (`clustered_data.txt`) summarizing cluster assignments for each region.
- **Visualizations**:
  - Metaplots: Show average profiles for each cluster.
  - Individual Cluster Plots: Display time series data for each cluster.

---

## Visualization Examples
- **K-Means**: Visualize clusters as interactive time series plots.
- **Hierarchical Clustering**: Examine a dendrogram to interpret the relationships between clusters.
- **GMM**: View clusters probabilistically with optimal group determination.

---

## Authors
- This repository was developed by Sicheng Ma, who can be reached by sm2287@cornell.edu. 
- Special thanks to Rachel (Hsin-Yun) Chang, Dr. Siu Sylvia Lee, and Sarah McMurry.

---
