#!/bin/bash
printf "Compilo\n"

make linux

echo "Test 1 './qsort test_files/numeros.txt'"
echo "-----------------------------------------"
if ./qsort test_files/numeros.txt | grep -z '1\s10\s2\s3\s4\s5\s6\s7\s8\s9' ; then
	echo "		OK"
else
	echo "		ERROR!"
fi

echo ""
echo ""

echo "Test 2 './qsort -n test_files/numeros.txt'"
echo "-----------------------------------------"
if ./qsort -n test_files/numeros.txt | grep -z '1\s2\s3\s4\s5\s6\s7\s8\s9\s10' ; then
	echo "		OK"
else
	echo "		ERROR!"
fi
