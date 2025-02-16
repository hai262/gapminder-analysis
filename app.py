import streamlit as st
from pathlib import Path

# Set up Streamlit app
st.set_page_config(page_title="Data Analysis Report", layout="wide")

# Title
st.title("📊 Data Analysis and Visualization Report")

# Introduction
st.markdown("""
### 🔍 Overview
This app presents the **Gapminder Data Analysis and Visualization Report**, covering:
- **Economic Indicators** (GDP per capita trends)
- **Demographics** (Population growth & migration)
- **Health Metrics** (Life expectancy analysis)
- **Interactive visualizations** for deeper insights

📥 **Download the full report and R script below:**
""")

# File paths
report_path = "Data Analysis and Visualization Report_HaiNguyen.pdf"
r_script_path = "Project_HaiNguyen.R"

# Display PDF Report
st.subheader("📄 View Report")
if Path(report_path).exists():
    with open(report_path, "rb") as pdf_file:
        st.download_button(label="Download Report (PDF)", data=pdf_file, file_name="Analysis_Report.pdf", mime="application/pdf")
else:
    st.error("Report file not found!")

# Display R Script
st.subheader("📜 View R Code")
if Path(r_script_path).exists():
    with open(r_script_path, "r") as r_file:
        r_code = r_file.read()
        st.code(r_code, language="r")  # Display R script in readable format
    with open(r_script_path, "rb") as r_file:
        st.download_button(label="Download R Script", data=r_file, file_name="Project_HaiNguyen.R", mime="text/plain")
else:
    st.error("R script file not found!")

# Summary of Key Insights
st.subheader("📊 Key Insights from the Report")
st.markdown("""
- **Economic Indicators**
  - 🌍 Europe & Oceania have the **highest GDP per capita**, while Africa has the lowest.
  - 📈 **GDP has increased globally** from 1952 to 2007, especially in developed nations.
  - 🗺️ **Choropleth maps** highlight extreme disparities in GDP across countries.

- **Demographics**
  - 🌏 **Asia has the largest population**, followed by Africa.
  - 📊 **Population trends** show rapid growth in Africa & Asia.
  - 🔄 **Migration patterns** analyzed using Sankey diagrams.

- **Health & Life Expectancy**
  - ❤️ **Life expectancy has improved globally**, but **Africa still lags behind.**
  - 🔬 Countries with **higher GDP generally have higher life expectancy.**

📌 **Explore the full report above for detailed insights!**
""")

# Run the app using: streamlit run app.py
