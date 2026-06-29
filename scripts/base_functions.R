# ============================================================
# Single-cell clustering Pipeline (Base R + igraph + uwot)
# ============================================================
library(igraph)
library(uwot)

read_mat <- function(dir, geneid = 'V2') {
  message("[1/8] Reading 10X matrix ...")
  bar <- readLines(gzfile(file.path(dir, "barcodes.tsv.gz")))
  feat <- read.delim(gzfile(file.path(dir, "features.tsv.gz")), header = FALSE)
  mtx <- Matrix::readMM(gzfile(file.path(dir, "matrix.mtx.gz")))
  colnames(mtx) <- bar
  rownames(mtx) <- feat[, geneid]
  message("      Done: ", nrow(mtx), " genes × ", ncol(mtx), " cells")
  mtx
}

log_normalize <- function(data) {
  message("[2/8] Log-normalizing data (log1p(CPM * 1e4)) ...")
  data_log <- apply(data, 2, function(x) log(x / sum(x) * 10000 + 1))
  message("      Done")
  data_log
}
find_hvg_vst <- function(data,
                         loess.span = 0.3,
                         clip.max = 'auto',
                         nfeatures = 2000) {
  message("[3/8] Finding variable features (VST) ...")
  ##mean
  hvf.info <- data.frame(mean = Matrix::rowMeans(x = data))
  ##variance
  #hvf.info$variance <- rowVars(as.matrix(data))
  #as.matrix may cause memory problem when used for large data.
  hvf.info$variance <- apply(data, 1, var)
  #variance.expected
  hvf.info$variance.expected <- 0
  hvf.info$variance.standardized <- 0
  not.const <- hvf.info$variance > 0
  fit <- loess(
    formula = log10(x = variance) ~ log10(x = mean),
    data = hvf.info[not.const, ],
    span = loess.span
  )
  hvf.info$variance.expected[not.const] <- 10 ^ fit$fitted
  #variance.standardized
  sdnor <- function(x, mean.x, var.ex, clip.max){
    nor_x <- (x - mean.x)/var.ex
    #when value in var.ex equal to 0 ,return na. Then convert na to 0.
    nor_x[is.na(nor_x)] <- 0
    nor_x[nor_x > clip.max] <- clip.max
    sdx <- apply(nor_x, 1, var)
    return(sdx)
  }
  if (clip.max == 'auto') {
    clip.max <- sqrt(x = ncol(x = data))
  }
  hvf.info$variance.standardized <- sdnor(data,
                                          hvf.info$mean,
                                          sqrt(hvf.info$variance.expected),
                                          clip.max)
  rownames(hvf.info) <- rownames(data)
  thresh <- sort(hvf.info$variance.standardized, decreasing = TRUE)[nfeatures]
  topgenes <- hvf.info[hvf.info$variance.standardized >= thresh,]
  #topgenes <- hvf.info %>% top_n(nfeatures, variance.standardized)
  hvf.info$variable <- rownames(hvf.info) %in% rownames(topgenes)
  colnames(x = hvf.info) <- paste0('vst.', colnames(x = hvf.info))
  message("      Done: ", sum(hvf.info$vst.variable), " variable genes selected")
  
  return(hvf.info)
}


scale_data <- function(mat, features = NULL, clip = c(-10, 10)) {
  message("[4/8] Scaling data (z-score, clip = [-10, 10]) ...")
  
  sub <- if (is.null(features)) mat else mat[features, , drop = FALSE]
  mu <- rowMeans(sub)
  sd <- sqrt(rowSums((sub - mu)^2) / (ncol(sub) - 1))
  sd[sd == 0] <- 1
  
  scaled <- (sub - mu) / sd
  scaled[sd == 1, ] <- 0
  
  if (inherits(scaled, "dgCMatrix")) {
    scaled@x <- pmin(pmax(scaled@x, clip[1]), clip[2])
  } else {
    scaled <- pmin(pmax(scaled, clip[1]), clip[2])
  }
  
  dimnames(scaled) <- dimnames(sub)
  message("      Done")
  scaled
}
run_PCA <- function(scaledata, ndim = 50, features = NULL) {
  message("[5/8] Running PCA (SVD on scaled data) ...")
  if (!is.null(features)) scaledata <- scaledata[features,]
  ####SVD 
  svdresult <- svd(t(scaledata))
  feature.loadings <- svdresult$v
  feature.loadings <- feature.loadings[, 1:ndim]
  cell.embeddings <- svdresult$u %*% diag(svdresult$d)
  cell.embeddings <- cell.embeddings[, 1:ndim]
  colnames(cell.embeddings) <- paste0('PC_',1:ncol(cell.embeddings))
  rownames(cell.embeddings) <- colnames(scaledata)
  colnames(feature.loadings) <- paste0('PC_',1:ncol(feature.loadings))
  rownames(feature.loadings) <- rownames(scaledata)
  return(list(feature.loadings = feature.loadings, 
              cell.embeddings = cell.embeddings))
}

# FindNeighbors 核心实现
find_neighbors <- function(emb, k = 20) {
  message("[6/8] Building SNN graph (k = ", k, ") ...")
  dist_mat <- as.matrix(dist(emb, method = "euclidean"))
  diag(dist_mat) <- Inf  # 排除自身
  # 找 k 近邻
  knn <- t(apply(dist_mat, 1, function(x) order(x)[1:k]))
  # 构建 SNN 图（共享近邻）
  n <- nrow(emb)
  snn <- matrix(0, n, n)
  for (i in 1:n) {
    for (j in 1:n) {
      if (i >= j) next
      shared <- length(intersect(knn[i, ], knn[j, ]))
      snn[i, j] <- snn[j, i] <- shared / k
    }
  }
  dimnames(snn) <- list(rownames(emb), rownames(emb))
  snn
}

# FindClusters 核心实现（Louvain算法）
find_clusters <- function(snn, resolution = 1) {
  message("[7/8] Clustering cells (Louvain, resolution = ", resolution, ") ...")
  g <- igraph::graph.adjacency(snn, weighted = TRUE, mode = "undirected")
  igraph::E(g)$weight <- igraph::E(g)$weight * resolution
  # 获取Louvain结果，减1, 0起始编号，转因子
  memb <- igraph::membership(igraph::cluster_louvain(g)) - 1
  message("      Done: ", length(unique(memb)), " clusters identified")
  data.frame(
    seurat_clusters = factor(memb),
    row.names = rownames(snn)  # 行名=细胞名，和Seurat一致
  )
}
run_umap <- function(emb, n_components = 2, n_neighbors = 30, 
                     min_dist = 0.3, spread = 1.0, 
                     learning_rate = 1.0, seed = 42) {
  message("[8/8] Running UMAP (uwot implementation) ...")
  # 设置随机种子确保可重复
  set.seed(seed)
  # 使用 uwot 包
  umap_res <- uwot::umap(
    X = emb,
    n_components = n_components,
    n_neighbors = n_neighbors,
    min_dist = min_dist,
    spread = spread,
    learning_rate = learning_rate,
    verbose = FALSE
  )
  colnames(umap_res) <- paste0("UMAP_", seq_len(n_components))
  rownames(umap_res) <- rownames(emb)
  message("      Done: UMAP coordinates computed")
  as.data.frame(umap_res)
}
# ------------------------------------------------------------
# Optional wrapper: run full pipeline
# ------------------------------------------------------------
run_sc_clustering <- function(
    data_dir,
    npcs = 50,
    k = 20,
    resolution = 1,
    nfeatures = 2000
) {
  message("=== Starting single-cell clustering pipeline ===")
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
  list(
    raw = mat,
    normalized = norm,
    hvf = hvf,
    scaled = scaled,
    pca = pca,
    snn = snn,
    clusters = clusters,
    umap = umap_coords 
  )
}