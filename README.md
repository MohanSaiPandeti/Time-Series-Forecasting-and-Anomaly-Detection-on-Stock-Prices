# Time-Series-Forecasting-and-Anomaly-Detection-on-Stock-Prices
This project performs an end-to-end time series analysis of BlackRock (BLK) stock data, sourced from Yahoo Finance. The analysis covers the period from January 1, 2015, to the present i.e (October 21, 2025).


# 📈 BlackRock (BLK) Stock Market Analysis & Forecasting

<div align="center">
  
![BlackRock](assets/blackrock_building.jpg)

*Comprehensive time series analysis and predictive modeling of BlackRock Inc. stock performance*

[![R](https://img.shields.io/badge/R-4.4.0-blue.svg)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Data Source](https://img.shields.io/badge/data-Yahoo%20Finance-red.svg)](https://finance.yahoo.com/)

</div>

---

## 🎯 Project Overview

This project presents an end-to-end quantitative analysis of **BlackRock Inc. (NYSE: BLK)**, the world's largest asset management company. Using advanced statistical methods and time series forecasting techniques, we explore historical stock performance from 2015 to present, uncover market anomalies, and build predictive models for future price movements.

### Why BlackRock?

BlackRock manages over $10 trillion in assets and is a bellwether for the global financial services sector. Understanding its stock behavior provides valuable insights into broader market dynamics and institutional investment trends.

---

## 🚀 Key Features

- **📊 Exploratory Data Analysis (EDA)**: Comprehensive visualization of price trends, trading volumes, and moving averages
- **🔄 Feature Engineering**: Advanced transformation techniques including log returns and percentage change calculations
- **🎯 Anomaly Detection**: Statistical identification of abnormal trading days using time series decomposition
- **🔮 ARIMA Forecasting**: Predictive modeling with 252-day (1 trading year) price projections
- **📉 Volatility Analysis**: Deep dive into daily return distributions and market risk metrics

---

## 📂 Project Structure

```
blackrock-stock-analysis/
│
├── data/
│   ├── BLK_data_clean.csv           # Cleaned historical stock data
│   └── BLK_data_transformed.csv     # Feature-engineered dataset
│
├── assets/
│   ├── blackrock_building.jpg       # Company image
│   ├── price_trend.png              # Adjusted close price visualization
│   ├── trading_volume.png           # Volume analysis
│   ├── moving_averages.png          # MA50 & MA200 comparison
│   ├── daily_returns.png            # Daily log returns
│   ├── returns_distribution.png     # Return distribution histogram
│   ├── anomaly_detection.png        # Detected market anomalies
│   ├── arima_residuals.png          # Model diagnostic plots
│   └── price_forecast.png           # 252-day forecast
│
├── DA_Proj.R                        # Main analysis script
├── README.md                        # Project documentation
└── LICENSE                          # MIT License

```

---

## 🛠️ Technology Stack

| Category | Tools |
|----------|-------|
| **Language** | R (v4.4.0+) |
| **Data Acquisition** | `quantmod` |
| **Data Manipulation** | `tidyverse` (dplyr, ggplot2) |
| **Time Series** | `timetk`, `forecast`, `tseries` |
| **Anomaly Detection** | `anomalize` |
| **Visualization** | `ggplot2`, `plotly` |

---

## 📊 Dataset Details

### Source
- **Provider**: Yahoo Finance
- **Ticker Symbol**: BLK
- **Date Range**: January 1, 2015 → Present
- **Frequency**: Daily trading data
- **Total Records**: ~2,500+ trading days

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

---

## 📈 Key Insights & Visualizations

### 1. Historical Price Trajectory (2015-Present)

![Price Trend](assets/price_trend.png)

**Key Observations:**
- BlackRock's stock has demonstrated remarkable growth, appreciating from ~$250 to over $1,200 (380% increase)
- Notable volatility during the 2020 COVID-19 pandemic with a sharp recovery
- Strong upward momentum post-2022, reaching all-time highs in 2025

---

### 2. Trading Volume Analysis

![Trading Volume](assets/trading_volume.png)

**Insights:**
- Extreme volume spike in March 2020 (>6M shares) correlating with pandemic market panic
- Average daily volume: ~450,000 shares
- Volume spikes often precede significant price movements

---

### 3. Moving Average Crossover Strategy

![Moving Averages](assets/moving_averages.png)

**Technical Analysis:**
- **50-day MA (Blue)**: Short-term trend indicator
- **200-day MA (Green)**: Long-term trend indicator
- **Golden Cross** patterns visible in 2020 and 2024 (bullish signals)
- Price consistently trading above both MAs since late 2023 indicates strong bullish momentum

---

### 4. Daily Volatility Profile

![Daily Returns](assets/daily_returns.png)

**Risk Metrics:**
- Extreme outliers: March 2020 shows -15% single-day drop and +13% rebound
- Most returns cluster between -2% to +2% (normal market conditions)
- Increased volatility periods align with macroeconomic uncertainty

---

### 5. Return Distribution Analysis

![Returns Distribution](assets/returns_distribution.png)

**Statistical Properties:**
- Distribution approximates normal (bell curve) with slight negative skew
- Fat tails indicate higher probability of extreme events than normal distribution predicts
- Mean daily return: ~0.05% (translates to ~13% annualized)

---

### 6. Anomaly Detection Results

![Anomalies](assets/anomaly_detection.png)

**Methodology:**
- Used GESD (Generalized Extreme Studentized Deviate) test at 95% confidence
- Detected **41 anomalous trading days** over 10-year period

**Notable Anomalies:**
- **March 2020**: COVID-19 market crash (15 anomalies detected)
- **2020-Q2**: Pandemic recovery volatility
- **2022**: Federal Reserve rate hike concerns
- **2025**: Recent market corrections

*Full anomaly list available in console output (see `anomalous_days` variable)*

---

### 7. ARIMA Model Performance

![ARIMA Residuals](assets/arima_residuals.png)

**Model Specification:**
- **Best Model**: ARIMA(0,1,0) with drift
- **AIC**: 19999.77 (lower is better)
- **Drift Coefficient**: 0.3269 (statistically significant)

**Model Validation:**
- **Ljung-Box Test**: p-value = 2.734e-06 → Residuals show some autocorrelation
- **Residuals Distribution**: Approximately normal with fat tails
- **ACF Plot**: Most lags within confidence bounds indicating decent fit

**Interpretation:**
The ARIMA(0,1,0) with drift is essentially a random walk with positive drift, suggesting that:
1. Stock follows a stochastic trend (random walk hypothesis)
2. Positive drift indicates long-term upward bias (~$0.33/day)
3. Past prices don't strongly predict future changes (efficient market)

---

### 8. 252-Day Price Forecast

![Price Forecast](assets/price_forecast.png)

**Forecast Horizon**: Next 252 trading days (~1 year)

**Projections:**
- **Point Forecast**: ~$1,500 (representing continued growth)
- **80% Confidence Interval**: $1,100 - $1,900
- **95% Confidence Interval**: $900 - $2,100

**Investment Implications:**
- Model suggests bullish continuation with expected upside
- Wide confidence bands reflect inherent market uncertainty
- Forecast assumes current market dynamics remain stable

---

## 🔬 Methodology

### Phase 1: Data Acquisition
```r
# Download historical data from Yahoo Finance
getSymbols("BLK", src = "yahoo", from = "2015-01-01", to = Sys.Date())
```

### Phase 2: Exploratory Data Analysis
- Time series visualization
- Volume analysis
- Moving average calculation (50-day & 200-day)

### Phase 3: Feature Engineering
```r
# Calculate log returns
mutate(Daily_Return_Log = log(Adjusted / lag(Adjusted)))
```

### Phase 4: Anomaly Detection
```r
# Time series decomposition + GESD test
time_decompose() %>% anomalize(method = "gesd", alpha = 0.05)
```

### Phase 5: Forecasting
```r
# Automatic ARIMA model selection
auto.arima(blk_ts, seasonal = TRUE, stepwise = TRUE)
# 252-day forecast
forecast(arima_model, h = 252)
```

---

## 🚀 Getting Started

### Prerequisites

Install R (version 4.0.0 or higher) and the following packages:

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

### Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/blackrock-stock-analysis.git
cd blackrock-stock-analysis
```

2. Create the required directories:
```bash
mkdir -p data assets
```

3. Run the analysis:
```r
source("DA_Proj.R")
```

---

## 📖 Usage

The analysis is divided into 5 sequential phases. You can run the entire script or execute phases individually:

```r
# Run complete analysis
source("DA_Proj.R")

# Or run specific phases
# Phase 1: Data download and cleaning
# Phase 2: Exploratory data analysis
# Phase 3: Feature engineering
# Phase 4: Anomaly detection
# Phase 5: Time series forecasting
```

### Output Files
- `data/BLK_data_clean.csv`: Raw cleaned data
- `data/BLK_data_transformed.csv`: Feature-engineered dataset
- Console: Anomaly dates and ARIMA model summary

---

## 📊 Results Summary

| Metric | Value |
|--------|-------|
| **Analysis Period** | 2015-01-01 to 2025-10-22 |
| **Total Trading Days** | 2,500+ |
| **Price Appreciation** | 380% (10-year) |
| **Detected Anomalies** | 41 days |
| **Best ARIMA Model** | ARIMA(0,1,0) with drift |
| **Mean Daily Return** | 0.05% |
| **Annualized Volatility** | ~18% |
| **1-Year Forecast** | $1,500 (±$600) |

---

## 🔮 Future Enhancements

- [ ] Machine Learning models (LSTM, Random Forest)
- [ ] Sentiment analysis integration (news/Twitter)
- [ ] Multi-factor regression analysis
- [ ] Portfolio optimization with Modern Portfolio Theory
- [ ] Real-time data streaming and alerts
- [ ] Interactive Shiny dashboard
- [ ] Backtesting trading strategies

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

**This project is for educational and research purposes only.** The analysis and forecasts provided should NOT be considered as financial advice. Stock market investments carry inherent risks, and past performance does not guarantee future results. Always consult with a qualified financial advisor before making investment decisions.

---

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)
- Email: your.email@example.com

---

## 🙏 Acknowledgments

- **Yahoo Finance** for providing free historical stock data
- **R Community** for excellent open-source packages
- **BlackRock Inc.** for being a fascinating subject of analysis
- **Stack Overflow** for debugging assistance

---

## 📚 References

- Box, G. E., Jenkins, G. M., Reinsel, G. C., & Ljung, G. M. (2015). *Time series analysis: forecasting and control*. John Wiley & Sons.
- Tsay, R. S. (2010). *Analysis of financial time series*. John Wiley & Sons.
- Yahoo Finance API Documentation: https://finance.yahoo.com/

---

<div align="center">

### ⭐ If you found this project helpful, please consider giving it a star!

**Made with ❤️ and R**

</div>
