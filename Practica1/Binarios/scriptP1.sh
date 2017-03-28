#!/bin/bash

echo "---------------- STATIC LIST ----------------"
if grep -q DynamicList main.pas; 
then 
#   Sustituir una sola ocurrencia de ListaDinamica
#	sed -i '0,/DynamicList/s//StaticList/' main.pas 

#	Sustituir todas las ocurrencias de DynamicList
	sed -i 's/DynamicList/StaticList/g' main.pas 

fi

echo "Compiling main program using STATIC LIST..."

fpc main

echo "---------------- STATIC LIST ----------------" >> static_output.txt



# new: testing adding new ingredients 
echo "#####" >> static_output.txt
echo  NEW >> static_output.txt
echo "#####" >> static_output.txt
echo "Running NEW .."
./main new.txt >> static_output.txt


# MODIFY: adding quantities to existing ingredients  
echo "#####" >> static_output.txt
echo  MODIFY >> static_output.txt
echo "#####" >> static_output.txt
echo "Running MODIFY.."
./main modify.txt >> static_output.txt



# REMOVE: removing expired ingredients 
echo "#####" >> static_output.txt
echo  REMOVE>> static_output.txt
echo "#####" >> static_output.txt
echo "Running REMOVE .."
./main remove.txt >> static_output.txt


# ALLERGENS: showing ingredients with allergens 
echo "#####" >> static_output.txt
echo  ALLERGENS>> static_output.txt
echo "#####" >> static_output.txt
echo "Running ALLERGENS .."
./main allergens.txt >> static_output.txt



echo "----------------  DYNAMIC LIST ----------------"
sed -i 's/StaticList/DynamicList/g' main.pas 

echo "Compiling main program using dynamic list..."

fpc main



echo "---------------- DYNAMIC LIST ----------------" >> dynamic_output.txt

# new: testing adding new ingredients 
echo "#####" >> dynamic_output.txt
echo  NEW >> dynamic_output.txt
echo "#####" >> dynamic_output.txt
echo "Running NEW .."
./main new.txt >> dynamic_output.txt


# MODIFY: adding quantities to existing ingredients  
echo "#####" >> dynamic_output.txt
echo  MODIFY >> dynamic_output.txt
echo "#####" >> dynamic_output.txt
echo "Running MODIFY.."
./main modify.txt >> dynamic_output.txt



# REMOVE: removing expired ingredients 
echo "#####" >> dynamic_output.txt
echo  REMOVE>> dynamic_output.txt
echo "#####" >> dynamic_output.txt
echo "Running REMOVE .."
./main remove.txt >> dynamic_output.txt


# ALLERGENS: showing ingredients with allergens 
echo "#####" >> dynamic_output.txt
echo  ALLERGENS>> dynamic_output.txt
echo "#####" >> dynamic_output.txt
echo "Running ALLERGENS .."
./main allergens.txt >> dynamic_output.txt

