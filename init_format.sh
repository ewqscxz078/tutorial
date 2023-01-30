#!/bin/bash

func_2unix(){
  find -type f -name "*.txt" | xargs dos2unix
}

func_replaceTailTab(){
	egrep -lR "[ 　\t]+$" --include=*.{java,xml,properties,txt,jsp,html,js} | xargs sed -i "s/[[:blank:]]*$//"
}


func_reqlaceTailSpace(){
  egrep -InR $'\t'+$ --include=*.{java,xml,properties,txt,jsp,html,js} 
  #if not match will $?=1 or 計算個數大於>=1 || do 取代
  if [ $? -eq 0 ]; then
    egrep -lR $'\t'+$ --include=*.{java,xml,properties,txt,jsp,html,js} | xargs sed -i "s/\t\+$//g"
  fi
  ##if not match will $?=1，sed: no input files
  
}

main(){
  func_2unix
  func_replaceTailTab
  func_reqlaceTailSpace
}

main