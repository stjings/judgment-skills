#!/usr/bin/env bash
# plugin.json의 version을 올린다. Claude Code는 version이 바뀌어야 각 PC에 새 버전을 설치한다.
# 사용: ./scripts/bump-version.sh [patch|minor|major]   (기본 patch)
set -euo pipefail
cd "$(dirname "$0")/.."
part="${1:-patch}"
node -e '
const fs=require("fs");const f=".claude-plugin/plugin.json";
const j=JSON.parse(fs.readFileSync(f,"utf8"));
let [a,b,c]=j.version.split(".").map(Number);
const p=process.argv[1];
if(p==="major"){a++;b=0;c=0}else if(p==="minor"){b++;c=0}else{c++}
j.version=`${a}.${b}.${c}`;
fs.writeFileSync(f,JSON.stringify(j,null,2)+"\n");
console.log(j.version);
' "$part"
