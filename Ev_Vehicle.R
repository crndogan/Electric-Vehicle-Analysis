library(readr) 
library(dplyr) 
library(tidyverse)
library(ggplot2)

ev_data <- read_csv("C:/Electric_Vehicle_Population_Data.csv")

#Inspect the data
head(ev_data)
str(ev_data)
summary(ev_data)

#renaming columns
ev_data <- ev_data %>%
  rename(
    VIN = `VIN (1-10)`,
    PostalCode= `Postal Code`,
    ModelYear = `Model Year`,
    EvType = `Electric Vehicle Type`,
    BasePrice = `Base MSRP`,
    ElectricRange=`Electric Range`,
    EligibilityStatus = `Clean Alternative Fuel Vehicle (CAFV) Eligibility`,
    LegislativeDistrict=`Legislative District`,
    VehicleID =`DOL Vehicle ID`,
    VehicleLocation =`Vehicle Location`,
    ElectricUtility=`Electric Utility`,
    CensusTract20 =`2020 Census Tract`)


#updating data types and adding fields

mean_range <- mean(ev_data$ElectricRange)
current_year <- as.numeric(format(Sys.Date(), "%Y"))  
  
ev_data <- ev_data %>%
  mutate(
         County = as.factor(County),
         City = as.factor(City),
         Make = as.factor(Make),
         Model = as.factor(Model),
         ElectricRangeQuality = ifelse(ElectricRange> mean_range, 'GOOD', 'BAD'), 
         CAFV_Eligible=ifelse ( EligibilityStatus=='Clean Alternative Fuel Vehicle Eligible','Yes', 'No'),
         EV_Age = current_year-ModelYear,
         BasePrice_Range=ifelse(BasePrice >100000, 'High','Low'),
         EV_Brand = paste(Make,' ', Model))


#Creating Data Frame 1

ev_state <- ev_data %>%
             group_by(State) %>%  summarise(State_count = length(Make)) %>% 
             arrange(-State_count) %>% 
             head(15)

#Creating Data Frame 2

ev_type <- ev_data %>%
           group_by(EvType) %>%
           summarise(count=n())


#Creating Data Frame 3
ev_price <- ev_data %>%
  filter(ElectricRange > 0) %>%
  group_by(EV_Brand) %>%
  summarise(avg_range = mean (ElectricRange))



#TOP 5 vehicle count by make bar chart
top_makes <- ev_data %>%
  count(Make) %>%
  arrange(desc(n)) %>%
  slice_head(n = 5)
top5make_data <- ev_data %>%
  filter(Make %in% top_makes$Make)
ggplot(top5make_data, aes(x = Make)) +
  coord_flip()+
  geom_bar(fill = "steelblue") +
  theme(axis.text.x = element_text(angle = 45, hjust = -1)) +
  labs(title = "Number of Electric Vehicles by Make",
       x = "Count",
       y = "Make")+
  theme_classic()

#histogram of vehicle age

ggplot(ev_data, aes(x = EV_Age)) +
  geom_histogram(bins = 10, fill = "blue", color = "black") +
  theme_classic() +
  labs(title = "Distribution of Vehicle Ages",
       x = "Vehicle Age (Years)",
       y = "Frequency")+
  theme(axis.text.x = element_text(hjust = 1),
        legend.position = "top")

#Plot data for electrical vehicle range
ev_price <- ev_data %>%
  filter(BasePrice > 0) %>%
  group_by(EV_Brand) %>%
  summarise(avg_range = mean (ElectricRange),
            avg_price =mean(BasePrice))%>%
  arrange(avg_range)
ggplot(data = ev_price, mapping = aes(x = avg_price, y = avg_range)) +
  geom_point()


#Pie chart for ev_type data frame
ggplot(ev_type, aes(x = "", y = count, fill = EvType)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta = "y") +  
  theme_void() +  
  labs(fill = "EV Type", title = "Distribution of Electric Vehicle Types")


#Top 10 Electric Vehicle Models by Average Electric Range
ev_line <- ev_data %>%
  filter(ElectricRange > 0) %>%
  group_by(Make) %>%
  summarise(avg_range = mean(ElectricRange))

top_10_models <- ev_line %>%
  arrange(desc(avg_range)) %>%
  head(10)

ggplot(top_10_models, aes(x = reorder(Make, avg_range), y = avg_range)) +
  geom_line(color = "blue") +
  geom_point(color = "blue", size = 3) +  
  geom_smooth(method = "loess", se = FALSE, color = "red") +  
  theme_minimal() +
  labs(title = "Top 10 Electric Vehicle Models by Average Electric Range",
       x = "Electric Vehicle Model",
       y = "Average Electric Range (miles)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  
        axis.title = element_text(size = 12, face = "bold"),  
        plot.title = element_text(size = 16, face = "bold")) 

# Exporting processed data to a CSV file

write.csv(ev_data, "Ev_Data.csv", row.names = FALSE)
write.csv(ev_state, "Df1_EvState.csv", row.names = FALSE)
write.csv(ev_type, "Df2_EvType.csv", row.names = FALSE)
write.csv(ev_price, "Df3_EvPrice.csv", row.names = FALSE)



