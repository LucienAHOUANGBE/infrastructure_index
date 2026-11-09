# Methodology of the Infrastructure Index (v1.0.0)

This document describes how the index in `Output_Data/InfrastructureIndex.csv` is built by `Scripts/01_infrastructure_index.do`.

## 1. Overview

Following Donaubauer, Meyer and Nunnenkamp (2016), we construct a composite infrastructure index covering several dimensions of transport and utility infrastructure. Our index extends theirs in two directions:

- **temporal coverage**: country-year panel for 2006–2021;
- **breadth**: digital and utility infrastructure are included alongside the traditional transport components.

Two variants are produced (Section 6).

## 2. Variables and sources

| Code name | Indicator | Source | Dimension |
|---|---|---|---|
| `lpi_infra` | Logistics Performance Index, infrastructure component (1–5) | World Bank, LPI | Transport |
| `road` | Quality of road infrastructure (1–7, best) | World Economic Forum, Executive Opinion Survey (GCI and TTDI editions) | Transport |
| `liner_shipping_connexion` | Liner Shipping Connectivity Index (LSCI) | UNCTAD, retrieved via the World Bank | Transport |
| `air_transport_passengers` | Air transport, passengers carried | WDI | Transport |
| `mobile_phone` | Mobile cellular subscriptions (per 100 inhabitants) | WDI | Digital |
| `internet_user` | Individuals using the Internet (% of population) | WDI | Digital |
| `elec` | Access to electricity (% of population) | WDI | Utility |
| `water1` | Access to at least basic water services (% of population) | WDI | Utility |

- The LPI infrastructure component reflects the quality of trade- and transport-related infrastructure as assessed by logistics professionals.
- The LSCI captures a country's degree of integration into global maritime shipping networks.
- The road-quality series combines several WEF waves (GCI executive opinion survey and TTDI), all on the same 1–7 scale.

## 3. Candidate variables not retained

| Variable | Reason for exclusion |
|---|---|
| Fixed-telephone subscriptions | Structural decline, which makes them a poor proxy for current communication capacity |
| Rail quality indicators (WEF) | Too many missing values across the sample |
| WEF air transport efficiency | Series frequently ends around 2017 |
| Air freight variables | High collinearity with air passengers, which is the most complete series and is retained |
| Container port traffic | Available only for coastal countries (no data for landlocked countries); a revised version of the index may address this |
| Alternative water series (`water2`) | `water1` is more complete |
| LPI components other than infrastructure (customs, international shipping, logistics quality, timeliness, tracking and tracing) | Conceptual overlap with the LPI infrastructure component; the index is restricted to physical infrastructure rather than logistics process performance |

## 4. Missing data

Two imputation steps are applied sequentially, after restricting the panel to 2006–2021.

**Step 1: interior gaps.** For each country, a missing value in year *t* is replaced by the arithmetic mean of the values in *t−1* and *t+1* when both are observed. Gaps of two or more consecutive years are not filled by this step.

**Step 2: LPI infrastructure, years after the last survey wave.** The LPI is published in survey waves (2007, 2010, 2012, 2014, 2016, 2018 and 2023; no edition was published in 2020). Within the sample period, the wave years are therefore 2007, 2010, 2012, 2014, 2016 and 2018. Consequently:

- 2011, 2013, 2015 and 2017 are filled by Step 1;
- 2019, 2020 and 2021 are projected recursively with the compound annual growth rate (CAGR) observed over the four years preceding the last available value:

  `LPI(t) = LPI(t−1) × (LPI(t−1) / LPI(t−5))^(1/4)`

  For 2020 and 2021 the formula uses the values already projected (and interpolated) for 2019 and 2020;
- 2006, 2008 and 2009 remain missing, since no adjacent pair of observations is available. For these years the index is computed over the remaining components (Section 5).

The projected LPI values for 2019–2021 lie beyond the last survey wave in the sample period. They are the most assumption-dependent part of the index.

## 5. Standardization and aggregation

Each retained variable *x* is standardized to zero mean and unit variance over the whole pooled panel (all countries, 2006–2021):

```
z = (x − mean(x)) / sd(x)         (Stata: egen std_x = std(x))
```

The index of country *i* in year *t* is the arithmetic mean of the standardized scores available for that observation:

```
I(i,t) = (1 / K(i,t)) · Σ z_k(i,t)         (Stata: egen ... = rowmean(...))
```

where *K(i,t)* is the number of non-missing components (at most 4 for `infra_type1`, at most 8 for `infra_type2`). The index has no fixed range; positive values indicate above-sample-average infrastructure.

Because missing components are skipped rather than imputed, *K(i,t)* can vary across observations. The index of an observation with few available components is less comparable with that of an observation with all components.

**Note on WDI aggregates.** The WDI export contains 49 regional and income-group aggregates (e.g. `WLD`, `EUU`, `SSF`) in addition to countries. In version 1.0.0, these aggregates are part of the panel when each variable is standardized; they are removed only afterwards, before the index is exported. The effect is small for most components (the standard deviation changes by less than 5%), but it multiplies the standard deviation of `air_transport_passengers` by about 5.3, because the world total far exceeds any single country. This reduces the weight of that component in the index. Version 1.0.0 keeps this computation unchanged. A later version is planned to standardize on countries only and to transform air passengers (log or per capita).

## 6. Variants

| Variable | Components | *K* max |
|---|---|---|
| `infra_type1` | `lpi_infra`, `road`, `liner_shipping_connexion`, `air_transport_passengers` (transport only) | 4 |
| `infra_type2` | The four transport components plus `mobile_phone`, `internet_user`, `elec`, `water1` | 8 |

`infra_type1` is a narrower, transport-only measure. `infra_type2` adds utility and digital infrastructure and is a broader measure of productive infrastructure endowment.

## 7. Choice of equal weighting

Donaubauer et al. (2016) derive their index with an Unobserved Components Model (UCM), which weights indicators according to their informational content. We use equal weights on standardized scores instead, for three reasons:

1. **Sample breadth.** Principal component analysis requires complete observations across all indicators, which means listwise deletion of any country-year with a missing value. Given the survey-wave schedule of the LPI and the uneven country coverage of WEF indicators in early years, this would shrink the sample and bias it toward better-documented, typically higher-income economies. Averaging over available components preserves these observations.
2. **Transparency and replicability.** The index is a simple average that can be recomputed from the published components without estimating weights.
3. **Common practice.** Equal weighting is a standard and transparent baseline in the composite-indicator literature (OECD/JRC, 2008).

## 8. Outputs

| File | Content |
|---|---|
| `Output_Data/InfrastructureData.dta` | Merged raw indicators (all sources, before restrictions and imputation) |
| `Output_Data/InfrastructureDataClean.dta` | Restricted, imputed and standardized data, with both indices (includes the WDI aggregates) |
| `Output_Data/InfrastructureIndex.csv` | Final index: `ccode`, `year`, `infra_type1`, `infra_type2` (countries only; WDI aggregates removed at export) |

## References

- Donaubauer, J., Meyer, B. E., & Nunnenkamp, P. (2016). A new global index of infrastructure: construction, rankings and applications. *The World Economy*, 39(2), 236–259. https://doi.org/10.1111/twec.12290
- OECD/European Commission Joint Research Centre (2008). *Handbook on Constructing Composite Indicators: Methodology and User Guide*. Paris: OECD Publishing. https://doi.org/10.1787/9789264043466-en
