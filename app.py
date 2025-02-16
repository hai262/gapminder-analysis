import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path

# Set page config
st.set_page_config(page_title="Gapminder Analysis Dashboard", layout="wide", page_icon = "🌍")

# Custom title with colors
st.markdown(
    """
    <h1 style='text-align: center; font-size: 48px; color: #FF5733;'>📊 Gapminder Data Analysis & Visualization</h1>
    <h3 style='text-align: center; font-size: 24px; color: #2E86C1;'>🔍 Explore Economic, Demographic & Health Trends</h3>
    """,
    unsafe_allow_html=True,
)

# Sidebar Navigation
st.sidebar.header("Navigation")
page = st.sidebar.radio("Go to:", ["Home", "Economic Indicators", "Demographics", "Health Indicators", "Advanced Insights", "Report & Presentation"])

# Load Data
gapminder = pd.read_csv("https://raw.githubusercontent.com/resbaz/r-novice-gapminder-files/master/data/gapminder-FiveYearData.csv")

# Home Page
if page == "Home":
    st.markdown("""
    ## 🔍 :green[Overview]
    Welcome to the **Gapminder Data Analysis & Visualization Dashboard**.
    
    This interactive app explores:
    - **Economic Trends** (GDP per capita, growth rates, disparities)
    - **Demographics** (Population analysis, migration, distributions)
    - **Health Metrics** (Life expectancy variations & trends)
    - **Advanced Insights** (Comparative analytics, 3D plots, and more!)
    
    """)
    st.image("https://upload.wikimedia.org/wikipedia/commons/6/6d/Gapminder-dollargdp-vs-lifeexpectancy.gif", caption="Economic Growth vs. Life Expectancy", use_column_width=True)
# Economic Indicators Page
elif page == "Economic Indicators":
    st.subheader("💰 :green[Economic Indicators]")
    
    # GDP per Capita by Continent
    gdp_df = gapminder.groupby("continent")["gdpPercap"].mean().reset_index()
    fig = px.bar(gdp_df, x="continent", y="gdpPercap", color="continent", title="Average GDP per Capita by Continent")
    st.plotly_chart(fig, use_container_width=True)
    
    # Improved GDP Growth Over Time Chart
    fig_area = px.area(gapminder, x="year", y="gdpPercap", color="continent", line_group="continent", title="GDP per Capita Over Time with Trend Highlight")
    fig_area.update_traces(mode="lines+markers", line_shape="spline")
    st.plotly_chart(fig_area, use_container_width=True)

# Demographics Page
elif page == "Demographics":
    st.subheader("👥 :green[Population Trends]")
    
    # Population Over Time
    pop_df = gapminder.groupby(["year", "continent"])["pop"].sum().reset_index()
    fig = px.area(pop_df, x="year", y="pop", color="continent", title="Population Growth by Continent")
    st.plotly_chart(fig, use_container_width=True)
    
    # Population Distribution by Continent (2007)
    pop_2007 = gapminder[gapminder.year == 2007].groupby("continent")["pop"].sum().reset_index()
    fig_pie = px.pie(pop_2007, values="pop", names="continent", title="Population Distribution by Continent (2007)")
    st.plotly_chart(fig_pie, use_container_width=True)

# Health Indicators Page
elif page == "Health Indicators":
    st.subheader("❤️ :green[Life Expectancy Analysis]")
    
    # Improved Life Expectancy Over Time Chart with Box Plot
    fig_life_box = px.box(gapminder, x="continent", y="lifeExp", color="continent", title="Life Expectancy Distribution by Continent")
    st.plotly_chart(fig_life_box, use_container_width=True)
    
    # New Histogram for Life Expectancy
    fig_life_hist = px.histogram(gapminder, x="lifeExp", color="continent", marginal="rug", title="Life Expectancy Distribution")
    st.plotly_chart(fig_life_hist, use_container_width=True)

# Advanced Insights
elif page == "Advanced Insights":
    st.subheader("🚀 :green[Advanced Data Visualizations]")
    
    # 3D Scatter Plot
    fig_3d = px.scatter_3d(gapminder, x="gdpPercap", y="lifeExp", z="pop", color="continent", title="3D View: GDP vs Life Expectancy & Population")
    st.plotly_chart(fig_3d, use_container_width=True)
    
    # Bubble Plot
    fig_bubble = px.scatter(gapminder, x="gdpPercap", y="lifeExp", size="pop", color="continent", log_x=True, title="GDP vs Life Expectancy (Bubble Plot)")
    st.plotly_chart(fig_bubble, use_container_width=True)

# Report & Presentation Page
elif page == "Report & Presentation":
    st.subheader("📄 :green[Download Report, Presentation & R Script]")
    
    report_path = "Data Analysis and Visualization Report_HaiNguyen.pdf"
    presentation_path = "Data Analysis and Visualization Presentation_HaiNguyen.pptx"
    r_script_path = "Project_HaiNguyen.R"
    
    # Run R script to generate the PowerPoint file if missing
    pptx_generated = False
    if not Path(presentation_path).exists():
        st.warning("Presentation file not found. Generating now...")
        try:
            subprocess.run(["Rscript", "Project_HaiNguyen.R"], check=True)
            pptx_generated = True
        except Exception as e:
            st.error(f"Error generating presentation: {e}")
    
    # Report Download
    if Path(report_path).exists():
        with open(report_path, "rb") as file:
            st.download_button("Download Report (PDF)", file, file_name="Gapminder_Report.pdf", mime="application/pdf")
    else:
        st.error("Report file not found!")
    
    # Presentation Download
    if Path(presentation_path).exists() or pptx_generated:
        with open(presentation_path, "rb") as file:
            st.download_button("Download Presentation (PPTX)", file, file_name="Gapminder_Presentation.pptx", mime="application/vnd.openxmlformats-officedocument.presentationml.presentation")
    else:
        st.error("Presentation file not found!")
    
    # R Script Download
    if Path(r_script_path).exists():
        with open(r_script_path, "rb") as file:
            st.download_button("Download R Script", file, file_name="Project_HaiNguyen.R", mime="text/plain")
    else:
        st.error("R script file not found!")

# Run with: streamlit run app.py
