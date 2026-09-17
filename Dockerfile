FROM python:3.12-slim

WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制代码
COPY bigdata_service_mcp.py .

# 创建非 root 用户
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# 暴露端口
EXPOSE 8765

# 启动命令（默认 HTTP 模式）
CMD ["python", "bigdata_service_mcp.py", "--transport", "http", "--port", "8765", "--host", "0.0.0.0"]