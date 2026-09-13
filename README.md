# PLAN MAISON — moteur 3D autonome

Cette version est volontairement simplifiée pour le déploiement : **seulement 3 fichiers à conserver dans le dépôt** : `Dockerfile`, `package.json` et `server.js`.

`server.js` contient l'interface PLAN MAISON et le script Blender embarqués. Le conteneur installe Blender automatiquement.

## Architecture
PLAN MAISON → POST `/api/render3d` → Node/Express → Blender → PNG 3D → application.

## Vérification
- `GET /api/health`
- `POST /api/render3d`

Le rendu est réellement calculé par Blender. Les estimations de matériaux restent indicatives.
