# Lucky Jim's Ranch Panel 🤠🌾

Panel web indépendant du relais Discord et du projet LSPD/EMS.

## Fonctionnalités (version initiale)
- Connexion via Supabase Auth et adhésion Ranch active.
- Tableau de bord western Texas.
- Catalogue d'articles et déclaration de récoltes avec primes calculées en base.
- Livraisons sans commande, avec prime configurée en base.
- Consultation des historiques de récoltes, livraisons et paies.
- Ajout d'articles et consultation des employés pour les responsables.

## Démarrage
1. Installer Node.js 20+ puis lancer `npm install`.
2. Copier `.env.example` en `.env`, y renseigner **uniquement** l'URL et la clé publique (publishable/anon) du projet Supabase **Panel Ranch**.
3. Vérifier le schéma et les politiques RLS de votre base. Examiner `supabase/migration.sql` **avant** de l'exécuter. Ne pas appliquer sans revue : la migration ne configure pas toutes les politiques RLS nécessaires.
4. Créer les utilisateurs dans Supabase Auth, leurs profils employés et leurs adhésions Ranch.
5. Lancer `npm run dev`, puis `npm run build`.

## Sécurité
- Ne jamais publier la clé `service_role`, des mots de passe, des webhooks ou un fichier `.env`.
- L'ancien fichier Google Sheets contient des mots de passe en clair : **ne pas les importer** ; créer de nouveaux accès via Supabase Auth.
- Un dépôt public n'ouvre pas l'accès aux données Supabase : les règles RLS doivent être correctes.

## État réel
**Version de démarrage, non prête à déployer en production.** À terminer : politiques RLS, vérification du schéma existant, gestion avancée des articles et des tarifs, validation de livraisons, paies complètes, stocks, recettes et transformations, gestion des comptes, import des articles et tests. Le projet ne gère pas les commandes.


## Publication
Le site est publié par GitHub Actions vers GitHub Pages. Configurer les variables Actions `VITE_SUPABASE_URL` et `VITE_SUPABASE_ANON_KEY`, puis lancer le workflow `Deploy Lucky Jim's Ranch to GitHub Pages`.

## Connexion Discord OAuth
Dans Supabase **Panel Ranch** → Authentication → Providers → Discord, activer Discord et renseigner le **Client ID** et le **Client Secret** de l'application Discord (ne jamais les mettre sur GitHub). Dans Discord Developer Portal → OAuth2, enregistrer comme Redirect URI **l'URL de callback Supabase affichée dans le fournisseur Discord**, généralement `https://lizjrqnkmpjrxtwjxszt.supabase.co/auth/v1/callback`. Dans Supabase → Authentication → URL Configuration, ajouter `https://cgasmj-blip.github.io/LuckyJimsRanchPanel/` aux Redirect URLs autorisées. Vérifier que `ranch_memberships` et les comptes employés sont associés aux utilisateurs Supabase créés par OAuth. Le simple fait de se connecter avec Discord ne donne pas de droits d'administration et ne vérifie pas automatiquement l'appartenance à un serveur Discord.
