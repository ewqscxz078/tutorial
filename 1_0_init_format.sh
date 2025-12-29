#!/bin/bash

func_check_is_window(){
  # 使用「od」指令來查看檔案的十六進位表示，看是否包含「0d 0a」（即「CR+LF」）
  # od -c filename.txt | grep -E "\\r|\\n"
  return `find . -type f -name "*.txt" -print0 | xargs -0 od -c | grep -l -E "\\r|\\n"`
}

func_check_is_window_by_file(){
  # 使用 file ${filepath} 判斷
  # dos : filename.txt: ASCII text, with CRLF line terminators
  # unix : filename.txt: ASCII text
  return `find . -type f -name "*.txt" -print0 | xargs -0 file | grep "CRLF" | awk -F ":" '{print $1}'`
  #return `find . -type f -name "*.txt" -print0 | xargs -0 file | grep -l "CRLF"`
}

func_2unix(){
  # 在有中文路徑的下的 window 換行格式輸出若為 ascii 會有問題，代表當前編輯器輸出的格式非預期
  result=`find . -type f -name "*.txt" -print0 | xargs -0 file | grep "CRLF" | awk -F ":" '{print $1}'`
  for target in $result; do
    dos2unix $target
  done
}

func_replaceTailTab(){
	egrep -lR "[ 　\t]+$" --include=*.{java,xml,properties,txt,jsp,html,js,md} | xargs sed -i "s/[[:blank:]]*$//"
}


func_reqlaceTailSpace(){
  egrep -InR $'\t'+$ --include=*.{java,xml,properties,txt,jsp,html,js,md} 
  #if not match will $?=1 or 計算個數大於>=1 || do 取代
  if [ $? -eq 0 ]; then
    egrep -lR $'\t'+$ --include=*.{java,xml,properties,txt,jsp,html,js,md} | xargs sed -i "s/\t\+$//g"
  fi
  ##if not match will $?=1，sed: no input files
  
}

main(){
  func_2unix
  func_replaceTailTab
  func_reqlaceTailSpace
}

check_tailTab(){
  egrep -lR "[ 　\t]+$" --include=*.{java,xml,properties,txt,jsp,html,js,md}
}
check_tailSpace(){
  egrep -InR $'\t'+$ --include=*.{java,xml,properties,txt,jsp,html,js,md}
}

main


#已知有缺陷當檔名路徑有空白無法執行 格式化