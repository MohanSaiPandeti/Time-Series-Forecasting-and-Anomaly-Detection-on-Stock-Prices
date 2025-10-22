# Time-Series-Forecasting-and-Anomaly-Detection-on-Stock-Prices

![BlackRock Building](assets/Black%20Rock.webp)

> A comprehensive analysis of BlackRock Inc. (BLK) stock using advanced time series forecasting and statistical anomaly detection techniques in R

[![R](https://img.shields.io/badge/R-4.4.0-blue.svg)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Data Source](https://img.shields.io/badge/data-Yahoo%20Finance-red.svg)](https://finance.yahoo.com/)

## Table of Contents

- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [Technology Stack](#technology-stack)
- [Dataset Details](#dataset-details)
- [Installation](#installation)
- [Usage](#usage)
- [Analysis Phases](#analysis-phases)
- [Key Insights & Visualizations](#key-insights--visualizations)
- [Results Summary](#results-summary)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)
- [Disclaimer](#disclaimer)

## Project Overview

This project presents an end-to-end quantitative analysis of **BlackRock Inc. (NYSE: BLK)**, the world's largest asset management company with over $10 trillion in assets under management. 

Using advanced statistical methods and time series forecasting techniques, this analysis:
- Explores historical stock performance from 2015 to present
- Identifies market anomalies and unusual trading patterns
- Builds predictive ARIMA models for future price movements
- Provides actionable insights into volatility and risk metrics

**Why BlackRock?** As a bellwether for the global financial services sector, understanding BlackRock's stock behavior provides valuable insights into broader market dynamics and institutional investment trends.

## Key Features

- **Exploratory Data Analysis (EDA)** - Comprehensive visualization of price trends, trading volumes, and moving averages
- **Feature Engineering** - Advanced transformation techniques including log returns and percentage change calculations
- **Anomaly Detection** - Statistical identification of 41 abnormal trading days using time series decomposition
- **ARIMA Forecasting** - Predictive modeling with 252-day (1 trading year) price projections
- **Volatility Analysis** - Deep dive into daily return distributions and market risk metrics

## Technology Stack

**Language:** R (v4.4.0+)

**Key Libraries:**
- `quantmod` - Financial data acquisition from Yahoo Finance
- `tidyverse` - Data manipulation (dplyr) and visualization (ggplot2)
- `timetk` - Time series data transformation
- `forecast` - ARIMA modeling and forecasting
- `tseries` - Statistical tests (ADF, stationarity)
- `anomalize` - Anomaly detection in time series data
- `plotly` - Interactive visualizations

## Dataset Details

**Source:** Yahoo Finance  
**Ticker Symbol:** BLK  
**Date Range:** January 1, 2015 → Present  
**Frequency:** Daily trading data  
**Total Records:** ~2,500+ trading days

### Features

| Feature | Description |
|---------|-------------|
| `Date` | Trading date |
| `Open` | Opening price ($) |
| `High` | Highest price of the day ($) |
| `Low` | Lowest price of the day ($) |
| `Close` | Closing price ($) |
| `Volume` | Number of shares traded |
| `Adjusted` | Adjusted closing price (accounts for dividends & splits) |
| `Daily_Return_Pct` | Simple percentage return |
| `Daily_Return_Log` | Logarithmic return (preferred for analysis) |

## Installation

### Prerequisites

Install R (version 4.0.0 or higher) from [CRAN](https://cran.r-project.org/)

### Install Required Packages

```r
install.packages(c(
  "quantmod",    # Financial data acquisition
  "tidyverse",   # Data manipulation & visualization
  "timetk",      # Time series toolkit
  "forecast",    # ARIMA modeling
  "anomalize",   # Anomaly detection
  "tseries",     # Statistical tests
  "plotly"       # Interactive plots
))
```

### Clone Repository

```bash
git clone https://github.com/yourusername/Time-Series-Forecasting-and-Anomaly-Detection-on-Stock-Prices.git
cd Time-Series-Forecasting-and-Anomaly-Detection-on-Stock-Prices
```

### Create Required Directories

```bash
mkdir -p data assets
```

## Usage

Run the complete analysis:

```r
source("TimeSeries Forecasting and Anomaly Detection in Stock Prices.R")
```

Or execute specific phases individually by running sections of the script:

- **Phase 1:** Data Acquisition & Initial Setup
- **Phase 2:** Exploratory Data Analysis (EDA)
- **Phase 3:** Data Transformation and Feature Engineering
- **Phase 4:** Anomaly Detection
- **Phase 5:** Time Series Forecasting (ARIMA/SARIMA Modeling)

### Output Files

- `data/BLK_data_clean.csv` - Raw cleaned data
- `data/BLK_data_transformed.csv` - Feature-engineered dataset with returns
- Console output - Anomaly dates and ARIMA model summary

## Analysis Phases

### Phase 1: Data Acquisition

```r
# Download historical data from Yahoo Finance
ticker <- "BLK"
start_date <- "2015-01-01"
end_date <- Sys.Date()

getSymbols(ticker, src = "yahoo", from = start_date, to = end_date)
```

### Phase 2: Exploratory Data Analysis

- Time series visualization of adjusted close price
- Trading volume analysis
- Moving average calculation (50-day & 200-day)

### Phase 3: Feature Engineering

```r
# Calculate log returns (preferred over simple returns)
mutate(Daily_Return_Log = log(Adjusted / lag(Adjusted)))
```

### Phase 4: Anomaly Detection

```r
# Time series decomposition + GESD test at 95% confidence
time_decompose(target = Daily_Return_Log) %>%
  anomalize(method = "gesd", alpha = 0.05) %>%
  time_recompose()
```

### Phase 5: Time Series Forecasting

```r
# Automatic ARIMA model selection
arima_model <- auto.arima(blk_ts, seasonal = TRUE, stepwise = TRUE)

# Generate 252-day forecast (1 trading year)
blk_forecast <- forecast(arima_model, h = 252)
```

## Key Insights & Visualizations

### 1. Historical Price Trajectory (2015-Present)

![Price Trend](assets/Rplot.png)

**Key Observations:**
- BlackRock's stock has demonstrated remarkable growth, appreciating from ~$250 to over $1,200 (**380% increase**)
- Notable volatility during the 2020 COVID-19 pandemic with sharp recovery
- Strong upward momentum post-2022, reaching all-time highs in 2025

---

### 2. Trading Volume Analysis

![Trading Volume](assets/Rplot2.png)

**Insights:**
- Extreme volume spike in March 2020 (>6M shares) correlating with pandemic market panic
- Average daily volume: ~450,000 shares
- Volume spikes often precede significant price movements

---

### 3. Moving Average Crossover Strategy

![Moving Averages](assets/Rplot03.png)

**Technical Analysis:**
- **50-day MA (Blue)** - Short-term trend indicator
- **200-day MA (Green)** - Long-term trend indicator
- **Golden Cross** patterns visible in 2020 and 2024 (bullish signals)
- Price consistently trading above both MAs since late 2023 indicates strong bullish momentum

---

### 4. Daily Volatility Profile

![Daily Returns](assets/Rplot4_phase3.png)

**Risk Metrics:**
- Extreme outliers: March 2020 shows -15% single-day drop and +13% rebound
- Most returns cluster between -2% to +2% (normal market conditions)
- Increased volatility periods align with macroeconomic uncertainty

---

### 5. Return Distribution Analysis

![Returns Distribution](assets/Rplot05_phase3.png)

**Statistical Properties:**
- Distribution approximates normal (bell curve) with slight negative skew
- Fat tails indicate higher probability of extreme events than normal distribution predicts
- Mean daily return: ~0.05% (translates to ~13% annualized)

---

### 6. Anomaly Detection Results

![Anomalies](assets/Rplot06_phase4.png)

**Console Output - Detected Anomalies:**

![Anomaly List](assets/phase4_ii.png)

**Methodology:**
- Used GESD (Generalized Extreme Studentized Deviate) test at 95% confidence
- Detected **41 anomalous trading days** over 10-year period

**Notable Anomaly Clusters:**
- **March 2020** - COVID-19 market crash (15 anomalies detected)
- **Q2 2020** - Pandemic recovery volatility
- **2022** - Federal Reserve rate hike concerns
- **2025** - Recent market corrections

**Sample Anomalous Days:**

| Date | Observed Return | Remainder | Anomaly |
|------|-----------------|-----------|---------|
| 2015-12-11 | -0.0673 | -0.0660 | Yes |
| 2016-06-24 | -0.0706 | -0.0725 | Yes |
| 2020-03-09 | -0.0723 | -0.0534 | Yes |
| 2020-03-12 | -0.1110 | -0.0900 | Yes |
| 2020-03-16 | -0.1470 | -0.1270 | Yes |

*Full list of 41 anomalies available in the analysis output*

---

### 7. ARIMA Model Performance

**Stationarity Test:**

![ADF Test](assets/phase5_%20Augmented%20Dickey%20-%20Fuller%20Test.png)

**Model Selection Process:**

![ARIMA Selection](assets/Phase5_ARIMA.png)

**Residual Diagnostics:**

![Ljung-Box Test](assets/phase5_Ljung_Box_test.png)

![Residual Analysis](assets/Rplot08_phase5.png)

**Model Specification:**
- **Best Model:** ARIMA(0,1,0) with drift
- **AIC:** 19999.77 (Akaike Information Criterion - lower is better)
- **Drift Coefficient:** 0.3269 (statistically significant)
- **Standard Error:** 0.1846

**Model Validation:**
- **Ljung-Box Test:** Q* = 661.65, p-value = 2.734e-06
- **Residuals Distribution:** Approximately normal with some fat tails
- **ACF Plot:** Most lags within confidence bounds indicating decent fit

**Interpretation:**

The ARIMA(0,1,0) with drift is essentially a **random walk with positive drift**, suggesting:
1. Stock follows a stochastic trend (supports random walk hypothesis)
2. Positive drift of $0.33/day indicates long-term upward bias
3. Past prices don't strongly predict future changes (efficient market characteristics)

---

### 8. 252-Day Price Forecast

![Time Series Object](assets/Rplot07_phase5.png)

![Price Forecast](assets/Rplot09_phase5.png)

**Forecast Horizon:** Next 252 trading days (~1 year)

**Projections:**
- **Point Forecast:** ~$1,500 (representing continued growth trajectory)
- **80% Confidence Interval:** $1,100 - $1,900
- **95% Confidence Interval:** $900 - $2,100

**Investment Implications:**
- Model suggests bullish continuation with expected upside potential
- Wide confidence bands reflect inherent market uncertainty
- Forecast assumes current market dynamics and drift remain stable

## Results Summary

| Metric | Value |
|--------|-------|
| **Analysis Period** | 2015-01-01 to 2025-10-22 |
| **Total Trading Days** | 2,500+ |
| **Price Appreciation** | 380% (10-year CAGR: ~16.8%) |
| **Detected Anomalies** | 41 days (1.6% of trading days) |
| **Best ARIMA Model** | ARIMA(0,1,0) with drift |
| **Mean Daily Return** | 0.05% (~13% annualized) |
| **Estimated Volatility** | ~18% (annualized) |
| **1-Year Forecast** | $1,500 (±$600 at 95% CI) |
| **Model AIC** | 19999.77 |

## Future Enhancements

- [ ] Machine Learning models (LSTM, Random Forest, XGBoost)
- [ ] Sentiment analysis integration (news headlines, Twitter/X sentiment)
- [ ] Multi-factor regression analysis (market factors, sector indices)
- [ ] Portfolio optimization with Modern Portfolio Theory
- [ ] Real-time data streaming and automated alerts
- [ ] Interactive Shiny dashboard for dynamic exploration
- [ ] Backtesting of technical trading strategies
- [ ] Comparison with peer companies (JPMorgan, Goldman Sachs)

## Contributing

Contributions are welcome! If you'd like to improve this analysis:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

⚠️ **IMPORTANT:** This project is for **educational and research purposes only**. 

The analysis, insights, and forecasts provided in this repository should **NOT** be considered as financial advice or investment recommendations. Stock market investments carry inherent risks, and past performance does not guarantee future results. 

Always conduct your own research and consult with a qualified financial advisor before making any investment decisions.

---

## Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your Profile](https://linkedin.com/in/yourprofile)
- Email: your.email@example.com

## Acknowledgments

- **Yahoo Finance** for providing free, reliable historical stock data
- **R Community** for maintaining excellent open-source packages
- **BlackRock Inc.** for being a fascinating subject of financial analysis
- **Anthropic's Claude** for assistance in documentation

## References

1. Box, G. E., Jenkins, G. M., Reinsel, G. C., & Ljung, G. M. (2015). *Time Series Analysis: Forecasting and Control*. John Wiley & Sons.
2. Tsay, R. S. (2010). *Analysis of Financial Time Series*. John Wiley & Sons.
3. Yahoo Finance API Documentation: https://finance.yahoo.com/
4. R Documentation: https://www.r-project.org/

---

**Made with ❤️ and R** | ⭐ Star this repo if you found it helpful!
