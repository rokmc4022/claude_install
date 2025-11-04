#!/bin/bash

# Claude Code 설치 스크립트 for Ubuntu
# 사용법: curl -fsSL https://your-domain.com/install-claude-code.sh | bash

set -e  # 오류 발생 시 스크립트 중단

echo "================================================"
echo "Claude Code 설치 시작"
echo "================================================"

# Root 권한 확인
if [ "$EUID" -ne 0 ]; then 
    echo "이 스크립트는 sudo 권한이 필요합니다."
    echo "다시 실행: sudo bash install-claude-code.sh"
    exit 1
fi

echo ""
echo "1단계: 기존 Node.js 제거 중..."
apt-get remove --purge -y nodejs npm libnode-dev libnode72 node-* 2>/dev/null || true
apt-get autoremove -y
apt-get autoclean
rm -f /etc/apt/sources.list.d/nodesource.list

echo ""
echo "2단계: Node.js 20 LTS 설치 중..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get update
apt-get install -y nodejs

echo ""
echo "3단계: 설치 확인..."
NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
echo "Node.js 버전: $NODE_VERSION"
echo "npm 버전: $NPM_VERSION"

echo ""
echo "4단계: Claude Code 설치 중..."
npm install -g @anthropic-ai/claude-code

echo ""
echo "5단계: Claude Code 설치 확인..."
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
echo "자세한 문서: https://docs.claude.com/en/docs/claude-code"
