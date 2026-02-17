ABSTRACT-DEVFLOW 

Non aplikasyon an: DevFlow 

Kategori: Education / Programming / Flashcards 

Objektif aplikasyon an 

DevFlow se yon aplikasyon mobil ki fèt pou ede etidyan ak devlopè debitan 
revize konsèp enpòtan nan Flutter, Dart ak devlopman Android atravè sistèm 
flashcards entèaktif. Objektif prensipal la se rann aprantisaj la pi rapid, pi senp, 
epi pi amizan gras ak kestyon teknik, repons klè, ak eksplikasyon detaye ansanm 
ak lyen ki mennen sou dokimantasyon ofisyèl yo. 

Ki pwoblèm li rezoud 

Aplikasyon an ede etidyan ki gen difikilte pou metrize ak sonje konsèp teknik nan 
Android, Dart ak Flutter, espesyalman timoun L4 yo ki ap prepare pou egzamen, 
soutenans, pwojè final oswa menm entèvyou teknik. Li pèmèt yo revize kestyon 
teknik yo yon fason rapid, estriktire ak entèaktif, atravè kestyon o aza ki ranfòse 
memorizasyon ak konpreyansyon. 
Chak kestyon vini ak repons klè ak eksplikasyon detaye pou ede itilizatè yo 
konprann pi byen chak nosyon. Aplikasyon an pèmèt tou make kestyon enpòtan 
kòm favori pou yon revizyon plis pèsonalize. Anplis, menm si pa gen entènèt, li 
ka itilize done ki te deja sove lokalman gras ak sistèm estokaj entegre a. 

Fonksyonalite prensipal yo 
- Chaje flashcards depi yon API ekstèn - Melanje kestyon yo otomatikman (random shuffle) 
- Afichaj kestyon ak repons sou ekran diferan 
- Montre eksplikasyon detaye pou chak kestyon 
- Lyen dirèk pou wè dokimantasyon ofisyèl
- Sistèm favori ak estokaj lokal (SharedPreferences) 
- Pwogrè vizyèl (progress bar) 
- Jesyon erè ak bouton pou reeseye 
- Splash screen ak entèfas modèn (Google Fonts, Material Design) 

Moun, Wòl ak Responsablite 

CESAR Yves Angello 
Wòl: Backend 
Responsablite: Modèl Flashcard, API, estokaj lokal (favori/cache), jesyon eta 
aplikasyon an 

CALVERT Wanguy 
Wòl: Frontend A 
Responsablite: SplashScreen, HomeScreen, navigasyon, ba pwogrè, bouton yo 

JOSEPH Scarline 
Wòl: Frontend B 
Responsablite: LibraryScreen (favori), DetailScreen (repons), AboutScreen, 
Logo DevFlow, jesyon erè 

Rezime teknik 
Aplikasyon an devlope ak Flutter epi li itilize achitekti ki baze sou Provider pou 
jesyon eta (state management). 
Li gen plizyè ekran prensipal: 
- SplashScreen (ekran lansman) 
- HomeScreen (afichaj kestyon ak pwogrè) 
- DetailScreen (repons ak eksplikasyon) 
- LibraryScreen (lis kestyon favori yo) 
- AboutScreen (enfòmasyon sou pwojè a ak ekip la) 

Teknoloji ak pakè yo itilize: 
- http pou rekipere done depi API 
- provider pou jesyon eta 
- shared_preferences pou estokaj lokal 
- url_launcher pou ouvri lyen ekstèn 
- google_fonts pou amelyore aparans tipografi 

Aplikasyon an entegre yon sistèm cache lokal pou pèmèt itilizasyon menm si 
koneksyon entènèt la pa disponib. 