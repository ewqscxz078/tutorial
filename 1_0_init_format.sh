#!/bin/bash

func_2unix(){
  # 使用 file ${filepath} 判斷
  # dos : filename.txt: ASCII text, with CRLF line terminators
  # unix : filename.txt: ASCII text
  # 使用「od」指令來查看檔案的十六進位表示，看是否包含「0d 0a」（即「CR+LF」）
  # od -c filename.txt
  # find -type f -name "*.txt" | xargs dos2unix
  result=`find . -type f -name "*.txt" -print0 | xargs -0 file | grep "CRLF" | awk -F ":" '{print $1}'`
  #echo $result
  for target in $result; do
    dos2unix $target
  done
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

check_tailTab(){
  egrep -lR "[ 　\t]+$" --include=*.{java,xml,properties,txt,jsp,html,js}
}
check_tailSpace(){
  egrep -InR $'\t'+$ --include=*.{java,xml,properties,txt,jsp,html,js}
}

main