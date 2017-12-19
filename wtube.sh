#!/bin/bash 

###################################
#
#   命令需要有两个参数
#       $1 -- youtube 的下载地址
#       $2 -- 指定保存文件的名字
#
###################################



function change_format {

file=${1}.${2}.vtt
outfile=${1}.${2}.srt

# RS : Record Separator 记录分隔符
# ORS: Output Pecord Separator 输出的记录分隔符
# FS : Field Separator 字段分隔符
# OFS: Out of Field Separator 字段输出的分隔符

cat $file | sed '1,4d' \
    | awk  'BEGIN{RS="\n\n";FS="\n"; n=1 } {print n "\n" $1 "\n" $2 "\n" $3 "\n"; n=n+1}' \
    > $outfile
    #| iconv -f "UTF-8" -t "UCS-2" > $outfile
}


type youtube-dl 
[ $? -ne 0 ] && echo "youtube-dl 命令不存在,请先按照" && return -2

[ $# -ne 2 ] && echo "需要两个参数 1)下载地址 2)存储的名字" && return -1


filename=${2}
filename=${filename//.mp4} # ${filename%.mp4} 删除，前者是替换

youtube-dl --sub-lang "zh-CN,en" -o ${filename}.mp4 -f "mp4"  --write-sub $1

# 字幕文件存在转换成 srt 格式

[ -f ${filename}.en.vtt ] && change_format ${filename} en
[ -f ${filename}.zh-CN.vtt ] && change_format ${filename} zh-CN


zip ${filename}.zip  ${filename}*

exit 0

