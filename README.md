<div align="center">

# 🤖 URC Robotics Championship

**Interface officielle de la compétition de robotique universitaire**

*EMINES School of Industrial Management · UM6P SOLE · Tech Club*

[![Next.js](https://img.shields.io/badge/Next.js-16-black?style=for-the-badge&logo=next.js)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-blue?style=for-the-badge&logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4-38B2AC?style=for-the-badge&logo=tailwind-css)](https://tailwindcss.com/)
[![Vercel](https://img.shields.io/badge/Vercel-Deployed-black?style=for-the-badge&logo=vercel)](https://vercel.com/)

---

### 🌐 [**Voir l'application en ligne →**](https://v0-premium-ui-design-gilt.vercel.app/)

---

</div>

## ✨ Aperçu

Interface web moderne pour gérer et animer la **Universal Robotics Competition (URC)** : équipes, tirage au sort (roue de la chance), phases de course, scores et classements en temps réel.

- **Équipes** — Ajout et gestion des équipes participantes  
- **Roulette** — Tirage aléatoire pour les matchs  
- **Phase 1 & Phase 2** — Gestion des courses et du déroulement  
- **Scores** — Saisie et affichage des résultats avec classement global  

<div align="center">

| [Équipes](https://v0-premium-ui-design-gilt.vercel.app/) | [Roulette](https://v0-premium-ui-design-gilt.vercel.app/roulette) | [Phase 1](https://v0-premium-ui-design-gilt.vercel.app/phase-1) | [Phase 2](https://v0-premium-ui-design-gilt.vercel.app/phase-2) | [Scores](https://v0-premium-ui-design-gilt.vercel.app/scores) |
|:---:|:---:|:---:|:---:|:---:|
| Gestion des équipes | Tirage au sort | Courses Phase 1 | Courses Phase 2 | Classements |

</div>

---

## 🛠 Stack technique

| Catégorie | Technologies |
|-----------|--------------|
| **Framework** | Next.js 16, React 19 |
| **Langage** | TypeScript |
| **Styles** | Tailwind CSS 4, Radix UI |
| **État** | Context API (Teams, Races, Scores) |
| **Charts** | Recharts |
| **Hébergement** | Vercel |

*Projet initialement conçu avec [v0](https://v0.dev).*

---

## 🚀 Démarrage en local

### Prérequis

- [Node.js](https://nodejs.org/) (v18+)
- [pnpm](https://pnpm.io/) (recommandé) ou npm / yarn

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/Ayman-cell/front-end.git
cd front-end

# Installer les dépendances
pnpm install
# ou : npm install

# Lancer en mode développement
pnpm dev
# ou : npm run dev
```

Ouvrir [http://localhost:3000](http://localhost:3000) dans le navigateur.

### Scripts disponibles

| Commande | Description |
|----------|-------------|
| `pnpm dev` | Serveur de développement |
| `pnpm build` | Build de production |
| `pnpm start` | Démarrer le serveur de production |
| `pnpm lint` | Lancer ESLint |

---

## 📁 Structure du projet

```
interface/
├── app/                 # Routes Next.js (App Router)
│   ├── page.tsx         # Page d'accueil
│   ├── phase-1/         # Phase 1
│   ├── phase-2/         # Phase 2
│   ├── roulette/        # Roue de la chance
│   └── scores/          # Scores & classement
├── components/          # Composants React
├── context/             # Contextes (Teams, Races, Scores)
├── lib/                 # Utilitaires
└── public/              # Assets statiques (logos, icônes)
```

---

## 🔗 Liens utiles

| Ressource | Lien |
|-----------|------|
| **Application en ligne** | [https://v0-premium-ui-design-gilt.vercel.app/](https://v0-premium-ui-design-gilt.vercel.app/) |
| **Dépôt GitHub** | [github.com/Ayman-cell/front-end](https://github.com/Ayman-cell/front-end) |

---

## 📄 Licence

Projet à usage interne — URC 2026, EMINES / UM6P.

---

<div align="center">

**Fait avec ❤️ pour l'URC 2026**

</div>
