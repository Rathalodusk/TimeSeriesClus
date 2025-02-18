# Load required libraries
library(tidyr)
library(dplyr)
library(ggplot2)
library(highcharter)
library(mclust)
library(cluster)

# Load in the metadata
data <- read.table("Sample.txt", header = TRUE, sep = "\t")

# Run GMM clustering
gmm_result <- Mclust(data[, -1])  # Exclude the first column if it contains non-numeric identifiers

# Assign clusters to the data
data$cluster <- gmm_result$classification

# Plot GMM result
plot(gmm_result, what = "classification", main = "GMM Clustering")

# Cluster centers and colors
groups <- unique(data$cluster)
default_colors <- c(
  "#f22020", "#3750db", "#7dfc00", "#0ec434", "#ffc413",
  "#b732cc", "#29bdab", "#f07cab", "#37294f", "#fff000",
  "#235b54", "#991919", "#d30b94", "#e68f66", "#3998f5"
)
cluster_colors <- default_colors[1:length(groups)]
colors_list <- setNames(as.list(cluster_colors), paste0("Cluster", groups))

# Plot clustered time series
plot(data$cluster, type = "b", col = data$cluster)
legend("topright", legend = paste("Cluster", groups), col = unique(data$cluster), pch = 1)

# Calculate the average profile for metaplot
cluster_means <- data %>%
  group_by(cluster) %>%
  summarise(across(where(is.numeric), mean))

# Reshape the data for plotting using ggplot2
cluster_means_long <- cluster_means %>%
  pivot_longer(cols = -cluster, names_to = "Time", values_to = "Value")

# Plot using ggplot2
ggplot(cluster_means_long, aes(x = Time, y = Value, group = factor(cluster), color = factor(cluster))) +
  geom_line() +
  scale_color_manual(values = cluster_colors) +
  labs(x = "Time", y = "Mean Value", color = "Cluster") +
  theme_minimal()

# Individual Cluster Plot
clus_result <- data$cluster
cluster_list <- split(data, data$cluster)

Colorpointer <- 1

for (currclus in cluster_list) {
  # Remove duplicate rows
  currclus <- currclus %>% distinct()
  
  # Reshape the data to long format for plotting
  df_long <- currclus %>%
    pivot_longer(cols = starts_with("P"), names_to = "Time", values_to = "Value")
  
  # Ensure correct ordering of time points
  df_long$Time <- factor(df_long$Time, levels = c("P1vsN1", "P2vsN2", "P3vsN3"))
  
  # Remove rows with missing or NA values
  df_long <- df_long %>% filter(!is.na(Value))
  
  # Check grouping variable
  if (!"geneid" %in% names(df_long)) {
    stop("Error: 'geneid' column is missing in the data.")
  }
  
  # Interactive plot
  p <- df_long %>%
    hchart("line", hcaes(x = Time, y = Value, group = geneid), color = cluster_colors[Colorpointer]) %>%
    hc_legend(enabled = FALSE) %>%
    hc_title(text = paste("Cluster", Colorpointer))
  
  # Print the interactive plot
  print(p)
  
  # Increment the color pointer
  Colorpointer <- Colorpointer + 1
}



# Create chart for clustering result
gene_names <- data[, 1]
frame_for_sort <- data.frame(cluster = clus_result, names = gene_names)

# Group by Cluster and concatenate Names
clustered_data <- frame_for_sort %>%
  group_by(cluster) %>%
  summarise(Names = paste(names, collapse = " "))

# Print the results
print(clustered_data)

# Write to a text file
write.table(clustered_data, "clustered_data.txt", sep = " ", row.names = FALSE, quote = FALSE)
