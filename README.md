# Lucky Jim's Ranch — Panel 🌾

Panel GitHub Pages indépendant de tout projet EMS/LSPD.

**Site :** https://cgasmj-blip.github.io/LuckyJimsRanchPanel/

## Fonctionnalités développées

- Connexion Discord OAuth via Supabase Ranch et vérification des grades par Edge Function.
- Tableau de bord avec six thèmes.
- Récoltes par article, sans boutons de quantités prédéfinies ni affichage des primes dans les tuiles ou le récapitulatif.
- Commandes ExpressSantos : registre, recherche, filtre par statut, rafraîchissement, bouton de synchronisation Discord.
- Livraisons et rapprochement facultatif avec une commande.
- Registre de facturation **sans génération de devis ou facture**.
- Catalogue, tarifs, stocks, mouvements et transformations par recettes.
- Fiches employés et historique des rémunérations.
- Saisie des paies par période avec blocage serveur des périodes chevauchantes (pour les nouvelles paies).

## Configuration nécessaire

1. Configurer les variables GitHub Actions `VITE_SUPABASE_URL` et `VITE_SUPABASE_ANON_KEY` avec **uniquement** l'URL et la clé publique du projet Ranch `lizjrqnkmpjrxtwjxszt`.
2. Activer Discord OAuth dans Supabase et autoriser `https://cgasmj-blip.github.io/LuckyJimsRanchPanel/` comme Redirect URL. Callback fournisseur : `https://lizjrqnkmpjrxtwjxszt.supabase.co/auth/v1/callback`.
3. Configurer les Edge Functions Ranch de contrôle des grades et de synchronisation ExpressSantos. Pour lire le salon Discord, fournir le secret **`RANCH_DISCORD_BOT_TOKEN` dans les secrets Supabase Ranch**, jamais dans le dépôt ou le navigateur.
4. Définir les adhésions Ranch et tester les politiques RLS avec les rôles réels.

La synchronisation Discord est **manuelle depuis le panel** tant qu'aucune tâche planifiée côté serveur n'est configurée. Le simple bouton ne remplace pas le secret Discord.

## Import historique

Les articles et une partie des commandes/récoltes ont été repris de l'ancien Google Sheets. Les **quatre fiches employés renseignées** dans la feuille source ont été importées (nom RP, grade, statut et identifiant historique uniquement). Les champs d'identification et mots de passe de l'ancien fichier **n'ont pas été importés**.

Les anciennes paies et certaines lignes de commandes/récoltes restent à reprendre ou à rapprocher. Les anciennes paies sans dates de période ne bénéficient pas du blocage automatique des chevauchements.

## Développement

```sh
npm install
npm run dev
npm run build
```

Créer un `.env` local depuis `.env.example` avec la clé **publique** Supabase Ranch uniquement. Ne jamais committer `.env`, `service_role`, mots de passe, webhooks ou tokens Discord.

## État de livraison

**Travaux non encore validés de bout en bout** : import historique restant, automatisation ExpressSantos, tests de sécurité par grade, opérations de stocks/paies et vérification de la publication GitHub Pages. Les fonctionnalités ci-dessus sont implémentées, pas toutes certifiées en conditions réelles.
