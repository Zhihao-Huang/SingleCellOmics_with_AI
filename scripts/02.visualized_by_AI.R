library(ClaudeR)

# 点击Rstudio菜单横栏中的Addins, 在下拉菜单中点击Claude Rstudio Connection. 然后在viewer弹框中点击Start Server
# 点击Terminal (Console旁边), 在home目录创建settings.json: vi .claude/settings.json, 点击i, 粘贴输入env的内容, 点击esc, 按shift+冒号, 输入wq, 回车保存文件.
# 继续在Terminal输入claude

# prompt 1: 读取Seurat对象文件, 路径是./reports/obj_Seurat.rds, 该文件包含外周血单细胞的聚类结果, 请尝试做注释, 然后画umap图, 画marker基因表达图, 保存在./reports/中
# prompt 2: 读取聚类文件, 路径是./reports/clusterlist.rds, 该文件包含外周血单细胞的聚类结果, 请尝试做注释, 然后画umap图, 画marker基因表达图, 保存在./reports/中
# 学员自己尝试用Claude画其他图