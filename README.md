# Superstore Customer Lifetime Models: A Strategic Analysis for Revenue Optimization

## Project Metadata

* **Tools Used**: Python (Pandas, NumPy, PySpark, Lifetimes, PyMC, Arviz, Seaborn, Matplotlib), Apache Spark, Jupyter Notebook
  
* **Project Type**: Data Cleaning, Predictive Modeling, Customer Lifetime Value (CLV) Analysis, Strategic Business Analytics
  
* **Repository**: \https://github.com/inhamo/Predictive-Marketing
  
* **Stakeholders**: Superstore Marketing Leadership, CRM Team, Business Intelligence & Analytics Division, Chief Revenue Officer

---

## Table of Contents

1. [Project Background](#project-background)
2. [Executive Summary](#executive-summary)
3. [Insights Deep Dive](#insights-deep-dive)

   * [Customer Segmentation by Purchase Behavior](#customer-segmentation-by-purchase-behavior)
   * [Purchase Frequency Patterns](#purchase-frequency-patterns)
   * [Monetary Value Distribution](#monetary-value-distribution)
   * [Churn Probability and Retention Opportunities](#churn-probability-and-retention-opportunities)
4. [Recommendations](#recommendations)
5. [Clarifying Questions and Assumptions](#clarifying-questions-and-assumptions)

---

## Project Background

This project centers on enhancing the long-term revenue potential of Superstore, a retail enterprise offering **furniture, technology products, and office supplies**. Using advanced customer lifetime value (CLV) modeling techniques—specifically Pareto-NBD for purchase frequency and churn estimation, and Gamma-Gamma for monetary value estimation—this analysis delivers predictive insights into customer behavior and strategic levers for engagement.

The dataset, `customer_features.csv`, consists of anonymized transactional features including purchase dates, order counts, and average order values. Data was processed using Apache Spark for scalability and Python for in-depth statistical modeling.

**Objective**: Develop a predictive framework to estimate CLV, support personalized marketing, and drive strategic growth across product categories.

---

## Executive Summary

This analysis reveals distinct customer behavioral segments and provides a predictive foundation for revenue optimization:

* **Churn Risk Concentration**: Over 60% of customers are single-transaction buyers, highlighting a retention gap.
* **High-Value Customers Identified**: A small cohort of customers (e.g., Customer ID 102 with a \$4,041.78 average order value) disproportionately contributes to revenue.
* **Actionable Purchase Forecasts**: Pareto-NBD modeling enables probabilistic forecasts of future purchases, as seen in the case of Customer 1487 with 3–6 expected purchases in the next 3–12 months.
* **Spending Behavior Stratified**: Gamma-Gamma models highlight monetary heterogeneity, enabling targeted upselling and premium-tier offerings.

These findings provide a tactical edge in customer relationship management, ensuring marketing spend aligns with customer value potential.

---

## Insights Deep Dive

### Customer Segmentation by Purchase Behavior

**Key Finding**: Customer base is bifurcated between one-time buyers and repeat purchasers.

* Approximately 60% of customers (e.g., Customer IDs 10, 100, 1000) exhibit no repeat behavior post-initial transaction.
* Conversely, high-frequency buyers such as ID 102 (7 purchases) and ID 1015 (4 purchases) are consistent revenue generators.

**Business Implication**: Strategic segmentation unlocks opportunities for customized retention initiatives and loyalty programs tailored to repeat purchasers.

---

### Purchase Frequency Patterns

**Key Finding**: Pareto-NBD modeling identifies customers with high future purchase likelihood.

* For example, Customer ID 1487 demonstrates a 3–6 purchase forecast within 90–365 days.
* Customer ID 102, with six purchases and an average 74-day interpurchase time, is highly engaged.

**Business Implication**: These projections enable precision-targeted marketing—particularly valuable for timing promotional cycles and seasonal outreach.

---

### Monetary Value Distribution

**Key Finding**: Substantial variability exists in average order values.

* Orders range from \$10.84 (Customer ID 1011) to \$4,041.78 (Customer ID 102).
* The Gamma-Gamma model estimates future spend, helping isolate high-LTV customer segments.

**Business Implication**: Insights into order value inform differentiated strategies—ranging from discount optimization to exclusive product bundles.

---

### Churn Probability and Retention Opportunities

**Key Finding**: Customers with low recency and frequency have high predicted churn probability.

* For instance, ID 10 (recency = 0, frequency = 0) is at high churn risk, whereas ID 1015 (recency = 1,157 days, frequency = 3) shows long-term engagement.

**Business Implication**: Churn scores provide a foundation for proactive re-engagement campaigns and can be embedded into automated CRM workflows.

---

## Recommendations

1. **Re-Engage Inactive Customers**
   Develop targeted campaigns for single-order customers using time-limited discounts or reactivation incentives. Prioritize campaigns within 90 days post-purchase.

2. **Leverage High-LTV Segments**
   Implement VIP or premium loyalty tiers for high-value customers. Offer early access to new furniture and tech product launches.

3. **Optimize Campaign Timing**
   Use Pareto-NBD forecasts to sequence email and digital ads to align with projected buying windows (e.g., next 3–12 months).

4. **Enhance Customer Profiling**
   Integrate demographic, regional, and product-category data to enable hyper-targeted marketing (e.g., office supply discounts for B2B clients).

5. **Measure and Iterate**
   Establish A/B testing frameworks to benchmark retention offers and optimize marketing ROI based on incremental CLV gains.

---

## Clarifying Questions and Assumptions

### Key Questions for Stakeholders

* What are Superstore’s strategic objectives with respect to CLV (e.g., reduce churn vs. increase ARPU)?
* Are there specific product verticals or customer profiles that are prioritized for growth?
* What is the intended forecast horizon—1 year, 3 years, or longer?
* How can these insights be integrated into current CRM or campaign management platforms?
* Are there operational constraints (e.g., budget, timing) that may affect campaign deployment?

### Assumptions

* The dataset `customer_features.csv` is a representative and clean sample of the overall customer base.
* One-time purchasers are re-engageable within a six-month window via digital outreach.
* Pareto-NBD and Gamma-Gamma models are appropriate due to alignment with transactional characteristics (non-contractual purchasing, heterogeneous spend behavior).
* The maximum date in the dataset defines the observation window for T and recency.
* Market conditions have remained stable, with no major structural shifts influencing purchasing behavior.


