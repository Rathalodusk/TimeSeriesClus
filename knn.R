library(tidyr)
library(dtwclust)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(highcharter) 


# load in the metadata
data <- read.table("Sample.txt", header = TRUE, sep = "\t")
metadata <- names(data)
# k-means clustering
###P1,P2&P3
kmeans_clusters <- kmeans(data[, -1], centers = 10)
###P2&P3
# kmeans_clusters <- kmeans(data[, -c(1, 2)], centers = 8)
###P3 ONLY
# kmeans_clusters <- kmeans(data[, -c(1, 2, 3)], centers = 8)
groups <- 1:10

# Get default colors
default_colors <- 
  c(  "#f22020",  
      "#3750db",
      "#7dfc00",
      "#0ec434",
      "#ffc413",
      "#b732cc",
      "#29bdab",
      "#f07cab",
      "#37294f",
      "#fff000",
      "#235b54",
      "#991919",
      "#d30b94",
      "#e68f66",
      "#3998f5",
      "#f47a22",
      "#2f2aa0",
      "#772b9d",
      "#c56133",
      "#228c68",
      "#946aa2",
      "#5d4c86",
      "#96341c",
      "#632819",
      "#277da7",
      "#8ad8e8",
      "#ffcba5",
      "#c3a5b4"
  )

cluster_colors <- default_colors[1:10]

colors_list <- list()

for (i in 1:length(cluster_colors)) {
  colors_list[[paste0("Cluster", i)]] <- cluster_colors[i]
}


# Plot clustered time series
plot(kmeans_clusters$cluster, type = "b", col = kmeans_clusters$cluster)
legend("topright", legend = paste("Cluster", unique(kmeans_clusters$cluster)), col = unique(kmeans_clusters$cluster), pch = 1)



####METAPLOT
# Calculate the average profile
cluster_means <- aggregate(data[, -1], by = list(kmeans_clusters$cluster), FUN = mean)

cluster_means$Group <- factor(cluster_means$Group)

cluster_means <- subset(cluster_means, select = -Group.1)

# Reshape the data for plotting using ggplot2
cluster_means_long <- gather(cluster_means, key = "Time", value = "Value", -Group)

# Plot using ggplot2
ggplot(cluster_means_long, aes(x = Time, y = Value, group = Group, color = Group)) +
  geom_line() +
  scale_color_manual(values = cluster_colors) +  
  labs(x = "Time", y = "Mean Value", color = "Cluster") +
  theme_minimal()



###INDIVIDUAL PLOT


# Set highcharter options
options(highcharter.theme = hc_theme_smpl(tooltip = list(valueDecimals = 2)))

clus_result <- kmeans_clusters$cluster
cluster_list <- list()

# iterate over the numbers vector
for (num in groups) {
  clusname <- paste0("cluster", num)
  indices <- which(clus_result == num)
  cluster_list[[clusname]] <- data[indices, ]
}

Colorpointer <- 1

# RUN FROM HERE TO GENERATE INDIVIDUAL PLOTS
for (currclus in cluster_list) {
  # Reshape the data to long format for plotting
  df_long <- pivot_longer(currclus, cols = starts_with("P"), names_to = "Time", values_to = "Value")
  
  
  
  ####NORMAL MODE#####
  #p <- ggplot(df_long, aes(x = Time, y = Value, group = geneid, color = as.factor(Colorpointer))) + geom_line() + scale_color_manual(values = default_colors[[Colorpointer]]) +  labs(title = "Time Series Plot", x = "Time", y = "Value") + theme_minimal()

  
  
  
  ####INTERACTIVE MODE#### SAVE WITH HTML FORMAT PLEASE
  p <- df_long %>%hchart("line",hcaes(x = Time, y = Value, group = geneid),color = default_colors[[Colorpointer]])
  p <- p %>% hc_legend(enabled = FALSE)
  mytitle <- paste("Cluster", Colorpointer, sep = "")
  p <- p %>% hc_title(text = mytitle)
  
  
  
  # Print or save the plot
  print(p)  
  # Increment the color pointer
  Colorpointer <- Colorpointer + 1
}

###CREATE CHART FOR CLUSTERING RESULT
gene_names <- data[,1]
frame_for_sort <- data.frame(cluster = clus_result, names = gene_names)

# Group by Cluster and concatenate Names
clustered_data <- frame_for_sort %>%
  group_by(cluster) %>%
  summarise(Names = paste(names, collapse = " "))

# Print the results
print(clustered_data)
# Write to a text file
write.table(clustered_data, "clustered_data.txt", sep = " ", row.names = FALSE, quote = FALSE)

