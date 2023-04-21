#!/bin/bash

func_2unix(){

  # 使用 file ${filepath} 判斷
  # dos : filename.txt: ASCII text, with CRLF line terminators
  # unix : filename.txt: ASCII text
  # 使用「od」指令來查看檔案的十六進位表示，看是否包含「0d 0a」（即「CR+LF」）
  # od -c filename.txt
  # find -type f -name "*.txt" | xargs dos2unix
  #echo $result
  #result=`find . -type f -name "*.txt"`
  # 不使用 file 執行後符合的結果回傳，僅輔助判定，不然會有中文路徑或檔名解譯問題
  #listDos2unix=()
  #for aa in $result; do
  #  if file $aa | grep -q "CRLF"; then
#	   紀錄要處理 dos2unix
  #	  echo "需要處理的 $aa"
  #  listDos2unix+=($aa)
#	fi
#  done
  #for target in ${listDos2unix[@]}; do
    #dos2unix $target
  #done

  # TODO 在有中文路徑的下的 window 換行格式會有問題
  result=`find . -type f -name "*.txt" -print0 | xargs -0 file | grep "CRLF" | awk -F ":" '{print $1}'`
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