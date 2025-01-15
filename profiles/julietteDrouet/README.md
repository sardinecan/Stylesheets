# Juliette Drouet - TEI Stylesheets profile Word2tei

Profile personnalisé pour la transformation word2tei des transcriptions des lettres de Juliette Drouet.

## Prérequis
- cloner le repo [Stylesheets](https://github.com/TEIC/Stylesheets) du consortium TEI.

## Installation
- changer de dossier courant pour `chemin/vers/Stylesheets/profiles`
- cloner le repo `word2tei` avec la commande :
```
❯ git clone https://gitlab.huma-num.fr/ceen/juliette-drouet/word2tei.git julietteDrouet
```
- remonter d'un niveau pour installer les Stylesheets :
```
❯ cd ..
❯ make install
```

## Utiliser le profile
```
❯ docxtotei --profile=julietteDrouet transcriptions/1866_01rev.docx tei/1861.tei.xml
```
