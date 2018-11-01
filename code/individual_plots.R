# Code for creating the heatmap plots using individual plots

# Load libraries 
library(plotly)
library(ggplot2)
library(dplyr)

# Input data
hamby224_test_explain <- readRDS("./data/hamby224_test_explain.rds")

# Create a dataset with all combinations of lands and bullets comparisons for each set
combinations1 <- data.frame(set = factor(1),
                            expand.grid(land1 = factor(1:6),
                                        land2 = factor(1:6),
                                        bullet1 = factor(c("1", "2", "Q")),
                                        bullet2 = factor(c("1", "2", "Q"))))
combinations11 <- data.frame(set = factor(11),
                             expand.grid(land1 = factor(1:6),
                                         land2 = factor(1:6), 
                                         bullet1 = factor(c("1", "2", "I")),
                                         bullet2 = factor(c("1", "2", "I"))))
combinations <- rbind(combinations1, combinations11)

# Join the combinations and the data so that all combinations have a row in the data
hamby224_test_explain_NAs <- left_join(combinations, hamby224_test_explain,
                                       by = c("set", "land1", "land2", "bullet1", "bullet2")) %>%
  mutate(bullet1 = forcats::fct_recode(bullet1, "Known 1" = "1", "Known 2" = "2", 
                                       "Questioned" = "Q", "Questioned" = "I"),
         bullet2 = forcats::fct_recode(bullet2, "Known 1" = "1", "Known 2" = "2", 
                                       "Questioned" = "Q", "Questioned" = "I"))

chosen_set = 1

p1 <- hamby224_test_explain_NAs %>%
  filter(set == chosen_set, bullet1 == "Known 1", bullet2 == "Known 1") %>%
  select(case, bullet1, bullet2, land1, land2, rfscore) %>%
  distinct() %>%
  ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2)) +
  geom_tile(aes(fill = rfscore)) +
  facet_grid(bullet1 ~ bullet2, scales = "free") +
  theme_minimal() +
  scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5) +
  labs(x = "Land 1", y = "Land 2", fill = "RF Score") + 
  theme(legend.position = "none")

p2 <- hamby224_test_explain_NAs %>%
  filter(set == chosen_set, bullet1 == "Known 1", bullet2 == "Known 2") %>%
  select(case, bullet1, bullet2, land1, land2, rfscore) %>%
  distinct() %>%
  ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2)) +
  geom_tile(aes(fill = rfscore)) +
  facet_grid(bullet1 ~ bullet2, scales = "free") +
  theme_minimal() +
  scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5) +
  labs(x = "Land 1", y = "Land 2", fill = "RF Score") + 
  theme(legend.position = "none")

p3 <- hamby224_test_explain_NAs %>%
  filter(set == chosen_set, bullet1 == "Known 1", bullet2 == "Questioned") %>%
  select(case, bullet1, bullet2, land1, land2, rfscore) %>%
  distinct() %>%
  ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2)) +
  geom_tile(aes(fill = rfscore)) +
  facet_grid(bullet1 ~ bullet2, scales = "free") +
  theme_minimal() +
  scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5) +
  labs(x = "Land 1", y = "Land 2", fill = "RF Score") + 
  theme(legend.position = "none")

p4 <- ggplot() + geom_blank() + theme_classic()

p5 <- hamby224_test_explain_NAs %>%
  filter(set == chosen_set, bullet1 == "Known 2", bullet2 == "Known 2") %>%
  select(case, bullet1, bullet2, land1, land2, rfscore) %>%
  distinct() %>%
  ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2)) +
  geom_tile(aes(fill = rfscore)) +
  facet_grid(bullet1 ~ bullet2, scales = "free") +
  theme_minimal() +
  scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5) +
  labs(x = "Land 1", y = "Land 2", fill = "RF Score") + 
  theme(legend.position = "none")

p6 <- hamby224_test_explain_NAs %>%
  filter(set == chosen_set, bullet1 == "Known 2", bullet2 == "Questioned") %>%
  select(case, bullet1, bullet2, land1, land2, rfscore) %>%
  distinct() %>%
  ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2)) +
  geom_tile(aes(fill = rfscore)) +
  facet_grid(bullet1 ~ bullet2, scales = "free") +
  theme_minimal() +
  scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5) +
  labs(x = "Land 1", y = "Land 2", fill = "RF Score") + 
  theme(legend.position = "none")

p7 <- ggplot() + geom_blank() + theme_classic()

p8 <- ggplot() + geom_blank() + theme_classic()

p9 <- hamby224_test_explain_NAs %>%
  filter(set == chosen_set, bullet1 == "Questioned", bullet2 == "Questioned") %>%
  select(case, bullet1, bullet2, land1, land2, rfscore) %>%
  distinct() %>%
  ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2)) +
  geom_tile(aes(fill = rfscore)) +
  #facet_grid(bullet1 ~ bullet2, scales = "free") +
  theme_minimal() +
  scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5, limits = c(0,1)) +
  labs(x = "Land 1", y = "Land 2", fill = "RF Score")

style(subplot(p1, p2, p3, p4, p5, p6, p7, p8, p9, nrows = 3, titleX = TRUE, titleY = TRUE, margin = 0.03),
      hoverinfo = "skip",
      traces = 7)

