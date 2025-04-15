FROM golang:1.22-alpine AS builder

WORKDIR /app

# 复制Go模块文件
COPY go.mod go.sum ./
RUN go mod download

# 复制源代码
COPY . .

# 编译应用
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o proxypool .

# 使用轻量级的alpine镜像
FROM alpine:latest

WORKDIR /app

# 从构建阶段复制编译好的二进制文件
COPY --from=builder /app/proxypool .
# 复制配置和其他必要文件
COPY ./config ./config
COPY ./source ./source

# 设置时区
RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

# 暴露可能需要的端口
EXPOSE 8080

# 运行应用
CMD ["./proxypool"] 
