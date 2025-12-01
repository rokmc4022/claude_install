#!/bin/bash

# Claude Code 설치 스크립트 for Rocky Linux / RHEL / CentOS / AlmaLinux
# 사용법: curl -fsSL https://raw.githubusercontent.com/rokmc4022/claude_install/main/install-claude-code-rocky.sh | sudo bash

set -e  # 오류 발생 시 스크립트 중단

echo "================================================"
echo "Claude Code 설치 시작 (Rocky/RHEL 계열)"
echo "================================================"

# Root 권한 확인
if [ "$EUID" -ne 0 ]; then 
    echo "이 스크립트는 sudo 권한이 필요합니다."
    echo "다시 실행: sudo bash install-claude-code-rocky.sh"
    exit 1
fi

# OS 확인
if [ -f /etc/redhat-release ]; then
    OS_NAME=$(cat /etc/redhat-release)
    echo "감지된 OS: $OS_NAME"
else
    echo "경고: RHEL 계열 OS가 아닐 수 있습니다."
fi

echo ""
echo "1단계: 기존 Node.js 제거 중..."
dnf remove -y nodejs npm 2>/dev/null || yum remove -y nodejs npm 2>/dev/null || true
rm -rf /usr/local/lib/node_modules
rm -rf /usr/local/bin/node
rm -rf /usr/local/bin/npm
rm -f /etc/yum.repos.d/nodesource*.repo

echo ""
echo "2단계: 필수 패키지 설치 중..."
dnf install -y curl 2>/dev/null || yum install -y curl 2>/dev/null

echo ""
echo "3단계: Node.js 20 LTS 설치 중..."
# NodeSource 저장소 추가
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -

# Node.js 설치
dnf install -y nodejs 2>/dev/null || yum install -y nodejs 2>/dev/null

echo ""
echo "4단계: 설치 확인..."
NODE_VERSION=$(node --version 2>/dev/null || echo "설치 실패")
NPM_VERSION=$(npm --version 2>/dev/null || echo "설치 실패")
echo "Node.js 버전: $NODE_VERSION"
echo "npm 버전: $NPM_VERSION"

# 버전 확인
if [[ "$NODE_VERSION" != v20* ]] && [[ "$NODE_VERSION" != v22* ]]; then
    echo "경고: Node.js 20 이상이 필요합니다. 현재: $NODE_VERSION"
    exit 1
fi

echo ""
echo "5단계: Claude Code 설치 중..."
npm install -g @anthropic-ai/claude-code

echo ""
echo "6단계: Claude Code 설치 확인..."
CLAUDE_VERSION=$(claude --version 2>&1 || echo "버전 확인 실패")
echo "Claude Code: $CLAUDE_VERSION"

echo ""
echo "================================================"
echo "✅ 설치 완료!"
echo "================================================"
echo ""
echo "사용 방법:"
echo "  claude              # Claude Code 시작"
echo "  claude --help       # 도움말 보기"
echo ""
echo "자세한 문서: https://docs.anthropic.com/en/docs/claude-code"
