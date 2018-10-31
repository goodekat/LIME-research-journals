# Example with Plotly to show dead space in heatmap

# System information
# R version 3.5.1 (2018-07-02)
# Platform: x86_64-apple-darwin15.6.0 (64-bit)
# Running under: macOS  10.14

# Load libraries
library(plotly) # version 4.8.0
library(ggplot2) # version 3.1.0
library(tidyr) # version 0.8.2

# Example from: https://plot.ly/r/heatmaps/ -------------------------------------------

# Create dataset
m <- matrix(rnorm(9), nrow = 3, ncol = 3)

# Create plotly heatmap - no dead space to be found
plot_ly(x = c("a", "b", "c"), y = c("d", "e", "f"), z = m, type = "heatmap")

# Example using ggplotly function -----------------------------------------------------

# Reshape the data for ggplot
m_gathered <- data.frame(m) %>%
  gather(key = column) %>%
  mutate(row = factor(rep(c("X1", "X2", "X3"), 3))) %>%
  select(column, row, value)

# Create ggplot heatmap
p <- ggplot(m_gathered, aes(x = column, y = row, fill = value)) +
  geom_tile() + 
  scale_x_discrete(expand = c(0, 0)) + 
  scale_y_discrete(expand = c(0, 0))

# Apply plotly to ggplot heatmap - dead space in the middle of (X1, X1)
ggplotly(p)

# Create ggplot heatmap without a legend
p_nolegend <- ggplot(m_gathered, aes(x = column, y = row, fill = value)) +
  geom_tile() +
  theme(legend.position = "none") 

# Apply plotly to ggplot heatmap - the dead space is gone!
ggplotly(p_nolegend)
