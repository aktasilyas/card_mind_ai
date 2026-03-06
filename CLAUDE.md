# CardMind AI — Flutter Projesi

Flutter 3.x + Dart 3.x, Android & iOS hedef.

## Mimari
Clean Architecture: data / domain / presentation katmanları.
Her feature kendi klasöründe bağımsız.

## State Management
flutter_bloc — her feature için ayrı Bloc/Cubit.
UI doğrudan iş mantığına erişmez, sadece Bloc üzerinden.

## Kurallar
- `any` tipi kullanma, tüm tipler explicit
- Tüm Bloc event/state sınıfları `sealed class` olarak tanımla
- Repository'ler sadece `Either<Failure, T>` döndürür (dartz)
- Widget'lar mümkün olduğunca stateless, state Bloc'ta
- Hiçbir zaman `BuildContext` async gap sonrası kullanma
- const constructor her yerde kullan

## Komutlar
- `flutter run` — cihazda çalıştır
- `flutter test` — tüm testler
- `flutter test test/features/deck/` — deck testleri
- `flutter build apk --release` — release APK
- `dart fix --apply` — otomatik düzeltmeler
- `flutter pub run build_runner build --delete-conflicting-outputs` — code gen

## Önemli Dosyalar
- `lib/core/constants/api_keys.dart` — API anahtarları (git'e ekleme!)
- `lib/core/utils/sm2_algorithm.dart` — Spaced Repetition algoritması
- `assets/prompts/card_generation_prompt.txt` — AI prompt şablonu

## Bağımlılıklar (pubspec.yaml'a eklendi)
flutter_bloc, hive_flutter, get_it, injectable, go_router,
dio, dartz, google_mobile_ads, purchases_flutter (RevenueCat),
freezed, json_serializable

## Git
- Feature branch'ler: `feature/deck-management`, `feature/ai-generate`
- Commit formatı: `feat(deck): add create deck use case`
- Her feature tamamlandığında PR aç

## Worktree Kullanımı
WSL ortamında `claude --worktree` çalışmıyor.
Bunun yerine manuel branch workflow kullan:

  git checkout -b feature/xxx
  # çalışmayı yap
  git add .
  git commit -m "feat(xxx): ..."
  git checkout main
  git merge feature/xxx
  git push
  
## UX Prensipleri
- Maksimum 2 tap: Her işlem en fazla 2 dokunuşla yapılabilmeli
- İç içe navigation yasak: Stack derinliği max 2 seviye
- Bottom navigation her zaman görünür (çalışma modu hariç)
- FAB ile ana aksiyonlar direkt erişilebilir
- Dialog yerine bottom sheet tercih et (daha az kesinti)
- Boş durumlar actionable olmalı ("Henüz kart yok" + direkt "Kart Ekle" butonu)
- Geri butonu gerektiren akışlardan kaç
- Her ekran tek bir ana aksiyon içermeli

## Kod İnceleme Kuralı
Her feature implementation tamamlandığında flutter-reviewer 
subagent'ını MUTLAKA çalıştır. Sonuçları göster, 
onay almadan merge etme.