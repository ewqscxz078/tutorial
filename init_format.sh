#!/bin/bash

func_2unix(){
  find -type f -name "*.txt" | xargs dos2unix
}

func_replaceTailTab(){
	egrep -lR "[ 　\t]+$" --include=*.{java,xml,properties,txt,jsp,html,js} | xargs sed -i "s/[[:blank:]]*$//"
}


func_reqlaceTailSpace(){
  #egrep -InR $'\t'+$ --include=*.{java,xml,properties,txt,jsp,html,js}
  egrep -lR $'\t'+$ --include=*.{java,xml,properties,txt,jsp,html,js} | xargs sed -i "s/\t\+$//g"
}

main(){
  func_2unix
  func_replaceTailTab
  func_reqlaceTailSpace
}

main