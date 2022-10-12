#!/bin/bash

function kill_pid_arr() {
    socket_ls=$1

    # !arr[$0]++ 去重方法
    # {printf "%d ", $0} 转换为数组的方法
    pid_arr=$(echo "${socket_ls}" | awk '{if(NR!=1) print $3}' | awk '!arr[$0]++ {printf "%d ", $0}')

    # pid_arr是一个数组，[@]代表获取所有数据
    echo "${pid_arr[@]}"

    for pid in "${pid_arr[@]}"
    do
      echo "kill: ${pid}pid"
      kill -9 "${pid}"
    done
}

function kill_pid_assign() {
    socket_ls=$1

    echo "------------------------------------"
    echo "Please choose a line: "

    read -r no
    # $0代表整行
    line=$(echo "${socket_ls}" | awk '{if($1=='"${no}"') print $0 }')
    echo "$line"
    pid=$(echo "$line" | awk '{print $3}')
    kill -9 "${pid}"
}

port=$1
if [[ -z $port ]]; then
  echo "Requires a port parameter, E.g: killport.sh 8080"
  exit 1
fi

socket_ls=$(lsof -i:"${port}" | awk '{printf("%-5d%s\n", NR-1, $0)}')

# -n代表非空串，-z代表空串
# 使用[] 或者 [[]] ，两边都需要有空格
if [[ -z $socket_ls ]]; then
  echo "socket not found"
  exit 1
fi
echo "${socket_ls}"
echo "------------------------------------"
echo "Please select a method:"
echo "1    kill all"
echo "2    kill select"
echo "------------------------------------"

read -r no
if [[ $no == 1 ]]; then
    kill_pid_arr "${socket_ls}"
elif [[ $no == 2 ]]; then
    kill_pid_assign "${socket_ls}"
else
    echo "invalid input"
fi