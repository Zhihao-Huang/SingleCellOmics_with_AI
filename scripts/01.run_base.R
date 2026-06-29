source('./scripts/base_functions.R')

# configures
data_dir = './data/filtered_gene_bc_matrices/'
npcs = 50
k = 20
resolution = 1
nfeatures = 2000

mat <- read_mat(data_dir)
norm <- log_normalize(mat)
norm <- norm[!duplicated(rownames(norm)),]
print(dim(norm))
hvf <- find_hvg_vst(norm, nfeatures = nfeatures)
hvgs <- rownames(hvf)[hvf$vst.variable]
scaled <- scale_data(norm, features = hvgs)
pca <- run_PCA(scaled, ndim = npcs, features = hvgs)
snn <- find_neighbors(pca$cell.embeddings, k = k)
clusters <- find_clusters(snn, resolution = resolution)
umap_coords <- run_umap(pca$cell.embeddings[, 1:npcs])

resultlist <- list(
  raw = mat,
  normalized = norm,
  hvf = hvf,
  scaled = scaled,
  pca = pca,
  snn = snn,
  clusters = clusters,
  umap = umap_coords 
)
saveRDS(resultlist, file = './reports/base_obj.rds')

plotdata <- resultlist$umap
plotdata$cluster <- resultlist$clusters$seurat_clusters

library(ggplot2)
ggplot(plotdata, aes(UMAP_1, UMAP_2, color = cluster)) + geom_point()


