# CardMind AI — Proje Durumu

## Son Güncelleme
2026-03-07

## Tamamlanan Asamalar
- Asama 1: Temel altyapi (Clean Architecture, GetIt, Hive, GoRouter)
- Asama 2: Deck feature (CRUD, Hive, BLoC, testler)
- Asama 3: SM-2 Spaced Repetition algoritmasi + Study UI scaffold
- Asama 4: AI kart uretimi (OpenAI GPT-4o-mini, gunluk limit)
- Asama 5: Monetizasyon (AdMob, RevenueCat abonelik)
- Asama 6: Study session UI (flip card, rating bar, navigation)
- Uygulama uctan uca calisiyor

## Su An Yapilan
Sprint 4 Gamification baslandi (feature/sprint-4-gamification branch):
- business-logic-dev agent: XP sistemi, streak, kalp, istatistik domain+data katmani
- ui-ux-dev agent: Duolingo tasarim sistemi, GameHeader, DuoButton, StatsPage

## Siradaki Sprintler
- Sprint 1: Duolingo tasarim sistemi (Sprint 4 ile paralel yapiliyor)
- Sprint 5: Ayarlar ekrani
- Sprint 2: PDF + dosya destegi (premium)
- Sprint 3: Sesli giris (premium)
- Sprint 6: AI uretim ekrani yenileme
- Sprint 7: Onboarding

## Mimari
- Clean Architecture: data/domain/presentation
- State: flutter_bloc (sealed events/states)
- Local DB: Hive
- DI: GetIt + Injectable
- Navigation: GoRouter
- AI: OpenAI GPT-4o-mini
- Abonelik: RevenueCat
- Reklam: AdMob

## Claude Code Yapilari Kullanilanlar
- CLAUDE.md: proje kurallari + UX prensipleri + kod inceleme kurali
- Custom slash commands: /yeni-feature
- Subagents: flutter-reviewer, business-logic-dev, ui-ux-dev
- GitHub MCP: PR otomasyonu
- Plan Mode: her feature oncesi

## Onemli Dosyalar
- lib/core/constants/api_keys.dart → gitignore'da (OpenAI + RevenueCat key)
- lib/core/utils/sm2_algorithm.dart → SM-2 algoritmasi
- lib/core/di/injection.dart → GetIt DI
- lib/core/router/app_router.dart → GoRouter
- assets/prompts/card_generation_prompt.txt → AI prompt sablonu

## Bilinen Sorunlar
- WSL'de claude --worktree calismiyor, manuel branch kullaniliyor
- injection.config.dart build_runner ile uretiliyor

## Yeni Chat Acildiginda
1. Bu dosyayi oku
2. CLAUDE.md'yi oku
3. git log --oneline -10 calistir
4. Mevcut branch'i kontrol et
5. Devam edeceksen: "Sprint X'e devam ediyorum" de
