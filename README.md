# BigData Service MCP Server

基于 FastMCP 框架开发的大数据服务 MCP Server，用于对接外部大数据服务，核对外挂上报表数据与权威数据源是否一致。

## 功能特性

提供两个核心查询接口：

### 1. 对外投资情况查询 (query_fund_investments)
- **入参**: 基金简称
- **返回**: 该合伙企业的对外投资明细列表
- **用途**: 核对投资标的企业全称、统一社会信用代码、累计投资本金额

### 2. 外部工商数据查询 (query_company_business)
- **入参**: 统一社会信用代码
- **返回**: 企业工商信息
- **用途**: 核对被投企业全称、企业类别、企业规模、所属行业产业、注册地、基金投资后是否上市

### 3. 批量企业查询 (batch_query_companies)
- **入参**: 逗号分隔的信用代码列表
- **返回**: 多个企业的工商信息列表

### 4. 服务状态查询 (get_service_status)
- **入参**: 无
- **返回**: 服务可用性和统计信息

## 安装

```bash
pip install -r requirements.txt
```

## 运行

```bash
# 方式1：直接运行
python bigdata_service_mcp.py

# 方式2：使用 fastmcp CLI
fastmcp run bigdata_service_mcp.py

# 方式3：作为模块运行
python -m bigdata_service_mcp
```

## WorkBuddy 配置

在 `mcp.json` 中添加：

```json
{
  "mcpServers": {
    "bigdata-service": {
      "command": "python",
      "args": ["-m", "bigdata_service_mcp"],
      "env": {},
      "disabled": false
    }
  }
}
```

## 使用示例

```
# 查询基金对外投资
query_fund_investments("东方佳康")

# 查询企业工商信息
query_company_business("91411500MAG0YUAK0N")

# 批量查询
batch_query_companies("91411500MAG0YUAK0N,913604055892302382")

# 获取服务状态
get_service_status()
```

## 正式环境部署

当前为 MOCK 模拟实现。正式环境使用时：

1. 替换 `_MOCK_FUND_INVESTMENTS` 和 `_MOCK_BIZ_DB` 为真实 HTTP 接口调用
2. 参考以下接口规范：

```python
import httpx

# 对外投资情况服务
def query_fund_investments_api(fund_name: str):
    response = httpx.get(
        "https://api.example.com/investments",
        params={"fund_name": fund_name},
        headers={"Authorization": f"Bearer {API_TOKEN}"},
        timeout=30
    )
    return response.json()

# 工商数据服务
def query_company_business_api(credit_code: str):
    response = httpx.get(
        "https://api.example.com/business",
        params={"credit_code": credit_code},
        headers={"Authorization": f"Bearer {API_TOKEN}"},
        timeout=30
    )
    return response.json()
```

## License

MIT
