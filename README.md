# MindGameTrainer — guida al setup (≈15 minuti)

App web per allenarsi ai *mindgame* di MindGame contro un bot casuale, con statistiche
condivise, ranking per imprevedibilità e analisi dei pattern. I dati stanno su Supabase
(gratuito) e l'app si pubblica su GitHub Pages (gratuito). Serve solo un browser.

File in questa cartella:
- `index.html` — l'applicazione (unico file).
- `schema.sql` — le tabelle del database, da incollare in Supabase.
- `README.md` — questa guida.

---

## Passo 1 — Crea il database su Supabase (5 min)

1. Vai su https://supabase.com → **Start your project** → accedi (con GitHub va bene).
2. **New project**: dai un nome (es. `mindgametrainer`), scegli una password del database
   (salvala) e una region vicina (es. *Frankfurt/EU*). Attendi ~2 minuti che si crei.
3. Nel menu a sinistra apri **SQL Editor** → **New query**.
4. Apri `schema.sql`, copia **tutto** il contenuto, incollalo nell'editor e premi **RUN**.
   Deve comparire *Success*. (Crea le tabelle `players` ed `events`.)
5. Prendi le due chiavi: menu **Project Settings** (ingranaggio) → **API**. Copia:
   - **Project URL** (es. `https://abcd1234.supabase.co`)
   - **anon public** key (una stringa lunga; è pensata per stare nel sito, è sicura).

> La chiave `anon` è pubblica per definizione: con le regole in `schema.sql` permette solo
> di leggere le statistiche e aggiungere partite, **non** di cancellare dati altrui.

## Passo 2 — Inserisci le chiavi in `index.html` (1 min)

Apri `index.html` con un editor di testo (Blocco note, TextEdit, VS Code…) e in cima allo
`<script>` trovi:

```js
const SUPABASE_URL = "__SUPABASE_URL__";
const SUPABASE_ANON_KEY = "__SUPABASE_ANON_KEY__";
```

Sostituisci i due segnaposto con i tuoi valori del Passo 1, per esempio:

```js
const SUPABASE_URL = "https://abcd1234.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOi...la-tua-chiave-anon...";
```

Salva. Puoi già fare doppio clic su `index.html` per provarlo: in alto il pallino deve
diventare verde ("online").

## Passo 3 — Pubblica su GitHub Pages (5–8 min)

1. Vai su https://github.com → accedi/registrati → **New repository**.
   Nome es. `mindgametrainer`, **Public**, crea.
2. Nella pagina del repo: **Add file → Upload files**. Trascina `index.html`
   (basta questo file; `schema.sql` e `README.md` sono facoltativi). **Commit changes**.
3. **Settings** (del repo) → **Pages** → in *Build and deployment* imposta
   **Source: Deploy from a branch**, **Branch: `main`** cartella **`/ (root)`** → **Save**.
4. Dopo 1–2 minuti, in cima alla stessa pagina compare il link pubblico, tipo:
   `https://<tuo-utente>.github.io/mindgametrainer/`

Quello è il link da **condividere**. Funziona su desktop e su smartphone.

## Cosa vede chi apre il link

La stessa app: schermata **Giocatore** (registra un nickname o scegline uno esistente) →
**Gioca** (Attacco/Difesa, round singolo o attacco completo con difesa 2–5) →
**Ranking** (tutti i giocatori, ordinati per imprevedibilità, con statistiche globali in
fondo) → **Analisi** (i pattern di un nickname). Le statistiche sono condivise da tutti.

## Aggiornare l'app in futuro

Se ti mando una nuova versione di `index.html`: nel repo GitHub → apri il file → icona
matita (Edit) o ricarica il file con lo stesso nome → Commit. Il sito si aggiorna da solo
in ~1 minuto. **Ricordati di rimettere le due chiavi** se il file nuovo ha di nuovo i
segnaposto.

## Esportare i dati (per addestrare l'AI, più avanti)

Supabase → **Table Editor** → tabella `events` → **Export → CSV**. Ogni riga è un mindgame
(nickname, ruolo, numero giocato, numero del bot, esito, ecc.): è il dataset con cui in
futuro addestreremo il bot AI.

## Note e limiti (onesti)

- Senza login chiunque può scegliere qualsiasi nickname (impersonazione possibile). Va bene
  per allenarsi; se servirà proteggere i dati di training aggiungeremo un PIN per nickname.
- Il ranking rilegge tutte le partite a ogni apertura: perfetto fino a decine di migliaia di
  mindgame. Se un giorno diventassero centinaia di migliaia, aggiungeremo una tabella di
  statistiche aggregate per tenerlo veloce.
- Piani gratuiti: Supabase e GitHub Pages bastano ampiamente per un progetto di playtest.
