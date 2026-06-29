library(ClaudeR)

# 点击Rstudio菜单横栏中的Addins, 在下拉菜单中点击Claude Rstudio Connection. 然后在viewer弹框中点击Start Server
# 

# prompt 1: 读取Seurat对象文件, 路径是./reports/obj_Seurat.rds, 该文件包含外周血单细胞的聚类结果, 请尝试做注释, 然后画umap图, 画marker基因表达图, 保存在./reports/中
# prompt 2: 读取聚类文件, 路径是./reports/clusterlist.rds, 该文件包含外周血单细胞的聚类结果, 请尝试做注释, 然后画umap图, 画marker基因表达图, 保存在./reports/中
# 学员自己尝试用ClaudeR画图