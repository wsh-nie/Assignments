## 编程作业任务

* 图像去雾
  
### 要求

* 编程语言不限
* 不允许调用的库函数：导向滤波函数

### 实验环境

windows 10， Matlab 2020b

## 实验原理

复现[文章1](http://kaiminghe.com/publications/cvpr09.pdf)，使用[文章2](http://kaiminghe.com/eccv10/eccv10ppt.pdf)的导向滤波代替Soft Matting 获得refine t。

主函数在Main.m中。

### 暗通道

$$
J^{dark}(X) = \min_{c\in {r,g,b}} ( \min_{y \in \Omega(x)} (J^c(y)) )
$$

在GetDark.m中实现
### 大气光

在GetAirLight.m中实现
### 参数t_hat

$$
\hat t(x) = 1-\omega \min_c (\min_{y \in \Omega(x)}(\frac{I^c(y)}{A^c}))
$$

在GetT_hat.m中实现
### 导向滤波获得细化t

在GuideFilter.m中实现
### 获得去雾图片

在GetImg.m中实现