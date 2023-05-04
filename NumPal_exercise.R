###### Introduction #####

rm(list=ls())
# This command will clean your environment - same as clicking on the broom in the "Environment" tab

#### Area charts ####
# For this exercise you will need the following packages:
# ggplot2
# data.table
# After completing previous exercises, you should already know how to install and load
# a package. And what to do in order for your R Markdown file to process this information correctly.
# If you still hesitate, try to consult the materials in module 0, ask the teaching assistants, or ask in the course's Teams channel.

# Importing the csv file. 
Table2 <- read.csv(file="Table2.csv", header=T, sep = ",")

# Changing to the so called long format, which is used to make graphics with ggplot
# When you import Table 4, the parameters might vary slightly. Always check the dimensions
# of your file and open it to check if it has imported correctly.
df2 <- data.table::melt(Table2, measure.vars=colnames(Table2)[3:10])

# We set a lot of parameters in this plot because we want it to have a perfect legend.
# Genus and species names in Latin are written in italics so we use a relatively complex code to 
# preserve this convention. Without the italics, the code for the plot would be simpler, but it wouldn't be as correct.
ggplot2::ggplot(df2, aes(x=Layer, y=value, fill=variable)) + 
  geom_area(alpha=0.6 , linewidth=1, colour="black")+
  theme_classic()+
  scale_x_reverse(breaks=seq(1, 11, 1))+
  ylab("Abundance [%]")+
  scale_fill_discrete(name = "Taxon", labels = c(expression(italic("Dicrostonyx")),                 
                                                 expression(italic("Microtus nivalis")),            
                                                 expression(italic("Microtus oeconomus")),          
                                                 expression(italic("Microtus gregalis")),           
                                                 expression(italic("Microtus arvalis")),            
                                                 expression(italic("Microtus gregalis")~ "or"~italic("M. arvalis")),
                                                 expression(italic("Arvicola")),                    
                                                 expression(italic("Clethrionomys"))))+
  theme(legend.text.align = 0)+
  ggtitle("Proportion of first lower molars of voles (Arvicolinae) at Jankovich Cave")

# What if we plotted along age instead?
ggplot2::ggplot(df2, aes(x=Age, y=value, fill=variable)) + 
  geom_area(alpha=0.6 , linewidth=1, colour="black")+
  theme_classic()+
  scale_x_reverse(breaks=Table2$Age)+
  ylab("Abundance [%]")+
  scale_fill_discrete(name = "Taxon", labels = c(expression(italic("Dicrostonyx")),                 
                                                 expression(italic("Microtus nivalis")),            
                                                 expression(italic("Microtus oeconomus")),          
                                                 expression(italic("Microtus gregalis")),           
                                                 expression(italic("Microtus arvalis")),            
                                                 expression(italic("Microtus gregalis")~ "or"~italic("M. arvalis")),
                                                 expression(italic("Arvicola")),                    
                                                 expression(italic("Clethrionomys"))))+
  theme(legend.text.align = 0)+
  ggtitle("Proportion of first lower molars of voles (Arvicolinae) at Jankovich Cave")

# That looks a bit weird, doesn't it? 
# This is because some layers have been assigned the same age. In reality, the ones
# above the others are for sure younger, it's just geological dating does not give us
# sufficient resolution to measure how much younger they are.
# There are several solutions to it. You could average out the proportions from two layers
# that have the same age (so you would have fewer points on the X axis) or add a small
# number to the age of the younger layer in each pair to make it plot as slightly
# younger - we leave it up to you how to deal with it. Just document in your report what you did.

#### Plotting biomes ####

require("ncdf4")
require("lattice")

file <- "LateQuaternary_Environment.nc";

env_nc      <- ncdf4::nc_open(file)
longitude   <- ncdf4::ncvar_get(env_nc, "longitude")
latitude    <- ncdf4::ncvar_get(env_nc, "latitude")
years       <- ncdf4::ncvar_get(env_nc, "time")
months      <- ncdf4::ncvar_get(env_nc, "month")
temperature <- ncdf4::ncvar_get(env_nc, "temperature")
biome       <- ncdf4::ncvar_get(env_nc, "biome")
ncdf4::nc_close(env_nc)

my_year      <- -10000;   # Here you set the age you are interested in - 10 000 BP as example

p1 <- print(lattice::levelplot(biome[,,years == my_year][320:550,150:300], main = "Biome distribution, 10 000 BP", 
                               col.regions=rainbow(28)))
# These colors are a bit toxic, but give high contrast. If you want to change the palette, you can try 
# substituting rainbow(28) with terrain.color(28), heat.colors(28), topo.colors(28) or cm.colors(28)

# What does "[320:550,150:300]" mean? The dataset is for the entire world. With this fragment of code
# we cut out the fragment corresponding to Europe. You can modify it and see what happens -
# maybe you just want to see how biomes changed in the Netherlands?

# But the biome scale is in numbers, not names! What now?
# Biomes are standardized in this widely used model, so each number has a fixed meaning:
# 0.  'Tropical evergreen forest',
# 1.	'Tropical semi-deciduous forest',
# 2.	'Tropical deciduous forest/woodland',
# 3.	'Temperate deciduous forest',
# 4.	'Temperate conifer forest',
# 5.	'Warm mixed forest',
# 6.	'Cool mixed forest',
# 7.	'Cool conifer forest',
# 8.	'Cold mixed forest',
# 9.	'Evegreen taiga/montane forest',
# 10.	'Deciduous taiga/montane forest',
# 11.	'Tropical savanna',
# 12.	'Tropical xerophytic shrubland',
# 13.	'Temperate xerophytic shrubland',
# 14.	'Temperate sclerophyll woodland',
# 15.	'Temperate broadleaved savanna',
# 16.	'Open conifer woodland',
# 17.	'Boreal parkland',
# 18.	'Tropical grassland',
# 19.	'Temperate grassland',
# 20.	'Desert',
# 21.	'Steppe tundra',
# 22.	'Shrub tundra',
# 23.	'Dwarf shrub tundra',
# 24.	'Prostrate shrub tundra',
# 25.	'Cushion-forbs, lichen and moss',
# 26.	'Barren',
# 27.	‘Land ice’

# Why on earth does this list start at zero? It was originally a computer program
# Some programming languages count from zero and that's how it stayed. If you're a Python user, you're probably used to it already.
