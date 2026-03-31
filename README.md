# README

- Auth Logic
  Next.js
  │
  │ 로그인 버튼
  ▼
  Rails
  /auth/google?redirect_path=/my
  │
  │ redirect
  ▼
  Google Login
  │
  │ 인증 성공
  ▼
  Rails callback
  /auth/google/callback
  │
  │ user 생성/조회
  │ session 생성
  ▼
  redirect
  FRONTEND_URL + redirect_path
