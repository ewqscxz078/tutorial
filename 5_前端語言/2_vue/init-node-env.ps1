# =========================
# init-node-env.ps1
# 目的：設定 Node.js portable 環境（User scope）
# =========================

# 1) 你的 Node.js portable 解壓路徑（請改成你的）
$NodeHome = "C:\tools\nodejs"

# 2) npm 全域安裝目錄與 cache 目錄（可改）
$NpmGlobal = Join-Path $NodeHome "npm-global"
$NpmCache  = Join-Path $NodeHome "npm-cache"

# 3) 內網 registry / proxy（擇一使用）
# 3a) 若你們有「內部 npm registry」，填這個（例如 Nexus/Artifactory/Verdaccio）
$Registry = ""   # 例："https://npm.company.com/"
# 3b) 若你們走 HTTP Proxy，填這兩個
$ProxyHttp  = "" # 例："http://proxy.company:8080"
$ProxyHttps = "" # 例："http://proxy.company:8080"

Write-Host "== NodeHome: $NodeHome =="

# 基本檢查
$nodeExe = Join-Path $NodeHome "node.exe"
if (!(Test-Path $nodeExe)) {
  Write-Error "找不到 node.exe：$nodeExe`n請確認 NodeHome 路徑是否正確。"
  exit 1
}

# 取得目前使用者 PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

function Add-ToUserPath([string]$p) {
  if ([string]::IsNullOrWhiteSpace($p)) { return }
  $parts = $currentPath -split ';' | Where-Object { $_ -and $_.Trim() -ne "" }
  if ($parts -contains $p) {
    Write-Host "PATH 已包含：$p"
  } else {
    $script:currentPath = ($currentPath.TrimEnd(';') + ";" + $p)
    Write-Host "已加入 PATH：$p"
  }
}

# 1) 加入 NodeHome 到使用者 PATH
Add-ToUserPath $NodeHome

# 2) 設定 npm prefix / cache（User scope）
# 注意：npm.cmd 在 NodeHome 底下，所以先用絕對路徑呼叫
$npmCmd = Join-Path $NodeHome "npm.cmd"

& $npmCmd config set prefix "$NpmGlobal" --location=user | Out-Null
& $npmCmd config set cache  "$NpmCache"  --location=user | Out-Null

# 3) 設定 registry / proxy（若有填才會設）
if ($Registry -ne "") {
  & $npmCmd config set registry "$Registry" --location=user | Out-Null
  Write-Host "已設定 npm registry：$Registry"
}

if ($ProxyHttp -ne "") {
  & $npmCmd config set proxy "$ProxyHttp" --location=user | Out-Null
  Write-Host "已設定 npm proxy：$ProxyHttp"
}

if ($ProxyHttps -ne "") {
  & $npmCmd config set https-proxy "$ProxyHttps" --location=user | Out-Null
  Write-Host "已設定 npm https-proxy：$ProxyHttps"
}

# 4) 將 npm-global 也加到 PATH（讓全域工具可直接用）
# npm global bin 在 Windows 通常是 prefix 本身
Add-ToUserPath $NpmGlobal

# 5) 寫回使用者 PATH
[Environment]::SetEnvironmentVariable("Path", $currentPath, "User")

Write-Host ""
Write-Host "=== 完成 ==="
Write-Host "請關閉並重開 VS Code / 終端機後再驗證："
Write-Host "  node -v"
Write-Host "  npm -v"
Write-Host "  npm config get prefix"
Write-Host "  npm config get cache"
if ($Registry -ne "") { Write-Host "  npm config get registry" }




# 執行方式
# PowerShell 可能預設禁止執行腳本，你可以用一次性方式執行（不改系統策略）：
# powershell -ExecutionPolicy Bypass -File .\init-node-env.ps1