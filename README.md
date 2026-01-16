# Raycast Scripts 🧰

Des petits scripts pour Raycast qui automatisent des tâches du quotidien sur macOS. Chaque script peut être lancé depuis Raycast **ou** directement depuis le terminal.

## ✨ Scripts inclus

### 1) Archive du bureau 📦
**Fichier :** `RC_archive.sh`  
**Mot‑clé Raycast :** `archive`

**Ce que ça fait :**
- Crée un dossier `DesktopArchive` sur le Bureau.
- Classe les fichiers du Bureau par mois (ex: `2024_11_novembre`).
- Ignore les fichiers tagués `Bureau`.

**Lancer :**
- Raycast → tape `archive`
- Terminal → `./RC_archive.sh`

---

### 2) Changer le fond d’écran en boucle 🖼️
**Fichier :** `RC_change-wallpaper.sh`  
**Mot‑clé Raycast :** `wallpaper`

**Ce que ça fait :**
- Change le fond d’écran toutes les 60 secondes.
- Choisit une image aléatoire dans `wallpapers/*.jpg`.

**Pré‑requis :**
- Créer un dossier `wallpapers` à côté du script.
- Y ajouter des images `.jpg`.

**Lancer :**
- Raycast → tape `wallpaper`
- Terminal → `./RC_change-wallpaper.sh`

**Arrêter :**
- Terminal → `Ctrl+C`
- Raycast → arrêter l’exécution si besoin

---

### 3) Déplacer les téléchargements vers le bureau ⬇️➡️🖥️
**Fichier :** `RC_dl2desk.sh`  
**Mot‑clé Raycast :** `dl2desk`

**Ce que ça fait :**
- Déplace les fichiers de `~/Downloads` vers `~/Desktop`.
- Ignore les fichiers `.tmp` et `.crdownload`.
- Déplace aussi les dossiers.
- Boucle toutes les 5 secondes.

**Lancer :**
- Raycast → tape `dl2desk`
- Terminal → `./RC_dl2desk.sh`

**Arrêter :**
- Terminal → `Ctrl+C`
- Raycast → arrêter l’exécution si besoin

## ⚙️ Installation dans Raycast

1. Ouvre Raycast → **Extensions** → **Script Commands**
2. Clique **Add Script Directory**
3. Sélectionne ce dossier :
   - `/Users/clm/Documents/GitHub/EXTENSIONS/RC_pkscripts`
4. Lance un script avec son mot‑clé (ex: `archive`)

## ✅ Notes

- Les lignes `@raycast.*` sont **des commentaires** : elles n’impactent pas l’exécution en terminal.
- Les scripts avec une boucle infinie (wallpaper, dl2desk) peuvent être laissés en tâche de fond.

---

# Raycast Scripts 🧰 (English)

Small Raycast scripts to automate daily macOS tasks. Each script can be launched from Raycast **or** directly from the terminal.

## ✨ Included scripts

### 1) Desktop archive 📦
**File:** `RC_archive.sh`  
**Raycast keyword:** `archive`

**What it does:**
- Creates a `DesktopArchive` folder on the Desktop.
- Sorts Desktop files by month (e.g. `2024_11_november`).
- Skips files tagged `Bureau`.

**Run:**
- Raycast → type `archive`
- Terminal → `./RC_archive.sh`

---

### 2) Looping wallpaper changer 🖼️
**File:** `RC_change-wallpaper.sh`  
**Raycast keyword:** `wallpaper`

**What it does:**
- Changes wallpaper every 60 seconds.
- Picks a random image from `wallpapers/*.jpg`.

**Requirements:**
- Create a `wallpapers` folder next to the script.
- Put `.jpg` images inside.

**Run:**
- Raycast → type `wallpaper`
- Terminal → `./RC_change-wallpaper.sh`

**Stop:**
- Terminal → `Ctrl+C`
- Raycast → stop execution if needed

---

### 3) Move downloads to desktop ⬇️➡️🖥️
**File:** `RC_dl2desk.sh`  
**Raycast keyword:** `dl2desk`

**What it does:**
- Moves files from `~/Downloads` to `~/Desktop`.
- Ignores `.tmp` and `.crdownload` files.
- Also moves folders.
- Loops every 5 seconds.

**Run:**
- Raycast → type `dl2desk`
- Terminal → `./RC_dl2desk.sh`

**Stop:**
- Terminal → `Ctrl+C`
- Raycast → stop execution if needed

## ⚙️ Install in Raycast

1. Open Raycast → **Extensions** → **Script Commands**
2. Click **Add Script Directory**
3. Select this folder:
   - `/Users/clm/Documents/GitHub/EXTENSIONS/RC_pkscripts`
4. Run a script using its keyword (e.g. `archive`)

## ✅ Notes

- `@raycast.*` lines are **comments**: they do not affect terminal execution.
- Scripts with infinite loops (wallpaper, dl2desk) can run in the background.
