<h1 align="center">InstaBrute Max</h1>

<p align="center">
  <strong>Bruteforce Instagram | 100% Bash | TOR + fzf + Session Save</strong><br>
  <em>Par @trhacknon (origine) • Optimisé par AutoExpert</em>
</p>

## Proof:
![insta](https://user-images.githubusercontent.com/50268203/81773518-694f8800-94b6-11ea-859d-9c2362d71dd4.gif)


---

### ✨ Présentation

**InstaBrute Max** est un script Bash avancé de brute-force Instagram, enrichi pour être :

- plus **interactif** (menu fzf)
- plus **fiable** (IP dynamique via TOR)
- plus **ergonomique** (session resume + UI terminal stylée)
- et toujours 100% shell, sans Python, sans bullshit.

---

### ⚙️ Fonctionnalités clés

- [x] Support TOR complet (rotation IP, vérification auto)
- [x] Sélection de wordlist via `fzf` (optionnelle)
- [x] Détection de profils publics/privés
- [x] Gestion de session automatique et manuelle (`--resume`)
- [x] Interface terminal colorée + prompts ludiques
- [x] Compatible Linux (Ubuntu, Debian...)

---

### 🚀 Installation rapide

```bash
git clone https://github.com/trh4ckn0n/instax.git
cd instabrute-max
chmod +x install.sh instax.sh
./install.sh
```

---

### 🎯 Utilisation

#### Bruteforce classique :
```bash
./instax.sh
```

#### Reprise d'une session sauvegardée :
```bash
./instax.sh --resume
```

> Pense à créer une wordlist `passwords.lst` ou à en ajouter plusieurs `.lst`

---

### 📦 Fichiers générés

- `found.instashell` → login valides trouvés
- `sessions/` → sauvegardes de sessions (reprises automatiques)
- `passwords.lst` → wordlist par défaut

---

### 🔐 Avertissement

> Ce projet est à but **éducatif uniquement**.  
> Tu es **le seul responsable** de l'utilisation de cet outil.

---

### ❤️ Merci

Basé sur le travail de [trhacknon](https://github.com/trh4ckn0n).  
---

### 🧠 Prochaines idées ?

- [ ] Ajout d'un mode stealth avec `proxychains`
- [ ] Intégration Telegram pour notification de succès
- [ ] Génération automatique de wordlist avec `cupp`

---
