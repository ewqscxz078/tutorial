#!/bin/bash
#set -x

work_location=`pwd`
base_output_path=$work_location/stats_dependency
all_stats_tar_gz=$work_location/all_stats.tar.gz
[[ -d $base_output_path ]] && rm -rf $base_output_path/* || mkdir -p $base_output_path
[[ -f $all_stats_tar_gz ]] && rm -f $all_stats_tar_gz

exclude_maven_dirs=(
CI
TOOLS
greenc/SRIS/RS/sris3-rs-mongosearch-exec
aw-app/TEMPLATE/sris3-aw-TYPE-NAME-web
sris/sris-aw-app
neid/neid-me-app/ME/TS
)

maven_output_path=$base_output_path/maven
[[ -d $maven_output_path ]] || mkdir -p $maven_output_path

all_org_maven_depency_tree_dir=$maven_output_path/org_depency_tree
[[ -d $all_org_maven_depency_tree_dir ]] || mkdir -p $all_org_maven_depency_tree_dir

all_maven_distinct_dependency=$maven_output_path/all_maven_distinct.dependency~
all_maven_stats_dependency=$maven_output_path/all_maven_stats.dependency~
func_collect_maven_dependency(){
  #pwd /home/ccuser/jenkins/workspace/greenc108/b0-stats-dependency

  #前端傳入參數
  branch=$1
  #var
  stats_pom="pom-stats.xml~"
  dependency_plugin="<plugin><groupId>org.apache.maven.plugins</groupId><artifactId>maven-dependency-plugin</artifactId><version>2.10</version></plugin>"
  #TODO 未來改成從settings-template.xml replace方式
  maven_setting="/home/ccuser/.m2/settings-${branch}.xml" #settings-master.xml / settings-PRE_RELEASE-main.xml
  # check maven_setting exist
  [[ ! -f $maven_setting ]] && echo "$maven_setting is not exist" && exit 0
  #/home/ccuser/ext_workspace/issue_build/TEAM/.m2/settings.xml

  all_maven_target_pom=$maven_output_path/all_maven_pom.file~
  all_maven_ignore_pom=$maven_output_path/all_maven_ignore_pom.file~
  all_maven_stats_file=$maven_output_path/all_maven_stats.file~
  all_maven_stats_fail_file=$maven_output_path/all_maven_stats_fail.file~
  #all_maven_stats_tar_gz=$maven_output_path/all_mstats.tar.gz

  exclude_path=""
  for excldue_dir in ${exclude_maven_dirs[@]}; do
    exclude_path+="! -path \"$work_location/$excldue_dir/*\" "
  done
  echo "ignore path ${exclude_maven_dirs[@]}"

  echo "0. clean maven"
  eval "find . -type f -name $stats_pom $exclude_path" | xargs rm -f
  eval "find . -type f -name *.stats.fail~ $exclude_path" | xargs rm -f
  eval "find . -type f -name *.stats~ $exclude_path" | xargs rm -f
  [[ -f $all_maven_target_pom ]] && > $all_maven_target_pom || touch $all_maven_target_pom
  [[ -f $all_maven_ignore_pom ]] && > $all_maven_ignore_pom || touch $all_maven_ignore_pom
  [[ -f $all_maven_stats_file ]] && > $all_maven_stats_file || touch $all_maven_stats_file
  [[ -f $all_maven_stats_fail_file ]] && > $all_maven_stats_fail_file || touch $all_maven_stats_fail_file
  [[ -d $all_org_maven_depency_tree_dir ]] && rm -rf $all_org_maven_depency_tree_dir/*
  [[ -f $all_maven_stats_dependency ]] && > $all_maven_stats_dependency || touch $all_maven_stats_dependency
  [[ -f $all_maven_distinct_dependency ]] && > $all_maven_distinct_dependency || touch $all_maven_distinct_dependency

  echo "1. find all pom.xml"
  echo "2. cp pom.xml and add plugin maven-dependency-plugin 2.10 to pom-stats.xml~"
  #echo "find . -type f -name \"pom.xml\" $exclude_path"
  #for file_source in `find ~+ -type f -name "pom.xml" ! -path "./CI/*" ! -path "./TOOLS/*"`; do
  eval "find ~+ -type f -name \"pom.xml\" $exclude_path -print0" | while read -d $'\0' file_source; do

    source_dir=$(dirname $file_source)
    parent_path=$(dirname $source_dir)
    # 去掉 $work_location
    part_parent_path=${parent_path/$work_location\//}
    #echo "part_parent_path = $part_parent_path"
    project_name=$(basename $source_dir)
    file_target=$source_dir/$stats_pom

    #ignore <packaging>pom</packaging>
    if grep -q "<packaging>pom</packaging>" $file_source; then
      echo "ignore $file_target . because it is packaging pom"
      # 去掉 $work_location
      echo ${file_target/$work_location\//} >> $all_maven_ignore_pom
      continue
    fi

    cp $file_source $file_target
    # 去掉 $work_location
    echo ${file_target/$work_location\//} >> $all_maven_target_pom

    # 為了置入額外plugins 才能執行 dependency:tree
    ## check 已存在 <artifactId>maven-dependency-plugin</artifactId> 則不置入 dependency_plugin
    ## check </plugins> not exist then append $dependency_plugin
    ## check </build> not exist then append $dependency_plugin with plugins
    ## 皆無 append  $dependency_plugin with build、plugins
    if grep -q "</plugins>" $file_target; then
      if grep -q "<artifactId>maven-dependency-plugin</artifactId>" $file_target; then
        if grep -Eq "^.*<\!--.*<artifactId>maven-dependency-plugin</artifactId>" $file_target; then
          echo "$file_target found </plugins> (replace by </plugins>) because maven-dependency-plugin is mark"
          with_post_plugins="$dependency_plugin</plugins>"
          C=$(echo $with_post_plugins | sed 's/\//\\\//g')
          sed -i "s/<\/plugins>/${C}\n/g" $file_target
	else
          # exist maven-dependency-plugin and ignore
          echo "$file_target found <artifactId>maven-dependency-plugin</artifactId> ignore to append"
        fi
      else
        echo "$file_target found </plugins> (replace by </plugins>)"
        with_post_plugins="$dependency_plugin</plugins>"
        C=$(echo $with_post_plugins | sed 's/\//\\\//g')
        sed -i "s/<\/plugins>/${C}\n/g" $file_target
      fi
    elif grep -q "</build>" $file_target; then
      echo "$file_target found </build> (replace by </build>)"
      with_plugins="<plugins>$dependency_plugin</plugins></build>"
      C=$(echo $with_plugins | sed 's/\//\\\//g')
      sed -i "s/<\/build>/${C}\n/g" $file_target
    else
      echo "$file_target need append all (replace by </project>)"
      with_build="<build><plugins>$dependency_plugin</plugins></build>\n</project>"
      C=$(echo $with_build | sed 's/\//\\\//g')
      sed -i "s/<\/project>/${C}\n/g" $file_target
    fi

    #echo "3. call mvn dependency:tree with pom-stats.xml~ and create file to [repository-pom].tree"
    stats_file=$source_dir/${project_name}.stats~
    _part_parent_path=$(echo $part_parent_path | sed -e 's/\//_/g')
    org_stats_file=${source_dir}/${_part_parent_path}_${project_name}.stats~
    mvn -q dependency:tree -f $file_target -DoutputFile="$stats_file" -DappendOutput=true --settings $maven_setting -Dmaven.main.skip=true -Dmaven.test.skip=true

    #if file $source_dir/${project_name}.stats not exist touch fail
    stats_file_fail=${stats_file}.fail~
    if [ ! -f $stats_file ]; then
      touch $stats_file_fail
      # 去掉 $work_location
      echo ${stats_file_fail/$work_location\//} >> $all_maven_stats_fail_file
      continue
    fi

    cp $stats_file $org_stats_file
    cp $org_stats_file -t $all_org_maven_depency_tree_dir

    # 去掉 $work_location
    echo ${stats_file/$work_location\//} >> $all_maven_stats_file

    #ignore first line(self project_name.jar)
    sed -i "1d" $stats_file

    #replace +-|\- 開頭 => ""
    sed -ri "s/^(\+|\-| |\\\|-|\|)*//g" $stats_file

    #replace : => ,
    #sed -i "s/:/,/g" $stats_file

    #另外算好distinct一版
    cat $stats_file >> $all_maven_distinct_dependency

    #補上 prefix ${part_parent_path}:${project_name}:
    # part_parent_path 會有/ 所以改用#
    sed -i "s#\(.*\)#${part_parent_path}:${project_name}:\1#g" $stats_file

    #echo "4. collect to one csv file"
    cat $stats_file >> $all_maven_stats_dependency

  done

  # 組合 jar_name與欄位一致(大部分沒有classifier這欄位)
  awk -F : '{
  if($8=="")
    print $1":"$2":"$3":"$4":"$5":"$6":"$7":"$8":"$4"-"$6"."$5;
  else
    print $1":"$2":"$3":"$4":"$5":"$6":"$8":"$7":"$4"-"$7"-"$6"."$5;
  }' $all_maven_stats_dependency > ${all_maven_stats_dependency}.tmp && mv ${all_maven_stats_dependency}.tmp $all_maven_stats_dependency && rm -f ${all_maven_stats_dependency}.tmp
  #append first line head : parent_path(1):project_name(2):groupId(3):artifactId(4):filetype(5):version(6):scope(7):classifier(8):jar_name(9)
  sed -i "1s/^/parent_path:project_name:groupId:artifactId:filetype:version:scope:classifier:jar_name\n/" $all_maven_stats_dependency

  echo "5. distinct one csv file"
  # remove unwanted scope
  sed -ri "/(provided|runtime|test|system)$/d" $all_maven_distinct_dependency
  # sort and distinct
  sort -u $all_maven_distinct_dependency -o $all_maven_distinct_dependency
  # 組合 jar_name與欄位一致
  awk -F : '{
  if($6=="")
    print $1":"$2":"$3":"$4":"$5":"$6":"$2"-"$4"."$3;
  else
    print $1":"$2":"$3":"$4":"$6":"$5":"$2"-"$5"-"$4"."$3;
  }' $all_maven_distinct_dependency > ${all_maven_distinct_dependency}.tmp && mv ${all_maven_distinct_dependency}.tmp $all_maven_distinct_dependency && rm -f ${all_maven_distinct_dependency}.tmp
  #org append first line head : groupId(1):artifactId(2):filetype(3):version(4):scope(5):classifier(6):jar_name
  sed -i "1s/^/groupId:artifactId:filetype:version:scope:classifier:jar_name\n/" $all_maven_distinct_dependency

  # stats list file wc -l
  all_maven_target_pom_count=`cat $all_maven_target_pom |wc -l`
  echo "count pom file : $all_maven_target_pom_count"

  all_maven_ignore_pom_count=`cat $all_maven_ignore_pom |wc -l`
  echo "count ignore pom file : $all_maven_ignore_pom_count"

  all_maven_stats_file_count=`cat $all_maven_stats_file |wc -l`
  echo "count stats file : $all_maven_stats_file_count"

  all_maven_stats_fail_file_count=`cat $all_maven_stats_fail_file |wc -l`
  echo "count stats fail file : $all_maven_stats_fail_file_count"
}

func_send_redmine_download(){
  echo "6. send to redmine download folder"

  #share_folder=/mnt/SRIS/SRIS_DEV/www/downloads/stats-dependency
  #if [ -d $share_folder ]; then
  #  remote_tar_gz=$share_folder/all_stats.tar.gz
  #  [[ -f $remote_tar_gz ]] | rm -f $remote_tar_gz
  #  cp all_stats.tar.gz $share_folder
  #    echo "copy to share folder : $share_folder"
  #else
  #  echo "share folder not exist : $share_folder"
  #fi
}

exclude_gralde_dirs=(
CI
TOOLS
neid/neid-ap-app
neid/neid-me-app/ME/TS/neid-me-tspsetting-web
)

gradle_output_path=$base_output_path/gradle
[[ -d $gradle_output_path ]] || mkdir -p $gradle_output_path

all_org_gradle_depency_tree_dir=$gradle_output_path/org_depency_tree
[[ -d $all_org_gradle_depency_tree_dir ]] || mkdir -p $all_org_gradle_depency_tree_dir

all_gradle_distinct_dependency=$gradle_output_path/all_gradle_distinct.dependency~
all_gradle_stats_dependency=$gradle_output_path/all_gradle_stats.dependency~
func_collect_gradle_dependency(){

  #var
  stats_gradle="build-stats.gradle~"

  all_gradle_target_gradle=$gradle_output_path/all_gradle.file~
  #all_gradle_ignore=$gradle_output_path/all_gradle_ignore.file~
  all_gradle_stats_file=$gradle_output_path/all_gradle_stats.file~
  all_gradle_stats_fail_file=$gradle_output_path/all_gradle_stats_fail.file~

  exclude_gralde_path=""
  for exclude_gralde_dir in ${exclude_gralde_dirs[@]}; do
    exclude_gralde_path+="! -path \"$work_location/$exclude_gralde_dir/*\" "
  done
  echo "ignore gradle path ${exclude_gralde_dirs[@]}"

  echo "0. clean gradle"
  eval "find . -type f -name $stats_gradle $exclude_gralde_path" | xargs rm -f
  eval "find . -type f -name *.gstats.fail~ $exclude_gralde_path" | xargs rm -f
  eval "find . -type f -name *.gstats~ $exclude_gralde_path" | xargs rm -f
  [[ -f $all_gradle_target_gradle ]] && > $all_gradle_target_gradle || touch $all_gradle_target_gradle
  #[[ -f $all_gradle_ignore ]] && > $all_gradle_ignore
  [[ -f $all_gradle_stats_file ]] && > $all_gradle_stats_file || touch $all_gradle_stats_file
  [[ -f $all_gradle_stats_fail_file ]] && > $all_gradle_stats_fail_file || touch $all_gradle_stats_fail_file
  [[ -d $all_org_gradle_depency_tree_dir ]] && rm -rf $all_org_gradle_depency_tree_dir/*
  [[ -f $all_gradle_stats_dependency ]] && > $all_gradle_stats_dependency || touch $all_gradle_stats_dependency
  [[ -f $all_gradle_distinct_dependency ]] && > $all_gradle_distinct_dependency || touch $all_gradle_distinct_dependency

  echo "1. find all gradlew"
  echo "2. cp build.gradle and add task(to file) to build-stats.gradle~"
  gradle_projects=()
  #因為在 while 裡面跑 gradle 一次就會中斷,故記錄所有要跑的gradle project
  while read -d $'\0' file_source; do
    echo "gradle project found $file_source"
    gradle_projects+=($file_source)
  done < <(eval "find ~+ -type f -name \"gradlew\" $exclude_gralde_path -print0")
  echo "gradle project count : ${#gradle_projects[@]}"

  echo "3. call gradle dependencyReportFile with build-stats.gradle~ and create file to [repository-gradle].tree and format"
  for gradle_project in ${gradle_projects[@]}; do
    #echo "gradle_project path : $gradle_project"
    source_dir=$(dirname $gradle_project)
    parent_path=$(dirname $source_dir)
    part_parent_path=${parent_path/$work_location\//}
    #echo "part_parent_path = $part_parent_path"
    project_name=$(basename $source_dir)
    build_gradle=$source_dir/build.gradle
    gradlew=$source_dir/gradlew

    file_target=$source_dir/$stats_gradle
    cp $build_gradle $file_target

    # 去掉 $work_location
    echo ${file_target/$work_location\//} >> $all_gradle_target_gradle

    # append tail to $file_target 插入需要匯出 dependencies tree 到檔案的語法到 build-stats.gradle~
    gstats_file=$source_dir/${project_name}.gstats~
    # replace / to _
    _part_parent_path=$(echo $part_parent_path | sed -e 's/\//_/g')
    org_gstats_file=${source_dir}/${_part_parent_path}_${project_name}.gstats~

    sed -i '$ a task dependencyReportFile(type: DependencyReportTask){ \
      outputFile = file('\'"$project_name"'.gstats~'\'') \
      Set configs = [project.configurations.compileClasspath] \
      setConfigurations(configs) \
    }' $file_target

    # 原始語法無法產出至檔案 $gradlew -q -b $build_gradle dependencies --configuration=compileClasspath
    echo "call gradle dependencyReportFile with $file_target"
    # 必須使用 gradlew 才會使用 master-stats-dependency.Jenkinsfile 宣告的 GRADLE_USER_HOME 位置，gradle 會執行 GRADLE_HOMOE 位置
    last_pwd=$PWD
    cd $source_dir
    #neid-me-tsp-web\gradlw、neid-me-tspgw-web\gradlw
    #  cd "$(dirname \"$PRG\")/" >/dev/null
    #  會出現 ./gradlew: 40: cd: can't cd to  可略過該錯誤，因為 ``與 $()些微語法差異bug
    #echo "gradlew -q -b $file_target dependencyReportFile"
    ./gradlew -q -b $file_target dependencyReportFile
    # 返回之前目錄位置
    cd $last_pwd

    #if file $source_dir/${project_name}.stats not exist touch fail
    stats_gradle_file_fail=${gstats_file}.fail~
    if [ ! -f $gstats_file ]; then
      echo "file not exist : $gstats_file"
      touch $stats_gradle_file_fail
      # 去掉 $work_location
      echo ${stats_gradle_file_fail/$work_location\//} >> $all_gradle_stats_fail_file
      continue
    fi

    cp $gstats_file $org_gstats_file
    cp $org_gstats_file -t $all_org_gradle_depency_tree_dir

    # 去掉 $work_location
    echo ${gstats_file/$work_location\//} >> $all_gradle_stats_file

    # 格式化
    echo "format $gstats_file"

    # 1. 去頭，多餘部分
    start=`sed -n '/compileClasspath - Compile classpath for source set/{=;p}' $gstats_file | sed '{N;s/\n/ /}' | awk '{ print $1 }'`
    start_index=$(($start+1))
    cut_start="1,${start_index}d"
    sed -i "$cut_start" $gstats_file

    # 2. 去尾，多餘部分，(找到第一次開頭(的行位置，找到第一次match pattern行數後就停止)，``有bug 改用 $()模式
    end=$(sed -n '/^(/=; /^(/q' $gstats_file)
    end_index=$(($end-1))
    cut_end="${end_index},\$d"
    sed -i "$cut_end" $gstats_file

    # 3. replace 前墜 +-|\- => ""
    sed -ri "s/^(\+|\-| |\\\|-|\|)*//g" $gstats_file

    # 4. replace 後墜 ' (*)或(c)' => ""
    # https://stackoverflow.com/questions/66941255/gradle-dependency-what-does-c-and-n-mean
    # 結尾(*) 表示 dependencies omitted(listed previously)，傳遞依賴已傳遞，故省略
    # https://docs.gradle.org/current/userguide/dependency_constraints.html
    # 結尾(c) 表示: dependency constraint :依賴傳遞中有非預期的版本，使用 gradle 的 constraints 告知指定的依賴版本為何
    sed -ri "s/ \([\*|c]\)$//g" $gstats_file

    # 5. 分出 old_verison -> assign_version 還是只有 -> assign_version，透過箭頭符號左邊分割:的個數判斷
    # 例如 commons-io:commons-io:2.5 -> 2.6 變 commons-io:commons-io:2.6  (old_verison -> assign_version)
    #      org.springframework.boot:spring-boot-starter-web -> 2.2.4.RELEASE 變 org.springframework.boot:spring-boot-starter-web:2.2.4.RELEASE  (-> assign_version)
    awk -F " -> " '{
    if(NF==2)
    {
      n=split($1,a,":");
      if(n==3 || n==2)
        print a[1]":"a[2]":"$2;
      else
        print not3_or_2#n#$0;
    }
    else
    {
      print $0;
    }
    }' $gstats_file > ${gstats_file}.tmp && mv ${gstats_file}.tmp $gstats_file && rm -f ${gstats_file}.tmp

    #另外算好distinct一版
    cat $gstats_file >> $all_gradle_distinct_dependency

    # 6. 補上 prefix ${parent_path}:${project_name}:
    # part_parent_path 會有/ 所以改用#
    sed -i "s#\(.*\)#${part_parent_path}:${project_name}:\1#g" $gstats_file

    #echo "collect to one csv file"
    cat $gstats_file >> $all_gradle_stats_dependency

  done

  # 多組合出 jar_name，all_gradle_stats_dependency
  awk -F : '{
    print $1":"$2":"$3":"$4":"$5":"$4"-"$5".jar";
  }' $all_gradle_stats_dependency > ${all_gradle_stats_dependency}.tmp && mv ${all_gradle_stats_dependency}.tmp $all_gradle_stats_dependency && rm -f ${all_gradle_stats_dependency}.tmp
  #append first line head : parent_path(1)project_name(2):groupId(3):artifactId(4):version(5):jar_name(6)
  sed -i "1s/^/parent_path:project_name:groupId:artifactId:version:jar_name\n/" $all_gradle_stats_dependency

  # 多組合出 jar_name，all_gradle_distinct_dependency
  awk -F : '{
    print $1":"$2":"$3":"$2"-"$3".jar";
  }' $all_gradle_distinct_dependency > ${all_gradle_distinct_dependency}.tmp && mv ${all_gradle_distinct_dependency}.tmp $all_gradle_distinct_dependency && rm -f ${all_gradle_distinct_dependency}.tmp
  #append first line head : groupId(1):artifactId(2):version(3):jar_name
  sed -i "1s/^/groupId:artifactId:version:jar_name\n/" $all_gradle_distinct_dependency

  # stats list file wc -l
  all_gradle_target_gradle_count=`cat $all_gradle_target_gradle |wc -l`
  echo "count gradle file : $all_gradle_target_gradle_count"

  all_gstats_file_count=`cat $all_gradle_stats_file |wc -l`
  echo "count stats gradle file : $all_gstats_file_count"

  all_gstats_fail_file_count=`cat $all_gradle_stats_fail_file |wc -l`
  echo "count stats fail gradle file : $all_gstats_fail_file_count"
}

all_stats_dependency=$base_output_path/all_stats.dependency~
func_merge_stats_dependency(){
  [[ -f $all_stats_dependency ]] && > $all_stats_dependency

  #不含第一行
  awk -F : 'NR!=1{
    print "maven:"$1":"$2":"$3":"$4":"$6":"$9;
  }' $all_maven_stats_dependency >> $all_stats_dependency

  #不含第一行
  awk -F : 'NR!=1{
    print "gradle:"$1":"$2":"$3":"$4":"$5":"$6;
  }' $all_gradle_stats_dependency >> $all_stats_dependency

  # sort and distinct
  sort -u $all_stats_dependency -o $all_stats_dependency

  # 補回 header
  sed -i "1s/^/build_type:parent_path:project_name:groupId:artifactId:version:jar_name\n/" $all_stats_dependency
}

#only jar
all_distinct_dependency_jar=$base_output_path/all_distinct_jar.dependency~
func_merge_distinct_dependency(){
  [[ -f $all_distinct_dependency_jar ]] && > $all_distinct_dependency_jar

  # only distinct jar name
  awk -F : 'NR!=1{
    print $7;
  }' $all_maven_distinct_dependency >> $all_distinct_dependency_jar

  awk -F : 'NR!=1{
    print $4;
  }' $all_gradle_distinct_dependency >> $all_distinct_dependency_jar

  # sort and distinct
  sort -u $all_distinct_dependency_jar -o $all_distinct_dependency_jar
}

func_touch_branch_file(){
  #前端傳入參數
  branch=$1
  touch $base_output_path/${branch}.branch
}

main(){
  branch=$1
  echo "====================== collect_maven_dependency ==================================="
  func_collect_maven_dependency $branch
  echo "====================== collect_gradle_dependency =================================="
  func_collect_gradle_dependency
  echo "====================== merge_stats_dependency ====================================="
  func_merge_stats_dependency
  echo "====================== merge_distinct_dependency =================================="
  func_merge_distinct_dependency
  #echo "====================== send_redmine_download/ftp =================================="
  #func_send_redmine_download
  echo "====================== touch branch file  ========================================="
  func_touch_branch_file $branch
  echo "====================== gz all file ================================================"
  tar -czf all_stats.tar.gz stats_dependency
}

branch=$1
#為了 PRE_RELEASE/main 改成 PRE_RELEASE-main，以利對應到 maven setting 檔案名稱不能有/問題
format_branch=$(echo "$branch" | sed 's/\//-/g')
echo "branch : $branch ,  format_branch : $format_branch"
main "$format_branch"

