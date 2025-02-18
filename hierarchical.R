# Load required libraries
library(cluster)
library(tidyr)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(highcharter)

# Load the data
data <- read.table("Sample.txt", header = TRUE, sep = "\t")

# Compute distance matrix
dist_matrix <- dist(data[, -1]) # Use columns excluding the first one

# Perform hierarchical clustering
hclust_result <- hclust(dist_matrix, method = "ward.D2")

# Cut tree into clusters
clusters <- cutree(hclust_result, k = 2) # Specify number of clusters

# Assign clusters to the data
data$cluster <- clusters

# Visualize dendrogram
plot(hclust_result, labels = FALSE, main = "Hierarchical Clustering Dendrogram")
rect.hclust(hclust_result, k = 2, border = "red")

# Cluster means for metaplot
cluster_means <- aggregate(data[, -1], by = list(data$cluster), FUN = mean)
cluster_means$Group <- factor(cluster_means$Group.1)
cluster_means <- subset(cluster_means, select = -Group.1)

# Reshape for ggplot
cluster_means_long <- gather(cluster_means, key = "Time", value = "Value", -Group)

# Plot using ggplot2
cluster_colors <- c(
  "#f22020", "#3750db", "#7dfc00", "#0ec434", "#ffc413",
  "#b732cc", "#29bdab", "#f07cab", "#37294f", "#fff000"
)

ggplot(cluster_means_long, aes(x = Time, y = Value, group = Group, color = Group)) +
  geom_line() +
  scale_color_manual(values = cluster_colors) +
  labs(x = "Time", y = "Mean Value", color = "Cluster") +
  theme_minimal()

# Individual cluster plots using highcharter
options(highcharter.theme = hc_theme_smpl(tooltip = list(valueDecimals = 2)))

cluster_list <- list()
for (i in 1:10) {
  cluster_list[[paste0("Cluster", i)]] <- data[data$cluster == i, ]
}

Colorpointer <- 1

for (currclus in cluster_list) {
  df_long <- pivot_longer(currclus, cols = starts_with("P"), names_to = "Time", values_to = "Value")
  
  p <- df_long %>%
    hchart("line", hcaes(x = Time, y = Value, group = geneid), color = cluster_colors[[Colorpointer]])
  
  p <- p %>% hc_legend(enabled = FALSE)
  p <- p %>% hc_title(text = paste("Cluster", Colorpointer, sep = " "))
  print(p)
  
  Colorpointer <- Colorpointer + 1
}

# Summarize clustered data
gene_names <- data[, 1]
frame_for_sort <- data.frame(cluster = data$cluster, names = gene_names)

# Group by Cluster and concatenate Names
clustered_data <- frame_for_sort %>%
  group_by(cluster) %>%
  summarise(Names = paste(names, collapse = " "))

# Print and save results
print(clustered_data)
write.table(clustered_data, "clustered_data.txt", sep = " ", row.names = FALSE, quote = FALSE)
