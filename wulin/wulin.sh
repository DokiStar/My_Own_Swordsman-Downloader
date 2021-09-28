#!/bin/bash

# 安装 FFmpeg（略）

# 前置处理
mkdir -p full

# 指定开始下载的集数
episode_id=1

# 读取 links.txt 文件，获取下载链接
for link in $(cat src/links.txt); do

    # 前置处理
    mkdir -p wlwz-${episode_id}
    cd wlwz-${episode_id}
    touch wlwz-${episode_id}.txt
    >wlwz-${episode_id}.txt

    # 特殊集数规则
    if [ ${episode_id} == 1 ]; then
        cut=23
    elif [ ${episode_id} == 26 ] || [ ${episode_id} == 68 ]; then
        cut=21
    else
        cut=22
    fi

    # 下载
    for ((c = 1; c <= ${cut}; c++)); do
        echo "--------------------------------"
        echo "Downloading"
        echo "Episode: ${episode_id}, Cut: ${c}"
        echo "--------------------------------"
        wget -O "wlwz-${episode_id}-${c}.mp4" "$link${c}.mp4"
    done

    # 使用 FFmpeg 合并片段，并读取 names.txt 文件以进行重命名
    echo "--------------------------------"
    echo "Merging"
    echo "--------------------------------"
    echo "file wlwz-${episode_id}-${c}.mp4" >>"wlwz-${episode_id}.txt"
    ffmpeg -f concat -i wlwz-${episode_id}.txt -c copy ../full/"第`printf "%02d\n" ${episode_id}`回：`cat ../src/names.txt | sed -n ${episode_id}p | tr "\r" "."`mp4"

    # 准备下一轮循环
    ((episode_id++))
    cd ..

done
