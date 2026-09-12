# PLAN MAISON — moteur de rendu 3D en ligne

Cette version remplace la fausse « 3D réaliste » par une architecture réelle :
**PLAN MAISON → API `/api/render3d` → Blender → PNG photoréaliste/architectural → application**.

## Déploiement

Le projet est fourni avec un `Dockerfile` qui installe Node.js, Express et Blender. Déployez le dossier sur un hébergeur qui accepte les conteneurs Docker (par exemple un VPS ou une plateforme cloud compatible Docker).

Une fois le service en ligne, l'application utilise automatiquement `/api/render3d` : aucune URL API et aucune clé secrète ne sont demandées à l'utilisateur.

## API

`POST /api/render3d`

Le corps JSON contient le plan structuré, les pièces, portes, fenêtres et le descriptif. La réponse est :

```json
{"ok":true,"image_url":"https://votre-domaine/renders/ID.png","engine":"Blender","job_id":"ID"}
```

`GET /api/health` permet de vérifier le moteur.

## Important

Le rendu est réellement calculé par Blender. La qualité finale dépendra de la scène, des matériaux, du mobilier et de la puissance du serveur. Cette première scène est un moteur fonctionnel de base, à enrichir ensuite avec des bibliothèques de mobilier, matériaux et éclairage plus poussés.
