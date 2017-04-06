#!/bin/bash

for i in $(ps aux | grep STM | grep -v grep | awk '{ print $2 }')
do 
  kill -9 $i
done
for i in $(ps aux | grep 239.250.0 | grep -v grep | awk '{ print $2 }')
do
  kill -9 $i
done
for i in $(ps aux | grep c_c | grep pl | awk '{ print $2 }')
do 
  kill -9 $i
done

