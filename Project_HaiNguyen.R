# Install and load gapminder package
library(gapminder)
library(ggplot2)
library(tidyr)
library(dplyr)
library(plotly)
library(lattice)
library(latticeExtra)
library(ggalluvial)
library(waffle)
library(ggridges)
library(GGally)
library(grid)
library(maps)
# Load dataset
data("gapminder")
head(gapminder)
str(gapminder)
summary(gapminder)

# Overview
# 1. Pie Chart: Proportion of Countries by Continent
continent_proportion <- gapminder %>% count(continent) %>%
  mutate(percentage = n / sum(n) * 100)
ggplot(continent_proportion, aes(x = "", y = percentage, fill = continent)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Proportion of Countries by Continent", fill = "Continent") +
  theme_void() +
  geom_text(aes(label = paste0(round(percentage, 1), "%")), 
            position = position_stack(vjust = 0.5), size = 3) + 
  theme(plot.title = element_text(color = 'blue',hjust = 0.5))


# 2. Economic Indicators
# 2. Bar Chart: Average GDP per Capita by Continent
gapminder %>% group_by(continent) %>%
  summarise(avg_gdpPercap = mean(gdpPercap, na.rm = TRUE)) %>%
  ggplot(aes(x = continent, y = avg_gdpPercap, fill = continent)) +
  geom_bar(stat = "identity") +
  labs(title = "Average GDP per Capita by Continent", y = "GDP per Capita")+
  theme_minimal() + theme(plot.title = element_text(color = 'blue',hjust = 0.5),
  legend.position = 'top',legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9))

# 3. Heatmap: GDP per Capita Across Continents and Years
gapminder %>% ggplot(aes(x = year, y = continent, fill = gdpPercap)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "GDP per Capita Heatmap", y = "Continent", x = "Year")+
theme_minimal() + theme(plot.title = element_text(color = 'blue',hjust = 0.5),
  legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9))

# 3. Choropleth Map with GDP per Capita by Country
world_map <- map_data("world")
gapminder_2007 <- gapminder %>% filter(year == 2007)
world_map <- left_join(world_map, gapminder_2007, by = c("region" = "country"))
ggplot(world_map, aes(x = long, y = lat, group = group, fill = gdpPercap)) +
  geom_polygon(color = "lightblue") +
  scale_fill_gradient(low = "yellow", high = "red") +
  labs(title = "GDP per Capita by Country in 2007", fill = "GDPPercap") + theme_void() + theme_minimal() + 
  theme(plot.title = element_text(color = 'blue', hjust = 0.5),legend.position = c(0.1, 0.35),
        legend.background = element_rect(fill = "white", color = "black"),legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9)) +
  annotation_custom(grob = textGrob("Luxembourg", gp = gpar(col = "black", fontsize = 6, fontface = "bold")),
                    xmin = 5, xmax = 10, ymin = 45, ymax = 50) + 
  annotation_custom(grob = textGrob("Burundi", gp = gpar(col = "black", fontsize = 6, fontface = "bold")),
                    xmin = 29, xmax = 34, ymin = -3, ymax = 3)

# 5. Population and Demographics
# 5. Stacked Bar Chart: Population by Continent Over Time
gapminder %>% ggplot(aes(x = year, y = pop, fill = continent)) +
  geom_bar(stat = "identity") + scale_y_continuous(labels = scales::label_number(scale = 1e-6)) +
  labs(title = "Population by Continent Over Time", x = "Year", y = "Population (Millions)") + 
  scale_fill_brewer(palette = "Set3")+ theme_minimal() + 
  theme(plot.title = element_text(color = 'blue',hjust = 0.5),legend.position='top',
        legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9))

# 6. Sankey Diagram: Population Flows Between Continents
gapminder %>% filter(year %in% c(1952, 2007)) %>%
  ggplot(aes(axis1 = year, axis2 = continent, y = pop/1000000000, fill = continent)) +
  geom_alluvium(aes(fill = continent)) + geom_stratum(width = 0.1) +
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  labs(title = "Population Flows Between Continents (1952 to 2007)", y = "Population Billion")+ 
  theme_minimal() + theme(plot.title = element_text(color = 'blue',hjust = 0.5),
  legend.position='top',legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9) )

# 7. Waffle Chart: Population Distribution by Continent
gapminder %>% filter(year == 2007) %>% group_by(continent) %>% summarise(total_pop = sum(pop)) %>%
  mutate(proportion = round(total_pop / sum(total_pop) * 100)) %>%
  ggplot(aes(fill = continent, values = proportion)) +
  geom_waffle(n_rows = 10, size = 0.3, color = "white") +
  labs(title = "Population Distribution by Continent (2007)") +
  theme_void() + theme_minimal() + theme(plot.title = element_text(color = 'blue',hjust = 0.5),
  legend.position='top',legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9) )

# 8. Circular Bar Plot: Population by Country
gapminder %>% filter(year == 2007) %>% arrange(desc(pop)) %>%
  top_n(10, pop) %>% ggplot(aes(x = reorder(country, pop), y = pop / 1e6, fill = continent)) +
  geom_bar(stat = "identity") + coord_polar() +
  labs(title = "Top 10 Populated Countries in 2007", y = "Population (millions)",x="")+
  theme_minimal() + theme(plot.title = element_text(color = 'blue',hjust = 0.5),
legend.position='top',legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9) )

# 9. Health and Life Expectancy
# 9. Ridgeline Plot: Life Expectancy Distribution by Continent
gapminder %>% ggplot(aes(x = lifeExp, y = continent, fill = continent)) +
  geom_density_ridges() + labs(title = "Life Expectancy Distribution by Continent", x = "Life Expectancy", y = "Continent") +
  theme_ridges() + theme_minimal() + theme(plot.title = element_text(color = 'blue',hjust = 0.5),
                                           legend.position='top',legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9) )

# 10. Average Life Expectancy Over Time by Continent
avg_life_expectancy <- gapminder %>% group_by(continent, year) %>% summarize(avg_lifeExp = mean(lifeExp))
ggplot(avg_life_expectancy, aes(x = year, y = avg_lifeExp, color = continent)) +
  geom_line(size = 1) + geom_point(size = 2) +
  labs(title = "Average Life Expectancy Over Time by Continent", x = "Year", y = "Average Life Expectancy", color = "Continent") +
  theme(plot.title = element_text(color = "blue", hjust = 0.5)) +
  scale_color_manual(values = c("Asia" = "blue", "Europe" = "green", "Africa" = "red", "Americas" = "purple", "Oceania" = "orange"))+
  theme_minimal() + theme(plot.title = element_text(color = 'blue',hjust = 0.5),
                         legend.position='top',legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9) )


# 11. Combined Economic and Demographic Trends
# 11. Scatterplot Matrix: Key Economic Indicators
gapminder %>%
  select(lifeExp, gdpPercap, pop) %>% ggpairs( title = "Key Economic Indicators",
    upper = list(continuous = wrap("cor", size = 3, color = "darkgreen")),
    lower = list(continuous = wrap("points", size = 0.7, alpha = 0.6, color = "red")), 
    diag = list(continuous = wrap("densityDiag", fill = "yellow", color = "lightblue"))) + 
  theme(plot.title = element_text(color = 'blue', hjust = 0.5), axis.text = element_text(size = 8))

# 12. Time Series Line Plot: GDP per Capita and Life Expectancy Over Time
gapminder_summary <- gapminder %>% group_by(continent, year) %>%
  summarise(avg_gdpPercap = mean(gdpPercap, na.rm = TRUE), avg_lifeExp = mean(lifeExp, na.rm = TRUE))
ggplot(gapminder_summary, aes(x = year)) +
  geom_line(aes(y = avg_gdpPercap, color = continent), size = 1) +
  geom_line(aes(y = avg_lifeExp * 100, color = continent), size = 1, linetype = "dashed") +
  scale_y_continuous(name = "GDP per Capita", sec.axis = sec_axis(~./100, name = "Life Expectancy")) + 
  labs(title = "GDP per Capita and Life Expectancy Over Time by Continent",y = "GDP per Capita", color = "Continent") +
  theme_minimal()+ theme(plot.title = element_text(color = 'blue',hjust = 0.5),
  legend.position='top',legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9) )

# 13. Trend of GDP and Life Expectancy by Country (Top 3)
top_3_countries <- gapminder %>% group_by(country) %>% summarise(total_pop = sum(pop)) %>%
top_n(3, total_pop) %>% pull(country)
gapminder_top3 <- gapminder %>% filter(country %in% top_3_countries)
ggplot(gapminder_top3, aes(x = year)) + geom_line(aes(y = gdpPercap, color = country)) +
  geom_line(aes(y = lifeExp * 100, color = country), linetype = "dashed") +
  facet_wrap(~country) + labs(title = "GDP and Life Expectancy Trends by Country (Top 3 by Population)",
  y = "GDP per Capita", color = "Country") +
  scale_y_continuous(name = "GDP per Capita", sec.axis = sec_axis(~./100, name = "Life Expectancy")) +
  theme_minimal()+ theme(plot.title = element_text(color = 'blue',hjust = 0.5),axis.text.x = element_text(angle = 45),
  legend.position='top',legend.key.size = unit(0.3, "cm"), legend.title = element_text(size = 9), legend.text = element_text(size = 9))

# 14. Bubble Plot: GDP vs Life Expectancy with Population Size

# Identify data for USA and China in 2007
highlight_countries <- gapminder %>% filter(year == 2007 & country %in% c("United States", "China"))
# Identify region with low GDP
low_gdp_countries <- gapminder %>% filter(year == 2007 & gdpPercap < 500)  # Define threshold for low GDP
# Plot with highlights
gapminder %>% filter(year == 2007) %>% ggplot(aes(x = gdpPercap, y = lifeExp, size = pop / 1e6, color = continent)) +
  geom_point(alpha = 0.7) + scale_x_log10() +
  labs(title = "GDP vs Life Expectancy (Bubble Size = Population)", x = "GDP per Capita", y = "Life Expectancy") +
  scale_size_continuous(name = "Pop (M)") +
  theme_minimal() +
  theme(plot.title = element_text(color = 'blue', hjust = 0.5),legend.key.size = unit(0.3, "cm"),
        legend.title = element_text(size = 9),legend.text = element_text(size = 9)) +
  # Highlight China with its population
  geom_point(data = highlight_countries %>% filter(country == "China"), aes(x = gdpPercap, y = lifeExp),
             size = 8, color = "red", shape = 21, fill = "yellow") +
  geom_text(data = highlight_countries %>% filter(country == "China"),
            aes(label = paste0("China\n", round(pop / 1e6, 1), "M")),
            vjust = -0.5, hjust = 0.5, size = 3, color = "darkblue") +
  # Highlight USA with its life expectancy
  geom_point(data = highlight_countries %>% filter(country == "United States"),
             aes(x = gdpPercap, y = lifeExp),
             size = 8, color = "blue", shape = 21, fill = "lightblue") +
  geom_text(data = highlight_countries %>% filter(country == "United States"),
            aes(label = paste0("USA\n", round(lifeExp, 1), " years")),
            vjust = -0.5, hjust = 0.5, size = 3, color = "red") +
  # Highlight low GDP countries
  geom_point(data = low_gdp_countries, aes(x = gdpPercap, y = lifeExp),
             size = 2, color = "darkgreen", shape = 17) +
  geom_text(data = low_gdp_countries, aes(label = country),
            vjust = 1.5, hjust = 0.5, size = 2, color = "darkgreen")

# 15. Interactive and 3D Visualizations
# 15 3D Cloud Plot: GDP per Capita, Life Expectancy, and Population
plot_ly(gapminder, x = ~gdpPercap, y = ~lifeExp, z = ~pop, color = ~continent, size = ~pop / 1e6, type = "scatter3d", mode = "markers", 
marker = list(opacity = 0.7)) %>% layout(title = list(text="3D Cloud Plot: GDP, Life Expectancy, and Population",font = list(color = 'blue'),x = 0.5, y = 0.98),
scene = list(xaxis = list(title = "GDP per Capita",titlefont = list(size = 12, color = "green")), 
             yaxis = list(title = "Life Expectancy",titlefont = list(size = 12, color = "red")), 
             zaxis = list(title = "Population",titlefont = list(size = 12, color = "purple"))), 
legend = list(title = list(text = "Continent")))


# 16. Wireframe Plot: GDP per Capita vs Life Expectancy and Population
model <- lm(gdpPercap ~ lifeExp + pop, data = gapminder)
lifeExp_vals <- seq(min(gapminder$lifeExp, na.rm = TRUE), max(gapminder$lifeExp, na.rm = TRUE), length.out = 30)
pop_vals <- seq(min(gapminder$pop, na.rm = TRUE), max(gapminder$pop, na.rm = TRUE), length.out = 30)
grid_data <- expand.grid(lifeExp = lifeExp_vals, pop = pop_vals)
grid_data$gdpPercap <- predict(model, newdata = grid_data)
wireframe(gdpPercap ~ lifeExp + pop, data = grid_data, 
main = list("GDP per Capita vs Life Expectancy and Population", col = 'blue'), 
xlab = list("Life Expectancy",col='red',cex=0.7), ylab = list(text="Population",col='purple',cex=0.7), zlab = list("GDP per Capita",col='darkgreen',cex=0.7),
drape = TRUE, col.regions = heat.colors(100), 
scales = list(arrows = TRUE, col = "gray"), aspect = c(1, 1))
