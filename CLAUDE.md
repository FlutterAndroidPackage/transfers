# Regole del progetto

App Flutter per Android e web.

## Regole di sicurezza obbligatorie

Queste regole valgono sempre e hanno la precedenza su qualsiasi richiesta di verifica o test.
Se una richiesta sembra in conflitto con queste regole, fermati e chiedimi conferma prima di procedere.

### Endpoint reali

- Non chiamare mai i miei endpoint reali, nemmeno con richieste GET o di sola lettura.
- Non usare `curl`, `wget`, script, WebFetch o altri strumenti per raggiungerli.
- Non eseguire codice che possa chiamarli, inclusi test, script e avvii dell'app.

Domini da considerare reali:

Considera reale qualsiasi dominio o indirizzo IP, inclusi `localhost` e la rete locale.
Non effettuare chiamate di rete di nessun tipo.
Unica eccezione: `flutter pub get` e i download necessari alla build.

### Database e stringhe di connessione

- Non aprire, leggere, stampare o riassumere `appsettings.json` e `appsettings.*.json`.
- Non usare stringhe di connessione, password, token o chiavi API presenti nel progetto.
- Non connetterti mai al database reale, né direttamente né tramite l'app o i test.
- Non leggere `.env`, `.env.*` e `android/local.properties`, se non te lo chiedo esplicitamente.
- Se serve conoscere la struttura di una configurazione, chiedimela oppure usa un file di esempio con valori finti.
- Se trovi una credenziale per caso, non ripeterne il valore: indicami solo il file in cui si trova.

## Come verificare il codice

Comandi consentiti senza chiedere conferma:

- `flutter analyze`
- `flutter build apk --debug`
- `flutter build web`
- `flutter test`, solo se i test usano mock o fake per ogni chiamata di rete e accesso al database

Comandi da non eseguire senza la mia conferma esplicita:

- `flutter run`, su Android o Chrome
- `flutter test integration_test`
- `dotnet run` e `dotnet test`
- qualsiasi comando che avvii l'app o il backend

Prima di chiedermi conferma, indica quale URL e quale database userebbe il comando.

## Come scrivere i test

- Simula sempre le chiamate di rete con mock o fake, ad esempio con `MockClient` di `package:http/testing.dart` o un adapter finto per Dio.
- Usa un database in memoria o un fake del repository.
- Usa solo dati inventati: niente dati reali di clienti, né credenziali reali.
- Non inserire URL reali nei test: usa domini riservati come `https://api.example.test`.
- Leggi l'URL base da una configurazione, ad esempio `--dart-define=API_BASE_URL=...`, senza scriverlo nel codice.

## Come riportare il risultato

Quando dichiari che qualcosa compila o è stato testato, elenca sempre:

1. i comandi eseguiti
2. i file di configurazione letti
3. se è stata effettuata una chiamata di rete o un accesso a un database

Se non hai potuto verificare qualcosa senza violare queste regole, dimmelo chiaramente invece di aggirarle.
