#!/bin/csh 
set k=1
  grep -q aabc xyz.txt; @ gba = $?

echo $gba

while ("$gba" != "0")
#while ("$k" != "10")
echo 'Area source' $k
  @ k++  
  grep -q aabc xyz.txt;  @ gba = $?
 end

