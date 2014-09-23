# Group names
group.choices <- c("All", "Men", "Women", "Men's youth", "Men 18-39", 
  "Men 40-44", "Men 45-49", "Men 50-54", "Men 55-59", "Men 60-64", "Men 65-70", 
  "Men 70+", "Women's youth", "Women 18-39", "Women 40-44", "Women 45-49", 
  "Women 50-54", "Women 55-59", "Women 60-64", "Women 65-74", "Women 75+")

shinyUI(fluidPage(
  # Application title
  titlePanel("SEB Tallinn Marathon 2014 Results"),

  sidebarLayout(

    # Sidebar panel with inputs
    sidebarPanel(

      selectInput("distance",
        label = "Choose distance",
        choices = c("Marathon", "Half-marathon", "10k"),
        selected = "Marathon"),

      selectInput("group",
        label = "Choose group",
        choices = group.choices,
        selected = "All"),

      numericInput("number",
        label = "Start number",
        value  = NA,
        min = 1,
        max = 6729,
        step = 1
        ),

      checkboxInput("abs.y.scale", 
        label="Absolute y-scale", value=TRUE),

      helpText(br(), "Data from www.championchip.ee", 
        br(), "Andreas Beger", br(), a("@andybeega", href="https://twitter.com/andybeega"))

      ## add link back to my twitter or something

    ),

    # Show plot in main panel
    mainPanel(
      plotOutput("histogram")
    )

  )

))