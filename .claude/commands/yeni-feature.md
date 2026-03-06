---
description: Clean Architecture ile yeni Flutter feature scaffold'u oluştur
argument-hint: [feature-adı]
allowed-tools: Read, Edit, Bash
---

CLAUDE.md'yi oku. $ARGUMENTS adında yeni Flutter feature scaffold'u oluştur.

Şu yapıyı oluştur:
lib/features/$ARGUMENTS/
  data/datasources/$ARGUMENTS_local_datasource.dart  (abstract class)
  data/models/$ARGUMENTS_model.dart                  (boş, Hive hazır)
  data/repositories/$ARGUMENTS_repository_impl.dart  (boş impl)
  domain/entities/$ARGUMENTS.dart                    (boş entity)
  domain/repositories/$ARGUMENTS_repository.dart     (abstract)
  domain/usecases/                                   (boş klasör)
  presentation/bloc/$ARGUMENTS_bloc.dart             (boş Bloc)
  presentation/pages/$ARGUMENTS_page.dart            (boş Scaffold)
  presentation/widgets/                              (boş klasör)

test/features/$ARGUMENTS/
  domain/usecases/                                   (boş klasör)
  presentation/bloc/                                 (boş klasör)

Her dosyaya sadece class tanımı ve gerekli import'ları ekle, implementasyon yok.
