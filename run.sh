#!/bin/sh

# 设置定时任务 - 每6小时执行一次程序
echo "设置定时任务..."
echo "0 2 * * * /app/proxypool >> /app/run.log 2>&1" > /etc/crontabs/root
crond -b -l 8

# 首次运行
echo "首次运行代理池程序..."
date
/app/proxypool
echo "程序执行完成"
date

# 保持容器运行
echo "进入休眠状态，等待定时任务执行..."
tail -f /dev/null 
