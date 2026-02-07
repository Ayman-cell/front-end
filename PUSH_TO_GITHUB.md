# Pousser le projet vers votre GitHub (Ayman-cell/front-end)

## Méthode la plus simple : utiliser le script

1. **Ouvrez l’Explorateur de fichiers** et allez dans le dossier du projet **interface** :
   - `Class 2028\URC 2026\interface`

2. **Double-cliquez** sur **`push-vers-github.bat`**.

3. Le script va :
   - se placer dans le bon dossier (celui du projet),
   - ajouter tous les fichiers,
   - créer un commit,
   - pousser vers **https://github.com/Ayman-cell/front-end**.

4. Si Windows ou Git demande une **authentification** (identifiants GitHub), utilisez :
   - votre **nom d’utilisateur** GitHub,
   - un **Personal Access Token** (et non votre mot de passe).
   - Créer un token : GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Generate new token**.

---

## Utiliser uniquement le Git de ce projet (supprimer l’autre Git)

Si vous aviez un dépôt Git ailleurs (par exemple à la racine de votre profil ou d’OneDrive) et que vous voulez que **seul ce projet** soit lié à **Ayman-cell/front-end** :

- Le projet **interface** a maintenant **son propre** dossier **`.git`** dans `URC 2026\interface\`.
- En lançant **`push-vers-github.bat`** depuis le dossier **interface**, seuls les fichiers de ce projet sont ajoutés et poussés.
- Vous n’avez rien à supprimer ailleurs : tant que vous faites **git** et **push** depuis le dossier **interface** (via le script), seul ce dépôt est utilisé.

Si vous voulez **supprimer** un ancien dépôt Git qui se trouvait dans un **autre** dossier (par exemple au-dessus d’interface), vous pouvez supprimer le dossier **`.git`** dans ce dossier parent. Faites-le seulement si vous êtes sûr de ne plus en avoir besoin.

---

## En cas de conflit au premier push

Si le dépôt **Ayman-cell/front-end** existe déjà sur GitHub avec un README ou d’autres fichiers, le premier `git push` peut refuser. Dans ce cas :

1. Ouvrez **PowerShell** ou **CMD**.
2. Allez dans le dossier du projet :
   ```powershell
   cd "C:\Users\Aymen\OneDrive - Université Mohammed VI Polytechnique\Class 2028\URC 2026\interface"
   ```
3. Récupérez l’historique distant et poussez :
   ```powershell
   git pull origin main --rebase
   git push -u origin main
   ```

---

**Dépôt cible :** [https://github.com/Ayman-cell/front-end](https://github.com/Ayman-cell/front-end)
