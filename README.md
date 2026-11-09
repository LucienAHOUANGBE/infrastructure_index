# Infrastructure Index

Indice composite de qualité des infrastructures par pays et par année (2006–2021), construit à partir des données WDI, WEF et World Bank LPI. Version 1.0.0.

## Contenu de l'indice

Deux variantes sont produites (fichier `Output_Data/InfrastructureIndex.csv`) :

| Variable | Composantes |
|---|---|
| `infra_type1` | Qualité des infrastructures (LPI), qualité des routes (WEF), connectivité du transport maritime de ligne, passagers du transport aérien |
| `infra_type2` | Composantes de `infra_type1` + abonnements téléphonie mobile, utilisateurs d'internet, accès à l'électricité, accès à l'eau |

Clés : `ccode` (code pays), `year`.

## Méthode (résumé)

1. Import et fusion des sources (voir `Input_Data/`), panel pays × année.
2. Restriction à la période 2006–2021. Les variables avec trop de valeurs manquantes (rail, indicateur aérien WEF, lignes téléphoniques fixes, `water2`) sont écartées.
3. Imputation :
   - trou d'une année : moyenne des années voisines ;
   - `lpi_infra` 2019–2021 et `container_port` 2006–2007 : extrapolation au taux de croissance annuel moyen.
4. Standardisation de chaque composante (`egen std()`, sur l'ensemble du panel).
5. Indice = moyenne simple des composantes standardisées (`egen rowmean()`).

Description détaillée : `docs/Methode.md`.

## Reproduire

Prérequis : Stata 17 ou supérieur (aucun package externe).

```stata
cd "chemin/vers/infrastructure-index"
do Scripts/01_infrastructure_index.do
```

Le script doit être lancé depuis la racine du dépôt. Il écrit dans `Output_Data/` :

- `InfrastructureData.dta` : données brutes fusionnées ;
- `InfrastructureDataClean.dta` : données nettoyées, imputées, standardisées, avec les indices (inclut les agrégats WDI) ;
- `InfrastructureIndex.csv` : indices finaux (`ccode`, `year`, `infra_type1`, `infra_type2`), pays uniquement (agrégats WDI retirés à l'export).

## Données sources

| Fichier(s) | Source |
|---|---|
| `WDI_Infrastructure.xlsx` | World Bank, World Development Indicators |
| `WB_LPI_WIDEF.csv` | World Bank, Logistics Performance Index |
| `WEF_*.csv` | World Economic Forum (Global Competitiveness Index, Travel & Tourism Development Index), via Data360 |

Fichiers publiés dans `Input_Data/` : WDI et LPI (Banque mondiale, CC BY 4.0). Les données du World Economic Forum ne sont pas redistribuées ; elles restent soumises aux conditions du WEF (https://www.weforum.org/about/terms-of-use). Télécharge-les depuis les sources listées dans `Input_Data/README.md`.

Citation requise pour les données WEF : World Economic Forum (2018). *Global Competitiveness Report 2018*. https://reports.weforum.org/global-competitiveness-report-2018/

Liens de téléchargement et dates des fichiers : voir `Input_Data/README.md`. Toutes les sources ont été téléchargées depuis la plateforme [Data360 de la Banque mondiale](https://data360.worldbank.org/).

## Articles utilisant cet indice

- Ahouangbe, V. L., Kruse, H. W., Núñez, T., Turcu, C. *Paving the Way for Extraction: Development Aid Secures Natural Resources*. Comparative Economic Studies (à paraître).

## Citation

Ahouangbe, V. L. (2026). *Infrastructure Index* (v1.0.0). https://github.com/LucienAHOUANGBE/infrastructure_index. Voir aussi `CITATION.cff`.

## Licence

- Code (`Scripts/`) : licence MIT (voir `LICENSE`).
- Index publié (`Output_Data/`) : CC BY-NC 4.0 (voir `LICENSE-DATA`).
- Les données sources restent soumises aux conditions de leurs fournisseurs (Banque mondiale, UNCTAD, WEF).

## Auteur

Vignawou Lucien Ahouangbe (CRESE ; ETC)
