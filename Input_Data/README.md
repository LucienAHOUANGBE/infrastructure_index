# Input_Data

Données sources lues par `Scripts/01_infrastructure_index.do`. Les fichiers marqués « non » dans la colonne *Publié ?* ne sont pas dans le dépôt : télécharge-les depuis la plateforme Data360 de la Banque mondiale (liens ci-dessous) et place-les dans ce dossier, avec exactement les noms indiqués.

La date indiquée est celle du fichier utilisé pour la version 1.0.0.

| Fichier | Contenu | Source (Data360) | Date du fichier | Publié ? |
|---|---|---|---|---|
| `WDI_Infrastructure.xlsx` | World Development Indicators : une feuille par indicateur (voir tableau suivant) | [WB_WDI](https://data360.worldbank.org/en/dataset/WB_WDI) | 25/05/2026 | oui |
| `WB_LPI_WIDEF.csv` | Logistics Performance Index (composantes) | [WB_LPI](https://data360.worldbank.org/en/dataset/WB_LPI) | 12/05/2026 | oui |
| `WEF_GCIHH_EOSQ057_WIDEF_Road1.csv` | Qualité des routes (1–7), 2007–2017 | [WEF_GCIHH_EOSQ057](https://data360.worldbank.org/en/indicator/WEF_GCIHH_EOSQ057) | 20/05/2026 | non |
| `WEF_GCIHH_EOSQ057_WIDEF_Road2.csv` | Qualité des routes (1–7), 2017–2019 | [WEF_GCI_EOSQ057](https://data360.worldbank.org/en/indicator/WEF_GCI_EOSQ057) | 20/05/2026 | non |
| `WEF_TTDI_EOSQ057_WIDEF_Road3.csv` | Qualité des routes (1–7), 2019–2024 | [WEF_TTDI_EOSQ057](https://data360.worldbank.org/en/indicator/WEF_TTDI_EOSQ057) | 20/05/2026 | non |
| `WEF_GCIHH_EOSQ061_WIDEF_Air1.csv` | Qualité des infrastructures aériennes (importé, non retenu dans l'indice) | [WEF_GCIHH_EOSQ061](https://data360.worldbank.org/en/indicator/WEF_GCIHH_EOSQ061) | 20/05/2026 | non |
| `WEF_TTDI_TTDI_C_09_WIDEF_Air2.csv` | Infrastructures de transport aérien (importé, non retenu dans l'indice) | [WEF_TTDI_TTDI_C_09](https://data360.worldbank.org/en/indicator/WEF_TTDI_TTDI_C_09) | 20/05/2026 | non |
| `WEF_TTDI_EOSQ486_WIDEF_Air3.csv` | Efficacité du transport aérien (importé, non retenu dans l'indice) | [WEF_TTDI_EOSQ486](https://data360.worldbank.org/en/indicator/WEF_TTDI_EOSQ486) | 20/05/2026 | non |
| `WEF_GCIHH_EOSQRAILROAD_WIDEF_rail_road_2009-2017.csv` | Qualité des infrastructures ferroviaires, 2009–2017 (importé, non retenu dans l'indice) | [WEF_GCIHH_EOSQRAILROAD](https://data360.worldbank.org/en/indicator/WEF_GCIHH_EOSQRAILROAD) | 25/05/2026 | non |
| `WEF_GCI_RAILINF_WIDEF_rail_road_2017-2019.csv` | Qualité des infrastructures ferroviaires, 2017–2019 (importé, non retenu dans l'indice) | [WEF_GCI_RAILINF](https://data360.worldbank.org/en/indicator/WEF_GCI_RAILINF) | 25/05/2026 | non |

Les données du World Economic Forum ne sont pas redistribuées dans ce dépôt. Elles restent soumises aux conditions du WEF (https://www.weforum.org/about/terms-of-use). Télécharge-les depuis les sources indiquées ci-dessus.

## Feuilles de `WDI_Infrastructure.xlsx` utilisées dans l'indice

| Feuille | Indicateur WDI |
|---|---|
| `elec` | [Access to electricity (% of population)](https://data360.worldbank.org/en/indicator/WB_WDI_EG_ELC_ACCS_ZS) |
| `mobile_phone` | [Mobile cellular subscriptions (per 100 people)](https://data360.worldbank.org/en/indicator/WB_WDI_IT_CEL_SETS_P2) |
| `internet_user` | [Individuals using the Internet (% of population)](https://data360.worldbank.org/en/indicator/WB_WDI_IT_NET_USER_ZS) |
| `water1` | [People using at least basic drinking water services (% of population)](https://data360.worldbank.org/en/indicator/WB_WDI_SH_H2O_BASW_ZS) |
| `air_transport_passengers` | [Air transport, passengers carried](https://data360.worldbank.org/en/indicator/WB_WDI_IS_AIR_PSGR) |
| `liner_shipping_connexion` | [Liner shipping connectivity index (maximum value in 2004 = 100)](https://data360.worldbank.org/en/indicator/WB_WDI_IS_SHP_GCNW_XQ) |

Le classeur est un export WDI (une feuille par indicateur). Il contient 49 agrégats (régions, groupes de revenu) en plus des pays : voir `docs/Methode.md`, section 5.

Les autres feuilles (`container_port`, `air_transport`, `air_transport_freigth`, `railways_*`, `rail_lines*`, `fixed_phone`, `water2`, `mobile`) sont importées mais n'entrent pas dans l'indice (voir `docs/Methode.md`, section 3).

Remarque : le script importe aussi les séries WEF « air » et « rail », mais les supprime avant le calcul de l'indice. Elles doivent néanmoins être présentes pour que le script s'exécute.
