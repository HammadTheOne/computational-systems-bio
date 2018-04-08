# Code to build a Bayesian Network Structure with bnlearn:

# Install bnlearn package
install.packages('bnlearn')

# Load bnlearn
library(bnlearn)

# Install and load Tidyverse
install.packages('tidyverse')
library(tidyverse)
library(lubridate)

# Sample genes:
#ENSG00000149488 – Male Tissue, Lung
#ENSG00000132670 – Male Tissue, Lung
#ENSG00000196090 – Brain, Female Tissues

# We start by creating an empty graph with 3 genes:
genes <- c('ENSG00000149488', 'ENSG00000132670', 'ENSG00000196090')
dag  <- empty.graph(genes)
dag

# Create an Arc matrix for the existing network.

e <- matrix(
  c("ENSG00000149488", "ENSG00000132670"),
  ncol = 2, byrow = TRUE,
  dimnames = list(NULL, c("from", "to"))
)

arcs(dag) <- e
dag

# Created an adjacency matrix for our genes:
adj <- matrix(
  0L, 
  ncol = 3, 
  nrow = 3,
  dimnames = list(genes, genes)
)
adj["ENSG00000149488", "ENSG00000132670"] = 1L


print(adj)

amat(dag) <- adj

dag

# Install the package networkD3 to plot a D3 force graph:
install.packages('networkD3')
library(networkD3)

plotD3bn <- function(bn) {
  varNames <- nodes(bn)
  # Nodes should be zero indexed!
  links <- data.frame(arcs(bn)) %>%
    mutate(from = match(from, varNames)-1, to = match(to, varNames)-1, value = 1)
  
  nodes <- data.frame(name = varNames) %>%
    mutate(group = 1, size = 30)
  
  networkD3::forceNetwork(
    Links = links,  
    Nodes = nodes,
    Source = "from",
    Target = "to",
    Value = "value",
    NodeID = "name",
    Group = "group",
    fontSize = 20,
    zoom = TRUE,
    arrows = TRUE,
    bounded = TRUE,
    opacityNoHover = 1
  )
}

# Plot a D3 force graph, which is visually appealing and should have force repelling features.
plotD3bn(dag)




