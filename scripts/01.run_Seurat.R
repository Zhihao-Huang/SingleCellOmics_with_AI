library(Seurat)
data <- Read10X('./data/filtered_gene_bc_matrices/')
obj <- CreateSeuratObject(data)
obj <- NormalizeData(obj)
obj <- FindVariableFeatures(obj)
obj <- ScaleData(obj)
obj <- RunPCA(obj)
obj <- RunUMAP(obj, dims = 1:10)
obj <- FindNeighbors(obj, dims = 1:10)
obj <- FindClusters(obj)

p <- DimPlot(obj, label = T)

print(p)

saveRDS(obj, file = './reports/Seurat_obj.rds')
