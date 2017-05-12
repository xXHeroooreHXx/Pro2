#!/bin/bash

echo "COMPILING MAIN PROGRAM ..."

fpc main

# new: testing adding new ingredients 
echo "#####" > min_output.txt
echo  NEW >> min_output.txt
echo "#####" >> min_output.txt
echo "Running NEW .."
./main new.txt >> min_output.txt


# MODIFY: adding quantities to existing ingredients  
echo "#####" >> min_output.txt
echo  MODIFY >> min_output.txt
echo "#####" >> min_output.txt
echo "Running MODIFY.."
./main modify.txt >> min_output.txt


# REMOVE: removing expired ingredients 
echo "#####" >> min_output.txt
echo  REMOVE>> min_output.txt
echo "#####" >> min_output.txt
echo "Running REMOVE .."
./main remove.txt >> min_output.txt

# ALLERGENS: showing ingredients with allergens 
echo "#####" >> min_output.txt
echo  ALLERGENS>> min_output.txt
echo "#####" >> min_output.txt
echo "Running ALLERGENS .."
./main allergens.txt >> min_output.txt


# DESSERT: adding desserts to multilist
echo "#####" >> min_output.txt
echo  DESSERT>> min_output.txt
echo "#####" >> min_output.txt
echo "Running DESSERT .."
./main dessert.txt >> min_output.txt

# ADDING INGREDIENTS: adding ingredients desserts to multilist
echo "#####" >> min_output.txt
echo  ADDING INGREDIENTS>> min_output.txt
echo "#####" >> min_output.txt
echo "Running INGREDIENT .."
./main ingredient.txt >> min_output.txt

# TAKEOFF: removing desserts from multilist
echo "#####" >> min_output.txt
echo  TAKEOFF>> min_output.txt
echo "#####" >> min_output.txt
echo "Running TAKEOFF .."
./main takeoff.txt >> min_output.txt

# ORDER:managing orders
echo "#####" >> min_output.txt
echo  ORDER>> min_output.txt
echo "#####" >> min_output.txt
echo "Running ORDER .."
./main order.txt >> min_output.txt
