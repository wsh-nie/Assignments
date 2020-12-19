# 水平集变分推导

$$
能量函数: \epsilon_{g,\lambda, \nu} \lambda \mathcal L_g(\phi) + \nu \mathcal A_g(\phi) \\
\mathcal L_g(\phi) = \int_\Omega g \delta(\phi)|\nabla \phi| dx dy, \\ 
\mathcal A_g(\phi) = \int_\Omega gH(-\phi)dxdy, \\
g=\frac{1}{1+|\nabla G_\sigma * I|^2} \\
\delta \text{ is the univariate Dirac function, and it is a non-derivable function } \\
H(t) = \begin{cases}
0, & t \lt 0 \\
\frac{1}{2}, & t =0 \\
1, & t\gt 0
\end{cases}
$$

Solution:

先解$\mathcal L_g(\phi) = \int_\Omega g \delta(\phi)|\nabla \phi| dx dy$：
$$
\begin{align}
& 记E(\phi) = \mathcal L_g(\phi) = \int_\Omega g\delta(\phi)|\nabla \phi| dx dy \\
& 记F(\phi) = g\delta(\phi)|\nabla \phi| = g \delta(\phi) \sqrt{\phi_x^2 + \phi_y^2} \\
\end{align}
$$
引入极小变量$t$和任意函数$h$，其中函数$h$满足：$h|_{\partial \Omega} =0 $
$$
\therefore  F(\phi + th)  = g\delta(\phi)\sqrt{(\phi + th)_x^2 + (\phi + th)_y^2} \\
\begin{align}
\therefore  \frac{\partial F(\phi + th)}{\partial t} & = g \delta (\phi) \frac{h_x (\phi + th)_x + h_y(\phi + th)_y}{2\sqrt{(\phi + th)_x^2 + (\phi + th)_y^2}} \\
 & =\frac{1}{2} g \delta (\phi) \frac{\nabla h \cdot \nabla (\phi+th)}{\sqrt{(\phi_x^2 +\phi_y^2) + t^2(h_x^2 + h_y^2) + 2t\nabla h \cdot \nabla \phi}}
\end{align}\\
\therefore \frac{\partial F(\phi +th)}{\partial t}|_{t->0} = \frac{1}{2}g \delta(\phi) \frac{\nabla h \cdot \nabla \phi}{\sqrt{\phi_x^2 +\phi_y^2}}
$$

$$
\begin{align}
\therefore \frac{\partial E(\phi + th)}{\partial t} |_{t->0} &= \int_{\Omega} \frac{1}{2} g \delta(\phi) \frac{\nabla h \cdot \nabla \phi}{\sqrt{\phi_x^2 +\phi_y^2}} dx dy \\
& = \frac{1}{2} \delta(\phi) \int_\Omega g  \frac{\nabla h \cdot \nabla \phi}{\sqrt{\phi_x^2 +\phi_y^2}} dx dy \\
& = \frac{1}{2} \delta(\phi) \int_\Omega g  \frac{h_x\phi_x + h_y\phi_y}{\sqrt{\phi_x^2 +\phi_y^2}} dx dy 
\end{align}
$$


$$
\begin{align}
\because & \frac{\partial }{\partial x}[\phi_x h] = h_x \phi_x + h \phi_{xx}\\
& \frac{\partial }{\partial y}[\phi_y h] = h_y \phi_y + h \phi_{yy}
\end{align}
$$

$$
\therefore 
\begin{align} 
\frac{\partial E(\phi + th)}{\partial t} |_{t->0} = \frac{1}{2} \delta(\phi) [\int_{\Omega}g(\frac{\partial}{\partial x}[\frac{\phi_x}{|\nabla \phi|} h]  + \frac{\partial}{\partial y}[\frac{\phi_y}{|\nabla \phi|} h])dxdy - \int_{\Omega} g(\frac{\partial}{\partial x}[\frac{\phi_x}{|\nabla \phi|}] h + h \frac{\partial}{\partial y}[\frac{\phi_y}{|\nabla \phi|}]) dxdy ]
\end{align}\\
\text{According to Green Equation: }\oint_{\partial \Omega } Rdy + Sdx = \iint_{\Omega} \big( \frac{dS}{dy} - \frac{dR}{dx} \big) dxdy \\
\therefore \int_{\Omega}g(\frac{\partial}{\partial x}[\frac{\phi_x}{|\nabla \phi|} h]  + \frac{\partial}{\partial y}[\frac{\phi_y}{|\nabla \phi|} h])dxdy = \oint_{\partial \Omega }h \Big( \frac{\phi_y}{|\nabla \phi|} - \frac{\phi_x}{|\nabla \phi|} \Big) dxdy = 0 \\
$$

$$
\therefore
\begin{align}
\frac{\partial E(\phi + th)}{\partial \phi}|_{t->0} & = -\frac{1}{2} \delta(\phi) \int_{\Omega}h \cdot g(\frac{\partial}{\partial x}[\frac{\phi_x}{|\nabla \phi|}] + \frac{\partial}{\partial y}[\frac{\phi_y}{|\nabla \phi|}]) dxdy \\
& = -\frac{1}{2} \delta(\phi) \int_{\Omega} h \cdot \nabla[g \frac{\nabla \phi}{|\nabla \phi|}] dxdy
\end{align} \\
\text{When } E(\phi)\text{ reach the minimal,} \frac{E(\phi + th)}{\phi t}|_{t->0} = -\frac{1}{2} \delta(\phi) \int_{\Omega} h \cdot \nabla[g \frac{\nabla \phi}{|\nabla \phi|}] dxdy = 0 \\
\text{Since function h is arbitrary, we obtain: } \delta(\phi) \nabla[g \frac{\nabla \phi}{|\nabla \phi|}] = 0
$$

再解$\mathcal A_g(\phi) = \int_\Omega gH(-\phi)dxdy$：
$$
同样记E(\phi) = \mathcal A_g(\phi) = \int_\Omega gH(-\phi) dx dy \\
记F(\phi) = g H(-\phi)
$$
引入极小变量$t$和任意函数$h$，其中函数$h$满足：$h|_{\partial \Omega} =0 $
$$
F(\phi + th) = gH(-\phi - th) \\
\therefore \frac{\partial F(\phi + th)}{\partial t} = g\delta( - \phi - th) (-h) = -h \cdot g\delta(-\phi) = -h \cdot g\delta(\phi)\\
\therefore \frac{\partial E(\phi+th)}{\partial t} = - \int_{\Omega} h g\delta(\phi) dxdy \\
\text{When } E(\phi)\text{ reach the minimal,} \frac{E(\phi + th)}{\partial t}|_{t->0} = -\int_{\Omega} h\cdot g\delta(\phi) dxdy = 0\\
\text{Since function h is arbitrary, we obtain: } g\delta(\phi) = 0
$$
综上所述演化方程：
$$
\frac{\partial \phi}{\partial t} = \lambda \delta(\phi) \nabla[g\frac{\nabla \phi}{|\nabla \phi|}] + \nu g \delta(\phi)
$$
