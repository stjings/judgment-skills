# judgment-skills

**일은 AI에게, 판단의 기준은 내 손에.**

[mattpocock/skills](https://github.com/mattpocock/skills)의 엔지니어링 흐름(grill → spec → tickets → tdd → code-review → retro) 위에
**판단 게이트**를 얹은 강화판입니다. mattpocock skills가 "에이전트가 일하는 순서"를 잡아 준다면,
이 플러그인은 그 순서의 **앞(의도)**과 **끝(증거)**에서 사람이 판단을 놓치지 않게 합니다.

```
의도 기록 → 위임 경계 → 실행 증거 → 사람의 판단
```

## 스킬

### User-invoked (직접 호출)

| 스킬 | 언제 | mattpocock 대비 강화점 |
|---|---|---|
| [`/intent-grill`](skills/intent-grill/SKILL.md) | 구현 전, 프로젝트나 기능의 의도를 정할 때 | `grill-me` 인터뷰 + 제외 범위·판단 우선순위·위임 경계를 필수로 받고, **확정/미확정**을 구분해 `docs/intent.md`에 기록 |
| [`/delegate-task`](skills/delegate-task/SKILL.md) | 작업 하나를 맡길 때 | `implement` 앞에 작업 브리프(범위, 제외, 관찰 가능한 완료 기준, 검증 방법)와 의도 충돌 확인을 세우고, 끝에 기준별 증거 보고 |
| [`/evidence-review`](skills/evidence-review/SKILL.md) | 완료 보고를 받은 뒤 | `code-review`의 두 축에 더해 **완료 기준별 재실행 증거**, 테스트가 놓치는 실패, 요구사항 대비 누락·추가, 설계 이유 설명, 배포 판단 요약 |
| [`/judgment-check`](skills/judgment-check/SKILL.md) | 세션·하루 마무리 | 여섯 가지 판단 점검, 미룬 검토 기록, 반복 누락은 `retro`로 연결 |

### Model-invoked (에이전트가 참조)

| 스킬 | 내용 |
|---|---|
| [`judgment-gates`](skills/judgment-gates/SKILL.md) | 네 가지 게이트, 확정/미확정 규칙, 웹 운영개발 기본 위임 경계표, 충돌의 세 가지 선택, 세 가지 상태(위임/연기/포기), 검토를 미뤄도 되는 조건, 증거 규칙, 문서 규칙과 강제 장치의 구분 |

## 추천 흐름

```
/intent-grill              의도 확정 (프로젝트 시작 또는 큰 방향 변경 시)
   │
   ├─ 작은 작업 ──────────→ /delegate-task → /evidence-review
   │
   └─ 여러 세션의 큰 기능 → /to-spec → /to-tickets → /implement (mattpocock)
                                                  → /evidence-review
/judgment-check            세션 마무리
```

mattpocock skills와 **함께 설치**해서 쓰는 것을 전제로 합니다. 다만 mattpocock skills가 없는 환경(예: Claude 앱 채팅)에서도
각 스킬이 혼자 동작하도록 핵심 규칙을 안에 담았습니다. `tdd`, `code-review`, `domain-modeling`이 설치되어 있으면 Skill 도구로 불러 씁니다.

## 설치

### Claude Code (여러 PC 동기화)

각 PC에서 한 번만 실행합니다.

```bash
claude plugin marketplace add stjings/judgment-skills
claude plugin install judgment-skills@stjings
```

mattpocock skills도 함께 설치합니다(이미 있으면 생략).

```bash
claude plugin install mattpocock-skills@claude-plugins-official
```

**업데이트 받기**: 이 저장소에 새 버전이 push되면 각 PC에서

```bash
claude plugin marketplace update stjings
claude plugin update judgment-skills@stjings
```

`/plugin` 메뉴의 마켓플레이스 설정에서 자동 업데이트를 켜 두면 Claude Code 시작 시 자동으로 받습니다.
Claude Code는 `plugin.json`의 `version`이 바뀌어야 새 버전으로 인식하므로, 스킬을 고친 뒤에는 반드시 버전을 올려 push합니다.

### Claude 앱 (채팅)

채팅은 GitHub 마켓플레이스를 읽지 않으므로 계정 스킬로 따로 등록합니다.

```bash
./scripts/package-for-claude-app.sh   # dist/<skill>.zip 생성
```

Claude 앱의 설정 → 기능(Capabilities) → 스킬에서 zip을 하나씩 업로드합니다. 스킬을 고친 뒤에는 다시 올려야 반영됩니다.

## 스킬 수정 절차

```bash
# 1. skills/<name>/SKILL.md 수정
# 2. 버전 올리기
./scripts/bump-version.sh          # patch, 또는 minor / major
# 3. 검증
claude plugin validate . --strict
# 4. 커밋·push
git commit -am "feat: ..." && git push
# 5. Claude 앱도 쓰면 바뀐 스킬 zip 다시 업로드
```

## 저장소에 생기는 문서

mattpocock skills의 구조(`GLOSSARY.md`, `docs/adr/`, `docs/agents/`)를 그대로 쓰고, 아래만 더합니다. 모두 쓸 내용이 생길 때 만들어집니다.

| 파일 | 내용 |
|---|---|
| `docs/intent.md` | 대상, 목표, 하지 않을 일, 판단 우선순위, 위임 경계 (확정/미확정 구분) |
| `docs/agents/delegation.md` | 프로젝트별 위임 경계표 (없으면 `judgment-gates` 기본값) |
| `docs/tasks/<작업명>.md` | 작업 브리프 |
| `docs/deferred-reviews.md` | 미룬 검토 기록 |

## 출처와 라이선스

MIT. mattpocock/skills (MIT) 기반 부분과 개념 출처는 [NOTICE.md](NOTICE.md)를 참고하세요.
